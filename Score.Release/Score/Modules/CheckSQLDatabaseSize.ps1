#************************************************************************************************************************************
# function CheckSQLDatabaseSize
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
#	- cm.spDatabaseSizeUpdate
#	- pm.spDatabaseSizeRawInsert
#
# Overview
# 	Iterate through databases on each instance and update size
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
[string]$moduleName = "CheckSQLDatabaseSize"
	
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

################################################################################
# THIS PROCESS WILL ONLY RETRIEVE DATABASE IN THE REPOSITORY
# IT WILL NOT DISCOVER NEW DATABASES
################################################################################

# Retrieve instances installed on server
$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstanceSelectByComputer"
[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::Bit)
$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
$sqlCommand.Parameters["@Active"].value = $true

$sqlReader = $sqlCommand.ExecuteReader()
$sqlCommand.Dispose()

$instanceDataTable = New-Object System.Data.DataTable
$instanceDataTable.Load($SqlReader)

# Iterate through database instances
#region DatabaseInstance
foreach($row in $instanceDataTable){
	[Guid]$databaseInstanceGUID = $row["objectGUID"]
	[string]$instanceName = $row["InstanceName"]
	[string]$connectionString = $row["ConnectionString"]
	
	If($row["InstanceName"] -eq "MSSQLSERVER"){
		[string]$serviceName = "MSSQLSERVER"
	} else {
		[string]$serviceName = "MSSQL`$$instanceName"
	}

	# Before attempting to connect, check to see if the service is running
	$instanceState = Get-Service -ComputerName $dnsHostName -Name $serviceName # -ErrorAction SilentlyContinue
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
		
	
	# Retrieve databases for this instance 
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseSelectByDatabaseInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	$sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID

	$sqlReader = $sqlCommand.ExecuteReader()
	$sqlCommand.Dispose()

	$databaseDataTable = New-Object System.Data.DataTable
	$databaseDataTable.Load($SqlReader)
	
	# Connect to the target Instance
	$sqlServer = GetSMOConnection $connectionString $dbUserName $dbPassword
	if($sqlServer -eq $null){
		Write-Verbose " : $dnsHostName : $moduleName : $instanceName : Unable to connect to instance." -ForegroundColor Red
		AddLogEntry $dnsHostName "Error" $moduleName "$dnsHostName : $instanceName : Unable to connect to instance." $sqlConnection
		$errorCounter++
		continue
	}
	
	foreach($row in $databaseDataTable){
		$database = $sqlServer.Databases[$row["DatabaseName"]]
		
		# It's possible that a database will have been deleted since the last discovery
		# since this process only works with KNOWN databases, must include here a check
		# for non-existent database
		if($database -eq $null){
			continue
		}

		[Int64]$dataFileSize = 0
		[Int64]$dataFileSpaceUsed = 0
		[Int64]$logFileSize = 0
		[Int64]$logFileSpaceUsed = 0

		try {
			if($database.Status -eq "Normal"){
			
				# Data Files
				foreach($fileGroup in $database.FileGroups) { 
					foreach($file in $fileGroup.Files) {
						
						# Keep a running tally for database space used and database file size
						$dataFileSize += $file.Size
						$dataFileSpaceUsed += $file.UsedSpace
					}
				}
				# Log Files
				foreach($logFile in $database.LogFiles) {
					# Keep a running tally for database space used and database file size
					$logFileSize += $logFile.Size
					$logFileSpaceUsed += $logFile.UsedSpace
				}
				
				# Get the count of Virtual Log files
				$virtualLogFileCount = $database.ExecuteWithResults("DBCC LOGINFO").Tables[0]
				
				# Update cm.Database with current size
				$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseSizeUpdate"
    			[Void]$sqlCommand.Parameters.Add("@DatabaseGUID", [system.data.SqlDbType]::uniqueidentifier)
				[Void]$sqlCommand.Parameters.Add("@DataFileSize", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@DataFileSpaceUsed", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@LogFileSize", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@LogFileSpaceUsed", [system.data.SqlDbType]::BigInt)
				[Void]$sqlCommand.Parameters.Add("@VirtualLogFileCount", [system.data.SqlDbType]::Int)
				
				$sqlCommand.Parameters["@DatabaseGUID"].Value = $row["objectGUID"]
				$sqlCommand.Parameters["@DataFileSize"].Value = $dataFileSize * 1024
				$sqlCommand.Parameters["@DataFileSpaceUsed"].Value = $dataFileSpaceUsed * 1024
				$sqlCommand.Parameters["@LogFileSize"].Value = $logFileSize * 1024
				$sqlCommand.Parameters["@LogFileSpaceUsed"].Value = $logFileSpaceUsed * 1024
				$sqlCommand.Parameters["@VirtualLogFileCount"].Value = $virtualLogFileCount.Rows.Count
				[void]$sqlCommand.ExecuteNonQuery()
				$sqlCommand.Dispose()

				# Insert a record into pm.DatabaseSizeRaw
				$sqlCommand = GetStoredProc $sqlConnection "pm.spDatabaseSizeRawInsert"
				[void]$sqlCommand.Parameters.Add("@DateTime",  [System.Data.SqlDbType]::datetime)
				[void]$sqlCommand.Parameters.Add("@DatabaseGUID",  [System.Data.SqlDbType]::uniqueidentifier)
				[void]$sqlCommand.Parameters.Add("@DataFileSize",  [System.Data.SqlDbType]::bigint)
				[void]$sqlCommand.Parameters.Add("@DataFileSpaceUsed",  [System.Data.SqlDbType]::bigint)
				[void]$sqlCommand.Parameters.Add("@LogFileSize",  [System.Data.SqlDbType]::bigint)
				[void]$sqlCommand.Parameters.Add("@LogFileSpaceUsed",  [System.Data.SqlDbType]::bigint)
				[void]$sqlCommand.Parameters.Add("@dbAddDate",  [System.Data.SqlDbType]::datetime)
				
				[DateTime]$timeNow = (Get-Date)
				$sqlCommand.Parameters["@DateTime"].Value = $timeNow
				$sqlCommand.Parameters["@DatabaseGUID"].Value = $row["objectGUID"]
				$sqlCommand.Parameters["@DataFileSize"].Value = $dataFileSize * 1024
				$sqlCommand.Parameters["@DataFileSpaceUsed"].Value = $dataFileSpaceUsed * 1024
				$sqlCommand.Parameters["@LogFileSize"].Value = $logFileSize * 1024
				$sqlCommand.Parameters["@LogFileSpaceUsed"].Value = $logFileSpaceUsed * 1024
				$sqlCommand.Parameters["@dbAddDate"].Value = $timeNow
				[void]$sqlCommand.ExecuteNonQuery()	
				$sqlCommand.Dispose()
				
			} 
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Error" $moduleName "Database Size : $database.Name: $msg" $sqlConnection
			$warningCounter++
		}
	}		
} 
#endregion


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