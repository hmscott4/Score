#************************************************************************************************************************************
# function CheckInstalledApplications
#
# Parameters:
# 	- $dnsHostName
# 	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- cm.spApplicationInstallationUpsert (note, this maintains a master list of installed software using cm.ApplicationUpsert)
#
# Get the list of installed applications from the Windows Registry Uninstall tree
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
[string]$moduleName = "CheckInstalledApplications"

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
	#Open Remote Base
	[string]$root = GetRegistryClassName "HKLM"
	if($dnsHostName -match $Env:COMPUTERNAME) {
		[string]$machineName = $Env:COMPUTERNAME
	} else {
		[string]$machineName = $dnsHostName
	}
	$reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey($root, $machineName)

	#Check if it's got 64bit regkeys
	$keyRootSoftware = $reg.OpenSubKey("SOFTWARE")
	[bool]$is64 = ($keyRootSoftware.GetSubKeyNames() | Where-Object {$_ -eq 'WOW6432Node'} | Measure-Object).Count
	$keyRootSoftware.Close()

	#Get all of they keys into a list
	$softwareKeys = @()
	if ($is64){
	    $pathUninstall64 = "SOFTWARE\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
	    $keyUninstall64 = $reg.OpenSubKey($pathUninstall64)
	    foreach($key in $keyUninstall64.GetSubKeyNames()) {
	        $softwareKeys += $pathUninstall64 + "\\" + $key
	    }
	    $keyUninstall64.Close()
	}
	$pathUninstall32 = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
	$keyUninstall32 = $reg.OpenSubKey($pathUninstall32)
	foreach($key in $keyUninstall32.GetSubKeyNames()) {
	    $softwareKeys += $pathUninstall32 + "\\" + $key
	}
	$keyUninstall32.Close()
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spApplicationInstallationInactivateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()			

	$sqlCommand = GetStoredProc $sqlConnection "cm.spApplicationInstallationUpsert"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::NVarChar)
	[Void]$sqlCommand.Parameters.Add("@Version", [system.data.SqlDbType]::NVarChar)
	[Void]$sqlCommand.Parameters.Add("@Vendor", [system.data.SqlDbType]::NVarChar)
	[Void]$sqlCommand.Parameters.Add("@InstallDate", [system.data.SqlDbType]::DateTime)
	[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::Bit)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::DateTime)
			
	#Get information from all the keys
	foreach($softwareKey in $softwareKeys) {
	    $subkey=$reg.OpenSubKey($softwareKey)
	    if ($subkey.GetValue("DisplayName")){
	        [string]$tempInstallDate = $subkey.GetValue("InstallDate")
			if (!$tempInstallDate) {
				$installDate = [System.DBNull]::Value			
			}
	        if ($tempInstallDate -match "/"){
	            $installDate = Get-Date $subkey.GetValue("InstallDate")
	        }
	        elseif ($tempInstallDate.length -eq 8){
	            $installDate = Get-Date $subkey.GetValue("InstallDate").Insert(6,".").Insert(4,".")
	        } else {
				$installDate = [System.DBNull]::Value
			}

			Try {
			    $applicationName = $subkey.GetValue("DisplayName")
			    $applicationVersion = $subKey.GetValue("DisplayVersion")
			    $applicationPublisher = $subKey.GetValue("Publisher")
				if(!$applicationPublisher){$applicationPublisher = "Unknown"}
				if(!$applicationVersion) {$applicationVersion = "Unknown"}

	        	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	        	$sqlCommand.Parameters["@Name"].value = $applicationName
	        	$sqlCommand.Parameters["@Version"].value = $applicationVersion
	        	$sqlCommand.Parameters["@Vendor"].value = $applicationPublisher
	        	$sqlCommand.Parameters["@InstallDate"].value = $installDate
	        	$sqlCommand.Parameters["@Active"].value = $true
	        	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
				[Void]$sqlCommand.ExecuteNonQuery()
			}
			Catch [System.Exception] {
				$msg=$_.Exception.Message
				AddLogEntry $dnsHostName "Warning" $moduleName "$applicationName : $msg" $sqlConnection
				$warningCounter++			
			}	
	    }
	    $subkey.Close()
	}
	$reg.Close()	

	
	$sqlCommand.Dispose()
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