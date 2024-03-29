#************************************************************************************************************************************
# function CheckOperatingSystem
#
# Parameters:
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- spUpdateComputerWMI
#
#************************************************************************************************************************************
{
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
	[Parameter(Mandatory=$false,Position=2)]
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
[string]$moduleName = "CheckOperatingSystem"

#************************************************************************************************************************************
# function GetCIMOSType
#
# Parameters:
# 	- OsType to convert
#
# Function to convert OSType (int) to String
#
#************************************************************************************************************************************
function GetCIMOSType {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$OSType
)
	[string]$value = ""
	Switch($OsType){
		0 {$value = "Unknown"}
		15 {$value = "Windows 3.x"}
		16 {$value = "Windows 95"}
		17 {$value = "Windows 98"}
		18 {$value = "Windows NT"}
		19 {$value = "Windows CE"}
		36 {$value = "Linux"}
		default {$value = "Unknown: $OSType"}
	}
	
	return $value
}

#************************************************************************************************************************************
# function GetComputerGroupMembers
#
# Parameters:
# 	- $dnsHostName
# 	- $GroupName
#	- $psCredential
#
# Stored Procedures: 
#	- cm.ComputerGroupMemberUpsert 
#************************************************************************************************************************************
function GetComputerGroupMembers {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$GroupName,
	[Parameter(Mandatory=$False,Position=3)]
	[Management.Automation.PSCredential]$psCredential
)
	
	[string]$netBIOSName = $dnsHostName.Substring(0, $dnsHostName.IndexOf("."))
	
	try {
		[string]$queryString = "SELECT * FROM Win32_GroupUser WHERE GroupComponent = `"Win32_Group.Domain='$netBIOSName',Name='$GroupName'`""
		$MemberRefCollection = GetCIMResult $dnsHostName $queryString $psCredential
				
		$sqlCommand = GetStoredProc $sqlConnection "cm.spComputerGroupMemberInactivateByComputer"
		[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@GroupName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
		$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
		$sqlCommand.Parameters["@GroupName"].value = $GroupName
		$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
		
		[Void]$sqlCommand.ExecuteNonQuery()
		$sqlCommand.Dispose()
		
		$sqlCommand = GetStoredProc $sqlConnection "cm.spComputerGroupMemberUpsert"
		[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@GroupName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@MemberName", [system.data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
		[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)

		foreach ($MemberRef in $MemberRefCollection)	{
		 	
			# Code logic is as follows:
			# Typical result: \\SQL2008R2SRV1\root\cimv2:Win32_UserAccount.Domain="SQL2008R2SRV1",Name="Administrator"
			# Split by "." to get domain/user into a string
			# Split by "," to get domain and user into separate strings
			# Remove Name= and Domain= and quote marks
			[array]$aDomainPart = $MemberRef.PartComponent.Split(".")
			[array]$aNamePart = $aDomainPart[1].Split(",")
			[string]$sDomain = $aNamePart[0].Replace("Domain=","").Replace("""","")
			[string]$sUserName = $aNamePart[1].Replace("Name=","").Replace("""","")
			
	        $sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	        $sqlCommand.Parameters["@GroupName"].value = $GroupName
	        $sqlCommand.Parameters["@MemberName"].value = $sDomain + "\" + $sUserName
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)

			[Void]$sqlCommand.ExecuteNonQuery()
		}
		$sqlCommand.Dispose()		
		
	}
    catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry $dnsHostName "Error" $moduleName "CheckLocalGroupMembers: $msg" $sqlConnection
    }
}

################################################################################
# ESTABLISH CONNECTION TO CENTRAL REPOSITORY
################################################################################
$sqlConnection = GetSQLConnection $sqlConnectionString
if ($sqlConnection.State -ne "Open")	{
	Throw "Unable to open central repository database.  Application terminating."
	Return New-Object psobject -Property @{ErrorCount = 1; WarningCount = 0}
}	

Write-Verbose " : $dnsHostName : $moduleName : Start"

# Add Log Entry
AddLogEntry $dnsHostName "Info" $moduleName "Starting check..." $sqlConnection

################################################################################
# OBTAIN REMOTE HOST IP ADDRESS
################################################################################	
$pingStatus = GetNetworkPingStatus $dnsHostName
[string]$IPV4Address = $pingStatus.IPV4Address.ToString()

################################################################################
# CONNECT TO REMOTE SERVER AND COLLECT CIM DATA
################################################################################	
try {
	# Connect to CIM_OperatingSystem to retrieve basic info
	[string]$queryString = "SELECT * FROM CIM_OperatingSystem"
	$operatingSystem = GetCIMResult -dnsHostName $dnsHostName -queryString $queryString -psCredential $psCredential
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spOperatingSystemUpsert"

	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@IPV4Address",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Manufacturer",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@OSArchitecture",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@OSType",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@OperatingSystem",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Version",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ServicePack",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ServicePackMajorVersion",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@ServicePackMinorVersion",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@BootDevice",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@SystemDevice",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@WindowsDirectory",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@SystemDirectory",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@TotalVisibleMemorySize",  [System.Data.SqlDbType]::bigint)
	[void]$sqlCommand.Parameters.Add("@InstallDate",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@LastBootUpTime",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@Status",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)

	$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
	$sqlCommand.Parameters["@IPV4Address"].Value = $IPV4Address
	$sqlCommand.Parameters["@Manufacturer"].Value = $operatingSystem.Manufacturer
    If($operatingSystem.Version -like "5*"){
    	$sqlCommand.Parameters["@OSArchitecture"].Value = ""
    } else {
        $sqlCommand.Parameters["@OSArchitecture"].Value = $operatingSystem.OSArchitecture
    }
	$sqlCommand.Parameters["@OSType"].Value = GetCIMOSType $operatingSystem.OSType
	$sqlCommand.Parameters["@OperatingSystem"].Value = $operatingSystem.Caption
	$sqlCommand.Parameters["@Description"].Value = $operatingSystem.Description
	$sqlCommand.Parameters["@Version"].Value = $operatingSystem.Version
	$sqlCommand.Parameters["@ServicePack"].Value = $operatingSystem.CSDVersion
	$sqlCommand.Parameters["@ServicePackMajorVersion"].Value = $operatingSystem.ServicePackMajorVersion
	$sqlCommand.Parameters["@ServicePackMinorVersion"].Value = $operatingSystem.ServicePackMinorVersion
	$sqlCommand.Parameters["@BootDevice"].Value = $operatingSystem.BootDevice
	$sqlCommand.Parameters["@SystemDevice"].Value = $operatingSystem.SystemDevice
	$sqlCommand.Parameters["@WindowsDirectory"].Value = $operatingSystem.WindowsDirectory
	$sqlCommand.Parameters["@SystemDirectory"].Value = $operatingSystem.SystemDirectory
	$sqlCommand.Parameters["@TotalVisibleMemorySize"].Value = $operatingSystem.TotalVisibleMemorySize
	$sqlCommand.Parameters["@InstallDate"].Value = WMIDateStringToDate $operatingSystem.InstallDate
	$sqlCommand.Parameters["@LastBootUpTime"].Value = WMIDateStringToDate $operatingSystem.LastBootUpTime
	$sqlCommand.Parameters["@Status"].Value = $operatingSystem.Status
	$sqlCommand.Parameters["@Active"].Value = $true
	$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
	
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()		
}
catch [System.Exception] {
	$msg=$_.Exception.Message
	AddLogEntry $dnsHostName "Error" $moduleName $msg $sqlConnection
	$errorCounter++
}

################################################################################
# CHECK MEMBERSHIP IN SELECTED LOCAL GROUPS (ONE CALL NEEDED PER GROUP)
################################################################################
GetComputerGroupMembers -dnsHostName $dnsHostName -GroupName "Administrators" -psCredential $psCredential
GetComputerGroupMembers -dnsHostName $dnsHostName -GroupName "ORA_DBA" -psCredential $psCredential


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