#************************************************************************************************************************************
# function CheckInstalledHotfix
#
# Parameters:
# 	- $dnsHostName
# 	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- spInstalledApplicationUpsert
#
# Get the list of installed applications FROM the Windows Registry Uninstall tree
# This is NOT a perfect enumeration of all installed applications; for example,
# Oracle has its own installer/uninstaller and therefore will not show up
# in this listing.
#************************************************************************************************************************************
{ 
[CmdletBinding()] 
param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
	[Parameter(Mandatory=$False,Position=2)]
	[psCredential]$psCredential,
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
[string]$moduleName = "CheckInstalledHotfix"

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

try	{
	if($psCredential){
		$HotFixes = Get-HotFix -ComputerName $dnsHostName -Credential $psCredential	
	} else {
		$HotFixes = Get-HotFix -ComputerName $dnsHostName	
	}
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spWindowsUpdateInstallationInactivateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()			

	$sqlCommand = GetStoredProc $sqlConnection "cm.spWindowsUpdateInstallationUpsert"
	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@HotfixID",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Caption",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@FixComments",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@InstallDate",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@InstallBy",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			
	foreach($Hotfix in $Hotfixes){ 
		Try {
			$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
			$sqlCommand.Parameters["@HotfixID"].Value = $hotFix.HotfixID
			$sqlCommand.Parameters["@Description"].Value = $hotFix.Description
			$sqlCommand.Parameters["@Caption"].Value = $hotFix.Caption
			$sqlCommand.Parameters["@FixComments"].Value = $hotFix.FixComments
			$sqlCommand.Parameters["@InstallDate"].Value = $hotFix.InstalledOn
			$sqlCommand.Parameters["@InstallBy"].Value = $hotFix.InstalledBy
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			[Void]$sqlCommand.ExecuteNonQuery()
		}
		Catch [System.Exception] {
			$msg=$_.Exception.Message
            $HotfixID = $Hotfix.HotfixID
			AddLogEntry $dnsHostName "Warning" $moduleName "$HotfixID : $msg" $sqlConnection
			$warningCounter++
		}	
		
	$sqlCommand.Dispose()
	}
}
catch [System.Exception] {
	$msg = $_.Exception.Message
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