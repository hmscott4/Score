#************************************************************************************************************************************
# function CheckDisk
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- spLogicalVolumeUpsert (cm.LogicalVolume)
#	- spDiskDriveUpsert (cm.DiskDrive)
#	- spDiskPartitionUpsert (cm.DiskPartition)
#	- spDrivePartitionMapUpsert (cm.DrivePartitionMap)
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

# Connect to CIM_OperatingSystem to retrieve basic info
[string]$queryString = "SELECT * FROM CIM_OperatingSystem"
$operatingSystem = GetCIMResult -dnsHostName $dnsHostName -queryString $queryString -psCredential $psCredential

	
Try {
	# Round 1: Update Logical Volumes from Win32_Volume (used because this retrieves mount points)
	# Mount points appear to have a Name (in the format <x>:\<Path>), but no drive letter
	$sqlCommand = GetStoredProc $sqlConnection "cm.spLogicalVolumeInactivateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)

	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()

	# Retrieve logical storage information from WMI
	$queryString = "SELECT * FROM Win32_Volume WHERE DriveType=3"
	$logicalVolumes = GetCIMResult $dnsHostName $queryString $psCredential 
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spLogicalVolumeUpsert"
	
	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DriveLetter",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Label",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@FileSystem",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@BlockSize",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@SerialNumber",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Capacity",  [System.Data.SqlDbType]::bigint)
	[void]$sqlCommand.Parameters.Add("@SpaceUsed",  [System.Data.SqlDbType]::bigint)
	[void]$sqlCommand.Parameters.Add("@SystemVolume",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@IsClustered",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)		

	# First, find out if this is a cluster...
	$clusterService = Get-Service -ComputerName $dnsHostName -Name "ClusSvc" -ErrorAction SilentlyContinue
	
	foreach ($logicalVolume in $logicalVolumes)	{
		Try {
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
			$sqlCommand.Parameters["@dnsHostName"].Value = $ownerHost
			$sqlCommand.Parameters["@Name"].Value = $logicalVolume.Name
			$sqlCommand.Parameters["@DriveLetter"].Value = $logicalVolume.DriveLetter
			$sqlCommand.Parameters["@Label"].Value = $logicalVolume.Label
			$sqlCommand.Parameters["@FileSystem"].Value = $logicalVolume.FileSystem
			$sqlCommand.Parameters["@BlockSize"].Value = $logicalVolume.BlockSize
            If($operatingSystem.Version -like "5*"){                
			    $sqlCommand.Parameters["@SerialNumber"].Value = $logicalVolume.SerialNumber
            } else {
                $sqlCommand.Parameters["@SerialNumber"].Value = ""
            }
			$sqlCommand.Parameters["@Capacity"].Value = $logicalVolume.Capacity
			$sqlCommand.Parameters["@SpaceUsed"].Value = $logicalVolume.Capacity - $logicalVolume.FreeSpace
            if($operatingSystem.Version -like "5*"){
                $sqlCommand.Parameters["@SystemVolume"].Value = $false
            } else {
			    $sqlCommand.Parameters["@SystemVolume"].Value = $logicalVolume.SystemVolume
            }
			$sqlCommand.Parameters["@IsClustered"].Value = $isClustered
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
						
			[Void]$sqlCommand.ExecuteNonQuery()
		} 
		Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "LogicalVolume : $logicalVolume.DriveLetter : $msg" $sqlConnection
			$warningCounter++
		}
    }
	$sqlCommand.Dispose()
}
catch [System.Exception] {
	$msg =  $_.Exception.Message
	AddLogEntry $dnsHostName "Error" $moduleName "LogicalVolume : $msg" $sqlConnection
	$errorCounter++
}	

