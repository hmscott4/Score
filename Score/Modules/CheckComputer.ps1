#************************************************************************************************************************************
# function CheckComputer
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- cm.spComputerUpsert
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
[string]$moduleName = "CheckComputer"

#************************************************************************************************************************************
# function GetDomainRole
#
# Parameters:
# 	- DomainRole to convert
#
# Function to convert OSType (int) to String
#
#************************************************************************************************************************************
function GetDomainRole {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
	[int]$DomainRole
)
	if($DomainRole){
		[string]$value = ""
		Switch($DomainRole){
			0 {$value = "Standalone Workstation"}
			1 {$value = "Member Workstation"}
			2 {$value = "Standalone Server"}
			3 {$value = "Member Server"}
			4 {$value = "Backup Domain Controller"}
			5 {$value = "Primary Domain Controller"}
			default {$value = "Unknown: $DomainRole"}
		}
		
		return $value
	} else {
		return "Unknown"
	}
}

#************************************************************************************************************************************
# function GetPCSystemType
#
# Parameters:
# 	- PCSystemType to convert
#
# Function to convert OSType (int) to String
#
#************************************************************************************************************************************
function GetPCSystemType {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=0)]
	[int]$PCSystemType
)
	If($PCSystemType){
		[string]$value = ""
		Switch($PCSystemType){
			0 {$value = "Unspecified"}
			1 {$value = "Desktop"}
			2 {$value = "Mobile"}
			3 {$value = "Workstation"}
			4 {$value = "Enterprise Server"}
			5 {$value = "SOHO Server"}
			6 {$value = "Applicance PC"}
			7 {$value = "PerformanceServer"}
			8 {$value = "Maximum"}		
			default {$value = "Unknown: $PCSystemType"}
		}
		
		return $value
	} else {
		return "Unspecified"
	}
}

#************************************************************************************************************************************
# function GetPendingReboot
#
# Parameters:
# 	- dnsHostName
#
# Adapted from https://gallery.technet.microsoft.com/scriptcenter/Get-PendingReboot-Query-bdb79542
#    Author:  Brian Wilhite
#    Email:   bwilhite1@carolina.rr.com
#    Date:    08/29/2012
#    PSVer:   2.0/3.0
#    Updated: 05/30/2013
#
#************************************************************************************************************************************
Function GetPendingReboot
{
[CmdletBinding()]
param(
	[Parameter(Mandatory=$true,Position=0)]
	[String]$dnsHostName
)

	Begin {
		# Adjusting ErrorActionPreference to stop on all errors, since using [Microsoft.Win32.RegistryKey]
	    # does not have a native ErrorAction Parameter, this may need to be changed if used within another
	    # function.
		$TempErrAct = $ErrorActionPreference
		$ErrorActionPreference = "Stop"
	}
	Process {
		Try {
			if($dnsHostName -match $Env:COMPUTERNAME) {
				[string]$machineName = $Env:COMPUTERNAME
			} else {
				[string]$machineName = $dnsHostName
			}	
			# Setting pending values to false to cut down on the number of else statements
			[bool]$PendFileRename = $false
			[bool]$Pending = $false
			[bool]$SCCM = $false
	        
	        # Setting CBSRebootPend to null since not all versions of Windows have this value
	        $CBSRebootPend = $null
			
			# Querying WMI for build version
			$WMI_OS = Get-WmiObject -Class Win32_OperatingSystem -Property BuildNumber, CSName -ComputerName $machineName

			# Making registry connection to the local/remote computer
			$RegCon = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"LocalMachine",$machineName)
			
			# If Vista/2008 & Above query the CBS Reg Key
			If ($WMI_OS.BuildNumber -ge 6001) {
					$RegSubKeysCBS = $RegCon.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\").GetSubKeyNames()
					$CBSRebootPend = $RegSubKeysCBS -contains "RebootPending"			
			}
				
			# Query WUAU from the registry
			$RegWUAU = $RegCon.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\")
			$RegWUAURebootReq = $RegWUAU.GetSubKeyNames()
			$WUAURebootReq = $RegWUAURebootReq -contains "RebootRequired"
			
			# Query PendingFileRenameOperations from the registry
			# $RegSubKeySM = $RegCon.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\")
			# $RegValuePFRO = $RegSubKeySM.GetValue("PendingFileRenameOperations",$null)
			
			# Closing registry connection
			# $RegCon.Close()
			
			# If PendingFileRenameOperations has a value set $RegValuePFRO variable to $true
			# If ($RegValuePFRO) {
			# 	$PendFileRename = $true
			# }

			# Determine SCCM 2012 Client Reboot Pending Status
			# To avoid nested 'if' statements and unneeded WMI calls to determine if the CCM_ClientUtilities class exist, setting EA = 0
			$CCMClientSDK = $null
	        $CCMSplat = @{
	            NameSpace='ROOT\ccm\ClientSDK'
	            Class='CCM_ClientUtilities'
	            Name='DetermineIfRebootPending'
	            ComputerName=$machineName
	            ErrorAction='SilentlyContinue'
	            }
	        $CCMClientSDK = Invoke-WmiMethod @CCMSplat
			If ($CCMClientSDK) {
                If ($CCMClientSDK.ReturnValue -ne 0) {
					Write-Warning "Error: DetermineIfRebootPending returned error code $($CCMClientSDK.ReturnValue)"
			    }
		        If ($CCMClientSDK.IsHardRebootPending -or $CCMClientSDK.RebootPending) {
				    $SCCM = $true
			    }
	        } Else {
	        	$SCCM = $null
	        }                        
	        
	        # If any of the variables are true, set $Pending variable to $true
			If ($CBSRebootPend -or $WUAURebootReq -or $SCCM -or $PendFileRename) {
				$Pending = $true
			}
				
			# Creating Custom PSObject and Select-Object Splat
	        $SelectSplat = @{
	            Property=('Computer','CBServicing','WindowsUpdate','CCMClientSDK','RebootPending')
	            }
			New-Object -TypeName PSObject -Property @{
					Computer=$WMI_OS.CSName
					CBServicing=$CBSRebootPend
					WindowsUpdate=$WUAURebootReq
					CCMClientSDK=$SCCM
					RebootPending=$Pending
					} | Select-Object @SelectSplat

		}
		#End Try

		Catch {
				Write-Warning "$machineName`: $_"
		}
		#End Catch
			
	}#End Process
	
	End {
		# Resetting ErrorActionPref
		$ErrorActionPreference = $TempErrAct
	}#End End
	
}#End Function

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

