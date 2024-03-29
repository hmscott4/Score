#************************************************************************************************************************************
# function CheckDiskSpace
#
# Parameters
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- pm.spLogicalVolumeRawInsert
#
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
[string]$moduleName = "CheckDisk"

################################################################################
# ESTABLISH CONNECTION TO CENTRAL REPOSITORY
################################################################################
$sqlConnection = GetSQLConnection -sqlConnectionString $sqlConnectionString
if ($sqlConnection.State -ne "Open")	{
	Throw "Unable to open central repository database.  Application terminating."
	Return New-Object psobject -Property @{ErrorCount = 1; WarningCount = 0}
}

Write-Verbose " : $dnsHostName : $moduleName : Start"	

# Log Status
AddLogEntry $dnsHostName "Info" $moduleName "Starting check..." $sqlConnection
	
try {

	# Retrieve logical storage information from WMI
	$queryString = "SELECT * FROM Win32_Volume where DriveType=3"
	$logicalVolumes = GetCIMResult $dnsHostName $queryString $psCredential
	
	$sqlCommand = GetStoredProc $sqlConnection "pm.spLogicalVolumeSizeRawInsert"
	[void]$sqlCommand.Parameters.Add("@DateTime",  [System.Data.SqlDbType]::datetime2)
	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@LogicalVolumeName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@SpaceUsed",  [System.Data.SqlDbType]::bigint)
	[void]$sqlCommand.Parameters.Add("@dbAddDate",  [System.Data.SqlDbType]::datetime2)
	
	# First, find out if this is a cluster...
	$clusterService = Get-Service -ComputerName $dnsHostName -Name "ClusSvc" -ErrorAction SilentlyContinue	

	[datetime]$timeNow = (Get-Date)		
	foreach ($logicalVolume in $logicalVolumes)	{
		try {
			# Can we determine the owner?
			# Ugly, but maybe...
			# From: http://blogs.msdn.com/b/clustering/archive/2009/10/16/9908325.aspx
			[string]$ownerNode = $null
			[bool]$isClustered = $false
			if($clusterService){
				# Write-Verbose $logicalVolume.Name
				$serialNumber = $logicalVolume.SerialNumber
				$clusterPartition = Get-WmiObject -Namespace "root/mscluster" -computer $dnsHostName -Query "SELECT * FROM MSCluster_DiskPartition WHERE SerialNumber=$serialNumber"
				If($clusterPartition){
					$clusterDisk = Get-WmiObject -Namespace "root/mscluster" -computer $dnsHostName -Query "Associators of {$clusterPartition} where resultclass=MSCluster_Disk"
					# Write-Verbose $clusterPartition.SerialNumber
					$diskGroup = Get-WmiObject -Namespace "root/mscluster" -computer $dnsHostName -Query "Associators of {$clusterDisk} where resultclass=MSCluster_Resource"					
					
					$ownerNode = $diskgroup.OwnerNode.ToString()
					$ownerNode = $dnsHostName.Replace($dnsHostName.Substring(0,$dnsHostName.IndexOf(".")), $ownerNode)
					$isClustered = $true
				}
			}
			if($ownerNode.Length -eq 0){[string]$ownerHost = $dnsHostName} else {[string]$ownerHost = $ownerNode}
		
			$sqlCommand.Parameters["@DateTime"].Value = $timeNow
			$sqlCommand.Parameters["@dnsHostName"].Value = $ownerHost
			$sqlCommand.Parameters["@LogicalVolumeName"].Value = $logicalVolume.Name
			$sqlCommand.Parameters["@SpaceUsed"].Value = $logicalVolume.Capacity - $logicalVolume.FreeSpace
			$sqlCommand.Parameters["@dbAddDate"].Value = $timeNow
			[void]$sqlCommand.ExecuteNonQuery()
		}
		catch [System.Exception] {
			$msg =  $_.Exception.Message
			AddLogEntry $dnsHostName "Warning" "CheckDiskSpace" "$logicalVolume : $msg" $sqlConnection
			$warningCounter++
		}		
	}
	$sqlCommand.Dispose()
}
catch [System.Exception] {
	$msg =  $_.Exception.Message
	AddLogEntry $dnsHostName "Error" "CheckDiskSpace" "$msg" $sqlConnection
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