Try {
	# Round 2; pull back the Physical Disks
	[string]$queryString = "SELECT * FROM CIM_DiskDrive"
	$diskDrives = GetCIMResult $dnsHostName $queryString $psCredential
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDiskDriveInactivateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
    $sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
    $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)

	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()		
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDiskDriveUpsert"
	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DeviceID",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Manufacturer",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Model",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@SerialNumber",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@FirmwareRevision",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Partitions",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@InterfaceType",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@SCSIBus",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@SCSIPort",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@SCSILogicalUnit",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@SCSITargetID",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@Size",  [System.Data.SqlDbType]::bigint)
	[void]$sqlCommand.Parameters.Add("@Status",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
	
	foreach ($diskDrive in $diskDrives)
	{
		Try {
			$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
			$sqlCommand.Parameters["@Name"].Value = $DiskDrive.Name
			$sqlCommand.Parameters["@DeviceID"].Value = $DiskDrive.DeviceID
			$sqlCommand.Parameters["@Manufacturer"].Value = $DiskDrive.Manufacturer
			$sqlCommand.Parameters["@Model"].Value = $DiskDrive.Model
            If($operatingSystem.Version -like "5*"){
                $sqlCommand.Parameters["@SerialNumber"].Value = ""
            } else {
			    $sqlCommand.Parameters["@SerialNumber"].Value = $DiskDrive.SerialNumber.Trim()
            }
            If($operatingSystem.Version -like "5*"){
                $sqlCommand.Parameters["@SerialNumber"].Value = ""
            } else {
			    $sqlCommand.Parameters["@FirmwareRevision"].Value = $DiskDrive.FirmwareRevision
            }
			$sqlCommand.Parameters["@Partitions"].Value = $DiskDrive.Partitions
			$sqlCommand.Parameters["@InterfaceType"].Value = $DiskDrive.InterfaceType
			$sqlCommand.Parameters["@SCSIBus"].Value = $DiskDrive.SCSIBus
			$sqlCommand.Parameters["@SCSIPort"].Value = $DiskDrive.SCSIPort
			$sqlCommand.Parameters["@SCSILogicalUnit"].Value = $DiskDrive.SCSILogicalUnit
			$sqlCommand.Parameters["@SCSITargetID"].Value = $DiskDrive.SCSITargetID
			$sqlCommand.Parameters["@Size"].Value = $DiskDrive.Size
			$sqlCommand.Parameters["@Status"].Value = $DiskDrive.Status
	        $sqlCommand.Parameters["@Active"].value = $true
	        $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)				
            [Void]$sqlCommand.ExecuteNonQuery()
		}
		Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "DiskDrive: $DiskDrive.Name : $msg" $sqlConnection
			$warningCounter++
		}
	}
	$sqlCommand.Dispose()
}	
Catch [System.Exception] {
	$msg = $_.Exception.Message
	AddLogEntry $dnsHostName "Error" $moduleName "DiskDrive: $msg" $sqlConnection
	$errorCounter++
}	

Try {
	# Round 3; Retrieve Disk Partitions
	[string]$queryString = "SELECT * FROM CIM_DiskPartition"
	$DiskPartitions = GetCIMResult $dnsHostName $queryString $psCredential

	$sqlCommand = GetStoredProc $sqlConnection "cm.spDiskPartitionInactivateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
    $sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
    $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)

	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDiskPartitionUpsert"

	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@DiskIndex",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@Index",  [System.Data.SqlDbType]::int)
	[void]$sqlCommand.Parameters.Add("@DeviceID",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Bootable",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@BootPartition",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@PrimaryPartition",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@StartingOffset",  [System.Data.SqlDbType]::bigint)
	[void]$sqlCommand.Parameters.Add("@Size",  [System.Data.SqlDbType]::bigint)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
	
	foreach ($DiskPartition in $DiskPartitions)
	{
		Try {
			$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
			$sqlCommand.Parameters["@Name"].Value = $DiskPartition.Name
			$sqlCommand.Parameters["@DiskIndex"].Value = $DiskPartition.DiskIndex
			$sqlCommand.Parameters["@Index"].Value = $DiskPartition.Index
			$sqlCommand.Parameters["@DeviceID"].Value = $DiskPartition.DeviceID
            If($operatingSystem.Version -like "5*") {
                $sqlCommand.Parameters["@Bootable"].Value = $False
            } else {
			    $sqlCommand.Parameters["@Bootable"].Value = $DiskPartition.Bootable
            }
			$sqlCommand.Parameters["@BootPartition"].Value = $DiskPartition.BootPartition
			$sqlCommand.Parameters["@PrimaryPartition"].Value = $DiskPartition.PrimaryPartition
			$sqlCommand.Parameters["@StartingOffset"].Value = $DiskPartition.StartingOffset
			$sqlCommand.Parameters["@Size"].Value = $DiskPartition.Size
	        $sqlCommand.Parameters["@Active"].value = $true
	        $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
			
	        [Void]$sqlCommand.ExecuteNonQuery()		
		}
		Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "DiskPartition: $DiskPartition.Name : $msg" $sqlConnection
			$warningCounter++
		}			
	}
	$sqlCommand.Dispose()
}	
Catch [System.Exception] {
	$msg = $_.Exception.Message
	AddLogEntry $dnsHostName "Error" $moduleName "DiskPartition: $msg" $sqlConnection
	$errorCounter++
}	
	

