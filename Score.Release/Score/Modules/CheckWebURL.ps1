#************************************************************************************************************************************
# function CheckWebServer
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
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
[string]$moduleName = "CheckWebServer"
	
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

# Get List of URLs to check
$sqlCommand = GetStoredProc $sqlConnection "cm.spWebApplicationURLSelectByComputer"
[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
$sqlCommand.Parameters["@Active"].value = $true

$sqlReader = $sqlCommand.ExecuteReader()
$sqlCommand.Dispose()

$dataTable = New-Object System.Data.DataTable
$dataTable.Load($SqlReader)

If($dataTable.Rows.Count -eq 0){
	# There are no URLs associated to this host
	Write-Verbose " : $dnsHostName : $moduleName : Finish (nocheck)"
	[Void]$sqlConnection.Close
	$sqlConnection.Dispose()
	Return New-Object psobject -Property @{ErrorCount = 0; WarningCount = 0}
}


	$sqlCommand = GetStoredProc $sqlConnection "cm.spWebApplicationURLUpdateLastResult"
	[void]$sqlCommand.Parameters.Add("@WebApplicationURLGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand.Parameters.Add("@LastStatusCode",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@LastStatusDescription",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@LastResponseTime",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@LastUpdate",  [System.Data.SqlDbType]::datetime)
	
	$sqlCommand2 = GetStoredProc $sqlConnection "pm.spWebApplicationURLResponseRawInsert"
	[void]$sqlCommand2.Parameters.Add("@WebApplicationURLGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand2.Parameters.Add("@StatusCode",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand2.Parameters.Add("@StatusDescription",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand2.Parameters.Add("@LastResponseTime",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand2.Parameters.Add("@dbAddDate",  [System.Data.SqlDbType]::datetime2)	
	
foreach($row in $dataTable) {
	try {
		if($row["UseDefaultCredential"]){
			$responseTime = Measure-Command {$webResponse = Invoke-WebRequest $row["URL"] -UseDefaultCredentials -ErrorAction SilentlyContinue}
		} else {
			$responseTime = Measure-Command {$webResponse = Invoke-WebRequest $row["URL"] -ErrorAction SilentlyContinue}
		}
		
		[datetime]$timeNow = (Get-Date)
		$sqlCommand.Parameters["@WebApplicationURLGUID"].Value = $row["objectGUID"]
		$sqlCommand.Parameters["@LastStatusCode"].Value = $webResponse.StatusCode
		$sqlCommand.Parameters["@LastStatusDescription"].Value = $webResponse.StatusDescription
		$sqlCommand.Parameters["@LastResponseTime"].Value = $responseTime.Milliseconds
		$sqlCommand.Parameters["@LastUpdate"].Value = $timeNow
		[void]$sqlCommand.ExecuteNonQuery()	
		
		$sqlCommand2.Parameters["@WebApplicationURLGUID"].Value = $row["objectGUID"]
		$sqlCommand2.Parameters["@StatusCode"].Value = $webResponse.StatusCode
		$sqlCommand2.Parameters["@StatusDescription"].Value = $webResponse.StatusDescription
		$sqlCommand2.Parameters["@LastResponseTime"].Value = $responseTime.Milliseconds
		$sqlCommand2.Parameters["@dbAddDate"].Value = $timeNow
		[void]$sqlCommand2.ExecuteNonQuery()	

	}
	catch [System.Exception] {
		[string]$urlToCheck = $row["URL"]
		$msg = $_.Exception.Message
	    AddLogEntry $dnsHostName "Error" $moduleName "$urlToCheck : $msg" $sqlConnection
	}
}
$sqlCommand.Dispose()
$sqlCommand2.Dispose()


# Add Log Entry
AddLogEntry $dnsHostName "Info" $moduleName "Check completed." $sqlConnection

################################################################################
# CLEANUP
################################################################################
[Void]$sqlConnection.Close
$sqlConnection.Dispose()

Write-Verbose " : $dnsHostName : $moduleName : Finish"

# Return error count
Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}