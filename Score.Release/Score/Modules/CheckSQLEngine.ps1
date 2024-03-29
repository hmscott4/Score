#************************************************************************************************************************************
# function CheckSQLEngine
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#	- $dbUserName
#	- $dbPassword
#
# Stored Procedures: 
#	- cm.spDatabaseInstancePropertyUpsert
#	- cm.spDatabaseUpsert
#	- cm.spDatabasePropertyUpsert
#	- cm.spDatabaseFileUpsert
#
# Overview
# 	1.  Iterate through database instances on server, update databases and instance properties
#	2.  Iterate through databases on each instance, update database properties and files
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
	[string]$invocationPath,
	[Parameter(Mandatory=$False,Position=5)]
	[string]$dbUserName="",
	[Parameter(Mandatory=$False,Position=6)]
	[string]$dbPassword=""
)

Set-StrictMode -Version "Latest"

# Change path to working folder
Set-Location $invocationPath	

. ".\modules\MonitorFunctions.ps1"

# Initialize error variables
[int]$errorCounter = 0
[int]$warningCounter = 0
[string]$moduleName = "CheckSQLEngine"
	
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

# Load the Microsoft SQL Server SMO model
[Void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO")

# Retrieve instances installed on server
$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstanceSelectByComputer"
[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
$sqlCommand.Parameters["@Active"].value = $true

$sqlReader = $sqlCommand.ExecuteReader()
$sqlCommand.Dispose()

$dataTable = New-Object System.Data.DataTable
$dataTable.Load($SqlReader)

# array to store active (running) instances; used during Part 2
$activeInstances = @()

# Part 1.  Retrieve information about Database Instance Properties and Databases
#region DatabaseInstance
foreach($row in $dataTable){
	[Guid]$databaseInstanceGUID = $row["objectGUID"]
	[string]$instanceName = $row["InstanceName"]
	[string]$connectionString = $row["ConnectionString"]
	
	If($row["InstanceName"] -eq "MSSQLSERVER"){
		[string]$serviceName = "MSSQLSERVER"
	} else {
		[string]$serviceName = "MSSQL`$$instanceName"
	}

	# Before attempting to connect, check to see if the service is running
	$instanceState = Get-Service -ComputerName $dnsHostName -Name $serviceName -ErrorAction SilentlyContinue
	If($instanceState){
		If($instanceState.Status -ne "Running"){
			Write-Verbose " : $dnsHostName : $moduleName : $instanceName : Service not running; no connection made." -ForegroundColor Yellow
			AddLogEntry $dnsHostName "Warning" $moduleName "$dnsHostName : $instanceName : Service not running; no connection made." $sqlConnection
			$warningCounter++
			continue
		}
	} else {
		# This should never happen
		Write-Verbose " : $dnsHostName : $moduleName : $instanceName : Service does not exist; no connection made." -ForegroundColor Red
		AddLogEntry $dnsHostName "Error" $moduleName "$dnsHostName : $instanceName : Service does not exist; no connection made." $sqlConnection
		$errorCounter++
		continue	
	}
		
	$sqlServer = GetSMOConnection $connectionString $dbUserName $dbPassword
	if($sqlServer -eq $null){
		Write-Verbose " : $dnsHostName : $moduleName : $instanceName : Unable to connect to instance." -ForegroundColor Red
		AddLogEntry $dnsHostName "Error" $moduleName "$dnsHostName : $instanceName : Unable to connect to instance." $sqlConnection
		$errorCounter++
		continue
	}
	$activeInstance = New-Object psobject -Property @{DatabaseInstanceGUID = $databaseInstanceGUID; ConnectionString = $connectionString}
	$activeInstances += $activeInstance
	
	#region DatabaseInstanceProperties
	try {
		if($sqlServer.Version.Major -gt 8) {
		
			$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstancePropertyInactivateByDatabaseInstance"
			[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
			[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
		    $sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
		    $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
			
			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()			
		
			$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstancePropertyUpsert"
			[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
			[Void]$sqlCommand.Parameters.Add("@PropertyName", [system.data.SqlDbType]::nvarchar)
			[Void]$sqlCommand.Parameters.Add("@PropertyValue", [system.data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			
			foreach($property in $sqlServer.Properties){
				if($property.Name -eq "PolicyHealthState"){
					continue
				}
				else {
					if($property.Value -eq $null){$propertyValue = [System.DBNull]::Value} else {$propertyValue = $property.Value.ToString()}
				    $sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
				    $sqlCommand.Parameters["@PropertyName"].value = $property.Name
				    $sqlCommand.Parameters["@PropertyValue"].value = $propertyValue
					$sqlCommand.Parameters["@Active"].Value = $true
					$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
					
					[Void]$sqlCommand.ExecuteNonQuery()
				}
			}
		}
	}
	catch [System.Exception] {
		$msg = $_.Exception.Message
		AddLogEntry $dnsHostName "Warning" $moduleName "Database Instance Properties : $instanceName : $property.Name : $msg" $sqlConnection
		$warningCounter++
	}
	$sqlCommand.Dispose()
	#endregion	

	#region CheckDatabases
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInactivateByDatabaseInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@IncludeChildObjects", [system.data.SqlDbType]::bit)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
    $sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
    $sqlCommand.Parameters["@IncludeChildObjects"].value = $true
    $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	
	foreach($database in $sqlServer.Databases){
		try {
			if($database.LastBackupDate -eq "01/01/0001"){$lastBackupDate = [System.DBNull]::Value} else {$lastBackupDate = $database.LastBackupDate}
			if($database.LastDifferentialBackupDate -eq "01/01/0001"){$lastDifferentialBackupDate = [System.DBNull]::Value} else {$lastDifferentialBackupDate = $database.LastDifferentialBackupDate}
			if($database.LastLogBackupDate -eq "01/01/0001"){$lastLogBackupDate = [System.DBNull]::Value} else {$lastLogBackupDate = $database.LastLogBackupDate} 
			[string]$compatibilityLevel = $database.CompatibilityLevel
			
			$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseUpsert"
			[void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID",  [System.Data.SqlDbType]::uniqueidentifier)
			[void]$sqlCommand.Parameters.Add("@DatabaseName",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@DatabaseID",  [System.Data.SqlDbType]::int)
			[void]$sqlCommand.Parameters.Add("@RecoveryModel",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@Status",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@ReadOnly",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand.Parameters.Add("@UserAccess",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@CreateDate",  [System.Data.SqlDbType]::datetime)
			[void]$sqlCommand.Parameters.Add("@Owner",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@LastFullBackup",  [System.Data.SqlDbType]::datetime)
			[void]$sqlCommand.Parameters.Add("@LastDiffBackup",  [System.Data.SqlDbType]::datetime)
			[void]$sqlCommand.Parameters.Add("@LastLogBackup",  [System.Data.SqlDbType]::datetime)
			[void]$sqlCommand.Parameters.Add("@CompatibilityLevel",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
	
			$sqlCommand.Parameters["@DatabaseInstanceGUID"].Value = $databaseInstanceGUID
			$sqlCommand.Parameters["@DatabaseName"].Value = $Database.Name
			$sqlCommand.Parameters["@DatabaseID"].Value = $Database.ID
			$sqlCommand.Parameters["@RecoveryModel"].Value = $Database.RecoveryModel
			$sqlCommand.Parameters["@Status"].Value = $Database.Status
			$sqlCommand.Parameters["@ReadOnly"].Value = $Database.ReadOnly
			$sqlCommand.Parameters["@UserAccess"].Value = $Database.UserAccess
			$sqlCommand.Parameters["@CreateDate"].Value = $Database.CreateDate
			$sqlCommand.Parameters["@Owner"].Value = NullToString $database.Owner ""
			$sqlCommand.Parameters["@LastFullBackup"].Value = $lastBackupDate
			$sqlCommand.Parameters["@LastDiffBackup"].Value = $lastDifferentialBackupDate
			$sqlCommand.Parameters["@LastLogBackup"].Value = $lastLogBackupDate
			$sqlCommand.Parameters["@CompatibilityLevel"].Value = $Database.CompatibilityLevel
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)		
			
			[Void]$sqlCommand.ExecuteNonQuery()
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "Databases : $database.Name : $msg" $sqlConnection
			$warningCounter++
		}
	} 
	$sqlCommand.Dispose()
	
	#region LinkedServers
	$sqlCommand = GetStoredProc $sqlConnection "cm.spLinkedServerInactivateByDatabaseInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
    $sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
    $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()	
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spLinkedServerUpsert"
	[void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand.Parameters.Add("@ID",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DataSource",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Catalog",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ProductName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Provider",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ProviderString",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DistPublisher",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@Distributor",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@Publisher",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@Subscriber",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@Rpc",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@RpcOut",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@DataAccess",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@DateLastModified",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@State",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
	
	foreach($linkedServer in $sqlServer.LinkedServers){
		try {	
			$sqlCommand.Parameters["@DatabaseInstanceGUID"].Value = $databaseInstanceGUID
			$sqlCommand.Parameters["@ID"].Value = $linkedServer.ID
			$sqlCommand.Parameters["@Name"].Value = $linkedServer.Name
			$sqlCommand.Parameters["@DataSource"].Value = $linkedServer.DataSource
			$sqlCommand.Parameters["@Catalog"].Value = $linkedServer.Catalog
			$sqlCommand.Parameters["@ProductName"].Value = $linkedServer.ProductName
			$sqlCommand.Parameters["@Provider"].Value = $linkedServer.ProviderName
			$sqlCommand.Parameters["@ProviderString"].Value = $linkedServer.ProviderString
			$sqlCommand.Parameters["@DistPublisher"].Value = $linkedServer.DistPublisher
			$sqlCommand.Parameters["@Distributor"].Value = $linkedServer.Distributor
			$sqlCommand.Parameters["@Publisher"].Value = $linkedServer.Publisher
			$sqlCommand.Parameters["@Subscriber"].Value = $linkedServer.Subscriber
			$sqlCommand.Parameters["@Rpc"].Value = $linkedServer.Rpc
			$sqlCommand.Parameters["@RpcOut"].Value = $linkedServer.RpcOut
			$sqlCommand.Parameters["@DataAccess"].Value = $linkedServer.DataAccess
			$sqlCommand.Parameters["@DateLastModified"].Value = $linkedServer.DateLastModified
			$sqlCommand.Parameters["@State"].Value = $linkedServer.State
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			[void]$sqlCommand.ExecuteNonQuery()
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "LinkedServers : $linkedServer.Name : $msg" $sqlConnection
			$warningCounter++
		}
		
	}
	$sqlCommand.Dispose()
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spLinkedServerLoginInactivateByDatabaseInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
    $sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
    $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()	
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spLinkedServerLoginUpsert"
	[void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand.Parameters.Add("@LinkedServerID",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Impersonate",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@State",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DateLastModified",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
	
	foreach($linkedServer in $sqlServer.LinkedServers){
		foreach($linkedServerLogin in $linkedServer.LinkedServerLogins) {
			try {
				$sqlCommand.Parameters["@DatabaseInstanceGUID"].Value = $databaseInstanceGUID
				$sqlCommand.Parameters["@LinkedServerID"].Value = $linkedServer.ID
				$sqlCommand.Parameters["@Name"].Value = $linkedServerLogin.Name
				$sqlCommand.Parameters["@Impersonate"].Value = $linkedServerLogin.Impersonate
				$sqlCommand.Parameters["@State"].Value = $linkedServerLogin.State
				$sqlCommand.Parameters["@DateLastModified"].Value = $linkedServerLogin.DateLastModified
				$sqlCommand.Parameters["@Active"].Value = $true
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				[void]$sqlCommand.ExecuteNonQuery()
			}
			catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $dnsHostName "Warning" $moduleName "LinkedServerLogins : $linkedServer.Name : $linkedServerLogin.Name : $msg" $sqlConnection
				$warningCounter++
			}
		}
	}
	$sqlCommand.Dispose()
	#endregion
	
	
	#region SQLEngineConfiguration
	
	[int]$storeConfigurationHistory = GetConfigValue -configName "StoreConfigurationHistory" -sqlConnection $sqlConnection
	
	If($storeConfigurationHistory -eq 1){
		try {
			$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstanceConfigurationUpsert"
			[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
			[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			
		    $sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			
			[Void]$sqlCommand.ExecuteNonQuery()
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "Database Instance Configuration : $instanceName : $msg" $sqlConnection
			$warningCounter++
		}
		$sqlCommand.Dispose()
	}
	#endregion
}
#endregion			

# Part 2: Iterate through discovered databases for properties and files
foreach($activeInstance in $activeInstances){
	[Guid]$databaseInstanceGUID = $activeInstance.DatabaseInstanceGUID
	$connectionString = $activeInstance.ConnectionString
	
	# Retrieve databases for this instance 
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseSelectByDatabaseInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
	$sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
	$sqlCommand.Parameters["@Active"].value = $true

	$sqlReader = $sqlCommand.ExecuteReader()
	$sqlCommand.Dispose()

	$dataTable = New-Object System.Data.DataTable
	$dataTable.Load($SqlReader)
	
	# Connect to the target Instance
	$sqlServer = GetSMOConnection $connectionString $dbUserName $dbPassword
	
	foreach($row in $dataTable){
		
		$database = $sqlServer.Databases[$row["DatabaseName"]]
		
		#region DatabaseProperties
		try {
			if($database.Status -eq "Normal"){
			
				
				$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabasePropertyUpsert"
				[Void]$sqlCommand.Parameters.Add("@DatabaseGUID", [system.data.SqlDbType]::uniqueidentifier)
				[Void]$sqlCommand.Parameters.Add("@PropertyName", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@PropertyValue", [system.data.SqlDbType]::nvarchar)
				[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
				[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
				
				foreach($property in $database.Properties){
					if($property.Value -eq $null){$propertyValue = [System.DBNull]::Value} else {$propertyValue = $property.Value.ToString()}
					
				    $sqlCommand.Parameters["@DatabaseGUID"].value = $row["objectGUID"]
				    $sqlCommand.Parameters["@PropertyName"].value = $property.Name
				    $sqlCommand.Parameters["@PropertyValue"].value = $propertyValue
					$sqlCommand.Parameters["@Active"].Value = $true
					$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)		
					
					[Void]$sqlCommand.ExecuteNonQuery()
				}
				$sqlCommand.Dispose()
			}
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "Database Properties : $database.Name : $property.Name : $msg" $sqlConnection
			$warningCounter++
		}
		#endregion				

		#region DatabaseFiles
		try {
			if($database.Status -eq "Normal"){		
			
				$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseFileUpsert"
    			[Void]$sqlCommand.Parameters.Add("@DatabaseGUID", [system.data.SqlDbType]::uniqueidentifier)
				[Void]$sqlCommand.Parameters.Add("@FileID", [system.data.SqlDbType]::int)
				[Void]$sqlCommand.Parameters.Add("@FileGroup", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@LogicalName", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@PhysicalName", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@FileSize", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@MaxSize", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@SpaceUsed", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@Growth", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@GrowthType", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@IsReadOnly", [system.data.SqlDbType]::bit)
				[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
				[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			
				# Data Files
				$dataFileSpaceUsed = 0
				$dataFileSize = 0
				foreach($fileGroup in $database.FileGroups) { 
					foreach($file in $fileGroup.Files) {
	                    # if(!$file.IsReadOnly){$bIsReadOnly = $false} else {$bIsReadOnly = $file.IsReadOnly}
		    			$sqlCommand.Parameters["@DatabaseGUID"].value = $row["objectGUID"]
		    			$sqlCommand.Parameters["@FileID"].value = $file.ID
						$sqlCommand.Parameters["@FileGroup"].value = $fileGroup.Name
						$sqlCommand.Parameters["@LogicalName"].value = $file.Name
						$sqlCommand.Parameters["@PhysicalName"].value = $file.FileName
						$sqlCommand.Parameters["@FileSize"].value = $file.Size * 1024
						$sqlCommand.Parameters["@MaxSize"].value = $file.MaxSize * 1024
						$sqlCommand.Parameters["@SpaceUsed"].value = $file.UsedSpace * 1024
						$sqlCommand.Parameters["@Growth"].value = $file.Growth
						$sqlCommand.Parameters["@GrowthType"].value = $file.GrowthType
						$sqlCommand.Parameters["@IsReadOnly"].value = $file.IsReadOnly 
						$sqlCommand.Parameters["@Active"].Value = $true
						$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)	
						
						[Void]$sqlCommand.ExecuteNonQuery()
						
						# Keep a running tally for database space used and database file size
						$dataFileSpaceUsed += $file.UsedSpace
						$dataFileSize += $file.Size			
					}
				}
				$sqlCommand.Dispose()

					
				$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseFileUpsert"
    			[Void]$sqlCommand.Parameters.Add("@DatabaseGUID", [system.data.SqlDbType]::uniqueidentifier)
				[Void]$sqlCommand.Parameters.Add("@FileID", [system.data.SqlDbType]::int)
				[Void]$sqlCommand.Parameters.Add("@FileGroup", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@LogicalName", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@PhysicalName", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@FileSize", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@MaxSize", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@SpaceUsed", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@Growth", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@GrowthType", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@IsReadOnly", [system.data.SqlDbType]::bit)
				[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
				[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
				
				# Log Files
				$logFileSize = 0
				$logFileSpaceUsed = 0
				foreach($logFile in $database.LogFiles) {
	    			$sqlCommand.Parameters["@DatabaseGUID"].value = $row["objectGUID"]
	    			$sqlCommand.Parameters["@FileID"].value = $logFile.ID
					$sqlCommand.Parameters["@FileGroup"].value = "Log"
					$sqlCommand.Parameters["@LogicalName"].value = $logFile.Name
					$sqlCommand.Parameters["@PhysicalName"].value = $logFile.FileName
					$sqlCommand.Parameters["@FileSize"].value = $logFile.Size * 1024
					$sqlCommand.Parameters["@MaxSize"].value = $logFile.MaxSize * 1024
					$sqlCommand.Parameters["@SpaceUsed"].value = $logFile.UsedSpace * 1024
					$sqlCommand.Parameters["@Growth"].value = $logFile.Growth
					$sqlCommand.Parameters["@GrowthType"].value = $logFile.GrowthType
					$sqlCommand.Parameters["@IsReadOnly"].value = $logFile.IsReadOnly 
					$sqlCommand.Parameters["@Active"].Value = $true
					$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)	
					
					[Void]$sqlCommand.ExecuteNonQuery()
					
					# Keep a running tally for database space used and database file size
					$logFileSize += $logFile.Size
					$logFileSpaceUsed += $logFile.UsedSpace
				}
				$sqlCommand.Dispose()
			} 
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Error" $moduleName "Database Files : $database.Name: $msg" $sqlConnection
			$warningCounter++
		}
		
		#region SQLDatabaseConfiguration		
		[int]$storeConfigurationHistory = GetConfigValue -configName "StoreConfigurationHistory" -sqlConnection $sqlConnection
		
		If($storeConfigurationHistory -eq 1){
			try {
				$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseConfigurationUpsert"
				[Void]$sqlCommand.Parameters.Add("@DatabaseGUID", [system.data.SqlDbType]::uniqueidentifier)
				[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
				
			    $sqlCommand.Parameters["@DatabaseGUID"].value = $row["objectGUID"]
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				
				[Void]$sqlCommand.ExecuteNonQuery()
			}
			catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $dnsHostName "Warning" $moduleName "Database Configuration : $instanceName : $msg" $sqlConnection
				$warningCounter++
			}
			$sqlCommand.Dispose()
		}
		#endregion
	}		
} 

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