try {
	# Grab a reference to the cm.spComputerUpsert stored procedure
	$sqlCommand = GetStoredProc $sqlConnection "cm.spComputerUpsert"
	[Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@netBIOSName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@IPv4Address", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@DomainRole", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@CurrentTimeZone", [system.data.SqlDbType]::Int)
	[Void]$sqlCommand.Parameters.Add("@DaylightInEffect", [system.data.SqlDbType]::Bit)
	[Void]$sqlCommand.Parameters.Add("@Status", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Manufacturer", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Model", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@PCSystemType", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@SystemType", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@AssetTag", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@SerialNumber", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@TotalPhysicalMemory", [system.data.SqlDbType]::BigInt)
	[Void]$sqlCommand.Parameters.Add("@NumberOfLogicalProcessors", [system.data.SqlDbType]::Int)
	[Void]$sqlCommand.Parameters.Add("@NumberOfProcessors", [system.data.SqlDbType]::Int)
	[Void]$sqlCommand.Parameters.Add("@IsVirtual", [system.data.SqlDbType]::Bit)
	[Void]$sqlCommand.Parameters.Add("@PendingReboot", [system.data.SqlDbType]::Bit)
	[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::Bit)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::DateTime)

	# Connect to CIM_OperatingSystem to retrieve basic info; Need this to check compatibility
	[string]$queryString = "SELECT * FROM CIM_OperatingSystem"
	$operatingSystem = GetCIMResult -dnsHostName $dnsHostName -queryString $queryString -psCredential $psCredential
	

	# Connect to CIM_ComputerSystem to retrieve basic info
	[string]$queryString = "SELECT * FROM CIM_ComputerSystem"
	$ComputerSystem = GetCIMResult -dnsHostName $dnsHostName -queryString $queryString -psCredential $psCredential

	[string]$domainRoleString = GetDomainRole $ComputerSystem.DomainRole
	# NOTE: we've already checked that we can ping, so no need for extra check here
	$pingStatus = GetNetworkPingStatus -dnsHostName $dnsHostName
	[string]$IPV4Address = $pingStatus.IPV4Address.ToString()
    If($operatingSystem.Version -like "5*") {
    	[string]$stringPCSystemType = ""
    } else {
    	[string]$stringPCSystemType = GetPCSystemType $ComputerSystem.PCSystemType
    }

	if($ComputerSystem.PartOfDomain){
		$domainString = $ComputerSystem.Domain
	} else {
		$domainString = $ComputerSystem.Workgroup
	}
	
	# Check for pending reboot
	$rebootPending = GetPendingReboot $dnsHostName
	
    $sqlCommand.Parameters["@Domain"].value = $domainString
	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	$sqlCommand.Parameters["@netBIOSName"].value = $ComputerSystem.Name
    $sqlCommand.Parameters["@IPv4Address"].value = $IPV4Address
    $sqlCommand.Parameters["@DomainRole"].value = $domainRoleString
    $sqlCommand.Parameters["@CurrentTimeZone"].value = $ComputerSystem.CurrentTimeZone
    $sqlCommand.Parameters["@DaylightInEffect"].value = $ComputerSystem.DaylightInEffect
    $sqlCommand.Parameters["@Status"].value = $ComputerSystem.Status
    $sqlCommand.Parameters["@Manufacturer"].value = $ComputerSystem.Manufacturer
    $sqlCommand.Parameters["@Model"].value = $ComputerSystem.Model
    $sqlCommand.Parameters["@PCSystemType"].value = $stringPCSystemType
    $sqlCommand.Parameters["@SystemType"].value = $ComputerSystem.SystemType
	$sqlCommand.Parameters["@AssetTag"].value = ""
    $sqlCommand.Parameters["@TotalPhysicalMemory"].value = $ComputerSystem.TotalPhysicalMemory
    If($operatingSystem.Version -like "5*"){
        $sqlCommand.Parameters["@NumberOfLogicalProcessors"].value = $ComputerSystem.NumberOfProcessors
    } else {
        $sqlCommand.Parameters["@NumberOfLogicalProcessors"].value = $ComputerSystem.NumberOfLogicalProcessors
    }

    $sqlCommand.Parameters["@NumberOfProcessors"].value = $ComputerSystem.NumberOfProcessors
	if (($ComputerSystem.Manufacturer -like "VMware*") -or ($ComputerSystem.Manufacturer -like "Microsoft*")) {
		$sqlCommand.Parameters["@IsVirtual"].value = $true
	}
	else {
   		$sqlCommand.Parameters["@IsVirtual"].value = $false
	}
	$sqlCommand.Parameters["@PendingReboot"].value = $rebootPending.RebootPending
	$sqlCommand.Parameters["@Active"].value = $true
    $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)

	# Next connect to Win32_ComputerSystemProduct to retrieve serial number
	$queryString = "SELECT IdentifyingNumber FROM Win32_ComputerSystemProduct"
	$Computer = GetCIMResult -dnsHostName $dnsHostName -queryString $queryString -psCredential $psCredential

    $sqlCommand.Parameters["@SerialNumber"].value = $Computer.IdentifyingNumber

	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()		
}
catch [System.Exception] {
	$msg=$_.Exception.Message
	AddLogEntry $dnsHostName "Error" $moduleName $msg $sqlConnection
	$errorCounter++
}

