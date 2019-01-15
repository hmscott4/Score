#************************************************************************************************************************************
# function GetSQLConnectionString
#
# Parameters:
# 	- Database Server
# 	- Database 
#	- Database User
#	- Database Password
#
# function to encapsulate connections to SQL Database Servers
#************************************************************************************************************************************
function GetSQLConnectionString {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
	[string]$dbServer,
  [Parameter(Mandatory=$True,Position=2)]
	[string]$dbName,
  [Parameter(Mandatory=$False,Position=3)]
	[string]$dbUser = $null,
  [Parameter(Mandatory=$False,Position=4)]
	[string]$dbPassword = $null
)
	if ($dbUser.Length -eq 0){
		$sqlConnectionString = "Application Name=Catalog;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=" + $dbName + ";Data Source=" + $dbServer
	}
	else {
		$sqlConnectionString = "Application Name=Catalog;Persist Security Info=False;UID=" + $dbUser + ";Password=" + $dbPassword + ";Initial Catalog=" + $dbName + ";Data Source=" + $dbServer
	}
	
	Return $sqlConnectionString
}

#************************************************************************************************************************************
# function GetSQLConnection
#
# Parameters:
# 	- Connection String
#
# function to encapsulate connections to SQL Database Servers
#************************************************************************************************************************************
function GetSQLConnection {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
	[string]$sqlConnectionString
)
	
	$sqlConnection = New-Object System.Data.SqlClient.SqlConnection($sqlConnectionString)
	$sqlConnection.Open()
	
	Return $sqlConnection
}

#************************************************************************************************************************************
# function GetStoredProc
#
# Parameters:
# 	- Database Connection
#	- Procedure Name
#
# Function to return a reference to a stored procedure
#************************************************************************************************************************************
function GetStoredProc {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection,
  [Parameter(Mandatory=$True,Position=2)]
	[string]$sqlCommandName
)
		
	$sqlCommand = new-Object System.Data.SqlClient.SqlCommand
	$sqlCommand.CommandText = $sqlCommandName
    $sqlCommand.Connection = $sqlConnection
    $sqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure
	return $sqlCommand
}

#************************************************************************************************************************************
# function GetSQLInstances
#
# Parameters:
# 	- dnsHostName
#	- sqlClass
#
# Enumerate the installed instances of Analysis Services on the machine
#************************************************************************************************************************************
function GetSQLInstances {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
  [Parameter(Mandatory=$True,Position=2)]
  [ValidateSet("RS","SQL","OLAP")]
	[string]$sqlClass
)
	# Initialize to $null
	$instanceNames = $null
	try {
		# Connect to remote registry and retrieve instances
		[string]$root = GetRegistryClassName "HKLM"
		[string]$sSubKey = "SOFTWARE\\Microsoft\\Microsoft SQL Server\\Instance Names\\$sqlClass\\" # location for SQL 2005+

		if($dnsHostName -match $Env:COMPUTERNAME) {
			[string]$machineName = $Env:COMPUTERNAME
		} else {
			[string]$machineName = $dnsHostName
		}		
		
		$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($root, $machineName)         
		$regKey = $reg.OpenSubKey($sSubKey)           
		if($regKey) {
			$instanceNames = $regkey.GetValueNames()
		} elseif ($sqlClass -eq "SQL") {
			$sSubKey = "SOFTWARE\\Microsoft\\Microsoft SQL Server\\" # location for SQL 2000
			$regKey = $reg.OpenSubKey($sSubKey)
			if($regKey){
				$instanceNames = $regKey.GetValue("InstalledInstances")
				if(!$instanceNames){
					# Write-Host "Unable to locate $sqlClass instances on $dnsHostName"
					$instanceNames = $null
				}
			}
		} else {
			$instanceNames = $null
			# Write-Host "Unable to locate $sqlClass instances on $dnsHostName"
		}
	}
	catch [System.Exception] {
		$instanceNames = $null
		# Write-Host "Unable to locate $sqlClass instances on $dnsHostName"
	}

	return $instanceNames
}

