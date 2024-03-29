#************************************************************************************************************************************
# function CheckReportingServer
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- spInactivateReportServerInstance
#	- spAddReportServerInstance
#	- spAddRSCatalogItem
#
#************************************************************************************************************************************
{ 
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
	[Parameter(Mandatory=$False,Position=2)]
	[pscredential]$psCredential,
	[Parameter(Mandatory=$True,Position=3)]
	[string]$sqlConnectionString,
	[Parameter(Mandatory=$True,Position=4)]
	[string]$invocationPath
)

Set-StrictMode -Version "Latest"

# Change path to working folder
Set-Location $invocationPath	

. ".\modules\MonitorFunctions.ps1"

# Initialize error variables
[int]$errorCounter = 0
[int]$warningCounter = 0
[string]$moduleName = "CheckReportServer"

################################################################################
# ESTABLISH CONNECTION TO CENTRAL REPOSITORY
################################################################################
$sqlConnection = GetSQLConnection -sqlConnectionString $sqlConnectionString
if ($sqlConnection.State -ne "Open")	{
	Throw "Unable to open central repository database.  Application terminating."
	Return New-Object psobject -Property @{ErrorCount = 1; WarningCount = 0}
}

Write-Verbose " : $dnsHostName : $moduleName : Start"

# Add Log Entry
AddLogEntry $dnsHostName "Info" $moduleName "Starting check..." $sqlConnection

