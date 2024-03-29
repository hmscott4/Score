#************************************************************************************************************************************
# function CheckSQLInstance
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- spDatabaseInstanceUpsert
#	- spAnalysisInstanceUpsert
#	- spReportingInstanceUpsert
#
# Description:
#	- The purpose of this module is to iterate the registry and "discover" which instances of SQL are installed/functioning
#	- The module populates cm.DatabaseInstance, cm.AnalysisInstance, cm.ReportingInstance
#	- The module also tries to determine the state of the instance (running or not), and connection-specific information (port number, named instance)
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
[string]$moduleName = "CheckSQLInstance"
	
################################################################################
# ESTABLISH CONNECTION TO CENTRAL REPOSITORY
################################################################################
$sqlConnection = GetSQLConnection -sqlConnectionString $sqlConnectionString
if ($sqlConnection.State -ne "Open")	{
	Throw "Unable to open central repository database.  Application terminating."
	Return New-Object psobject -Property @{ErrorCount = 1; WarningCount = 0}
}

Write-Verbose " : $dnsHostname : $moduleName : Start"

# Add Log Entry
AddLogEntry $dnsHostname "Info" $moduleName "Starting check..." $sqlConnection

################################################################################
# CHECK FOR INSTALLATIONS OF SQL DATABASE ENGINE
################################################################################
#region DatabaseInstance

# Retrieve instances already discovered on server
$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstanceSelectByComputer"
[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
$sqlCommand.Parameters["@Active"].value = $true

$sqlReader = $sqlCommand.ExecuteReader()
$sqlCommand.Dispose()

$dataTable = New-Object System.Data.DataTable
$dataTable.Load($SqlReader)

# CREATE A HASH TABLE OF PREVIOUSLY DISCOVERED (ACTIVE) INSTANCES
$discoveredInstances = @{}
If($dataTable.Rows.Count -gt 0){
	foreach($row in $dataTable){
		[Guid]$instanceGUID = $row["objectGUID"]
		[string]$instanceName = $row["InstanceName"]
		$discoveredInstances[$instanceName] = $instanceGUID
	}
}

$sqlInstances = GetSQLInstances $dnsHostname "SQL"
if($sqlInstances){
			
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstanceUpsert"
	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@InstanceName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ProductName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ProductEdition",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ProductVersion",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ProductServicePack",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ConnectionString",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ServiceState",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@IsClustered",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@ActiveNode",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)

	foreach($sqlInstance in $sqlInstances) {
		try {
			$sqlRegistryRoot = "SOFTWARE\\Microsoft\\Microsoft SQL Server"
			$instanceHive = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\Instance Names\\SQL" $sqlInstance
			[string]$productEdition = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Setup" "Edition"
			[string]$productVersion = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Setup" "Version"
			[string]$productServicePack = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Setup" "SP"
			[bool]$isClustered = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\ClusterState\\" "SQL_Engine_Core_Inst"
			[string]$portNumber = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\MSSQLServer\\SuperSocketNetLib\\Tcp\\IPAll\\" "TcpPort"
			
			# If the server is clustered, replace $dnsHostName with the cluster network name
			if($isClustered){
				[string]$clusterName = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Cluster" "ClusterName"
				$sqlHostName = $dnsHostName.Replace($dnsHostName.Substring(0,$dnsHostName.IndexOf(".")),$clusterName)
			} else {
				$sqlHostName = $dnsHostName
			}
			# If it's a named instance, tack on the instance name to the connection string
			if($sqlInstance -eq "MSSQLSERVER"){
				$instanceConnectionString = $sqlHostName
			} else {
				$instanceConnectionString = $sqlHostName + "\" + $sqlInstance
			}
			# If it's not running on default port, append the port number to the connection string
			# This only checks the IPAll registry entry; there are probably better ways to do this
			if(($portNumber.Length -gt 0) -and ($portNumber -ne "1433")){
				$instanceConnectionString += "," + $portNumber
			}
			# Check the status of the Windows Service
			Try {
				if($sqlInstance -eq "MSSQLSERVER"){
					[string]$serviceState = (Get-Service -Name "MSSQLSERVER" -ComputerName $sqlHostName).Status
				} else {
					[string]$serviceState = (Get-Service -Name "MSSQL`$$sqlInstance" -ComputerName $sqlHostName).Status
				}
			}
			Catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $dnsHostname "Warning" $moduleName "Database Instance : $sqlInstance : $msg" $sqlConnection
				$warningCounter++
			}

			###########################################################################################################
			## IMPORTANT: $instanceConnectionString is written only on an Insert; subsequent updates are ignored.
			##            This allows an admin to override a default value if necessary without having it overwritten 
			##            during a later discovery.
			###########################################################################################################			
			$sqlCommand.Parameters["@dnsHostName"].Value = $sqlHostName 
			$sqlCommand.Parameters["@InstanceName"].Value = $sqlInstance
			$sqlCommand.Parameters["@ProductName"].Value = "Microsoft SQL Server" ## Hard-coded value; meant to allow for other database products
			$sqlCommand.Parameters["@ProductEdition"].Value = $productEdition
			$sqlCommand.Parameters["@ProductVersion"].Value = $productVersion
			$sqlCommand.Parameters["@ProductServicePack"].Value = $productServicePack
			$sqlCommand.Parameters["@ConnectionString"].Value = $instanceConnectionString
			$sqlCommand.Parameters["@ServiceState"].Value = $serviceState
			$sqlCommand.Parameters["@IsClustered"].Value = $isClustered
			$sqlCommand.Parameters["@ActiveNode"].Value = ""
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			
			[Void]$sqlCommand.ExecuteNonQuery()
			
			# REMOVE THIS INSTANCE FROM THE HASH TABLE
			$discoveredInstances.Remove($sqlInstance)
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostname "Error" $moduleName "Database Instance : $sqlInstance : $msg" $sqlConnection
			$errorCounter++
		}
	}
	$sqlCommand.Dispose()
	
	# ANYTHING LEFT IN $discoveredInstances HASHTABLE HAS BEEN REMOVED FROM THE SERVER
	# THESE NEED TO BE INACTIVATED (ALONG WITH CHILD OBJECTS)
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstanceInactivate"
	[void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand.Parameters.Add("@IncludeChildObjects",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::DateTime)
	
	for($index=0; $index -lt $discoveredInstances.Count; $index++){
		[Guid]$instanceGUID = $discoveredInstances[$discoveredInstances.Keys[$index]].Guid
		$sqlCommand.Parameters["@DatabaseInstanceGUID"].Value = $instanceGUID
		$sqlCommand.Parameters["@IncludeChildObjects"].Value = $true	
		$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)	
		
		[Void]$sqlCommand.ExecuteNonQuery()
	}
	$sqlCommand.Dispose()
}