Try {
    # Round 4; retrieve partition mapping between logical and physical
	[string]$queryString = "SELECT Antecedent, Dependent FROM CIM_LogicalDiskBasedOnPartition"
	$drivePartitionMaps = GetCIMResult -dnsHostName $dnsHostName -queryString $queryString -psCredential $psCredential

	$sqlCommand = GetStoredProc $sqlConnection "cm.spDrivePartitionMapInactivateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
    $sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
    $sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)

	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDrivePartitionMapUpsert"
    [Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
    [Void]$sqlCommand.Parameters.Add("@PartitionName", [system.data.SqlDbType]::nvarchar)
   	[Void]$sqlCommand.Parameters.Add("@DriveName", [system.data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
	
	foreach ($drivePartitionMap in $drivePartitionMaps){	
		Try {
			# Okay...a brief comment here
			# Tried to get this working using the ASSOCIATORS of syntax...but it just wasn't happening.
			# Trying to stick with CIM classes; parsing the strings may actually work faster...just not sure what it does w/ mount points
			# Have I mentioned that I hate mount points?
			$antecedent = $drivePartitionMap.Antecedent
			$dependent = $drivePartitionMap.Dependent
			
			$PartitionName = $antecedent.Substring($antecedent.IndexOf("`""), ($antecedent.Length - $antecedent.IndexOf("`""))).Replace("`"", "")
			$DriveName = $dependent.Substring($dependent.IndexOf("`""), ($dependent.Length - $dependent.IndexOf("`""))).Replace("`"", "")

			$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
			$sqlCommand.Parameters["@PartitionName"].Value = $PartitionName
			$sqlCommand.Parameters["@DriveName"].Value = $DriveName
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			
			[Void]$sqlCommand.ExecuteNonQuery()
		}
		Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "Partition Map: $PartitionName : $msg" $sqlConnection
			$warningCounter++
		}	
	}
	$sqlCommand.Dispose()
}	
Catch [System.Exception] {
	$msg = $_.Exception.Message
	AddLogEntry $dnsHostName "Error" $moduleName "Partition Map: $msg" $sqlConnection
	$errorCounter++
}

#region DiskConfigurationHistory		
################################################################################
# UPDATE CONFIGURATION HISTORY
################################################################################
	[int]$storeConfigurationHistory = GetConfigValue -configName "StoreConfigurationHistory" -sqlConnection $sqlConnection
	
	If($storeConfigurationHistory -eq 1){
	
		# Retrieve Physical Drives for this Computer 
		$sqlCommand = GetStoredProc $sqlConnection "cm.spDiskDriveSelectByComputer"
		[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
		$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
		$sqlCommand.Parameters["@Active"].value = $true
		
		$sqlReader = $sqlCommand.ExecuteReader()
		$sqlCommand.Dispose()

		$dataTable = New-Object System.Data.DataTable
		$dataTable.Load($SqlReader)	
	
		foreach($row in $dataTable){
			try {
				$sqlCommand = GetStoredProc $sqlConnection "cm.spDiskDriveConfigurationUpsert"
				[Void]$sqlCommand.Parameters.Add("@DiskDriveGUID", [system.data.SqlDbType]::uniqueidentifier)
				[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
				
			    $sqlCommand.Parameters["@DiskDriveGUID"].value = $row["objectGUID"]
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				
				[Void]$sqlCommand.ExecuteNonQuery()
			}
			catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $dnsHostName "Warning" $moduleName "Disk Drive Configuration : $instanceName : $msg" $sqlConnection
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

Write-Verbose " : $dnsHostName : $moduleName : Finish"

# Return error count
Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}