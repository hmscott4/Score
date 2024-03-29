#************************************************************************************************************************************
# function CheckEvents
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- spEventInsert
#
# Check Eventlog for errors and warnings
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
	[string]$logName="System"
)

Set-StrictMode -Version "Latest"

# Change path to working folder
Set-Location $invocationPath	

. ".\modules\MonitorFunctions.ps1"

# Initialize error variables
[int]$errorCounter = 0
[int]$warningCounter = 0
[string]$moduleName = "CheckEvents"
	
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
AddLogEntry $dnsHostName "Info" $moduleName "Starting check..."	$sqlConnection

try	{
	# Get the objectGUID for the computer
	$sqlCommand = GetStoredProc $sqlConnection "cm.spComputerSelect"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	$sqlReader = $sqlCommand.ExecuteReader()
	$dataTable = New-Object System.Data.DataTable
	$dataTable.Load($SqlReader)
	
	# There's almost certainly a better way to do this, but for now, since we only expect a single row
	[Guid]$ComputerGUID = $dataTable.Rows[0]["objectGUID"]
	
	# Determine the last date for which there is data in the eventlog
	$sqlCommand = GetStoredProc $sqlConnection "cm.spEventGetMaxDateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@LogName", [system.data.SqlDbType]::nvarchar)
	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	$sqlCommand.Parameters["@LogName"].value = $logName
	$cutoffDate = $sqlCommand.ExecuteScalar()
	
	# Update the cutoff date to an arbitrary value if it is null
    if ($cutoffDate -eq [System.DBNull]::Value){
		$cutoffDate=[DateTime](Get-Date).AddDays(-7)
	}

	# Connect to Event Log service
	if($dnsHostName -match $Env:COMPUTERNAME) {
		$Events = Get-EventLog -After $cutoffDate -EntryType "Error" -LogName $logName
	} else {
		$Events = Get-EventLog -ComputerName $dnsHostName -After $cutoffDate -EntryType "Error" -LogName $logName
	}	
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spEventInsert"
    [Void]$sqlCommand.Parameters.Add("@ComputerGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@MachineName", [system.data.SqlDbType]::nvarchar)
    [Void]$sqlCommand.Parameters.Add("@LogName", [system.data.SqlDbType]::nvarchar)
    [Void]$sqlCommand.Parameters.Add("@EventId", [system.data.SqlDbType]::int)
	[Void]$sqlCommand.Parameters.Add("@Source", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@TimeGenerated", [system.data.SqlDbType]::DateTime)
	[Void]$sqlCommand.Parameters.Add("@EntryType", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Message", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@UserName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbAddDate", [system.data.SqlDbType]::DateTime)

	foreach($Event in $Events) {
		try {
	        $sqlCommand.Parameters["@ComputerGUID"].value = $ComputerGUID
	        $sqlCommand.Parameters["@MachineName"].value = $Event.MachineName
	        $sqlCommand.Parameters["@LogName"].value = $logName
	        $sqlCommand.Parameters["@EventId"].value = $Event.EventId         
	        $sqlCommand.Parameters["@Source"].value = $Event.Source
	        $sqlCommand.Parameters["@TimeGenerated"].value =  $Event.TimeGenerated
	        $sqlCommand.Parameters["@EntryType"].value = $Event.EntryType
	        $sqlCommand.Parameters["@Message"].value = $Event.Message
	        $sqlCommand.Parameters["@UserName"].value = $Event.UserName
	        $sqlCommand.Parameters["@dbAddDate"].value = (Get-Date)
			
		   	[Void]$sqlCommand.ExecuteNonQuery()
		}
		catch {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "$msg" $sqlConnection
			$warningCounter++		
		}
	}
	$sqlCommand.Dispose()
}
catch [System.Exception]{
	$msg=$_.Exception.Message
	AddLogEntry $dnsHostName "Error" $moduleName $msg $sqlConnection
	$errorCounter++
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