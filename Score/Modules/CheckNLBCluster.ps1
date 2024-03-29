#************************************************************************************************************************************
# function CheckNLBCluster
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- cm.spNLBClusterUpsert
#	- cm.spNLBClusterNodeUpsert
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
[string]$moduleName = "CheckNLBCluster"

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
	$NLBCluster = Get-NLBcluster $dnsHostName
	If(!$NLBCluster){
		# NLB Cluster is not installed
		Write-Verbose " : $dnsHostName : $moduleName : Finish : $errorCounter error(s) : $warningCounter warning(s)"		
		Return New-Object psobject -Property @{ErrorCount = 0; WarningCount = 0}
	} else {
		$sqlCommand = GetStoredProc $sqlConnection "cm.spNLBClusterUpsert"
		[void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@ClusterName",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@IPAddress",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@ClusterNetworkMask",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@ClusterMacAddress",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@OperationMode",  [System.Data.SqlDbType]::nvarchar)
		[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
		[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
		
		try {		
			$sqlCommand.Parameters["@Name"].Value = $NLBCluster.Name
			$sqlCommand.Parameters["@ClusterName"].Value = $NLBCluster.ClusterName
			$sqlCommand.Parameters["@IPAddress"].Value = $NLBCluster.IPAddress
			$sqlCommand.Parameters["@ClusterNetworkMask"].Value = $NLBCluster.ClusterNetworkMask
			$sqlCommand.Parameters["@ClusterMacAddress"].Value = $NLBCluster.ClusterMacAddress
			$sqlCommand.Parameters["@OperationMode"].Value = $NLBCluster.OperationMode
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			[void]$sqlCommand.ExecuteNonQuery()
		} catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName $msg $sqlConnection
			$warningCounter++
		}
		
		$NLBClusterNode = Get-NLBclusterNode $dnsHostName -InputObject $NLBCluster
		
		If($NLBClusterNode){
			$sqlCommand = GetStoredProc $sqlConnection "cm.spNLBClusterNodeUpsert"
			[void]$sqlCommand.Parameters.Add("@NLBClusterName",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@InterfaceName",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@State",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@HostPriority",  [System.Data.SqlDbType]::smallint)
			[void]$sqlCommand.Parameters.Add("@InitialHostState",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@PersistSuspendOnReboot",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand.Parameters.Add("@MaskSourceMac",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand.Parameters.Add("@FilterIcmp",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand.Parameters.Add("@GreDescriptorTimeOut",  [System.Data.SqlDbType]::int)
			[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			
			try {
				$sqlCommand.Parameters["@NLBClusterName"].Value = $NLBCluster.Name
				$sqlCommand.Parameters["@dnsHostName"].Value = $NLBClusterNode.Host
				$sqlCommand.Parameters["@InterfaceName"].Value = $NLBClusterNode.InterfaceName
				$sqlCommand.Parameters["@State"].Value = $NLBClusterNode.State.ToString()
				$sqlCommand.Parameters["@HostPriority"].Value = $NLBClusterNode.HostPriority
				$sqlCommand.Parameters["@InitialHostState"].Value = $NLBClusterNode.InitialHostState
				$sqlCommand.Parameters["@PersistSuspendOnReboot"].Value = $NLBClusterNode.PersistSuspendOnReboot
				$sqlCommand.Parameters["@MaskSourceMac"].Value = $NLBClusterNode.MaskSourceMac
				$sqlCommand.Parameters["@FilterIcmp"].Value = $NLBClusterNode.FilterIcmp
				$sqlCommand.Parameters["@GreDescriptorTimeOut"].Value = $NLBClusterNode.GreDescriptorTimeOut
				$sqlCommand.Parameters["@Active"].Value = $true
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				[void]$sqlCommand.ExecuteNonQuery()	
			} catch [System.Exception] {
				$msg=$_.Exception.Message
				AddLogEntry $dnsHostName "Warning" $moduleName $msg $sqlConnection
				$warningCounter++
			}
		}
	}
}
catch [System.Exception] {
	$msg=$_.Exception.Message
	If($msg -eq "Invalid namespace "){
		# This means that NLB Clustering is not installed on the host
		# Continue
	} else {
		AddLogEntry $dnsHostName "Error" $moduleName $msg $sqlConnection
		$errorCounter++
	}
}


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