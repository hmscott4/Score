#************************************************************************************************************************************
# function CheckNetwork
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- cm.spNetworkUpsert
#	- cm.spNetworkConfigurationUpsert
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
[string]$moduleName = "CheckNetwork"

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
	$queryString = "SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True"
	$NetworkAdapterConfigurations = GetCIMResult $dnsHostName $queryString $psCredential
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spNetworkAdapterInactivateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)

	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spNetworkAdapterConfigurationInactivateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)

	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	
	#region params
	$sqlCommand = GetStoredProc $sqlConnection "cm.spNetworkAdapterConfigurationUpsert"
	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Index",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@MACAddress",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@IPV4Address",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@SubnetMask",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DefaultIPGateway",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DNSDomainSuffixSearchOrder",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DNSServerSearchOrder",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DNSEnabledForWINSResolution",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@FullDNSRegistrationEnabled",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@DHCPEnabled",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@DHCPLeaseObtained",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@DHCPLeaseExpires",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@DHCPServer",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@WINSPrimaryServer",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@WINSSecondaryServer",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@IPEnabled",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
	#endregion
				 
	foreach ($NetworkAdapterConfiguration in $NetworkAdapterConfigurations) {
		Try {

			# This one's a little different; we need to try to capture the Adapter to which this configuration belongs
			$queryString = "ASSOCIATORS OF {$networkAdapterConfiguration} WHERE ResultClass=Win32_NetworkAdapter"
			$networkAdapter = GetCIMResult $dnsHostName $queryString $psCredential

			$sqlCommand2 = GetStoredProc $sqlConnection "cm.spNetworkAdapterUpsert"
			[void]$sqlCommand2.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand2.Parameters.Add("@Index",  [System.Data.SqlDbType]::int)
			[void]$sqlCommand2.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand2.Parameters.Add("@NetConnectionID",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand2.Parameters.Add("@AdapterType",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand2.Parameters.Add("@Manufacturer",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand2.Parameters.Add("@MACAddress",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand2.Parameters.Add("@PhysicalAdapter",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand2.Parameters.Add("@Speed",  [System.Data.SqlDbType]::bigint)
			[void]$sqlCommand2.Parameters.Add("@NetEnabled",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand2.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand2.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)

			$sqlCommand2.Parameters["@dnsHostName"].Value = $dnsHostName
			$sqlCommand2.Parameters["@Index"].Value = $networkAdapter.Index
			$sqlCommand2.Parameters["@Name"].Value = $networkAdapter.Name
			$sqlCommand2.Parameters["@NetConnectionID"].Value = $networkAdapter.NetConnectionID
			$sqlCommand2.Parameters["@AdapterType"].Value = $networkAdapter.AdapterType
			$sqlCommand2.Parameters["@Manufacturer"].Value = $networkAdapter.Manufacturer
			$sqlCommand2.Parameters["@MACAddress"].Value = $networkAdapter.MACAddress
			$sqlCommand2.Parameters["@PhysicalAdapter"].Value = $networkAdapter.PhysicalAdapter
			$sqlCommand2.Parameters["@Speed"].Value = $networkAdapter.Speed
			$sqlCommand2.Parameters["@NetEnabled"].Value = $networkAdapter.NetEnabled				
			$sqlCommand2.Parameters["@Active"].Value = $true
			$sqlCommand2.Parameters["@dbLastUpdate"].Value = (Get-Date)
			
			[Void]$sqlCommand2.ExecuteNonQuery()
			$sqlCommand2.Dispose()	
			
			$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
			$sqlCommand.Parameters["@Index"].Value = $networkAdapterConfiguration.Index
			$sqlCommand.Parameters["@MACAddress"].Value = $networkAdapterConfiguration.MACAddress
			$sqlCommand.Parameters["@IPV4Address"].Value = $networkAdapterConfiguration.IPAddress -join ", "
			$sqlCommand.Parameters["@SubnetMask"].Value = $networkAdapterConfiguration.IPSubnet -join ", "
			$sqlCommand.Parameters["@DefaultIPGateway"].Value = $networkAdapterConfiguration.DefaultIPGateway -join ", "
			$sqlCommand.Parameters["@DNSDomainSuffixSearchOrder"].Value = $networkAdapterConfiguration.DNSDomainSuffixSearchOrder -join ", "
			$sqlCommand.Parameters["@DNSServerSearchOrder"].Value = $networkAdapterConfiguration.DNSServerSearchOrder -join ", "
			$sqlCommand.Parameters["@DNSEnabledForWINSResolution"].Value = $networkAdapterConfiguration.DNSEnabledForWINSResolution
			$sqlCommand.Parameters["@FullDNSRegistrationEnabled"].Value = $networkAdapterConfiguration.FullDNSRegistrationEnabled
			$sqlCommand.Parameters["@DHCPEnabled"].Value = $networkAdapterConfiguration.DHCPEnabled
			$sqlCommand.Parameters["@DHCPLeaseObtained"].Value = $networkAdapterConfiguration.DHCPLeaseObtained
			$sqlCommand.Parameters["@DHCPLeaseExpires"].Value = $networkAdapterConfiguration.DHCPLeaseExpires
			$sqlCommand.Parameters["@DHCPServer"].Value = $networkAdapterConfiguration.DHCPServer
			$sqlCommand.Parameters["@WINSPrimaryServer"].Value = $networkAdapterConfiguration.WINSPrimaryServer
			$sqlCommand.Parameters["@WINSSecondaryServer"].Value = $networkAdapterConfiguration.WINSSecondaryServer
			$sqlCommand.Parameters["@IPEnabled"].Value = $networkAdapterConfiguration.IPEnabled
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			
			[Void]$sqlCommand.ExecuteNonQuery()

		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Error" $moduleName "NetworkAdapter : $msg" $sqlConnection
			$errorCounter++
		}		
	}
}
catch [System.Exception] {
	$msg = $_.Exception.Message
	AddLogEntry $dnsHostName "Error" $moduleName $msg $sqlConnection
	$errorCounter++
}
$sqlCommand.Dispose()

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