#************************************************************************************************************************************
# function GetSMOConnection
#
# Parameters:
# 	- Database Server
#	- Database User
#	- Database Password
#
# function to encapsulate connections to the SMO object
#
#************************************************************************************************************************************
function GetSMOConnection {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
	[string]$dbServer,
  [Parameter(Mandatory=$False,Position=2)]
	[string]$dbUser,
  [Parameter(Mandatory=$False,Position=3)]
	[string]$dbPassword
)
	# Load the SQL Management Objects assembly (Pipe out-null supresses output)
	[Void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO")
	[Void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")
	$serverConnection = new-object Microsoft.SqlServer.Management.Common.ServerConnection
	
	if($dbUser.Length -gt 0){
		$serverConnection.ServerInstance=$dbServer
		$serverConnection.LoginSecure = $false
		$serverConnection.Login = $dbUser
		$serverConnection.Password = $dbPassword
		$serverConnection.ApplicationName = "Catalog Monitor"
	} else {
		$serverConnection.ServerInstance = $dbServer
		$serverConnection.LoginSecure = $true
		$serverConnection.ApplicationName = "Catalog Monitor"
	}
	
	Try {
		$sqlServer = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $serverConnection
		# In order to initiate the connection, you have to retrieve a property
		if($sqlServer.Version -eq $null){
			return $null
		} else {
			return $sqlServer
		}
	}
	Catch [System.Exception] {
			$msg = $_.Exception.Message
	}
}

#************************************************************************************************************************************
# function WMIDateStringToDate
#
# Parameters:
# 	- String to Convert
#
# function to convert String to proper Date Time
#
#************************************************************************************************************************************
function WMIDateStringToDate {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
	[string]$dateTimeString
)
	Return [System.Management.ManagementDateTimeconverter]::ToDateTime($dateTimeString)
}  

#************************************************************************************************************************************
# function GetDomainNetBIOSName
#
# Parameters:
# 	- adDomain
#
# Function to Convert Domain string to NetBIOS Name (ie foo.com to FOO)
#
#************************************************************************************************************************************
function GetDomainNetBIOSName {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
	[string]$adDomain
)
	$Domain = Get-ADDomain -Server $adDomain
	if($Domain){
		return $Domain.NetBIOSName
	} else {
		return $null
	}
}
#************************************************************************************************************************************
# function NullToString
#
# Parameters:
# 	$value1
#	$value2
#
# Converts a null value to a string
#************************************************************************************************************************************
function NullToString {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$False,Position=1)]
	[string]$value1,
  [Parameter(Mandatory=$False,Position=2)]
	[string]$value2
)
	if($value1 -eq $null){
		return $value2
	}
	else {
		return $value1
	}
}

#************************************************************************************************************************************
# function NullToDBNull
#
# Parameters:
# 	$value1
#
# Converts a null value to DBNull
#************************************************************************************************************************************
function NullToDBNull {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$False,Position=1)]
	[string]$value1
)
	if($value1 -eq $null){
		return [System.DBNull]::Value
	}
	else {
		return $value1
	}
}

