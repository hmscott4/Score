#************************************************************************************************************************************
# function CheckSQLJobs
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
#	- spAddSysJobs
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
[string]$moduleName = "CheckSQLJobs"
	
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

$sqlReader = $sqlCommand.ExecuteReader()
$sqlCommand.Dispose()

$dataTable = New-Object System.Data.DataTable
$dataTable.Load($SqlReader)

foreach($row in $dataTable){
	[string]$connectionString = $row["ConnectionString"]
	[string]$instanceName = $row["InstanceName"]
	[Guid]$databaseInstanceGUID = $row["objectGUID"]
	
	If($row["InstanceName"] -eq "MSSQLSERVER"){
		[string]$serviceName = "MSSQLSERVER"
	} else {
		[string]$serviceName = "MSSQL`$$instanceName"
	}	
	
	# Before attempting to connect, check to see if the service is running
	$serviceState = Get-Service -ComputerName $dnsHostName -Name $serviceName -ErrorAction SilentlyContinue
	If($serviceState){
		If($serviceState.Status -ne "Running"){
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

	$sqlServer = GetSMOConnection $ConnectionString $dbUserName $dbPassword

	if($sqlServer -eq $null){
		Write-Verbose " : $dnsHostName : $moduleName : $instanceName : Unable to connect to $connectionString." -ForegroundColor Red
		AddLogEntry $dnsHostName "Error" $moduleName "Unable to connect to $connectionString" $sqlConnection
		$errorCounter++
		Continue
	}
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spJobInactivateByInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()				

	$sqlCommand = GetStoredProc $sqlConnection "cm.spJobUpsert"
	[void]$sqlCommand.Parameters.Add("@JobID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand.Parameters.Add("@OriginatingServer",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@IsEnabled",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Category",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Owner",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DateCreated",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@DateModified",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@VersionNumber",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@LastRunDate",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@NextRunDate",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@CurrentRunStatus",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@LastRunOutcome",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@HasSchedule",  [System.Data.SqlDbType]::bit)	
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)	
		
	foreach($job in $sqlServer.JobServer.Jobs){
		try {
			if($job.DateCreated -eq "01/01/0001"){$dateCreated = [System.DBNull]::Value} else {$dateCreated = $job.DateCreated}
			if($job.DateLastModified -eq "01/01/0001"){$dateLastModified = [System.DBNull]::Value} else {$dateLastModified = $job.DateLastModified}
			if($job.LastRunDate -eq "01/01/0001"){$dateLastRun = [System.DBNull]::Value} else {$dateLastRun = $job.LastRunDate}
			if($job.NextRunDate -eq "01/01/0001"){$dateNextRun = [System.DBNull]::Value} else {$dateNextRun = $job.NextRunDate}
			
			$sqlCommand.Parameters["@JobID"].Value = $Job.JobID
			$sqlCommand.Parameters["@DatabaseInstanceGUID"].Value = $databaseInstanceGUID
			$sqlCommand.Parameters["@OriginatingServer"].Value = $Job.OriginatingServer
			$sqlCommand.Parameters["@Name"].Value = $Job.Name
			$sqlCommand.Parameters["@IsEnabled"].Value = $Job.IsEnabled
			$sqlCommand.Parameters["@Description"].Value = $Job.Description
			$sqlCommand.Parameters["@Category"].Value = $Job.Category
			$sqlCommand.Parameters["@Owner"].Value = $Job.OwnerLoginName
			$sqlCommand.Parameters["@DateCreated"].Value = $dateCreated
			$sqlCommand.Parameters["@DateModified"].Value = $dateLastModified
			$sqlCommand.Parameters["@VersionNumber"].Value = $Job.VersionNumber
			$sqlCommand.Parameters["@LastRunDate"].Value = $dateLastRun
			$sqlCommand.Parameters["@NextRunDate"].Value = $dateNextRun
			$sqlCommand.Parameters["@CurrentRunStatus"].Value = $Job.CurrentRunStatus
			$sqlCommand.Parameters["@LastRunOutcome"].Value = $Job.LastRunOutcome
			$sqlCommand.Parameters["@HasSchedule"].Value = $Job.HasSchedule		
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)		
			
			[Void]$sqlCommand.ExecuteNonQuery()
		} 
		catch [System.Exception] {
		$msg = $_.Exception.Message
		AddLogEntry $dnsHostName "Warning" $moduleName $msg $sqlConnection
		$warningCounter++
	}
	$sqlCommand.Dispose()			
	}
}

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