#endregion
	
################################################################################
# CHECK FOR INSTALLATIONS OF SQL ANALYSIS SERVICES ENGINE
################################################################################
#region AnalysisInstance
# Inactivate OLAP SQL Instances associated with computer (if there were any)
#$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisInstanceInactivateByComputer"
#[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
#[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
#$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
#$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
#[Void]$sqlCommand.ExecuteNonQuery()
#$sqlCommand.Dispose()


# Retrieve instances already discovered on server
$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisInstanceSelectByComputer"
[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
$sqlCommand.Parameters["@Active"].value = $true

$sqlReader = $sqlCommand.ExecuteReader()
$sqlCommand.Dispose()

$dataTable = New-Object System.Data.DataTable
$dataTable.Load($SqlReader)

# CREATE A HASH TABLE OF PREVIOUSLY DISCOVERED (ACTIVE) INSTANCES
$discoveredInstances = @{}
If($dataTable.Rows.Count -gt 0){
	foreach($row in $dataTable){
		[Guid]$instanceGUID = $row["objectGUID"]
		[string]$instanceName = $row["InstanceName"]
		$discoveredInstances[$instanceName] = $instanceGUID
	}
}

$asInstances = GetSQLInstances $dnsHostname "OLAP"
if($asInstances){

	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisInstanceUpsert"
	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@InstanceName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ProductName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ProductEdition",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ProductVersion",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ProductServicePack",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ConnectionString",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ServiceState",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@IsClustered",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@ActiveNode",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)	

	foreach($asInstance in $asInstances){
		Try {
			$sqlRegistryRoot = "SOFTWARE\\Microsoft\\Microsoft SQL Server"
			$instanceHive = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\Instance Names\\OLAP" $asInstance
			[string]$productEdition = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Setup" "Edition"
			[string]$productVersion = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Setup" "Version"
			[string]$productServicePack = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Setup" "SP"
			[bool]$isClustered = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\ClusterState\\" "Analysis_Server_Full"
			
			# If the server is clustered, replace $dnsHostName with the cluster network name
			if($isClustered){
				[string]$clusterName = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Cluster" "ClusterName"
				$sqlHostName = $dnsHostName.Replace($dnsHostName.Substring(0,$dnsHostName.IndexOf(".")),$clusterName)
			} else {
				$sqlHostName = $dnsHostName
			}
			# If it's a named instance, tack on the instance name to the connection string
			if($asInstance -eq "MSSQLSERVER"){
				$instanceConnectionString = $sqlHostName
			} else {
				$instanceConnectionString = $sqlHostName + "\" + $asInstance
			}
			# Check the status of the Windows Service
			Try {
				if($asInstance -eq "MSSQLSERVER"){
					[string]$serviceState = (Get-Service -Name "MSSQLServerOLAPService" -ComputerName $sqlHostName).Status
				} else {
					[string]$serviceState = (Get-Service -Name "MSOLAP`$$asInstance" -ComputerName $sqlHostName).Status
				}
			}
			Catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $dnsHostname "Warning" $moduleName "Analysis Instance : $asInstance : $msg" $sqlConnection
				$warningCounter++
			}
			
			
			###########################################################################################################
			## IMPORTANT: $instanceConnectionString is written only on an Insert; subsequent updates are ignored.
			##            This allows an admin to override a default value if necessary without having it overwritten 
			##            during a later discovery.
			###########################################################################################################
			$sqlCommand.Parameters["@dnsHostName"].Value = $sqlHostName 
			$sqlCommand.Parameters["@InstanceName"].Value = $asInstance
			$sqlCommand.Parameters["@ProductName"].Value = "Microsoft SQL Analysis Server" ## Hard-coded value; meant to allow for other database products
			$sqlCommand.Parameters["@ProductEdition"].Value = $productEdition
			$sqlCommand.Parameters["@ProductVersion"].Value = $productVersion
			$sqlCommand.Parameters["@ProductServicePack"].Value = $productServicePack
			$sqlCommand.Parameters["@ConnectionString"].Value = $instanceConnectionString
			$sqlCommand.Parameters["@ServiceState"].Value = $serviceState
			$sqlCommand.Parameters["@IsClustered"].Value = $isClustered
			$sqlCommand.Parameters["@ActiveNode"].Value = ""
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			
			[Void]$sqlCommand.ExecuteNonQuery()
			
			# REMOVE THIS INSTANCE FROM THE HASH TABLE
			$discoveredInstances.Remove($asInstance)
		}
		Catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostname "Error" $moduleName "Analysis Instance : $asInstance : $msg" $sqlConnection
			$errorCounter++
		}
	}
	$sqlCommand.Dispose()
	
	# ANYTHING LEFT IN $discoveredInstances HASHTABLE HAS BEEN REMOVED FROM THE SERVER
	# THESE NEED TO BE INACTIVATED (ALONG WITH CHILD OBJECTS)
	$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisInstanceInactivate"
	[void]$sqlCommand.Parameters.Add("@AnalysisInstanceGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand.Parameters.Add("@IncludeChildObjects",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::DateTime)
	
	for($index=0; $index -lt $discoveredInstances.Count; $index++){
		[Guid]$instanceGUID = $discoveredInstances[$discoveredInstances.Keys[$index]].Guid
		$sqlCommand.Parameters["@AnalysisInstanceGUID"].Value = $instanceGUID
		$sqlCommand.Parameters["@IncludeChildObjects"].Value = $true	
		$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)	
		
		[Void]$sqlCommand.ExecuteNonQuery()
	}
	$sqlCommand.Dispose()	
}
#endregion