# Retrieve instances installed on server
$sqlCommand = GetStoredProc $sqlConnection "cm.spReportingInstanceSelectByComputer"
[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
$sqlCommand.Parameters["@Active"].value = $true

$sqlReader = $sqlCommand.ExecuteReader()
$sqlCommand.Dispose()

$dataTable = New-Object System.Data.DataTable
$dataTable.Load($SqlReader)

If($dataTable.Rows.Count -eq 0){
	# There are no report server instances discovered on this instance
	Write-Verbose " : $dnsHostName : $moduleName : Finish (nocheck)"
	[Void]$sqlConnection.Close
	$sqlConnection.Dispose()	
	Return New-Object psobject -Property @{ErrorCount = 0; WarningCount = 0}
}

foreach($row in $dataTable.Rows){
	[Guid]$ReportingInstanceGUID = $row["objectGUID"]
	[string]$instanceName = $row["InstanceName"]
	[string]$reportServerURL = $row["ConnectionString"] 

	If(($row["RSConfiguration"] -ne "Configured") -and ($row["ServiceState"] -ne "Running")){
		Write-Verbose " : $dnsHostName : $moduleName : Finish : $instanceName not running or not configured." -ForegroundColor Yellow
		[Void]$sqlConnection.Close
		$sqlConnection.Dispose()	
		Return New-Object psobject -Property @{ErrorCount = 0; WarningCount = 1}	
	} else {
		# Validate URL and append WSDL path
		if($reportServerURL.Length -lt 5) {
			Write-Verbose " : $dnsHostName : $moduleName : Invalid url $reportServerURL (Instance: $instanceName)" -ForegroundColor Red
			continue
		} else {
			if($reportServerURL.substring($reportServerURL.Length -1) -eq "/"){
				$reportServerURL = $reportServerURL + "reportservice2010.asmx"
			} else {
				$reportServerURL = $reportServerURL + "/reportservice2010.asmx"
			}
		}	

		# Connect to the Web Service
		$reportServer = New-WebServiceProxy -Uri $reportServerURL -Namespace SSRS.ReportingService2010 -UseDefaultCredential 
		if ($reportServer -eq $null) {
			# Log error in connecting to Report Server
			Write-Verbose " : $dnsHostName : $moduleName : Connection error: unable to connect to $reportServerURL on server $dnsHostName" -ForegroundColor DarkRed
			AddLogEntry $dnsHostName "Error" $moduleName "Connection error: unable to connect to $reportServerURL on server $dnsHostName" $sqlConnection
			$errorCounter++
			continue
		}
		
		# Inactivate existing reports
		$sqlCommand = GetStoredProc $sqlConnection "cm.spReportServerItemInactivateByReportingInstance"
		[Void]$sqlCommand.Parameters.Add("@ReportingInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
		[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
		$sqlCommand.Parameters["@ReportingInstanceGUID"].value = $ReportingInstanceGUID
		$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
		[void]$sqlCommand.ExecuteNonQuery()
		$sqlCommand.Dispose()

		#region Reports
		try {
			# Enumerate the reports on the server
			$items = $reportServer.ListChildren("/", $true)
			
			$sqlCommand = GetStoredProc $sqlConnection "cm.spReportServerItemUpsert"
			[void]$sqlCommand.Parameters.Add("@ReportingInstanceGUID",  [System.Data.SqlDbType]::uniqueidentifier)
			[void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@Path",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@VirtualPath",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@TypeName",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@Size",  [System.Data.SqlDbType]::int)
			[void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@Hidden",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand.Parameters.Add("@CreationDate",  [System.Data.SqlDbType]::datetime)
			[void]$sqlCommand.Parameters.Add("@ModifiedDate",  [System.Data.SqlDbType]::datetime)
			[void]$sqlCommand.Parameters.Add("@ModifiedBy",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
				
			foreach ($item in $items)	{
				$sqlCommand.Parameters["@ReportingInstanceGUID"].Value = $ReportingInstanceGUID
				$sqlCommand.Parameters["@Name"].Value = $item.Name
				$sqlCommand.Parameters["@Path"].Value = NullToString $item.Path ""
				$sqlCommand.Parameters["@VirtualPath"].Value = NullToString $item.VirtualPath ""
				$sqlCommand.Parameters["@TypeName"].Value = $item.TypeName
				$sqlCommand.Parameters["@Size"].Value = $item.Size
				$sqlCommand.Parameters["@Description"].Value = $item.Description
				$sqlCommand.Parameters["@Hidden"].Value = $item.Hidden
				$sqlCommand.Parameters["@CreationDate"].Value = $item.CreationDate
				$sqlCommand.Parameters["@ModifiedDate"].Value = $item.ModifiedDate
				$sqlCommand.Parameters["@ModifiedBy"].Value = $item.ModifiedBy
				$sqlCommand.Parameters["@Active"].Value = $true
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				[void]$sqlCommand.ExecuteNonQuery()			
			}
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry $dnsHostName "Warning" $moduleName "Report Item : $msg" $sqlConnection
			$warningCounter++
		}
		$sqlCommand.Dispose()
		#endregion

		# Enumerate Subscriptions
		$subscriptionItems = $reportServer.ListSubscriptions($null)
		
		# Inactivate subscriptions for instance
		$sqlCommand = GetStoredProc $sqlConnection "cm.spReportServerSubscriptionInactivateByReportingInstance"
		[Void]$sqlCommand.Parameters.Add("@ReportingInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
		[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
		$sqlCommand.Parameters["@ReportingInstanceGUID"].value = $ReportingInstanceGUID
		$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
		[Void]$sqlCommand.ExecuteNonQuery()
		$sqlCommand.Dispose()	
	
		$sqlCommand = GetStoredProc $sqlConnection "cm.spReportServerSubscriptionUpsert"
		[void]$sqlCommand.Parameters.Add("@objectGUID",  [System.Data.SqlDbType]::uniqueidentifier)
		[void]$sqlCommand.Parameters.Add("@ReportingInstanceGUID",  [System.Data.SqlDbType]::uniqueidentifier)
		[void]$sqlCommand.Parameters.Add("@Owner",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@Path",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@VirtualPath",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@Report",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@Status",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@SubscriptionActive",  [System.Data.SqlDbType]::bit)
		[void]$sqlCommand.Parameters.Add("@LastExecuted",  [System.Data.SqlDbType]::datetime)
		[void]$sqlCommand.Parameters.Add("@ModifiedBy",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@ModifiedDate",  [System.Data.SqlDbType]::datetime)
		[void]$sqlCommand.Parameters.Add("@EventType",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@IsDataDriven",  [System.Data.SqlDbType]::bit)
		[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
		[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
				
		foreach ($subscription in $subscriptionItems)	{
			[Guid]$subscriptionID = $subscription.SubscriptionID
	
			try {
				[int]$activeCheck = 0
				[bool]$Active = $false
				if($subscription.Active.DeliveryExtensionRemoved){$activeCheck++}
				if($subscription.Active.SharedDataSourceRemoved){$activeCheck++}
				if($subscription.Active.MissingParameterValue){$activeCheck++}
				if($subscription.Active.InvalidParameterValue){$activeCheck++}
				if($subscription.Active.UnknownReportParameter){$activeCheck++}	
				if($activeCheck -gt 0){$Active = $false} else {$Active = $true}
				if($subscription.LastExecuted -eq "01/01/0001"){$dLastExecuted = [System.DBNull]::Value} else {$dLastExecuted = $subscription.LastExecuted}
				if($subscription.ModifiedDate -eq "01/01/0001"){$dModifiedDate = [System.DBNull]::Value} else {$dModifiedDate = $subscription.ModifiedDate}
				
				$sqlCommand.Parameters["@objectGUID"].Value = $subscriptionID
				$sqlCommand.Parameters["@ReportingInstanceGUID"].Value = $ReportingInstanceGUID
				$sqlCommand.Parameters["@Owner"].Value = $subscription.Owner
				$sqlCommand.Parameters["@Path"].Value = $subscription.Path
				$sqlCommand.Parameters["@VirtualPath"].Value = nulltoString $subscription.VirtualPath ""
				$sqlCommand.Parameters["@Report"].Value = $subscription.Report
				$sqlCommand.Parameters["@Description"].Value = $subscription.Description
				$sqlCommand.Parameters["@Status"].Value = $subscription.Status
				$sqlCommand.Parameters["@SubscriptionActive"].Value = $Active
				$sqlCommand.Parameters["@LastExecuted"].Value = $dLastExecuted
				$sqlCommand.Parameters["@ModifiedBy"].Value = $subscription.ModifiedBy
				$sqlCommand.Parameters["@ModifiedDate"].Value = $dModifiedDate
				$sqlCommand.Parameters["@EventType"].Value = $subscription.EventType
				$sqlCommand.Parameters["@IsDataDriven"].Value = $subscription.IsDataDriven
				$sqlCommand.Parameters["@Active"].Value = $true
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				[Void]$sqlCommand.ExecuteNonQuery()
				
				try {
					# As of 2012/02/07, only able to check parameters for non-data-driven subscriptions
					if(!$subscription.IsDataDriven){
					
						# Inactivate subscriptions for instance
						$sqlCommand2 = GetStoredProc $sqlConnection "cm.spReportServerSubscriptionParameterInactivateBySubscription"
						[Void]$sqlCommand2.Parameters.Add("@ReportServerSubscriptionGUID", [system.data.SqlDbType]::uniqueidentifier)
						[Void]$sqlCommand2.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
						$sqlCommand2.Parameters["@ReportServerSubscriptionGUID"].value = $subscriptionID				
						$sqlCommand2.Parameters["@dbLastUpdate"].value = (Get-Date)			
						[Void]$sqlCommand2.ExecuteNonQuery()
						$sqlCommand2.Dispose()
	
						$sqlCommand2 = GetStoredProc $sqlConnection "cm.spReportServerSubscriptionParameterUpsert"
						[Void]$sqlCommand2.Parameters.Add("@ReportServerSubscriptionGUID", [system.data.SqlDbType]::uniqueidentifier)
						[Void]$sqlCommand2.Parameters.Add("@ParameterName", [system.data.SqlDbType]::nvarchar)
						[Void]$sqlCommand2.Parameters.Add("@ParameterValue", [system.data.SqlDbType]::nvarchar)
						[Void]$sqlCommand2.Parameters.Add("@Active", [system.data.SqlDbType]::Bit)
						[void]$sqlCommand2.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)

						foreach($parameterValue in $subscription.DeliverySettings.ParameterValues){
	
							$sqlCommand2.Parameters["@ReportServerSubscriptionGUID"].value = $subscriptionID
							$sqlCommand2.Parameters["@ParameterName"].value = $parameterValue.Name
							$sqlCommand2.Parameters["@ParameterValue"].value = $parameterValue.Value	
							$sqlCommand2.Parameters["@Active"].Value = $true
							$sqlCommand2.Parameters["@dbLastUpdate"].Value = (Get-Date)					
							
							[Void]$sqlCommand2.ExecuteNonQuery()
						}
						$sqlCommand2.Dispose()						
					}
				}
				catch [System.Exception] {
					[string]$parameterName = $parameterValue.Name
					$msg = $_.Exception.Message
					AddLogEntry $dnsHostName "Error" $moduleName "Subscription Parameter : $parameterName : $msg" $sqlConnection
					$errorCounter++
				}		
			}
		    catch [System.Exception] {
				$msg = $_.Exception.Message
			    AddLogEntry $dnsHostName "Error" $moduleName "Subscription : $msg" $sqlConnection
				$errorCounter++
		    }
			$sqlCommand.Dispose()
		}
	}
}


# Add Log Entry
AddLogEntry $dnsHostName "Info" $moduleName "Check completed." $sqlConnection

################################################################################
# CLEANUP
################################################################################
[Void]$reportServer.Dispose()
[Void]$sqlConnection.Close
$sqlConnection.Dispose()

Write-Verbose " : $dnsHostName : $moduleName : Finish : $errorCounter error(s) : $warningCounter warning(s)"

# Return error count
Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}