#region ComputerConfigurationHistory		
################################################################################
# UPDATE CONFIGURATION HISTORY
################################################################################
	[int]$storeConfigurationHistory = GetConfigValue -configName "StoreConfigurationHistory" -sqlConnection $sqlConnection
	
	If($storeConfigurationHistory -eq 1){
	
		# Retrieve Physical Drives for this Computer 
		$sqlCommand = GetStoredProc $sqlConnection "cm.spComputerSelect"
		[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
		$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
		
		$sqlReader = $sqlCommand.ExecuteReader()
		$sqlCommand.Dispose()

		$dataTable = New-Object System.Data.DataTable
		$dataTable.Load($SqlReader)	
	
		foreach($row in $dataTable){
			try {
				$sqlCommand = GetStoredProc $sqlConnection "cm.spComputerConfigurationUpsert"
				[Void]$sqlCommand.Parameters.Add("@ComputerGUID", [system.data.SqlDbType]::uniqueidentifier)
				[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
				
			    $sqlCommand.Parameters["@ComputerGUID"].value = $row["objectGUID"]
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				
				[Void]$sqlCommand.ExecuteNonQuery()
			}
			catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $dnsHostName "Warning" $moduleName "Computer Configuration : $dnsHostName : $msg" $sqlConnection
				$warningCounter++
			}
			$sqlCommand.Dispose()
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

Write-Verbose " : $dnsHostName : $moduleName : Finish : $errorCounter error(s) : $warningCounter warning(s)"

# Return error count
Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}