################################################################################
# CHECK FOR INSTALLATIONS OF SQL REPORTING SERVICES ENGINE
################################################################################
#region ReportingInstance

################################################################################
# EXCEPTION: ReportingServices are Clustered using NLB or some other
#			 method.  We don't want to check for a Reporting Services install
#			 on a clustered resource node.
################################################################################

$sqlCommand = GetStoredProc $sqlConnection "cm.spComputerSelect"
[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName

$sqlReader = $sqlCommand.ExecuteReader()
$sqlCommand.Dispose()

$dataTable = New-Object System.Data.DataTable
$dataTable.Load($SqlReader)

if($dataTable.Rows[0]["IsClusterResource"] -eq $false){

	# Retrieve instances already discovered on server
	$sqlCommand = GetStoredProc $sqlConnection "cm.spReportingInstanceSelectByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
	$sqlCommand.Parameters["@Active"].value = $true

	$sqlReader = $sqlCommand.ExecuteReader()
	$sqlCommand.Dispose()

	$dataTable = New-Object System.Data.DataTable
	$dataTable.Load($SqlReader)

	# CREATE A HASH TABLE OF PREVIOUSLY DISCOVERED (ACTIVE) INSTANCES
	$discoveredInstances = @{}
	If($dataTable.Rows.Count -gt 0){
		foreach($row in $dataTable){
			[Guid]$instanceGUID = $row["objectGUID"]
			[string]$instanceName = $row["InstanceName"]
			$discoveredInstances[$instanceName] = $instanceGUID
		}
	}
		
	$rsInstances = GetSQLInstances $dnsHostname "RS"
	if($rsInstances){

		$sqlCommand = GetStoredProc $sqlConnection "cm.spReportingInstanceUpsert"
		[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@InstanceName",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@ProductName",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@ProductEdition",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@ProductVersion",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@ProductServicePack",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@ConnectionString",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@ServiceState",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@RSConfiguration",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
		[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)	

		foreach($rsInstance in $rsInstances){
			Try {
				$sqlRegistryRoot = "SOFTWARE\\Microsoft\\Microsoft SQL Server"
				$instanceHive = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\Instance Names\\RS" $rsInstance
				[string]$productEdition = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Setup" "Edition"
				[string]$productVersion = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Setup" "Version"
				[string]$productServicePack = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Setup" "SP"
				[string]$rsConfiguration = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\Setup" "RSConfiguration"
				# [string]$portNumber = GetRegistryValue $dnsHostName "HKLM" "$sqlRegistryRoot\\$instanceHive\\MSSQLServer\\SuperSocketNetLib\Tcp\IPAll\\" "TcpPort"
				
				###########################################################################################################
				## IMPORTANT: $instanceConnectionString is written only on an Insert; subsequent updates are ignored.
				##            This allows an admin to override a default value if necessary without having it overwritten 
				##            during a later discovery.
				###########################################################################################################
				[string]$instanceConnectionString = "http://$dnshostname/reportserver_$rsInstance"	
				# Check the status of the Windows Service
				if($rsConfiguration -eq "Configured"){
					try {
						if($rsInstance -eq "MSSQLSERVER"){
							[string]$serviceState = (Get-Service -Name "ReportServer" -ComputerName $dnsHostName).Status
						} elseif ($rsInstance -eq "@SharePoint") {
							# TODO: Validate this configuration
							[string]$serviceState = (Get-Service -Name "ReportServer`$$rsInstance" -ComputerName $dnsHostName).Status
						} else {
							[string]$serviceState = (Get-Service -Name "ReportServer`$$rsInstance" -ComputerName $dnsHostName).Status
						}
					} 
					Catch [System.Exception] {
						$msg = $_.Exception.Message
						AddLogEntry $dnsHostname "Warning" $moduleName "Reporting Instance : $rsInstance : $msg" $sqlConnection
						$warningCounter++
					}
				} else {
					$serviceState = "None"
				}
				
				$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName 
				$sqlCommand.Parameters["@InstanceName"].Value = $rsInstance
				$sqlCommand.Parameters["@ProductName"].Value = "Microsoft SQL Reporting Services" ## Hard-coded value; meant to allow for other products
				$sqlCommand.Parameters["@ProductEdition"].Value = $productEdition
				$sqlCommand.Parameters["@ProductVersion"].Value = $productVersion
				$sqlCommand.Parameters["@ProductServicePack"].Value = $productServicePack
				$sqlCommand.Parameters["@ConnectionString"].Value = $instanceConnectionString
				$sqlCommand.Parameters["@ServiceState"].Value = $serviceState
				$sqlCommand.Parameters["@RSConfiguration"].Value = $rsConfiguration			
				$sqlCommand.Parameters["@Active"].Value = $true
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				
				[Void]$sqlCommand.ExecuteNonQuery()
			
				# REMOVE THIS INSTANCE FROM THE HASH TABLE
				$discoveredInstances.Remove($rsInstance)
			}
			Catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $dnsHostname "Error" $moduleName "Reporting Instance : $rsInstance : $msg" $sqlConnection
				$errorCounter++
			}
		}
		$sqlCommand.Dispose()
	}
	
	# ANYTHING LEFT IN $discoveredInstances HASHTABLE HAS BEEN REMOVED FROM THE SERVER
	# THESE NEED TO BE INACTIVATED (ALONG WITH CHILD OBJECTS)
	$sqlCommand = GetStoredProc $sqlConnection "cm.spReportingInstanceInactivate"
	[void]$sqlCommand.Parameters.Add("@ReportingInstanceGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand.Parameters.Add("@IncludeChildObjects",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::DateTime)
	
	for($index=0; $index -lt $discoveredInstances.Count; $index++){
		[Guid]$instanceGUID = $discoveredInstances[$discoveredInstances.Keys[$index]].Guid
		$sqlCommand.Parameters["@ReportingInstanceGUID"].Value = $instanceGUID
		$sqlCommand.Parameters["@IncludeChildObjects"].Value = $true	
		$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)	
		
		[Void]$sqlCommand.ExecuteNonQuery()
	}
	$sqlCommand.Dispose()	
}

#endregion

AddLogEntry $dnsHostName "Info" $moduleName "Check completed." $sqlConnection

################################################################################
# CLEANUP
################################################################################
[Void]$sqlConnection.Close
$sqlConnection.Dispose()

Write-Verbose " : $dnsHostname : $moduleName : Finish"

# Return error count
Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}