#************************************************************************************************************************************
# Function AddLogEntry
#
# Parameters:
# 	- Computer Name (or other reference name)
#	- Status (Normal, Error)
#	- Module
#	- Message
#	- sqlConnection
#
# Returns:
#   - Nothing
#
# Writes log information about current process to dbo.ProcessLog
#
#************************************************************************************************************************************
Function AddLogEntry {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
    [string]$Reference,
  [Parameter(Mandatory=$True,Position=2)]
	[string]$Status,
  [Parameter(Mandatory=$True,Position=3)]
	[string]$moduleName,
  [Parameter(Mandatory=$True,Position=4)]
	[string]$messageString,
  [Parameter(Mandatory=$True,Position=5)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)

    # Open Connection to CMDB database
	$sqlCommand = GetStoredProc $sqlConnection "dbo.spProcessLogInsert"

	[Void]$sqlCommand.Parameters.Add("@Object", [system.data.SqlDbType]::nvarchar)
    [Void]$sqlCommand.Parameters.Add("@Severity", [system.data.SqlDbType]::nvarchar)
    [Void]$sqlCommand.Parameters.Add("@Process", [system.data.SqlDbType]::nvarchar)
    [Void]$sqlCommand.Parameters.Add("@Message", [system.data.SqlDbType]::nvarchar)
    [Void]$sqlCommand.Parameters.Add("@MessageDate", [system.data.SqlDbType]::DateTime)
	
    $sqlCommand.Parameters["@Object"].value = $Reference
    $sqlCommand.Parameters["@Severity"].value = $Status	
    $sqlCommand.Parameters["@Process"].value = $moduleName	
    $sqlCommand.Parameters["@Message"].value = $messageString
    $sqlCommand.Parameters["@MessageDate"].value = (Get-Date)

    [Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
}

#************************************************************************************************************************************
# Function GetConfigValue
#
# Parameters:
# 	- $configName
#   - $sqlConnection
#
# Returns:
#   - Nothing
#
# Writes log information about current process to dbo.ProcessLog
#
#************************************************************************************************************************************
Function GetConfigValue {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
    [string]$configName,
  [Parameter(Mandatory=$True,Position=2)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)

    # Open Connection to CMDB database
	$sqlCommand = GetStoredProc $sqlConnection "dbo.spConfigSelect"

	[Void]$sqlCommand.Parameters.Add("@ConfigName", [system.data.SqlDbType]::nvarchar)	
    $sqlCommand.Parameters["@ConfigName"].value = $configName

    $sqlReader = $sqlCommand.ExecuteReader()
	$dataTable = New-Object System.Data.DataTable
	$dataTable.Load($SqlReader)		
	$sqlCommand.Dispose()
	
	If($dataTable.Rows.Count -gt 0){
		return $dataTable.Rows[0]["ConfigValue"]
	} else {
		return $null
	}
}

#************************************************************************************************************************************
# function MaxValue
#
# Parameters:
# 	$value1
#	$value2
#
# Returns the maximum value from two values passed in
#************************************************************************************************************************************
function MaxValue {
param(
    [Parameter(Mandatory=$True,Position=1)]
	[decimal]$value1,
    [Parameter(Mandatory=$True,Position=2)]
	[decimal]$value2
)

	if($value1 -gt $value2){
		return $value1
	} else {
		return $value2
	}
}

#************************************************************************************************************************************
# function MaxDate
#
# Parameters:
# 	$value1
#	$value2
#
# Returns the maximum date from two dates passed in
#************************************************************************************************************************************
function MaxDate {
param(
    [Parameter(Mandatory=$True,Position=1)]
	[datetime]$value1,
    [Parameter(Mandatory=$True,Position=2)]
	[datetime]$value2
)

	if($value1 -gt $value2){
		return $value1
	} else {
		return $value2
	}
}

#************************************************************************************************************************************
# function GetCIMResult
#
# Parameters:
# 	- $dnsHostName
#	- $queryString
#	- $psCredential
#
# Returns CIM Query Object; optionally uses alternate credentials to query remote host
#************************************************************************************************************************************
function GetCIMResult {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
    [Parameter(Mandatory=$True,Position=2)]
	[string]$queryString,
    [Parameter(Mandatory=$False,Position=3)]
	[pscredential]$psCredential
)

	try {
		if($psCredential){
			$result = Get-WmiObject -Query $queryString -ComputerName $dnsHostName -Credential $psCredential 
		} else {
			$result = Get-WmiObject -Query $queryString -ComputerName $dnsHostName
		}
		
		return $result	
	}
	catch [System.Exception] {
		$msg = $_.Exception.Message
		# AddLogEntry $dnsHostName "Error" "GetCIMResult" "$msg. Query : $queryString"
        Write-Host "$dnsHostName : $msg"
		return $null
	}
}

#************************************************************************************************************************************
# function GetNetworkPingStatus
#
# Parameters:
# 	- $dnsHostName
#
# Returns response time to host (and IP Address); null if error
#************************************************************************************************************************************
function GetNetworkPingStatus {
[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName
)

	$pingStatus = get-wmiobject -Query "select * from win32_pingstatus where Address='$dnsHostName'"
	if($pingStatus.StatusCode -eq 0){
		# Return $pingStatus.ResponseTime, $pingStatus.IPV4Address.ToString()
        Return $pingStatus
	} else {
		return $null
	}
}

