#************************************************************************************************************************************
# function CheckServices
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- cm.spServiceUpsert
#
# Comments:
# 	Tried using CIM_Service, but it was waaaay slow.
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
[string]$moduleName = "CheckServices"

################################################################################
# ESTABLISH CONNECTION TO CENTRAL REPOSITORY
################################################################################
$sqlConnection = GetSQLConnection -sqlConnectionString $sqlConnectionString
if ($sqlConnection.State -ne "Open")	{
	Throw "Unable to open central repository database.  Application terminating."
	Return New-Object psobject -Property @{ErrorCount = 1; WarningCount = 0}
}

Write-Verbose " : $dnsHostName : $moduleName : Start"

try	{
	# Add Log Entry
	AddLogEntry $dnsHostName "Info" $moduleName "Starting check..." $sqlConnection	

	[string]$queryString = "SELECT * FROM Win32_Service"
	$Services = GetCIMResult $dnsHostName $queryString $PSCredential

	$sqlCommand = GetStoredProc $sqlConnection "cm.spServiceInactivateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
    $sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
    $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()	
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spServiceUpsert"
	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DisplayName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Status",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@State",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@StartMode",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@StartName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@PathName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@AcceptStop",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@AcceptPause",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
	
	foreach ($Service in $Services) {
		Try {
			$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
			$sqlCommand.Parameters["@Name"].Value = $Service.Name
			$sqlCommand.Parameters["@DisplayName"].Value = $Service.DisplayName
			$sqlCommand.Parameters["@Description"].Value = $Service.Description
			$sqlCommand.Parameters["@Status"].Value = $Service.Status
			$sqlCommand.Parameters["@State"].Value = $Service.State
			$sqlCommand.Parameters["@StartMode"].Value = $Service.StartMode
			$sqlCommand.Parameters["@StartName"].Value = $Service.StartName
			$sqlCommand.Parameters["@PathName"].Value = $Service.PathName
			$sqlCommand.Parameters["@AcceptStop"].Value = $Service.AcceptStop
			$sqlCommand.Parameters["@AcceptPause"].Value = $Service.AcceptPause
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)	
			
			[Void]$sqlCommand.ExecuteNonQuery()
		} 
		Catch [System.Exception] {
			[string]$serviceName = $Service.Name
			$msg=$_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "$serviceName : $msg" $sqlConnection
			$warningCounter++
		}	
	}
	$sqlCommand.Dispose()	
}	
catch [System.Exception] {
	$msg = $_.Exception.Message
    AddLogEntry $dnsHostName "Error" $moduleName "$msg" $sqlConnection
	$errorCounter	
}


# Add Log Entry
AddLogEntry $dnsHostName "Info" $moduleName "Check completed." $sqlConnection	

################################################################################
# CLEANUP
################################################################################
[Void]$sqlConnection.Close
$sqlConnection.Dispose()

Write-Verbose " : $dnsHostName : $moduleName : Finish"

# Return global error count
Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}