#************************************************************************************************************************************
# function CheckCluster
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- spClusterUpsert
#	- spClusterNodeUpsert
#	- spClusterResourceUpsert
#	- spClusterGroupUpsert
#	- spClusterGroupResourceUpsert
#
# Description:
#	- The purpose of this module is to enumerate properties of Microsoft Cluster Services
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
[string]$moduleName = "CheckCluster"

################################################################################
# ESTABLISH CONNECTION TO CENTRAL REPOSITORY
################################################################################
$sqlConnection = GetSQLConnection -sqlConnectionString $sqlConnectionString
if ($sqlConnection.State -ne "Open")	{
	Throw "Unable to open central repository database.  Application terminating."
	Return New-Object psobject -Property @{ErrorCount = 1; WarningCount = 0}
}

Write-Verbose " : $dnsHostname : $moduleName : Start"

# Add Log Entry
AddLogEntry $dnsHostname "Info" $moduleName "Starting check..." $sqlConnection


#region CheckCluster
Try {

	# Before attempting to connect, check to see if the cluster service is running
	[string]$queryString = "SELECT * FROM Win32_Service WHERE Name='ClusSvc'"
	$serviceState = GetCIMResult -dnsHostName $dnsHostName -queryString $queryString -psCredential $psCredential 
	# $serviceState = Get-Service -ComputerName $dnsHostName -Name "ClusSvc" -ErrorAction SilentlyContinue
	If($serviceState){
		If($serviceState.State -ne "Running"){
			Write-Verbose " : $dnsHostName : Cluster service not running; no connection made." -ForegroundColor Yellow
			AddLogEntry $dnsHostName "Warning" $moduleName "$dnsHostName : $instanceName : Service not running; no connection made." $sqlConnection
			$warningCounter++
			[Void]$sqlConnection.Close
			$sqlConnection.Dispose()			
			Return New-Object psobject -Property @{ErrorCount = 0; WarningCount = 1}
		}
	} else {
		# this is not a cluster server
		[Void]$sqlConnection.Close
		$sqlConnection.Dispose()
		Write-Verbose " : $dnsHostname : $moduleName : Finish (nocheck)"
		Return New-Object psobject -Property @{ErrorCount = 0; WarningCount = 0}
	}	
	
	# Get a reference to the cluster
	$clusterObject = Get-Cluster -Name $dnsHostName -ErrorAction SilentlyContinue
	
	if($clusterObject -eq $null){
		# This is an issue; the service is there (and running), but we failed to connect
		Write-Verbose " : $dnsHostName : Failed to obtain reference to Cluster object." -ForegroundColor Red
		AddLogEntry $dnsHostName "Error" $moduleName "$dnsHostName : Failed to obtain reference to Cluster object." $sqlConnection
		$errorCounter++
		[Void]$sqlConnection.Close
		$sqlConnection.Dispose()		
		Return New-Object psobject -Property @{ErrorCount = 1; WarningCount = 0}
	} 
	
	# So, apparently this is a cluster and we can connect to it
	$clusterName = $clusterObject.Name + "." + $clusterObject.Domain

	[string]$queryString = "SELECT * FROM CIM_OperatingSystem"
	# Really, we should be connecting using the $clusterName, but we have at least one example where the cluster name is not registered in DNS....
	# $operatingSystem = GetCIMResult $clusterName $queryString $psCredential
	$operatingSystem = GetCIMResult $dnsHostName $queryString $psCredential
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spClusterInactivateByClusterName"
	[Void]$sqlCommand.Parameters.Add("@ClusterName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@ClusterName"].value = $clusterName
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()

	$sqlCommand = GetStoredProc $sqlConnection "cm.spClusterUpsert"
	[void]$sqlCommand.Parameters.Add("@ClusterName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@OperatingSystem",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@OperatingSystemVersion",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)	

	Try {
		$sqlCommand.Parameters["@ClusterName"].Value = $clusterName
		$sqlCommand.Parameters["@OperatingSystem"].Value = $operatingSystem.Caption
		$sqlCommand.Parameters["@OperatingSystemVersion"].Value = $operatingSystem.Version
		$sqlCommand.Parameters["@Active"].Value = $true
		$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
		[void]$sqlCommand.ExecuteNonQuery()	
		$sqlCommand.Dispose()
	}
	Catch [System.Exception] {
		$msg=$_.Exception.Message
		AddLogEntry $dnsHostName "Warning" $moduleName "Cluster : $clusterName : $msg" $sqlConnection
		$warningCounter++
	}		

	#region CheckClusterNode
	$sqlCommand = GetStoredProc $sqlConnection "cm.spClusterNodeInactivateByClusterName"
	[Void]$sqlCommand.Parameters.Add("@ClusterName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@ClusterName"].value = $clusterName
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()

	$clusterNodes = Get-ClusterNode -cluster $dnsHostName
	foreach($clusterNode in $clusterNodes){
		# I really, really prefer to operate in terms of fully qualified domain names, but apparently MS does not
		[string]$clusterNodeNetBIOSName = $clusterNode.Name
		[string]$clusterNodeDnsName = $clusterNode.Name + "." + $clusterObject.Domain

		Try {
			$sqlCommand = GetStoredProc $sqlConnection "cm.spClusterNodeUpsert"
			[void]$sqlCommand.Parameters.Add("@ClusterName",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@NodeName",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@State",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
			[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)	

			$sqlCommand.Parameters["@ClusterName"].Value = $clusterName
			$sqlCommand.Parameters["@NodeName"].Value = $clusterNodeDnsName
			$sqlCommand.Parameters["@State"].Value = $clusterNode.State
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			[void]$sqlCommand.ExecuteNonQuery()	
			$sqlCommand.Dispose()
		}
		Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "Cluster Node : $clusterNodeDnsName : $msg" $sqlConnection
			$warningCounter++
		}			
		
	}
	#endRegion

	#region CheckClusterResource
	# Again, we should be using $clusterName, but DNS is currently busted, and this works
	$clusterResources = Get-ClusterResource -Cluster $dnsHostName

	$sqlCommand = GetStoredProc $sqlConnection "cm.spClusterResourceInactivateByClusterName"
	[Void]$sqlCommand.Parameters.Add("@ClusterName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@ClusterName"].value = $clusterName
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()

	$sqlCommand = GetStoredProc $sqlConnection "cm.spClusterResourceUpsert"
	[void]$sqlCommand.Parameters.Add("@objectGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand.Parameters.Add("@ClusterName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ResourceName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@ResourceType",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@OwnerGroup",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@OwnerNode",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@State",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
		
	foreach($clusterResource in $clusterResources){
		Try {
			[Guid]$clusterResourceGUID = $clusterResource.Id

			$sqlCommand.Parameters["@objectGUID"].Value = $clusterResourceGUID
			$sqlCommand.Parameters["@ClusterName"].Value = $clusterName
			$sqlCommand.Parameters["@ResourceName"].Value = $clusterResource.Name
			$sqlCommand.Parameters["@ResourceType"].Value = $clusterResource.ResourceType.ToString()
			$sqlCommand.Parameters["@OwnerGroup"].Value = $clusterResource.OwnerGroup.ToString()
			$sqlCommand.Parameters["@OwnerNode"].Value = $clusterResource.OwnerNode.ToString() + "." + $clusterObject.Domain
			$sqlCommand.Parameters["@State"].Value = $clusterResource.State
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			[void]$sqlCommand.ExecuteNonQuery()
		}
		Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "Cluster Resource : $clusterResource.Name : $msg" $sqlConnection
			$warningCounter++
		}
		
		# If the resource type is "Network Name", need to add the Cluster Network Name to cm.Computer
		# This is because cm.Computer is Pk for tables like cm.DatabaseInstance
		if($clusterResource.ResourceType.ToString() -eq "Network Name"){
			try {
				
				$networkObject = Get-ClusterParameter -InputObject $clusterResource -Name DnsName
				
				$sqlCommand2 = GetStoredProc $sqlConnection "cm.spComputerUpsertForCluster"
				[void]$sqlCommand2.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
				[void]$sqlCommand2.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
				[void]$sqlCommand2.Parameters.Add("@NetBIOSName",  [System.Data.SqlDbType]::nvarchar)
				[void]$sqlCommand2.Parameters.Add("@IsClusterResource",  [System.Data.SqlDbType]::bit)
				[void]$sqlCommand2.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
				[void]$sqlCommand2.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)	

				$sqlCommand2.Parameters["@Domain"].Value = $clusterObject.Domain
				$sqlCommand2.Parameters["@dnsHostName"].Value = $networkObject.Value + "." + $clusterObject.Domain
				$sqlCommand2.Parameters["@NetBIOSName"].Value = $networkObject.Value
				$sqlCommand2.Parameters["@IsClusterResource"].Value = $true			
				$sqlCommand2.Parameters["@Active"].Value = $true
				$sqlCommand2.Parameters["@dbLastUpdate"].Value = (Get-Date)
				[void]$sqlCommand2.ExecuteNonQuery()	
				$sqlCommand2.Dispose()
			}
			Catch [System.Exception] {
				$msg=$_.Exception.Message
				AddLogEntry $dnsHostName "Warning" $moduleName "Cluster Computer Object: $msg" $sqlConnection
				$warningCounter++
			}
		}
	}
	$sqlCommand.Dispose()	


	#endregion

	#region CheckClusterGroup
	# Once again, we should really be using $clusterName, but we need to make do
	# $clusterGroups = Get-ClusterGroup -Cluster $dnsHostName
	$clusterGroups = Get-ClusterGroup -Cluster $dnsHostName

	$sqlCommand = GetStoredProc $sqlConnection "cm.spClusterGroupInactivateByClusterName"
	[Void]$sqlCommand.Parameters.Add("@ClusterName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@ClusterName"].value = $clusterName
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()

	$sqlCommand = GetStoredProc $sqlConnection "cm.spClusterGroupUpsert"
	[void]$sqlCommand.Parameters.Add("@objectGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	[void]$sqlCommand.Parameters.Add("@ClusterName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@GroupName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@OwnerNode",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@State",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)			

	foreach($clusterGroup in $clusterGroups) {
		Try {
			[Guid]$clusterGroupGUID = $clusterGroup.ID

			$sqlCommand.Parameters["@objectGUID"].Value = $clusterGroupGUID
			$sqlCommand.Parameters["@ClusterName"].Value = $clusterName
			$sqlCommand.Parameters["@GroupName"].Value = $clusterGroup.Name
			$sqlCommand.Parameters["@Description"].Value = NullToString $clusterGroup.Description "" 
			$sqlCommand.Parameters["@OwnerNode"].Value = $clusterGroup.OwnerNode.ToString() + "." + $clusterObject.Domain
			$sqlCommand.Parameters["@State"].Value = $clusterGroup.State
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			[void]$sqlCommand.ExecuteNonQuery()
		}
		Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "ClusterGroup : $clusterGroup.Name : $msg" $sqlConnection
			$warningCounter++
		}		
	}
	$sqlCommand.Dispose()
	#endregion

}
Catch [System.Exception] {
	$msg=$_.Exception.Message
	AddLogEntry $dnsHostName "Error" $moduleName $msg $sqlConnection
	$errorCounter++
}
[Void]$sqlConnection.Close
$sqlConnection.Dispose()

#endregion

AddLogEntry $dnsHostname "Info" $moduleName "Check completed." $sqlConnection

################################################################################
# CLEANUP
################################################################################
[Void]$sqlConnection.Close
$sqlConnection.Dispose()

Write-Verbose " : $dnsHostname : $moduleName : Finish"

# Return error count
Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}