#************************************************************************************************************************************
# function TestPort
#
# Parameters:
# 	- ComputerName | IP
#   - Port
#   - Protocol
# 
# Returns "Success" or "Failed"
# From: http://www.travisgan.com/2014/03/use-powershell-to-test-port.html
#************************************************************************************************************************************
function TestPort {
[CmdletBinding()]
Param(
    [parameter(ParameterSetName='ComputerName', Position=0)]
    [string]
    $ComputerName,
    [parameter(ParameterSetName='IP', Position=0)]
    [System.Net.IPAddress]
    $IPAddress,
    [parameter(Mandatory=$true , Position=1)]
    [int]
    $Port,
    [parameter(Mandatory=$true, Position=2)]
    [ValidateSet("TCP", "UDP")]
    [string]
    $Protocol
)

    $RemoteServer = If ([string]::IsNullOrEmpty($ComputerName)) {$IPAddress} Else {$ComputerName};

    If ($Protocol -eq 'TCP')
    {
        $test = New-Object System.Net.Sockets.TcpClient;
        Try
        {
            # Write-Host "Connecting to "$RemoteServer":"$Port" (TCP)..";
            $test.Connect($RemoteServer, $Port);
            # Write-Host "Connection successful";
            $result = "Success"
        }
        Catch
        {
            # Write-Host "Connection failed";
            $result = "Failed"
        }
        Finally
        {
            $test.Dispose();
        }
    }

    If ($Protocol -eq 'UDP')
    {
        $test = New-Object System.Net.Sockets.UdpClient;
        Try
        {
            # Write-Host "Connecting to "$RemoteServer":"$Port" (UDP)..";
            $test.Connect($RemoteServer, $Port);
            # Write-Host "Connection successful";
            $result = "Success"
        }
        Catch
        {
            # Write-Host "Connection failed";
            $result = "Failed"
        }
        Finally
        {
            $test.Dispose();
        }
    }

    return $result
}

#************************************************************************************************************************************
# function GetRegistryClassName
#
# Parameters:
# 	- Root
#
# Returns Windows Registry Class from abbreviattion
#************************************************************************************************************************************
function GetRegistryClassName {
param (
	[string]$root
)
	switch($root) {
		"HKCR"  { return "ClassesRoot" }
		"HKCU"  { return "CurrentUser" }
		"HKLM"  { return "LocalMachine" }
		"HKU"   { return "Users" }
		"HKPD"  { return "PerformanceData" }
		"HKCC"  { return "CurrentConfig" }
		"HKDD"  { return "DynData" }
		default { 
			throw("Invalid ClassName")
			return $null }
	}
}

#************************************************************************************************************************************
# function GetRegistryValue
#
# Parameters:
# 	- $dnsHostName
#	- $registryClassName (valid values: "HKCR","HKCU","HKLM","HKU","HKPD","HKCC","HKDD")
#	- $registrySubKeyName
#	- $valueName
#
# Returns value for a registry key
#************************************************************************************************************************************
function GetRegistryValue {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
  [Parameter(Mandatory=$True,Position=2)]
  [ValidateSet("HKCR","HKCU","HKLM","HKU","HKPD","HKCC","HKDD")]
	[string]$registryClassName,
  [Parameter(Mandatory=$True,Position=3)]
	[string]$registrySubKeyName,
  [Parameter(Mandatory=$True,Position=4)]
	[string]$valueName
)
	if($dnsHostName -match $Env:COMPUTERNAME) {
		[string]$machineName = $Env:COMPUTERNAME
	} else {
		[string]$machineName = $dnsHostName
	}
	$registryValues = @()

	$registryClass = GetRegistryClassName $registryClassName
	$registryEntry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($registryClass, $machineName)
	if($registryEntry){
		$registrySubKey= $registryEntry.OpenSubKey($registrySubKeyName)
		if($registrySubKey){
			$registryValue = $registrySubKey.GetValue($valueName)
			
			return $registryValue
		}
		else {
			return $null
		}
	} else {
		return $null
	}
}
