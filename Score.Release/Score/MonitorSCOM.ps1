<#

.SYNOPSIS

	This script is intended to retrieve object health data and alert data from a SCOM management group.


.DESCRIPTION

	This script is intended to retrieve object health data and alert data from a SCOM management group.


.PARAMETER managementGroup

    The name of the Management Group.  This is tied to the app.monitor.config file and is case sensitive.  This value will be used to retrieve the server name to which the script will connect.

.PARAMETER ObjectClasses

	List of Object Classes to retreive.  The use of this parameter has evolved over time and the object classes are not directly tied in with SCOM object classes.

	"agent" - Information about Windows-hosted agents
	"config" - List of Resolution states and descriptions
	"alert" - All alerts (both open and closed0
	"WindowsComputer" - Information about Windows Computer objects that are monitored by SCOM
	"Generic" - This class is linked to the list of Object Classes in the config file (in the ObjectClasses stanza)
	"Group" - Information about groups that have health states defined
	"TimeZone" - Used to retrieve current time zone information from server

.PARAMETER SyncType

	Type of Synchronization to run
	Full - Synchronize all objects
	Incremental - Synchronize only those objects that have changed since the last synchronziation was executed


.INPUTS

  None

.OUTPUTS

  All data is written to the SCORE database.  The connection string for the SCORE database is stored in app.monitor.config.
  All errors are stored to the table dbo.ProcessLog in the SCORE database.

.NOTES

  Version:        3.0
  Author:         Hugh Scott
  Creation Date:  2019/01/31

  Purpose/Change: Initial script development

.EXAMPLE

	Example 1: Full Synchronization of Management Group objects and groups (not including alerts)
	.\MonitorDomain.ps1 -managementGroup ABCD_OM -objectClasses Generic -SyncType Full

.EXAMPLE

	Example 3: Full Synchronization of Management Group Windows Computers and Agents
	.\MonitorDomain.ps1 -managementGroup ABCD_OM -objectClasses WindowsComputer,agent -SyncType Full

.EXAMPLE

	Example 3: Full Synchronization of Management Group alerts (always retrieve "config" with "alert"
	.\MonitorDomain.ps1 -managementGroup ABCD_OM -objectClasses Config,Alert -SyncType Full

.EXAMPLE

	Example 4: Incremental Synchronization of Management Group alerts (always retrieve "config" with "alert"
	.\MonitorDomain.ps1 -managementGroup ABCD_OM -objectClasses Config,Alert -SyncType Incremental

#>

[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$managementGroup,
	[Parameter(Mandatory=$True,Position=2)]
	[ValidateSet("agent","alert","config","WindowsComputer","TimeZone","Generic","Group")]
	[string[]]$ObjectClasses,
	[Parameter(Mandatory=$False,Position=3)]
	[ValidateSet("Full","Incremental")]
	[string]$syncType="Full"
)


#region GetSyncStatus
#************************************************************************************************************************************
# Function GetSyncStatus
#
# Parameters:
# 	- ManagementGroup
#	- ObjectClass
#
# Returns:
#   - Last Update Type (varchar: Full | Incremental)
#   - Start Date (datetime)
#   - End Date (datetime)
#   - syncType
#
# Function to retrieve last synch type/status for an object class
#
#************************************************************************************************************************************
Function GetSyncStatus {
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
	$scomManagementGroup,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$ObjectClass,
	[Parameter(Mandatory=$True,Position=3)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection   
)

    [int]$errorCounter = 0
    [string]$moduleName = "GetSCOMSyncStatus"

    [string]$ManagementGroup = $scomManagementGroup["GroupName"]
    [string]$ManagementServer = $scomManagementGroup["ServerName"]

    Try {
	
        # Retrieve stored procedure
	    $sqlCommand = GetStoredProc $sqlConnection "scom.spSyncStatusViewSelect"

	    [Void]$sqlCommand.Parameters.Add("@ManagementGroup", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@ObjectClass", [system.data.SqlDbType]::nvarchar)
	
        $sqlCommand.Parameters["@ManagementGroup"].value = $ManagementGroup
        $sqlCommand.Parameters["@ObjectClass"].value = $ObjectClass
	    $sqlReader = $sqlCommand.ExecuteReader()
	    $sqlCommand.Dispose()

	    $dataTable = New-Object System.Data.DataTable
	    $dataTable.Load($SqlReader)
	
	    # Get results from last Synch
	    # IF
        #  - Requested synch does not exist, perform a full synch
	    #  - Requested synch is incremental and no previous synch has been performed, perform a full synch
	    if($dataTable.Rows.Count -gt 0) {
            # A record exists, we've checked this domain before
            if($dataTable.Rows[0]["LastStatus"] -eq "Starting...") {
			    # If the status is "Starting...", then it means that a process is running or aborted the last run
		        [string]$lastSyncType = "In process" 
		        [datetime]$lastStartDate = "1/1/1970"
		        [datetime]$lastFullSync = "1/1/1970"
		        [datetime]$lastIncrementalSync = "1/1/1970"
            } elseif( $dataTable.Rows[0]["lastFullSync"] -eq [System.DBNull]::Value) {
                # In theory, this should not happen, but it might if there was an error
		        [string]$lastSyncType = $dataTable.Rows[0]["LastSyncType"]
		        [datetime]$lastStartDate = $dataTable.Rows[0]["LastStartDate"]
		        [datetime]$lastFullSync = "1/1/1970"
		        [datetime]$lastIncrementalSync = "1/1/1970"
            } elseif( $dataTable.Rows[0]["lastIncrementalSync"] -eq [System.DBNull]::Value) {
                # Otherwise, gather the last synctype, the last full sync date and the last incremental sync date
		        [string]$lastSyncType = $dataTable.Rows[0]["LastSyncType"]
		        [datetime]$lastStartDate = $dataTable.Rows[0]["LastStartDate"]
		        [datetime]$lastFullSync = $dataTable.Rows[0]["lastFullSync"]
		        [datetime]$lastIncrementalSync = "1/1/1970"			
		    } else {
                # Otherwise, gather the last synctype, the last full sync date and the last incremental sync date
		        [string]$lastSyncType = $dataTable.Rows[0]["LastSyncType"]
		        [datetime]$lastStartDate = $dataTable.Rows[0]["LastStartDate"]
		        [datetime]$lastFullSync = $dataTable.Rows[0]["lastFullSync"]
		        [datetime]$lastIncrementalSync = $dataTable.Rows[0]["lastIncrementalSync"]
            }
	    } else {
            # A record does not exist, we need to perform a full synch
		    [string]$lastSyncType = "None" 
		    [datetime]$lastStartDate = "1/1/1970"
		    [datetime]$lastFullSync = "1/1/1970"
		    [datetime]$lastIncrementalSync = "1/1/1970"
	    }     
    }
	    catch [System.Exception] {
		    $msg = $_.Exception.Message
		    AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
		    $errorCounter++
    }
	$sqlCommand.Dispose()
	
	return new-object psobject -Property @{LastSyncType = $lastSyncType; LastStartDate = $lastStartDate; LastFullSync = $lastFullSync; LastIncrementalSync = $lastIncrementalSync}
	
}
#endregion

#region SetSyncStatus
#************************************************************************************************************************************
# Function SetSyncStatus
#
# Parameters:
# 	- ManagementGroup
#	- ObjectClass
#   - syncType (varchar: Full | Incremental)
#   - startDate (datetime)
#   - endDate (datetime)
#   - objectCount
#   - syncStatus
#
# Returns:
#
# Function to set AD Domain stats for object in scom.SyncStatus
# 
# May be called to set the beginning status (no end date) or to update upon completion (end date specified)
#
#************************************************************************************************************************************
Function SetSyncStatus {
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
	$scomManagementGroup,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$ObjectClass,
	[Parameter(Mandatory=$True,Position=3)]
	[ValidateSet("Full","Incremental","None")]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=4)]
	[datetime]$startDate,
	[Parameter(Mandatory=$False,Position=5)]
	[datetime]$endDate,
	[Parameter(Mandatory=$False,Position=6)]
	[Int32]$objectCount=0,
	[Parameter(Mandatory=$True,Position=7)]
	[string]$syncStatus,
	[Parameter(Mandatory=$True,Position=8)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection  
)  
    [int]$errorCounter = 0
    [string]$moduleName = "SetSCOMSyncStatus"

    # Retrieve SCOM Management Group Information
    [string]$ManagementGroup = $scomManagementGroup["GroupName"]
    [string]$ManagementServer = $scomManagementGroup["ServerName"]

	Try {
	
	    $sqlCommand = GetStoredProc $sqlConnection "scom.spSyncStatusUpsert"

	    [Void]$sqlCommand.Parameters.Add("@ManagementGroup", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@ObjectClass", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@SyncType", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@StartDate", [system.data.SqlDbType]::DateTime)
	    [Void]$sqlCommand.Parameters.Add("@EndDate", [system.data.SqlDbType]::DateTime)
	    [Void]$sqlCommand.Parameters.Add("@Count", [system.data.SqlDbType]::Int)
	    [Void]$sqlCommand.Parameters.Add("@Status", [system.data.SqlDbType]::nvarchar)
	
		If($endDate){
		    $sqlCommand.Parameters["@ManagementGroup"].value = $ManagementGroup
		    $sqlCommand.Parameters["@ObjectClass"].value = $ObjectClass
		    $sqlCommand.Parameters["@SyncType"].value = $syncType
		    $sqlCommand.Parameters["@StartDate"].value = $startDate
		    $sqlCommand.Parameters["@EndDate"].value = $endDate
		    $sqlCommand.Parameters["@Count"].value = $objectCount
		    $sqlCommand.Parameters["@Status"].value = $syncStatus
		} Else {
		    $sqlCommand.Parameters["@ManagementGroup"].value = $ManagementGroup
		    $sqlCommand.Parameters["@ObjectClass"].value = $ObjectClass
		    $sqlCommand.Parameters["@SyncType"].value = $syncType
		    $sqlCommand.Parameters["@StartDate"].value = $startDate
			$sqlCommand.Parameters["@Status"].value = $syncStatus
		}
        [Void]$sqlCommand.ExecuteNonQuery()
	    $sqlCommand.Dispose()

        If($endDate){

	        $sqlCommand = GetStoredProc $sqlConnection "scom.spSyncHistoryInsert"

	        [Void]$sqlCommand.Parameters.Add("@ManagementGroup", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@ObjectClass", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@SyncType", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@StartDate", [system.data.SqlDbType]::DateTime)
	        [Void]$sqlCommand.Parameters.Add("@EndDate", [system.data.SqlDbType]::DateTime)
	        [Void]$sqlCommand.Parameters.Add("@Count", [system.data.SqlDbType]::Int)
	        [Void]$sqlCommand.Parameters.Add("@Status", [system.data.SqlDbType]::nvarchar)
	
	        $sqlCommand.Parameters["@ManagementGroup"].value = $ManagementGroup
	        $sqlCommand.Parameters["@ObjectClass"].value = $ObjectClass
	        $sqlCommand.Parameters["@SyncType"].value = $syncType
	        $sqlCommand.Parameters["@StartDate"].value = $startDate
	        $sqlCommand.Parameters["@EndDate"].value = $endDate
	        $sqlCommand.Parameters["@Count"].value = $objectCount
	        $sqlCommand.Parameters["@Status"].value = $syncStatus
        }

	    [Void]$sqlCommand.ExecuteNonQuery()
		$sqlCommand.Dispose()
	}
    Catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
        $errorCounter++
    }
}
#endregion

#region SyncType
#************************************************************************************************************************************
# Function GetSyncType
#
# Parameters:
# 	- lastSyncStatus
#
# Returns:
#
# Returns string value of sync type to perform (Full or Incremental)
# 
#************************************************************************************************************************************
function GetSyncType {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	$lastSynchStatus,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$requestedSyncType
)
	If($lastSyncStatus.LastSyncType -eq "In process") {
		# There is a synch already in process, check if it's more than an hour old
        [datetime]$lastStart = $lastSyncStatus.LastStartDate
        [datetime]$currentTime = (Get-Date)
        [timespan]$timeDiff = New-TimeSpan -Start $lastStart -End $currentTime
        If($timeDiff.TotalMinutes -gt 90){
		    # An old, probably stale synch, let's try to restart it (cringe); retrieve values for $lastUpdate and $lastFullSync
            $syncType="Full"
		    [datetime]$lastUpdate = MaxDate $lastSyncStatus.LastFullSync $lastSyncStatus.LastIncrementalSync
		    [datetime]$lastFullSync = $lastSyncStatus.LastFullSync
        } else {
    		Write-Host "$object : A synchronization is already in process." -ForegroundColor Red
	    	AddLogEntry $domainDNSRoot "Warning" "GetSyncStatus" "$object : A synchronization is already in process." $sqlConnection
		    $warningCounter++
		    continue
        }
	} ElseIf ($lastSyncStatus.LastSyncType -eq "None") {
		# There has not been a successful previous sync, set $syncType to full
		$syncType = "Full"
		[datetime]$lastUpdate = MaxDate $lastSyncStatus.LastFullSync $lastSyncStatus.LastIncrementalSync
		[datetime]$lastFullSync = $lastSyncStatus.LastFullSync
	} ElseIf ($lastSyncStatus.LastSyncType -eq "Incremental" -and $lastSyncStatus.LastFullSync -lt (Get-Date).AddHours(-1)) {
		# The last full sync was more than 8 hours ago, set $syncType to full
		$syncType = "Full"
		[datetime]$lastUpdate = MaxDate $lastSyncStatus.LastFullSync $lastSyncStatus.LastIncrementalSync
		[datetime]$lastFullSync = $lastSyncStatus.LastFullSync
	} Else {
		# This is the normal condition; retrieve values for $lastUpdate and $lastFullSync
        $syncType=$requestedSyncType
		[datetime]$lastUpdate = MaxDate $lastSyncStatus.LastFullSync $lastSyncStatus.LastIncrementalSync
		[datetime]$lastFullSync = $lastSyncStatus.LastFullSync
	}

    # Return $syncType

	return new-object psobject -Property @{SyncType = $syncType; LastUpdate = $lastUpdate; LastFullSync = $lastFullSync}
}
#endregion

#************************************************************************************************************************************
# function WriteSCOMAgents
#
# Parameters:
# 	$managementServerName
#	$sqlConnection
# 	
# Stored Procedures:
#	dbo.spComputerUpsert
#
# Adds Computer to monitoring framework
#************************************************************************************************************************************
function WriteSCOMAgentInfo {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	$scomManagementGroup,
	[Parameter(Mandatory=$True,Position=2)]
	[ValidateSet("Full","Incremental","None")]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=3)]
    [DateTime]$lastUpdate,
	[Parameter(Mandatory=$False,Position=4)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)

    # Initialize error variables
    [int]$errorCounter = 0
    [int]$warningCounter = 0
    [string]$moduleName = "WriteSCOMAgentInfo"

    [int]$agentCounter = 0

    
    # Retrieve SCOM Management Group Information
    [string]$ManagementGroup = $scomManagementGroup["GroupName"]
    [string]$ManagementServer = $scomManagementGroup["ServerName"]

	AddLogEntry $ManagementGroup "Info" $moduleName "Starting $syncType check for Agent..." $sqlConnection

    ################################################################################
    # CONNECT TO SCOM
    ################################################################################  
    Import-Module OperationsManager


    # Connect to localhost when running on the management server or define a server to connect to.
    Try {
        $connect = New-SCOMManagementGroupConnection -ComputerName $ManagementServer -PassThru
    }
    Catch [System.Exception] {
		$msg=$_.Exception.Message
		AddLogEntry $ManagementGroup "Error" $moduleName "$ManagementServer : $msg" $sqlConnection
		$errorCounter++
	}

    If($connect.IsActive){
        # Record time stamp
        [datetime]$timeStart = (Get-Date)
        $lastUpdate = $lastUpdate.ToUniversalTime()


        ################################################################################
        # GET SCOM AGENTS
        ################################################################################
        Try {
            If($syncType -eq "Full") {
        	    $Agents = Get-SCOMAgent
            } Else {
                $Agents = Get-SCOMAgent | Where-Object {$_.LastModified -gt $lastUpdate}
            }
        }
        Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
			$errorCounter++
	    }        
	
	    $sqlCommand = GetStoredProc $sqlConnection "scom.spAgentUpsert"
	    [Void]$sqlCommand.Parameters.Add("@AgentID", [system.data.SqlDbType]::uniqueidentifier)
	    [Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@DisplayName", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@ManagementGroup", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@PrimaryManagementServer", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@Version", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@PatchList", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@ComputerName", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@HealthState", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@InstalledBy", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@InstallTime", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@ManuallyInstalled", [system.data.SqlDbType]::bit)
	    [Void]$sqlCommand.Parameters.Add("@ProxyingEnabled", [system.data.SqlDbType]::bit)
	    [Void]$sqlCommand.Parameters.Add("@IPAddress", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@LastModified", [system.data.SqlDbType]::datetime)

	    [Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
	    [Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	
        foreach($Agent in $Agents){
            Try {
	            [datetime]$timeNow = (Get-Date)
	            $sqlCommand.Parameters["@AgentID"].Value = $Agent.ID
	            $sqlCommand.Parameters["@Name"].Value = $Agent.Name
	            $sqlCommand.Parameters["@DisplayName"].Value = $Agent.DisplayName
	            $sqlCommand.Parameters["@Domain"].Value = $Agent.Domain
	            $sqlCommand.Parameters["@ManagementGroup"].Value = $Agent.ManagementGroup.ToString()
	            $sqlCommand.Parameters["@PrimaryManagementServer"].Value = $Agent.PrimaryManagementServerName
	            $sqlCommand.Parameters["@Version"].Value = $Agent.Version
	            $sqlCommand.Parameters["@PatchList"].Value = $Agent.PatchList.ToString()
	            $sqlCommand.Parameters["@ComputerName"].Value = $Agent.ComputerName
	            $sqlCommand.Parameters["@HealthState"].Value = $Agent.HealthState.ToString()
	            $sqlCommand.Parameters["@InstalledBy"].Value = $Agent.InstalledBy
	            $sqlCommand.Parameters["@InstallTime"].Value = $Agent.InstallTime
	            $sqlCommand.Parameters["@ManuallyInstalled"].Value = $Agent.ManuallyInstalled
	            $sqlCommand.Parameters["@ProxyingEnabled"].Value = $Agent.ProxyingEnabled.Value
	            $sqlCommand.Parameters["@IPAddress"].Value = $Agent.IPAddress
	            $sqlCommand.Parameters["@LastModified"].Value = $Agent.LastModified


	            $sqlCommand.Parameters["@Active"].Value = $true
	            $sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow
	            [void]$sqlCommand.ExecuteNonQuery()
                $agentCounter++
            }
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
			    $warningCounter++
	        }     

        }
	
	    $sqlCommand.Dispose()

        ################################################################################
        # GET SCOM MANAGEMENT SERVERS
        ################################################################################
        Try {
    	    $mgmtServers = Get-SCOMManagementServer
        }
        Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
			$errorCounter++
	    }        
	
	    $sqlCommand = GetStoredProc $sqlConnection "scom.spAgentUpsert"
	    [Void]$sqlCommand.Parameters.Add("@AgentID", [system.data.SqlDbType]::uniqueidentifier)
	    [Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@DisplayName", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@ManagementGroup", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@PrimaryManagementServer", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@Version", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@PatchList", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@ComputerName", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@HealthState", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@InstalledBy", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@InstallTime", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@ManuallyInstalled", [system.data.SqlDbType]::bit)
	    [Void]$sqlCommand.Parameters.Add("@ProxyingEnabled", [system.data.SqlDbType]::bit)
	    [Void]$sqlCommand.Parameters.Add("@IPAddress", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@LastModified", [system.data.SqlDbType]::datetime)

	    [Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
	    [Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	
        foreach($mgmtServer in $mgmtServers){
            Try {
	            $timeNow = (Get-Date)
	            $sqlCommand.Parameters["@AgentID"].Value = $mgmtServer.ID
	            $sqlCommand.Parameters["@Name"].Value = $mgmtServer.Name
	            $sqlCommand.Parameters["@DisplayName"].Value = $mgmtServer.DisplayName
	            $sqlCommand.Parameters["@Domain"].Value = $mgmtServer.Domain
	            $sqlCommand.Parameters["@ManagementGroup"].Value = $mgmtServer.ManagementGroup.ToString()
	            $sqlCommand.Parameters["@PrimaryManagementServer"].Value = "" # $managementServer.PrimaryManagementServerName
	            $sqlCommand.Parameters["@Version"].Value = $mgmtServer.Version
	            $sqlCommand.Parameters["@PatchList"].Value = "" # $managementServer.PatchList.ToString()
	            $sqlCommand.Parameters["@ComputerName"].Value = $mgmtServer.ComputerName
	            $sqlCommand.Parameters["@HealthState"].Value = $mgmtServer.HealthState.ToString()
	            $sqlCommand.Parameters["@InstalledBy"].Value = "" # $Agent.InstalledBy
	            $sqlCommand.Parameters["@InstallTime"].Value = $mgmtServer.InstallTime
	            $sqlCommand.Parameters["@ManuallyInstalled"].Value = $mgmtServer.ManuallyInstalled
	            $sqlCommand.Parameters["@ProxyingEnabled"].Value = $mgmtServer.ProxyingEnabled.Value
	            $sqlCommand.Parameters["@IPAddress"].Value = $mgmtServer.IPAddress
	            $sqlCommand.Parameters["@LastModified"].Value = $mgmtServer.LastModified


	            $sqlCommand.Parameters["@Active"].Value = $true
	            $sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow
	            [void]$sqlCommand.ExecuteNonQuery()
                $agentCounter++
            }
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
			    $warningCounter++
	        }     

        }
	
	    $sqlCommand.Dispose()

        ################################################################################
        # GET SCOM AGENT AVAILABILITY
        ################################################################################
        Try {
	        $Class = Get-SCOMClass -name "Microsoft.SystemCenter.Agent"
            $Agents = $null
            $Agents = Get-SCOMClassInstance -Class $Class
        }
        Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
			$warningCounter++
	    }
	
	    $sqlCommand = GetStoredProc $sqlConnection "scom.spAgentAvailabilityUpdate"
	    [Void]$sqlCommand.Parameters.Add("@DisplayName", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@IsAvailable", [system.data.SqlDbType]::bit)
	    [Void]$sqlCommand.Parameters.Add("@AvailabilityLastModified", [system.data.SqlDbType]::datetime)

        foreach($Agent in $Agents){
            Try {
	            $sqlCommand.Parameters["@DisplayName"].Value = $Agent.DisplayName
	            $sqlCommand.Parameters["@IsAvailable"].Value = $Agent.IsAvailable
	            $sqlCommand.Parameters["@AvailabilityLastModified"].Value = $Agent.AvailabilityLastModified

	            [void]$sqlCommand.ExecuteNonQuery()
            } 
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Error" $moduleName "Update Agent Availability : $msg" $sqlConnection
			    $warningCounter++
	        }
        }

        $sqlCommand.Dispose()

        ################################################################################
        # GET SCOM MANAGEMENT SERVER AVAILABILITY
        ################################################################################
        Try {
	        $Class = Get-SCOMClass -name "Microsoft.SystemCenter.ManagementServer"
            $Agents = $null
            $Agents = Get-SCOMClassInstance -Class $Class
        }
        Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
			$errorCounter++
	    }
	
	    $sqlCommand = GetStoredProc $sqlConnection "scom.spAgentAvailabilityUpdate"
	    [Void]$sqlCommand.Parameters.Add("@DisplayName", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@IsAvailable", [system.data.SqlDbType]::bit)
	    [Void]$sqlCommand.Parameters.Add("@AvailabilityLastModified", [system.data.SqlDbType]::datetime)

        foreach($Agent in $Agents){
            Try {
	            $sqlCommand.Parameters["@DisplayName"].Value = $Agent.DisplayName
	            $sqlCommand.Parameters["@IsAvailable"].Value = $Agent.IsAvailable
	            $sqlCommand.Parameters["@AvailabilityLastModified"].Value = $Agent.AvailabilityLastModified

	            [void]$sqlCommand.ExecuteNonQuery()
            } 
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Error" $moduleName "Update Agent Availability : $msg" $sqlConnection
			    $warningCounter++
	        }
        }

        $sqlCommand.Dispose()

        ############################################################################################################
        # IF SYNCTYPE IS FULL, INACTIVATE OBJECTS THAT WERE NOT UPDATED
        ############################################################################################################
        If($syncType -eq "Full") {
            Try {
                $sqlCommand = GetStoredProc $sqlConnection "scom.spAgentInactivate"
	            [Void]$sqlCommand.Parameters.Add("@BeforeDate", [system.data.SqlDbType]::datetime)

                $sqlCommand.Parameters["@BeforeDate"].Value = $timeStart

                [void]$sqlCommand.ExecuteNonQuery()
            }
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Error" $moduleName "Inactivate Agents: $msg" $sqlConnection
			    $warningCounter++
	        }

            $sqlCommand.Dispose()
        }

	
	    AddLogEntry $ManagementGroup "Info" $moduleName "Retrieved $agentCounter agents from $ManagementGroup" $sqlConnection

        # Determine Exit status
	    If($errorCounter -gt 0) {$syncStatus = "Error"}
	    ElseIf($warningCounter -gt 0) {$syncStatus = "Warning"}
	    Else {$syncStatus = "Success"}
	
        Return New-Object psobject -Property @{Status = $syncStatus; ObjectCount = $agentCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    } Else {
        $errorCounter++
        Return New-Object psobject -Property @{Status = "Error"; ObjectCount = $agentCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    }
}


#************************************************************************************************************************************
# function WriteSCOMConfig
#
# Parameters:
# 	$scomManagementGroup
#   $syncType
#   $lastUpdate
#	$sqlConnection
# 	
# Stored Procedures:
#	dbo.spAlertResolutionStateUpsert
#
# Update SCOM Configuration Information
#************************************************************************************************************************************
function WriteSCOMConfig {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	$scomManagementGroup,
	[Parameter(Mandatory=$True,Position=2)]
	[ValidateSet("Full","Incremental","None")]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=3)]
    [DateTime]$lastUpdate,
	[Parameter(Mandatory=$False,Position=4)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
    # Initialize error variables
    [int]$errorCounter = 0
    [int]$warningCounter = 0
    [string]$moduleName = "WriteSCOMConfig"

    [int]$configCounter = 0

    # Retrieve SCOM Management Group Information
    [string]$ManagementGroup = $scomManagementGroup["GroupName"]
    [string]$ManagementServer = $scomManagementGroup["ServerName"]

	AddLogEntry $managementGroup "Info" $moduleName "Starting $syncType check for Config..." $sqlConnection

    ################################################################################
    # CONNECT TO SCOM
    ################################################################################  
    # Check if the OperationsManager Module is loaded
    Import-module OperationsManager


    # Connect to localhost when running on the management server or define a server to connect to.
    Try {
        $connect = New-SCOMManagementGroupConnection -ComputerName $managementServer -PassThru
    } 
    Catch [System.Exception] {
		$msg=$_.Exception.Message
		AddLogEntry $managementGroup "Error" $moduleName $msg $sqlConnection
		$errorCounter++
	}

    If($connect.IsActive){

        ################################################################################
        # GET SCOM ALERT RESOLUTION STATES
        ################################################################################
        Try {
	        $AlertResolutionStates = Get-SCOMAlertResolutionState
        } 
        Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $managementGroup "Error" $moduleName $msg $sqlConnection
			    $errorCounter++
	    }
	
	    $sqlCommand = GetStoredProc $sqlConnection "scom.spAlertResolutionStateUpsert"
	    [Void]$sqlCommand.Parameters.Add("@ResolutionStateID", [system.data.SqlDbType]::uniqueidentifier)
	    [Void]$sqlCommand.Parameters.Add("@ResolutionState", [system.data.SqlDbType]::tinyint)
	    [Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
	    [Void]$sqlCommand.Parameters.Add("@IsSystem", [system.data.SqlDbType]::bit)
	    [Void]$sqlCommand.Parameters.Add("@ManagementGroup", [system.data.SqlDbType]::nvarchar)

	    [Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
	    [Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	
        foreach($AlertResolutionState in $AlertResolutionStates){
            Try {
	            [datetime]$timeNow = (Get-Date)
	            $sqlCommand.Parameters["@ResolutionStateID"].Value = $AlertResolutionState.ID
	            $sqlCommand.Parameters["@ResolutionState"].Value = $AlertResolutionState.ResolutionState
	            $sqlCommand.Parameters["@Name"].Value = $AlertResolutionState.Name
	            $sqlCommand.Parameters["@IsSystem"].Value = $AlertResolutionState.IsSystem
	            $sqlCommand.Parameters["@ManagementGroup"].Value = $AlertResolutionState.ManagementGroup.ToString()

	            $sqlCommand.Parameters["@Active"].Value = $true
	            $sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow
	            [void]$sqlCommand.ExecuteNonQuery()
                $configCounter++
            } 
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $managementGroup "Warning" $moduleName $msg $sqlConnection
			    $warningCounter++
	        }
        }
	
	    $sqlCommand.Dispose()
	
	    AddLogEntry $managementGroup "Info" $moduleName "Retrieved $configCounter configuration items from $managementGroup" $sqlConnection

        # Determine Exit status
	    If($errorCounter -gt 0) {$syncStatus = "Error"}
	    ElseIf($warningCounter -gt 0) {$syncStatus = "Warning"}
	    Else {$syncStatus = "Success"}
	
	    Return New-Object psobject -Property @{Status = $syncStatus; ObjectCount = $configCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    } Else {
        Return New-Object psobject -Property @{Status = "Error"; ObjectCount = $configCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    }
}


#************************************************************************************************************************************
# function WriteTimeZone
#
# Parameters:
# 	
# Stored Procedures:
#	dbo.spSystemTimeZoneUpsert
#
# Update SCOM Configuration Information
#************************************************************************************************************************************
function WriteTimeZone {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$False,Position=1)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
    # Initialize error variables
    [int]$errorCounter = 0
    [int]$warningCounter = 0
    [string]$moduleName = "WriteTimeZone"

    [int]$zoneCounter = 0

	AddLogEntry "TimeZone" "Info" $moduleName "Starting $syncType check for TimeZone..." $sqlConnection

	$sqlCommand = GetStoredProc $sqlConnection "dbo.spSystemTimeZoneUpsert"
    [void]$sqlCommand.Parameters.Add("@ID",  [System.Data.SqlDbType]::nvarchar)
    [void]$sqlCommand.Parameters.Add("@DisplayName",  [System.Data.SqlDbType]::nvarchar)
    [void]$sqlCommand.Parameters.Add("@StandardName",  [System.Data.SqlDbType]::nvarchar)
    [void]$sqlCommand.Parameters.Add("@DaylightName",  [System.Data.SqlDbType]::nvarchar)
    [void]$sqlCommand.Parameters.Add("@BaseUTCOffset",  [System.Data.SqlDbType]::int)	
    [void]$sqlCommand.Parameters.Add("@CurrentUTCOffset",  [System.Data.SqlDbType]::int)	
    [void]$sqlCommand.Parameters.Add("@SupportsDaylightSavingTime",  [System.Data.SqlDbType]::bit)

	[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)

    # Retrieve list of Time Zones from System
    $Zones = [System.TimeZoneInfo]::GetSystemTimeZones()
    [DateTime]$CurrentDate = (Get-Date)
	
    foreach($Zone in $Zones){
        Try {
	        [datetime]$timeNow = (Get-Date)
            $currentUTCOffset = $Zone.GetUtcOffset($CurrentDate).TotalMinutes
            $sqlCommand.Parameters["@ID"].Value = $Zone.ID
            $sqlCommand.Parameters["@DisplayName"].Value = $Zone.DisplayName
            $sqlCommand.Parameters["@StandardName"].Value = $Zone.StandardName
            $sqlCommand.Parameters["@DaylightName"].Value = $Zone.DaylightName
            $sqlCommand.Parameters["@BaseUTCOffset"].Value = $zone.BaseUtcOffset.TotalMinutes
            $sqlCommand.Parameters["@CurrentUTCOffset"].Value = $currentUTCOffset
            $sqlCommand.Parameters["@SupportsDaylightSavingTime"].Value = $Zone.SupportsDaylightSavingTime

	        $sqlCommand.Parameters["@Active"].Value = $true
	        $sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow
	        [void]$sqlCommand.ExecuteNonQuery()
            $zoneCounter++
        } 
        Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry "TimeZone" "Warning" $moduleName $msg $sqlConnection
			$warningCounter++
	    }
    }
	
	$sqlCommand.Dispose()
	
	AddLogEntry "TimeZone" "Info" $moduleName "Retrieved $zoneCounter Time Zones from system." $sqlConnection

    # Determine Exit status
	If($errorCounter -gt 0) {$syncStatus = "Error"}
	ElseIf($warningCounter -gt 0) {$syncStatus = "Warning"}
	Else {$syncStatus = "Success"}
	
	Return New-Object psobject -Property @{Status = $syncStatus; ObjectCount = $zoneCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
}

#************************************************************************************************************************************
# function WriteSCOMAlerts
#
# Parameters:
# 	$scomManagementGroup
#   $syncType
#   $lastUpdate
#	$sqlConnection
# 	
# Stored Procedures:
#	dbo.spAlertUpsert
#
# Update SCOM Alert Information
#************************************************************************************************************************************
function WriteSCOMAlerts {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	$scomManagementGroup,
	[Parameter(Mandatory=$True,Position=2)]
	[ValidateSet("Full","Incremental","None")]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=3)]
    [DateTime]$lastUpdate,
	[Parameter(Mandatory=$False,Position=4)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
    # Initialize error variables
    [int]$errorCounter = 0
    [int]$warningCounter = 0
    [string]$moduleName = "WriteSCOMAlerts"

    [int]$alertCounter = 0

    # Retrieve SCOM Management Group Information
    [string]$ManagementGroup = $scomManagementGroup["GroupName"]
    [string]$ManagementServer = $scomManagementGroup["ServerName"]

	AddLogEntry $ManagementGroup "Info" $moduleName "Starting $syncType check for Alerts..." $sqlConnection

    ################################################################################
    # CONNECT TO SCOM
    ################################################################################  
    # Check if the OperationsManager Module is loaded
    Import-module OperationsManager

    # Connect to localhost when running on the management server or define a server to connect to.
    Try {
        $connect = New-SCOMManagementGroupConnection -ComputerName $managementServer -PassThru
    }
    Catch [System.Exception] {
		$msg=$_.Exception.Message
		AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
		$errorCounter++
	}
    If($connect.IsActive){
        # Record time stamp
        [datetime]$timeStart = (Get-Date)
	    $lastUpdate=$lastUpdate.ToUniversalTime()

        ################################################################################
        # GET SCOM ALERTS
        ################################################################################
        Try {
            If($syncType -eq "Full") {
        	    $Alerts = Get-SCOMAlert
            } Else {
                # $Alerts = Get-SCOMAlert | Where-Object {($_.LastModified -gt $lastUpdate)}
                [string]$strlastUpdate = $lastUpdate.ToString()
                [string]$criteria = "LastModified > '" + $strLastUpdate + "'"
                $Alerts = Get-SCOMAlert -Criteria $criteria
                AddLogEntry $ManagementGroup "Info" $moduleName "Getting SCOM alerts last modified since UTC $lastUpdate" $sqlConnection
            }
            [int]$alertCount = $alerts.Count
		    AddLogEntry $ManagementGroup "Info" $moduleName "Retrieved $alertCount alerts from $ManagementGroup" $sqlConnection

        }
        Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $ManagementGroup "Error" $moduleName "Get SCOM Alerts : $msg" $sqlConnection
			$errorCounter++
	    }


	    $sqlCommand = GetStoredProc $sqlConnection "scom.spAlertUpsert"
        [Void]$sqlCommand.Parameters.Add("@AlertId", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@Description", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@MonitoringObjectId", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@MonitoringClassId", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@MonitoringObjectDisplayName", [system.data.SqlDbType]::ntext)
        [Void]$sqlCommand.Parameters.Add("@MonitoringObjectName", [system.data.SqlDbType]::ntext)
        [Void]$sqlCommand.Parameters.Add("@MonitoringObjectPath", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@MonitoringObjectFullName", [system.data.SqlDbType]::ntext)
        [Void]$sqlCommand.Parameters.Add("@IsMonitorAlert", [system.data.SqlDbType]::bit)
        [Void]$sqlCommand.Parameters.Add("@ProblemId", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@MonitoringRuleId", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@ResolutionState", [system.data.SqlDbType]::tinyint)
        [Void]$sqlCommand.Parameters.Add("@ResolutionStateName", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@Priority", [system.data.SqlDbType]::tinyint)
        [Void]$sqlCommand.Parameters.Add("@Severity", [system.data.SqlDbType]::tinyint)
        [Void]$sqlCommand.Parameters.Add("@Category", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@Owner", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@ResolvedBy", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@TimeRaised", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@TimeAdded", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@LastModified", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@LastModifiedBy", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@TimeResolved", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@TimeResolutionStateLastModified", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@CustomField1", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@CustomField2", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@CustomField3", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@CustomField4", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@CustomField5", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@CustomField6", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@CustomField7", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@CustomField8", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@CustomField9", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@CustomField10", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@TicketId", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@Context", [system.data.SqlDbType]::ntext)
        [Void]$sqlCommand.Parameters.Add("@ConnectorId", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@LastModifiedByNonConnector", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@MonitoringObjectInMaintenanceMode", [system.data.SqlDbType]::bit)
        [Void]$sqlCommand.Parameters.Add("@MaintenanceModeLastModified", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@MonitoringObjectHealthState", [system.data.SqlDbType]::tinyint)
        [Void]$sqlCommand.Parameters.Add("@StateLastModified", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@ConnectorStatus", [system.data.SqlDbType]::int)
        [Void]$sqlCommand.Parameters.Add("@TopLevelHostEntityId", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@RepeatCount", [system.data.SqlDbType]::int)
        [Void]$sqlCommand.Parameters.Add("@AlertStringId", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@AlertStringName", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@LanguageCode", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@AlertStringDescription", [system.data.SqlDbType]::ntext)
        [Void]$sqlCommand.Parameters.Add("@AlertParams", [system.data.SqlDbType]::ntext)
        [Void]$sqlCommand.Parameters.Add("@SiteName", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@TfsWorkItemId", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@TfsWorkItemOwner", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@HostID", [system.data.SqlDbType]::int)

        [Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
        [Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime2)
	
        foreach($Alert in $Alerts){
            Try {
	            [datetime]$timeNow = (Get-Date)
                If($Alert.MonitoringObjectName -eq $null){$MonitoringObjectName = [System.DBNull]::Value} Else {$MonitoringObjectName = $Alert.MonitoringObjectName}
                If($Alert.MonitoringObjectPath -eq $null){$MonitoringObjectPath = [System.DBNull]::Value} Else {$MonitoringObjectPath = $Alert.MonitoringObjectPath}
                If($Alert.Owner -eq $null){$Owner = [System.DBNull]::Value} Else {$Owner = $Alert.Owner}
                If($Alert.ResolvedBy -eq $null){$ResolvedBy = [System.DBNull]::Value} Else {$ResolvedBy = $Alert.ResolvedBy}
                If($Alert.TimeResolved -eq $null){$TimeResolved = [System.DBNull]::Value} Else {$TimeResolved = $Alert.TimeResolved }
                If($Alert.Context -eq $null){$Context = [System.DBNull]::Value} Else {$Context = $Alert.Context }
            
                If($Alert.CustomField1 -eq $null){$CustomField1 = [System.DBNull]::Value} Else {$CustomField1 = $Alert.CustomField1}
                If($Alert.CustomField2 -eq $null){$CustomField2 = [System.DBNull]::Value} Else {$CustomField2 = $Alert.CustomField2}
                If($Alert.CustomField3 -eq $null){$CustomField3 = [System.DBNull]::Value} Else {$CustomField3 = $Alert.CustomField3}
                If($Alert.CustomField4 -eq $null){$CustomField4 = [System.DBNull]::Value} Else {$CustomField4 = $Alert.CustomField4}
                If($Alert.CustomField5 -eq $null){$CustomField5 = [System.DBNull]::Value} Else {$CustomField5 = $Alert.CustomField5}
                If($Alert.CustomField6 -eq $null){$CustomField6 = [System.DBNull]::Value} Else {$CustomField6 = $Alert.CustomField6}
                If($Alert.CustomField7 -eq $null){$CustomField7 = [System.DBNull]::Value} Else {$CustomField7 = $Alert.CustomField7}
                If($Alert.CustomField8 -eq $null){$CustomField8 = [System.DBNull]::Value} Else {$CustomField8 = $Alert.CustomField8}
                If($Alert.CustomField9 -eq $null){$CustomField9 = [System.DBNull]::Value} Else {$CustomField9 = $Alert.CustomField9}
                If($Alert.CustomField10 -eq $null){$CustomField10 = [System.DBNull]::Value} Else {$CustomField10 = $Alert.CustomField10}

                If($Alert.TicketID -eq $null){$TicketID = [System.DBNull]::Value} Else {$TicketID = $Alert.TicketID}
                If($Alert.ConnectorID -eq $null){$ConnectorID = [System.DBNull]::Value} Else {$ConnectorID = $Alert.ConnectorID}
                If($Alert.TfsWorkItemId -eq $null){$TfsWorkItemId = [System.DBNull]::Value} Else {$TfsWorkItemId = $Alert.TfsWorkItemId}
                If($Alert.TfsWorkItemOwner -eq $null){$TfsWorkItemOwner = [System.DBNull]::Value} Else {$TfsWorkItemOwner = $Alert.TfsWorkItemOwner}


		        $sqlCommand.Parameters["@AlertId"].Value = $Alert.Id
		        $sqlCommand.Parameters["@Name"].Value = $Alert.Name
		        $sqlCommand.Parameters["@Description"].Value = $Alert.Description
		        $sqlCommand.Parameters["@MonitoringObjectId"].Value = $Alert.MonitoringObjectId
		        $sqlCommand.Parameters["@MonitoringClassId"].Value = $Alert.MonitoringClassId
		        $sqlCommand.Parameters["@MonitoringObjectDisplayName"].Value = $Alert.MonitoringObjectDisplayName
		        $sqlCommand.Parameters["@MonitoringObjectName"].Value = $MonitoringObjectName
		        $sqlCommand.Parameters["@MonitoringObjectPath"].Value = $MonitoringObjectPath
		        $sqlCommand.Parameters["@MonitoringObjectFullName"].Value = $Alert.MonitoringObjectFullName
		        $sqlCommand.Parameters["@IsMonitorAlert"].Value = $Alert.IsMonitorAlert
		        $sqlCommand.Parameters["@ProblemId"].Value = $Alert.ProblemId
		        $sqlCommand.Parameters["@MonitoringRuleId"].Value = $Alert.MonitoringRuleId
		        $sqlCommand.Parameters["@ResolutionState"].Value = $Alert.ResolutionState
		        $sqlCommand.Parameters["@ResolutionStateName"].Value = ""
		        $sqlCommand.Parameters["@Priority"].Value = $Alert.Priority
		        $sqlCommand.Parameters["@Severity"].Value = $Alert.Severity
		        $sqlCommand.Parameters["@Category"].Value = $Alert.Category
		        $sqlCommand.Parameters["@Owner"].Value = $Owner
		        $sqlCommand.Parameters["@ResolvedBy"].Value = $ResolvedBy
		        $sqlCommand.Parameters["@TimeRaised"].Value = $Alert.TimeRaised
		        $sqlCommand.Parameters["@TimeAdded"].Value = $Alert.TimeAdded
		        $sqlCommand.Parameters["@LastModified"].Value = $Alert.LastModified
		        $sqlCommand.Parameters["@LastModifiedBy"].Value = $Alert.LastModifiedBy
		        $sqlCommand.Parameters["@TimeResolved"].Value = $TimeResolved
		        $sqlCommand.Parameters["@TimeResolutionStateLastModified"].Value = $Alert.TimeResolutionStateLastModified
		        $sqlCommand.Parameters["@CustomField1"].Value = $CustomField1
		        $sqlCommand.Parameters["@CustomField2"].Value = $CustomField2
		        $sqlCommand.Parameters["@CustomField3"].Value = $CustomField3
		        $sqlCommand.Parameters["@CustomField4"].Value = $CustomField4
		        $sqlCommand.Parameters["@CustomField5"].Value = $CustomField5
		        $sqlCommand.Parameters["@CustomField6"].Value = $CustomField6
		        $sqlCommand.Parameters["@CustomField7"].Value = $CustomField7
		        $sqlCommand.Parameters["@CustomField8"].Value = $CustomField8
		        $sqlCommand.Parameters["@CustomField9"].Value = $CustomField9
		        $sqlCommand.Parameters["@CustomField10"].Value = $CustomField10
		        $sqlCommand.Parameters["@TicketId"].Value = $TicketID
		        $sqlCommand.Parameters["@Context"].Value = $Context
		        $sqlCommand.Parameters["@ConnectorId"].Value = $ConnectorID
		        $sqlCommand.Parameters["@LastModifiedByNonConnector"].Value = $Alert.LastModifiedByNonConnector
		        $sqlCommand.Parameters["@MonitoringObjectInMaintenanceMode"].Value = $Alert.MonitoringObjectInMaintenanceMode
		        $sqlCommand.Parameters["@MaintenanceModeLastModified"].Value = $Alert.MaintenanceModeLastModified
		        $sqlCommand.Parameters["@MonitoringObjectHealthState"].Value = $Alert.MonitoringObjectHealthState
		        $sqlCommand.Parameters["@StateLastModified"].Value = $Alert.StateLastModified
		        $sqlCommand.Parameters["@ConnectorStatus"].Value = $Alert.ConnectorStatus
		        $sqlCommand.Parameters["@TopLevelHostEntityId"].Value = [System.DBNull]::Value
		        $sqlCommand.Parameters["@RepeatCount"].Value = $Alert.RepeatCount
		        $sqlCommand.Parameters["@AlertStringId"].Value = [System.DBNull]::Value
		        $sqlCommand.Parameters["@AlertStringName"].Value = [System.DBNull]::Value
		        $sqlCommand.Parameters["@LanguageCode"].Value = [System.DBNull]::Value
		        $sqlCommand.Parameters["@AlertStringDescription"].Value = [System.DBNull]::Value
		        $sqlCommand.Parameters["@AlertParams"].Value = $Alert.Parameters.ToString()
		        $sqlCommand.Parameters["@SiteName"].Value = [System.DBNull]::Value
		        $sqlCommand.Parameters["@TfsWorkItemId"].Value = $TfsWorkItemId
		        $sqlCommand.Parameters["@TfsWorkItemOwner"].Value = $TfsWorkItemOwner
		        $sqlCommand.Parameters["@HostID"].Value = [System.DBNull]::Value

	            $sqlCommand.Parameters["@Active"].Value = $true
	            $sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow
	            [void]$sqlCommand.ExecuteNonQuery()
                $alertCounter++
            }
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Warning" $moduleName "Update SCOM Alert : $msg" $sqlConnection
			    $warningCounter++
	        }
        }
	
	    $sqlCommand.Dispose()

        ################################################################################
        # SET ALERTS IN DATABASE TO INACTIVE
        ################################################################################
        If($syncType -eq "Full" -and $errorCounter -eq 0){
            Try {
	            $sqlCommand = GetStoredProc $sqlConnection "scom.spAlertInactivateByDate"
                [Void]$sqlCommand.Parameters.Add("@BeforeDate", [system.data.SqlDbType]::datetime)

		        $sqlCommand.Parameters["@BeforeDate"].Value = $timeStart

	            [void]$sqlCommand.ExecuteNonQuery()
                $sqlCommand.Dispose()
            }
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Warning" $moduleName $msg $sqlConnection
			    $warningCounter++
	        }
        }

        ################################################################################
        # DELETE ALERTS FROM DATABASE THAT ARE NO LONGER ACTIVE
        ################################################################################
        #If($syncType -eq "Full") {
        #    Try {
	    #        $sqlCommand = GetStoredProc $sqlConnection "scom.spAlertDeleteInactive"
	    #        [void]$sqlCommand.ExecuteNonQuery()
        #        $sqlCommand.Dispose()
        #    }
        #    Catch [System.Exception] {
		#	    $msg=$_.Exception.Message
		#	    AddLogEntry $ManagementGroup "Warning" $moduleName $msg $sqlConnection
		#	    $warningCounter++
	    #    }
        #}
	
	    AddLogEntry $ManagementGroup "Info" $moduleName "Processed $alertCounter alerts from $ManagementGroup" $sqlConnection

        # Determine Exit status
	    If($errorCounter -gt 0) {$syncStatus = "Error"}
	    ElseIf($warningCounter -gt 0) {$syncStatus = "Warning"}
	    Else {$syncStatus = "Success"}
	
        Return New-Object psobject -Property @{Status = $syncStatus; ObjectCount = $alertCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    } Else {
        Return New-Object psobject -Property @{Status = "Error"; ObjectCount = $alertCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    }
}

#************************************************************************************************************************************
# function WriteSCOMWindowsComputers
#
# Parameters:
# 	$managementServerName
#	$sqlConnection
# 	
# Stored Procedures:
#	scom.spWindowsComputerUpsert
#
# Update SCOM Configuration Information
#************************************************************************************************************************************
function WriteSCOMWindowsComputers {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	$scomManagementGroup,
	[Parameter(Mandatory=$True,Position=2)]
	[ValidateSet("Full","Incremental","None")]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=3)]
    [DateTime]$lastUpdate,
	[Parameter(Mandatory=$False,Position=4)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
    # Initialize error variables
    [int]$errorCounter = 0
    [int]$warningCounter = 0
    [string]$moduleName = "WriteSCOMWindowsComputer"

    [int]$windowsComputerCounter = 0

    # Retrieve SCOM Management Group Information
    [string]$ManagementGroup = $scomManagementGroup["GroupName"]
    [string]$ManagementServer = $scomManagementGroup["ServerName"]

	AddLogEntry $ManagementGroup "Info" $moduleName "Starting $syncType check for WindowsComputer..." $sqlConnection

    ################################################################################
    # CONNECT TO SCOM
    ################################################################################  
    # Check if the OperationsManager Module is loaded
    Import-module OperationsManager
 

    # Connect to localhost when running on the management server or define a server to connect to.
    Try {
        $connect = New-SCOMManagementGroupConnection -ComputerName $managementServer -PassThru
    } 
    Catch [System.Exception] {
		$msg=$_.Exception.Message
		AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
		$errorCounter++
	}

    If($connect.IsActive){
        $lastUpdate=$lastUpdate.ToUniversalTime()

        ################################################################################
        # GET SCOM WINDOWS COMPUTERS
        ################################################################################
        Try {
            $class = Get-SCOMClass -name "Microsoft.Windows.Computer"
            If($syncType -eq "Full"){
                $WindowsComputers = Get-SCOMClassInstance -Class $class
            } Else {
                $WindowsComputers = Get-SCOMClassInstance -Class $class | Where-Object {($_.LastModified -gt $lastUpdate) -or ($_.StateLastModified -gt $lastUpdate) -or ($_.AvailabilityLastModified -gt $lastUpdate)}
            }
        } 
        Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
			    $errorCounter++
	    }
	
        [datetime]$startTime = (Get-Date)

	    $sqlCommand = GetStoredProc $sqlConnection "scom.spWindowsComputerUpsert"
        [Void]$sqlCommand.Parameters.Add("@ID", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@DNSHostName", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@IPAddress", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@ObjectSID", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@NetBIOSDomainName", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@DomainDNSName", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@OrganizationalUnit", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@ForestDNSName", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@ActiveDirectorySite", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@IsVirtualMachine", [system.data.SqlDbType]::bit)
        [Void]$sqlCommand.Parameters.Add("@HealthState", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@StateLastModified", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@IsAvailable", [system.data.SqlDbType]::bit)
        [Void]$sqlCommand.Parameters.Add("@AvailabilityLastModified", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@InMaintenanceMode", [system.data.SqlDbType]::bit)
        [Void]$sqlCommand.Parameters.Add("@MaintenanceModeLastModified", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@ManagementGroup", [system.data.SqlDbType]::nvarchar)

        [Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
        [Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime2)

	
        foreach($WindowsComputer in $WindowsComputers){
            $IsVirtualNode = $WindowsComputer | select -ExpandProperty *.IsVirtualNode
            # Write-Host $WindowsComputer.DisplayName : $IsVirtualNode.Value
            If($IsVirtualNode.Value -eq $null){
                Try {
	                [datetime]$timeNow = (Get-Date)
                    If($WindowsComputer.MaintenanceModeLastModified -eq $null){$MaintenanceModeLastModified = [System.DBNull]::Value} Else {$MaintenanceModeLastModified = $WindowsComputer.MaintenanceModeLastModified}
                    $DNSHostName = $WindowsComputer | select -ExpandProperty *.DNSName
                    $IpAddress = $WindowsComputer | select -ExpandProperty *.IpAddress
                    $ActiveDirectoryObjectSid = $WindowsComputer | select -ExpandProperty *.ActiveDirectoryObjectSid
                    $NetbiosDomainName = $WindowsComputer | select -ExpandProperty *.NetbiosDomainName
                    $DomainDNSName = $WindowsComputer | select -ExpandProperty *.DomainDNSName
                    $OrganizationalUnit = $WindowsComputer | select -ExpandProperty *.OrganizationalUnit
                    $ForestDNSName = $WindowsComputer | select -ExpandProperty *.ForestDNSName
                    $ActiveDirectorySite = $WindowsComputer | select -ExpandProperty *.ActiveDirectorySite
                    $IsVirtualMachine = $WindowsComputer | select -ExpandProperty *.IsVirtualMachine
                    If($ActiveDirectoryObjectSid.Value -eq $null){$ObjectSid = [System.DBNull]::Value} Else {$ObjectSid = $ActiveDirectoryObjectSid.Value }

                    $sqlCommand.Parameters["@ID"].Value = $WindowsComputer.Id
                    $sqlCommand.Parameters["@DNSHostName"].Value = $WindowsComputer.DisplayName
                    $sqlCommand.Parameters["@IPAddress"].Value = $IpAddress.Value
                    $sqlCommand.Parameters["@ObjectSID"].Value = $ObjectSid
                    $sqlCommand.Parameters["@NetBIOSDomainName"].Value = $NetbiosDomainName.Value
                    $sqlCommand.Parameters["@DomainDNSName"].Value = $DomainDNSName.Value
                    $sqlCommand.Parameters["@OrganizationalUnit"].Value = $OrganizationalUnit.Value
                    $sqlCommand.Parameters["@ForestDNSName"].Value = $ForestDNSName.Value
                    $sqlCommand.Parameters["@ActiveDirectorySite"].Value = $ActiveDirectorySite.Value
                    $sqlCommand.Parameters["@IsVirtualMachine"].Value = $IsVirtualMachine.Value
                    $sqlCommand.Parameters["@HealthState"].Value = $WindowsComputer.HealthState.ToString()
                    $sqlCommand.Parameters["@StateLastModified"].Value = $WindowsComputer.StateLastModified
                    $sqlCommand.Parameters["@IsAvailable"].Value = $WindowsComputer.IsAvailable
                    $sqlCommand.Parameters["@AvailabilityLastModified"].Value = $WindowsComputer.AvailabilityLastModified
                    $sqlCommand.Parameters["@InMaintenanceMode"].Value = $WindowsComputer.InMaintenanceMode
                    $sqlCommand.Parameters["@MaintenanceModeLastModified"].Value = $MaintenanceModeLastModified
                    $sqlCommand.Parameters["@ManagementGroup"].Value = $WindowsComputer.ManagementGroup.ToString()

                    $sqlCommand.Parameters["@Active"].Value = $True
                    $sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow

	                [void]$sqlCommand.ExecuteNonQuery()
                    $windowsComputerCounter++
                } 
                Catch [System.Exception] {
			        $msg=$_.Exception.Message
			        AddLogEntry $ManagementGroup "Warning" $moduleName "($WindowsComputer.DisplayName) : $msg" $sqlConnection
			        $warningCounter++
	            }
            }
        }
	
	    $sqlCommand.Dispose()

        ############################################################################################################
        # IF FULL SYNC, INACTIVATE OBJECTS THAT WERE NOT UPDATED
        ############################################################################################################
        If($syncType -eq "Full"){
            Try {
	            $sqlCommand = GetStoredProc $sqlConnection "scom.spWindowsComputerInactivateByDate"
                [Void]$sqlCommand.Parameters.Add("@BeforeDate", [system.data.SqlDbType]::datetime)

                $sqlCommand.Parameters["@BeforeDate"].Value = $startTime
                [void]$sqlCommand.ExecuteNonQuery()
                $sqlCommand.Dispose()
            }
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Warning" $moduleName "Inactivate Windows Computers : $msg" $sqlConnection
			    $errorCounter++
	        }

        }

        ############################################################################################################
        # EXECUTE STORED PROC FOR AGENT EXCLUSIONS
        ############################################################################################################
        Try {
	        $sqlCommand = GetStoredProc $sqlConnection "scom.spAgentExclusionsInsert"

            [void]$sqlCommand.ExecuteNonQuery()
            $sqlCommand.Dispose()
        }
        Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $ManagementGroup "Info" $moduleName "Agent Exclusions Insert : $msg" $sqlConnection
			$errorCounter++
	    }
	
	    AddLogEntry $ManagementGroup "Info" $moduleName "Retrieved $windowsComputerCounter Windows Computers from $ManagementGroup" $sqlConnection

        # Determine Exit status
	    If($errorCounter -gt 0) {$syncStatus = "Error"}
	    ElseIf($warningCounter -gt 0) {$syncStatus = "Warning"}
	    Else {$syncStatus = "Success"}
	
	    Return New-Object psobject -Property @{Status = $syncStatus; ObjectCount = $windowsComputerCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    } Else {
        Return New-Object psobject -Property @{Status = "Error"; ObjectCount = $windowsComputerCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    }
}

#************************************************************************************************************************************
# function GetObjectState
#
# Parameters:
# 	$monitoringHierarchy
# 	
# Stored Procedures:
#	None
#
# Retrieve top-level entity health (Availability, Configuration, Performance, Security
#************************************************************************************************************************************
function GetObjectState {
	[CmdletBinding()]
	param (
		[Parameter(Position=0,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
		[PSObject] $MonitoringHierarchy
	)

    # Initialize String Values
    [string]$Availability = "NoValue"
    [string]$Configuration = "NoValue"
    [string]$Performance = "NoValue"
    [string]$Security = "NoValue"
    [string]$Other = "NoValue"

    foreach ($Node in $MonitoringHierarchy) {
		# Only work on nodes that have something in them
		if ($Node){
			
			# Sort the child nodes in alphabetical order
			$SortedChildNodes = $Node.ChildNodes | Sort-Object -Property Item
			
			# loop through the child node retrieve health state for the main rollup items (Availability, Configuration, Performance and Security)
			foreach ($ChildNode in $SortedChildNodes){
                switch($ChildNode.Item.MonitorDisplayName){
                    "Availability" {[string]$Availability = $ChildNode.Item.HealthState}
                    "Configuration" {[string]$Configuration = $ChildNode.Item.HealthState}
                    "Performance" {[string]$Performance = $ChildNode.Item.HealthState}
                    "Security" {[string]$Security = $ChildNode.Item.HealthState}
                    "Default" {[string]$Other = $ChildNode.Item.HealthState}
                }
			}
		}
	}

    Return New-Object psobject -Property @{Availability = $Availability; Configuration = $Configuration; Performance = $Performance; Security = $Security; Other = $Other}
}


#************************************************************************************************************************************
# function WriteSCOMObjects
#
# Parameters:
# 	$managementServerName
#	$sqlConnection
# 	
# Stored Procedures:
#	scom.spObjectHealthStateUpsert
#
# Update SCOM Object Information for specified class
#************************************************************************************************************************************
function WriteSCOMObjects {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	$scomManagementGroup,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$objectClass,
	[Parameter(Mandatory=$True,Position=3)]
	[string]$genericClass,
	[Parameter(Mandatory=$True,Position=4)]
	[string]$distributedApplication,
	[Parameter(Mandatory=$True,Position=5)]
	[ValidateSet("Full","Incremental","None")]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=6)]
    [DateTime]$lastUpdate,
	[Parameter(Mandatory=$False,Position=7)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
    # Initialize error variables
    [int]$errorCounter = 0
    [int]$warningCounter = 0
    [string]$moduleName = "WriteSCOMObjects"

    [int]$objectCounter = 0

    # TODO: Validate that the ObjectClass exists in SCOM and in SCORE

    # Retrieve SCOM Management Group Information
    [string]$ManagementGroup = $scomManagementGroup["GroupName"]
    [string]$ManagementServer = $scomManagementGroup["ServerName"]

	AddLogEntry $ManagementGroup "Info" $moduleName "Starting $syncType check for $objectClass..." $sqlConnection

    ################################################################################
    # CONNECT TO SCOM
    ################################################################################  
    Try {
        $connect = New-SCOMManagementGroupConnection -ComputerName $managementServer -PassThru
    } 
    Catch [System.Exception] {
		$msg=$_.Exception.Message
		AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
		$errorCounter++
	}

    If($connect.IsActive){
        $lastUpdate = $lastUpdate.ToUniversalTime()

        ################################################################################
        # GET SCOM OBJECT OF THE SPECIFIED CLASS
        ################################################################################
        Try {
            $class = Get-SCOMClass -name $objectClass

			[datetime]$timeNow = (Get-Date)

			$sqlCommand = GetStoredProc $sqlConnection "scom.spObjectClassUpsert"
			[Void]$sqlCommand.Parameters.Add("@ID", [system.data.SqlDbType]::uniqueidentifier)
			[Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
			[Void]$sqlCommand.Parameters.Add("@DisplayName", [system.data.SqlDbType]::nvarchar)
			[Void]$sqlCommand.Parameters.Add("@GenericName", [system.data.SqlDbType]::nvarchar)
			[Void]$sqlCommand.Parameters.Add("@ManagementPackName", [system.data.SqlDbType]::nvarchar)
			[Void]$sqlCommand.Parameters.Add("@Description", [system.data.SqlDbType]::nvarchar)
			[Void]$sqlCommand.Parameters.Add("@DistributedApplication", [system.data.SqlDbType]::nvarchar)

			[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
			[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime2)


			If($distributedApplication -eq "True"){$distApp = 1} Else {$distApp = 0}
            $sqlCommand.Parameters["@ID"].Value = $class.Id
            $sqlCommand.Parameters["@Name"].Value = NullToString $class.Name ""
            $sqlCommand.Parameters["@DisplayName"].Value = NullToString $class.DisplayName ""
            $sqlCommand.Parameters["@GenericName"].Value = $genericClass
            $sqlCommand.Parameters["@ManagementPackName"].Value = NullToString $class.ManagementPackName ""
            $sqlCommand.Parameters["@Description"].Value = NullToString $class.DisplayName ""
            $sqlCommand.Parameters["@DistributedApplication"].Value = $distApp

            $sqlCommand.Parameters["@Active"].Value = $True
            $sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow
	                
			[void]$sqlCommand.ExecuteNonQuery()

			################################################################################
			# WRITE TO OBJECTCLASS
			################################################################################
            If($syncType -eq "Full"){
                $Objects = Get-SCOMClassInstance -Class $class
            } Else {
                $Objects = Get-SCOMClassInstance -Class $class | Where-Object {($_.LastModified -gt $lastUpdate) -or ($_.StateLastModified -gt $lastUpdate) -or ($_.AvailabilityLastModified -gt $lastUpdate)}
            }
        } 
        Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
			    $errorCounter++
	    }
	
        [datetime]$startTime = (Get-Date)

	    $sqlCommand = GetStoredProc $sqlConnection "scom.spObjectHealthStateUpsert"
        [Void]$sqlCommand.Parameters.Add("@ID", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@DisplayName", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@FullName", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@Path", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@ObjectClass", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@HealthState", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@StateLastModified", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@IsAvailable", [system.data.SqlDbType]::bit)
        [Void]$sqlCommand.Parameters.Add("@AvailabilityLastModified", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@InMaintenanceMode", [system.data.SqlDbType]::bit)
        [Void]$sqlCommand.Parameters.Add("@MaintenanceModeLastModified", [system.data.SqlDbType]::datetime2)
        [Void]$sqlCommand.Parameters.Add("@ManagementGroup", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@Availability", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@Configuration", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@Performance", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@Security", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@Other", [system.data.SqlDbType]::nvarchar)

        [Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
        [Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime2)


	    $sqlCommand2 = GetStoredProc $sqlConnection "scom.spObjectHealthStateAlertRelationshipUpsert"
        [Void]$sqlCommand2.Parameters.Add("@ObjectID", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand2.Parameters.Add("@AlertID", [system.data.SqlDbType]::uniqueidentifier)
	
        foreach($Object in $Objects){
            # If($Object.HealthState.ToString() -ne "Uninitialized" -and $Object.InMaintenanceMode -eq 0){
            # Try to skip over Windows Server Virtual Nodes
            $IsVirtualNode = $null
            [bool]$skipObject = $null
            Try{
                # Check to see if the Windows computer property *.IsVirtualNode exists
                $hasVirtualNodeMember = $Object | Get-Member -name *.IsVirtualNode
                If($hasVirtualNodeMember -ne $null){
                    # Write-Host $object.DisplayName
                    $IsVirtualNode = $Object | select -ExpandProperty *.IsVirtualNode
                    if($IsVirtualNode.Value -eq "True"){
                        # This is a virtual Node; we want to skip this
                        $skipObject = $true
                    } Else {
                        # This is not a virtual Node; we want this
                        $skipObject = $false
                    }
                } Else {
                    # If the property is missing, it's not a virtual node
                    $skipObject = $false
                }
            } Catch {
                # By default, we want to capture the object, so if there's an error, let's get it
                $skipObject = $False
                $Error.Clear()
            }
            If(!$skipObject){
                Try {

                    [datetime]$timeNow = (Get-Date)
                    If($Object.MaintenanceModeLastModified -eq $null){$MaintenanceModeLastModified = [System.DBNull]::Value} Else {$MaintenanceModeLastModified = $Object.MaintenanceModeLastModified}

                    
                    $ObjectState = GetObjectState -MonitoringHierarchy $object.GetMonitoringStateHierarchy() 

                    $sqlCommand.Parameters["@ID"].Value = $Object.Id
                    $sqlCommand.Parameters["@Name"].Value = NullToString $Object.Name ""
                    $sqlCommand.Parameters["@DisplayName"].Value = $Object.DisplayName
                    $sqlCommand.Parameters["@FullName"].Value = $Object.FullName
                    $sqlCommand.Parameters["@Path"].Value = NullToString $Object.Path ""
                    $sqlCommand.Parameters["@ObjectClass"].Value = $objectClass
                    $sqlCommand.Parameters["@HealthState"].Value = $Object.HealthState.ToString()
                    $sqlCommand.Parameters["@StateLastModified"].Value = $Object.StateLastModified
                    $sqlCommand.Parameters["@IsAvailable"].Value = $Object.IsAvailable
                    $sqlCommand.Parameters["@AvailabilityLastModified"].Value = $Object.AvailabilityLastModified
                    $sqlCommand.Parameters["@InMaintenanceMode"].Value = $Object.InMaintenanceMode
                    $sqlCommand.Parameters["@MaintenanceModeLastModified"].Value = $MaintenanceModeLastModified
                    $sqlCommand.Parameters["@ManagementGroup"].Value = $Object.ManagementGroup.ToString()
                    $sqlCommand.Parameters["@Availability"].Value = $ObjectState.Availability
                    $sqlCommand.Parameters["@Configuration"].Value = $ObjectState.Configuration
                    $sqlCommand.Parameters["@Performance"].Value = $ObjectState.Performance
                    $sqlCommand.Parameters["@Security"].Value = $ObjectState.Security
                    $sqlCommand.Parameters["@Other"].Value = $ObjectState.Other

                    $sqlCommand.Parameters["@Active"].Value = $True
                    $sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow

	                [void]$sqlCommand.ExecuteNonQuery()
                    $objectCounter++

                    #### GET RELATED ALERTS FOR OBJECT ####
                    If($Object.HealthState.ToString() -ne "Success") {
                        $relatedAlerts = $Object.GetMonitoringAlerts(1)
                        foreach($relatedAlert in $relatedAlerts){
                            # $sqlCommand2.Parameters["@ObjectId"].Value = $relatedAlert.MonitoringObjectID
                            $sqlCommand2.Parameters["@ObjectId"].Value = $object.Id
                            $sqlCommand2.Parameters["@AlertID"].Value = $relatedAlert.Id

                            [void]$sqlCommand2.ExecuteNonQuery()
                        }
                    }
                } 
                Catch [System.Exception] {
			        $msg=$_.Exception.Message
			        AddLogEntry $ManagementGroup "Warning" $moduleName "($Object.FullName) : $msg" $sqlConnection
			        $warningCounter++
	            }
            } 
        }


	    $sqlCommand.Dispose()
        $sqlCommand2.Dispose()

        ############################################################################################################
        # IF FULL SYNC, INACTIVATE OBJECTS THAT WERE NOT UPDATED
        ############################################################################################################
        If($syncType -eq "Full"){
            Try {
	            $sqlCommand = GetStoredProc $sqlConnection "scom.spObjectHealthStateInactivateByDate"
                [Void]$sqlCommand.Parameters.Add("@BeforeDate", [system.data.SqlDbType]::datetime)
                [Void]$sqlCommand.Parameters.Add("@ObjectClass", [system.data.SqlDbType]::nvarchar)

                $sqlCommand.Parameters["@BeforeDate"].Value = $startTime
                $sqlCommand.Parameters["@ObjectClass"].Value = $objectClass
                [void]$sqlCommand.ExecuteNonQuery()
                $sqlCommand.Dispose()

            }
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Warning" $moduleName "Inactivate Object : $msg" $sqlConnection
			    $errorCounter++
	        }

        }

        Try {
            ############################################################################################################
            # INACTIVATE ROWS IN OBJECTALERTRELATIONSHIP
            ############################################################################################################
            $sqlCommand.Dispose()

            $sqlCommand = GetStoredProc $sqlConnection "scom.spObjectHealthStateAlertRelationshipInactivate"

            [void]$sqlCommand.ExecuteNonQuery() 
            $sqlCommand.Dispose()
        }
        Catch [System.Exception] {
            $msg=$_.Exception.Message
            AddLogEntry $ManagementGroup "Warning" $moduleName "Object Alert Relationship Inactivate : $msg" $sqlConnection
            $errorCounter++
        }                     
	
	    AddLogEntry $ManagementGroup "Info" $moduleName "Retrieved $objectCounter $objectClass from $ManagementGroup" $sqlConnection

        # Determine Exit status
	    If($errorCounter -gt 0) {$syncStatus = "Error"}
	    ElseIf($warningCounter -gt 0) {$syncStatus = "Warning"}
	    Else {$syncStatus = "Success"}
	
	    Return New-Object psobject -Property @{Status = $syncStatus; ObjectCount = $objectCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    } Else {
        Return New-Object psobject -Property @{Status = "Error"; ObjectCount = $objectCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    }
}


#************************************************************************************************************************************
# function WriteSCOMGroup
#
# Parameters:
#   #managementGroup
# 	$groupName
#   $syncType
#   $lastUpdate
#	$sqlConnection
# 	
# Stored Procedures:
#	scom.spGroupHealthStateUpsert
#
# Update SCOM Object Information for specified class
#************************************************************************************************************************************
function WriteSCOMGroup {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	$scomManagementGroup,
	[Parameter(Mandatory=$True,Position=2)]
	$groupName,
	[Parameter(Mandatory=$True,Position=3)]
	[ValidateSet("Full","Incremental","None")]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=4)]
    [DateTime]$lastUpdate,
	[Parameter(Mandatory=$False,Position=5)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
    # Initialize error variables
    [int]$errorCounter = 0
    [int]$warningCounter = 0
    [string]$moduleName = "WriteSCOMGroup"

    [int]$groupCounter = 0

    # TODO: Validate that the Group exists in SCOM and in SCORE

    # Retrieve SCOM Management Group Information
    [string]$ManagementGroup = $scomManagementGroup["GroupName"]
    [string]$ManagementServer = $scomManagementGroup["ServerName"]

	AddLogEntry $ManagementGroup "Info" $moduleName "Starting $syncType check for Groups..." $sqlConnection

    ################################################################################
    # CONNECT TO SCOM
    ################################################################################  
    Try {
        $connect = New-SCOMManagementGroupConnection -ComputerName $managementServer -PassThru
    } 
    Catch [System.Exception] {
		$msg=$_.Exception.Message
		AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
		$errorCounter++
	}

    If($connect.IsActive){
        $lastUpdate = $lastUpdate.ToUniversalTime()

        ################################################################################
        # GET SCOM GROUP
        ################################################################################
        Try {
            # $class = Get-SCOMClass -name $objectClass
            If($syncType -eq "Full"){
                $Group = Get-SCOMGroup | Where-Object {$_.DisplayName -eq $groupName}
            } Else {
                $Group = Get-SCOMGroup | Where-Object {($_.DisplayName -eq $groupName) -and (($_.LastModified -gt $lastUpdate) -or ($_.StateLastModified -gt $lastUpdate) -or ($_.AvailabilityLastModified -gt $lastUpdate))}
            }
        } 
        Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
			    $errorCounter++
	    }

        ################################################################################
        # TEST IF THE RESULT IS NULL (NO GROUP WITH THAT NAME)
        ################################################################################        
	    
        If($Group){
            [datetime]$startTime = (Get-Date)

	        $sqlCommand = GetStoredProc $sqlConnection "scom.spGroupHealthStateUpsert"
            [Void]$sqlCommand.Parameters.Add("@ID", [system.data.SqlDbType]::uniqueidentifier)
            [Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@DisplayName", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@FullName", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@Path", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@MonitoringClassIds", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@HealthState", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@StateLastModified", [system.data.SqlDbType]::datetime2)
            [Void]$sqlCommand.Parameters.Add("@IsAvailable", [system.data.SqlDbType]::bit)
            [Void]$sqlCommand.Parameters.Add("@AvailabilityLastModified", [system.data.SqlDbType]::datetime2)
            [Void]$sqlCommand.Parameters.Add("@InMaintenanceMode", [system.data.SqlDbType]::bit)
            [Void]$sqlCommand.Parameters.Add("@MaintenanceModeLastModified", [system.data.SqlDbType]::datetime2)
            [Void]$sqlCommand.Parameters.Add("@ManagementGroup", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@Availability", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@Configuration", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@Performance", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@Security", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@Other", [system.data.SqlDbType]::nvarchar)

            [Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
            [Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime2)


	        $sqlCommand2 = GetStoredProc $sqlConnection "scom.spGroupHealthStateAlertRelationshipUpsert"
            [Void]$sqlCommand2.Parameters.Add("@GroupID", [system.data.SqlDbType]::uniqueidentifier)
            [Void]$sqlCommand2.Parameters.Add("@AlertID", [system.data.SqlDbType]::uniqueidentifier)
	
            Try {

			    # Set Current Timestamp
                [datetime]$timeNow = (Get-Date)

			    # Handle null value for MaintenModeLastModified
                Try {
                    If($Group.MaintenanceModeLastModified -eq $null){$MaintenanceModeLastModified = [System.DBNull]::Value} Else {$MaintenanceModeLastModified = $Group.MaintenanceModeLastModified}
                }
                Catch {
                    $MaintenanceModeLastModified = [System.DBNull]::Value
                }
			    # Handle ReadOnlyCollection for MonitoringClassIds
			    [string]$tmpValue=""
                ForEach($value in $Group.MonitoringClassIds){
                    $tmpValue = $value.guid + ", "
                }
                $tmpValue = $tmpValue.Substring(0,$tmpValue.Length -2)
                    
                $GroupState = GetObjectState -MonitoringHierarchy $Group.GetMonitoringStateHierarchy() 

                $sqlCommand.Parameters["@ID"].Value = $Group.Id
                $sqlCommand.Parameters["@Name"].Value = NullToString $Group.Name ""
                $sqlCommand.Parameters["@DisplayName"].Value = $Group.DisplayName
                $sqlCommand.Parameters["@FullName"].Value = $Group.FullName
                $sqlCommand.Parameters["@Path"].Value = NullToString $Group.Path ""
                $sqlCommand.Parameters["@MonitoringClassIds"].Value = $tmpValue
                $sqlCommand.Parameters["@HealthState"].Value = $Group.HealthState.ToString()
                $sqlCommand.Parameters["@StateLastModified"].Value = $Group.StateLastModified
                $sqlCommand.Parameters["@IsAvailable"].Value = $Group.IsAvailable
                $sqlCommand.Parameters["@AvailabilityLastModified"].Value = $Group.AvailabilityLastModified
                $sqlCommand.Parameters["@InMaintenanceMode"].Value = $Group.InMaintenanceMode
                $sqlCommand.Parameters["@MaintenanceModeLastModified"].Value = $MaintenanceModeLastModified
                $sqlCommand.Parameters["@ManagementGroup"].Value = $Group.ManagementGroup.ToString()
                $sqlCommand.Parameters["@Availability"].Value = $GroupState.Availability
                $sqlCommand.Parameters["@Configuration"].Value = $GroupState.Configuration
                $sqlCommand.Parameters["@Performance"].Value = $GroupState.Performance
                $sqlCommand.Parameters["@Security"].Value = $GroupState.Security
                $sqlCommand.Parameters["@Other"].Value = $GroupState.Other

                $sqlCommand.Parameters["@Active"].Value = $True
                $sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow

	            [void]$sqlCommand.ExecuteNonQuery()
                $groupCounter++

                #### GET RELATED ALERTS FOR OBJECT ####
                If($Group.HealthState.ToString() -ne "Success") {
                    $relatedAlerts = $Group.GetMonitoringAlerts(1)
                    foreach($relatedAlert in $relatedAlerts){
                        # $sqlCommand2.Parameters["@ObjectId"].Value = $relatedAlert.MonitoringObjectID
                        $sqlCommand2.Parameters["@GroupId"].Value = $Group.Id
                        $sqlCommand2.Parameters["@AlertID"].Value = $relatedAlert.Id

                        [void]$sqlCommand2.ExecuteNonQuery()
                    }
                }
            } 
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Warning" $moduleName "($groupName) : $msg" $sqlConnection
			    $warningCounter++
	        }

	        $sqlCommand.Dispose()
            $sqlCommand2.Dispose()
        } 
        Else
        {
            $msg = "Group $GroupName does not exist."
	        AddLogEntry $ManagementGroup "Error" $moduleName $msg $sqlConnection
            $errorCounter++
        }

        ############################################################################################################
        # IF FULL SYNC, INACTIVATE GROUP THAT WERE NOT UPDATED
        ############################################################################################################
        If($syncType -eq "Full"){
            Try {
	            $sqlCommand = GetStoredProc $sqlConnection "scom.spGroupHealthStateInactivateByDate"
                [Void]$sqlCommand.Parameters.Add("@BeforeDate", [system.data.SqlDbType]::datetime)
                # [Void]$sqlCommand.Parameters.Add("@ObjectClass", [system.data.SqlDbType]::nvarchar)

                $sqlCommand.Parameters["@BeforeDate"].Value = $startTime
                # $sqlCommand.Parameters["@ObjectClass"].Value = $objectClass
                [void]$sqlCommand.ExecuteNonQuery()
                $sqlCommand.Dispose()

            }
            Catch [System.Exception] {
			    $msg=$_.Exception.Message
			    AddLogEntry $ManagementGroup "Warning" $moduleName "Inactivate Object : $msg" $sqlConnection
			    $errorCounter++
	        }

        }

        Try {
            ############################################################################################################
            # INACTIVATE ROWS IN GROUPALERTRELATIONSHIP
            ############################################################################################################
            $sqlCommand.Dispose()

            $sqlCommand = GetStoredProc $sqlConnection "scom.spGroupHealthStateAlertRelationshipInactivate"

            [void]$sqlCommand.ExecuteNonQuery() 
            $sqlCommand.Dispose()
        }
        Catch [System.Exception] {
            $msg=$_.Exception.Message
            AddLogEntry $ManagementGroup "Warning" $moduleName "Group Alert Relationship Inactivate : $msg" $sqlConnection
            $errorCounter++
        }                     
	
	    AddLogEntry $ManagementGroup "Info" $moduleName "Retrieved $groupCounter groups from $ManagementGroup" $sqlConnection

        # Determine Exit status
	    If($errorCounter -gt 0) {$syncStatus = "Error"}
	    ElseIf($warningCounter -gt 0) {$syncStatus = "Warning"}
	    Else {$syncStatus = "Success"}
	
	    Return New-Object psobject -Property @{Status = $syncStatus; ObjectCount = $groupCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    } Else {
        Return New-Object psobject -Property @{Status = "Error"; ObjectCount = $groupCounter; ErrorCount = $errorCounter; WarningCount = $warningCounter}
    }
}

################################################################################
# SET STRICT MODE
################################################################################
Set-StrictMode -Version "Latest"

################################################################################
# DOT SOURCE MonitorFunctions MODULE
################################################################################

# Set current location
[string]$shellFolder = Split-Path $MyInvocation.MyCommand.Path

# Change path to working folder
Set-Location $shellFolder	

. ".\modules\MonitorFunctions.ps1"

################################################################################
# CONSTANT DECLARATIONS
################################################################################
Set-Variable CONFIG_FILE -Scope "Global" -Value ".\app.monitor.config"

################################################################################
# VARIABLE DECLARATIONS
################################################################################
[int]$errorCounter = 0
[int]$warningCounter = 0

################################################################################
# LOAD APPLICATION CONFIGURATION FILE
################################################################################
If(Test-Path $global:CONFIG_FILE){
	Try {
		[xml]$appConfig = Get-Content $global:CONFIG_FILE
	} Catch {
		Throw "Unable to process XML in configuration file!"
	}
} Else {
	Throw "Unable to load config file!"
}

################################################################################
# BEGIN MAIN PORTION OF SCRIPT
################################################################################
Write-Host "****** Starting process ******"
Write-Host "Mgmt Group : $managementGroup"
Write-Host "Objects    : $ObjectClasses"
Write-Host "SyncType   : $SyncType"
Write-Host "******************************"

################################################################################
# ESTABLISH CONNECTION TO CENTRAL REPOSITORY 
################################################################################
[string]$sqlConnectionString = $appConfig.configuration.connectionstrings.centralrepository.connectionstring
[System.Data.SqlClient.SqlConnection]$sqlConnection = GetSQLConnection -sqlConnectionString $sqlConnectionString

# Check connection to repository
If ($sqlConnection.State -ne "Open")	{
	Throw "Unable to open central repository database.  Application terminating."
}

################################################################################
# RETRIEVE SCOM MANAGEMENT GROUP CONNECTION INFO
################################################################################
$temp = $appConfig.SelectSingleNode("//configuration/servers/ManagementGroup[@name='$managementGroup']")
$scomManagementGroup = @{"GroupName" = $temp.name; "ServerName" = $temp.server}
#[string]$managementServerName = $appConfig.configuration.connectionstrings.ManagementServer.name

foreach ($objectClass in $ObjectClasses){
    $objectClass = $objectClass.ToLower()

	Switch ($objectClass) {
		"agent" 		{
                            # Retrieve last SyncStatus
	                        $lastSyncStatus = GetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -sqlConnection $sqlConnection
                            $thisSyncType = GetSyncType $lastSyncStatus $syncType

                            # Update scom.SyncStatus to indicate a sync is starting
	                        [datetime]$startDate = (Get-Date)
                            SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -SyncType $thisSyncType.SyncType -startDate $startDate -syncStatus "Starting..." -sqlConnection $sqlConnection

							$result = WriteSCOMAgentInfo -scomManagementGroup $scomManagementGroup -syncType $thisSyncType.syncType  -lastupdate $thisSyncType.lastUpdate -sqlConnection $sqlConnection
                            $scomObjects = $result.ObjectCount
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
                            Write-Host "$scomObjects agents processed."

                            [datetime]$endDate = (Get-Date)

	                        # Update scom.SyncStatus to indicate a sync is completed
	                        [string]$syncStatus = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $result.Status, $result.ObjectCount, $result.ErrorCount, $result.WarningCount
	                        SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -SyncType $thisSyncType.syncType -startDate $startDate -endDate $endDate -objectCount $result.ObjectCount -syncStatus $syncStatus -sqlConnection $sqlConnection

						}
		"config" 		{
                            # Retrieve last SyncStatus
	                        $lastSyncStatus = GetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -sqlConnection $sqlConnection
                            $thisSyncType = GetSyncType $lastSyncStatus $syncType

                            # Update scom.SyncStatus to indicate a sync is starting
	                        [datetime]$startDate = (Get-Date)
                            SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -SyncType $thisSyncType.SyncType -startDate $startDate -syncStatus "Starting..." -sqlConnection $sqlConnection

							$result = WriteSCOMConfig -scomManagementGroup $scomManagementGroup -syncType "Full" -lastupdate $thisSyncType.lastUpdate -sqlConnection $sqlConnection
                            $scomObjects = $result.ObjectCount
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
                            Write-Host "$scomObjects configuration items processed."

                            [datetime]$endDate = (Get-Date)

	                        # Update scom.SyncStatus to indicate a sync is completed
	                        [string]$syncStatus = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $result.Status, $result.ObjectCount, $result.ErrorCount, $result.WarningCount
	                        SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -SyncType "Full" -startDate $startDate -endDate $endDate -objectCount $result.ObjectCount -syncStatus $syncStatus -sqlConnection $sqlConnection

						}
		"alert" 		{
                            # Retrieve last SyncStatus
	                        $lastSyncStatus = GetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -sqlConnection $sqlConnection
                            $thisSyncType = GetSyncType $lastSyncStatus $syncType

                            # Update scom.SyncStatus to indicate a sync is starting
	                        [datetime]$startDate = (Get-Date)
                            SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -SyncType $thisSyncType.SyncType -startDate $startDate -syncStatus "Starting..." -sqlConnection $sqlConnection

							$result = WriteSCOMAlerts -scomManagementGroup $scomManagementGroup -syncType $thisSyncType.syncType  -lastupdate $thisSyncType.LastUpdate -sqlConnection $sqlConnection
                            $scomObjects = $result.ObjectCount
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
                            Write-Host "$scomObjects alerts processed."

                            [datetime]$endDate = (Get-Date)

	                        # Update scom.SyncStatus to indicate a sync is completed
	                        [string]$syncStatus = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $result.Status, $result.ObjectCount, $result.ErrorCount, $result.WarningCount
	                        SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -SyncType $thisSyncType.syncType -startDate $startDate -endDate $endDate -objectCount $result.ObjectCount -syncStatus $syncStatus -sqlConnection $sqlConnection

						}
		"WindowsComputer" 		{
                            # Retrieve last SyncStatus
	                        $lastSyncStatus = GetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -sqlConnection $sqlConnection
                            $thisSyncType = GetSyncType $lastSyncStatus $syncType

                            # Update scom.SyncStatus to indicate a sync is starting
	                        [datetime]$startDate = (Get-Date)
                            SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -SyncType $thisSyncType.SyncType -startDate $startDate -syncStatus "Starting..." -sqlConnection $sqlConnection

							$result = WriteSCOMWindowsComputers -scomManagementGroup $scomManagementGroup -syncType $thisSyncType.SyncType  -lastupdate $thisSyncType.LastUpdate -sqlConnection $sqlConnection
                            $scomObjects = $result.ObjectCount
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
                            Write-Host "$scomObjects Windows Computers processed."

                            [datetime]$endDate = (Get-Date)

	                        # Update scom.SyncStatus to indicate a sync is completed
	                        [string]$syncStatus = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $result.Status, $result.ObjectCount, $result.ErrorCount, $result.WarningCount
	                        SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -SyncType $thisSyncType.SyncType -startDate $startDate -endDate $endDate -objectCount $result.ObjectCount -syncStatus $syncStatus -sqlConnection $sqlConnection

						}
		"TimeZone" 		{

                            # Update scom.SyncStatus to indicate a sync is starting
	                        [datetime]$startDate = (Get-Date)
                            SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -SyncType "Full" -startDate $startDate -syncStatus "Starting..." -sqlConnection $sqlConnection

							$result = WriteTimeZone -sqlConnection $sqlConnection
                            $scomObjects = $result.ObjectCount
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
                            Write-Host "$scomObjects Time Zones processed."

	                        # Update scom.SyncStatus to indicate a sync is completed
                            [datetime]$endDate = (Get-Date)
                            [string]$syncStatus = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $result.Status, $result.ObjectCount, $result.ErrorCount, $result.WarningCount
	                        SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $objectClass -SyncType "Full" -startDate $startDate -endDate $endDate -objectCount $result.ObjectCount -syncStatus $syncStatus -sqlConnection $sqlConnection

						}
		"Generic" 	{
                            $Classes=$appConfig.SelectNodes("/configuration/ObjectClasses/ObjectClass[@active='True']")
                            foreach($Class in $Classes){
                                $className = $class.name
								$distributedApplication = $class.DistributedApplication
								$genericClass = $class.genericClass

	                            $lastSyncStatus = GetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $className -sqlConnection $sqlConnection
                                $thisSyncType = GetSyncType $lastSyncStatus $syncType

                                # Update scom.SyncStatus to indicate a sync is starting
	                            [datetime]$startDate = (Get-Date)
                                SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $className -SyncType $thisSyncType.SyncType -startDate $startDate -syncStatus "Starting..." -sqlConnection $sqlConnection

							    $result = WriteSCOMObjects -scomManagementGroup $scomManagementGroup -objectClass $className -genericClass $genericClass -distributedApplication $distributedApplication -syncType $thisSyncType.syncType -lastUpdate $thisSyncType.lastUpdate -sqlConnection $sqlConnection
                                $scomObjects = $result.ObjectCount
							    $errorCounter += $result.ErrorCount
							    $warningCounter += $result.WarningCount
                                Write-Host "$scomObjects objects of $className processed."

	                            # Update scom.SyncStatus to indicate a sync is completed
                                [datetime]$endDate = (Get-Date)
                                [string]$syncStatus = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $result.Status, $result.ObjectCount, $result.ErrorCount, $result.WarningCount
	                            SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $className -SyncType $thisSyncType.syncType -startDate $startDate -endDate $endDate -objectCount $result.ObjectCount -syncStatus $syncStatus -sqlConnection $sqlConnection

                            }
						}
		"Group" 	{
                            [int]$groupCount=0
                            $Groups=$appConfig.SelectNodes("/configuration/Groups/Group[@active='True']")
							foreach($Group in $Groups){
								$groupName = $Group.DisplayName
								$lastSyncStatus = GetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $groupName -sqlConnection $sqlConnection
								$thisSyncType = GetSyncType $lastSyncStatus $syncType

								# Update scom.SyncStatus to indicate a sync is starting
								[datetime]$startDate = (Get-Date)
								SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $groupName -SyncType $thisSyncType.SyncType -startDate $startDate -syncStatus "Starting..." -sqlConnection $sqlConnection

								$result = WriteSCOMGroup -scomManagementGroup $scomManagementGroup -groupName $groupName -syncType $thisSyncType.syncType -lastUpdate $thisSyncType.lastUpdate -sqlConnection $sqlConnection
								$scomObjects = $result.ObjectCount
								$errorCounter += $result.ErrorCount
								$warningCounter += $result.WarningCount
								# Write-Host "$scomObjects Groups processed."

								# Update scom.SyncStatus to indicate a sync is completed
								[datetime]$endDate = (Get-Date)
								[string]$syncStatus = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $result.Status, $result.ObjectCount, $result.ErrorCount, $result.WarningCount
								SetSyncStatus -scomManagementGroup $scomManagementGroup -ObjectClass $groupName -SyncType $thisSyncType.syncType -startDate $startDate -endDate $endDate -objectCount $result.ObjectCount -syncStatus $syncStatus -sqlConnection $sqlConnection
                                $groupCount++
							}
                            Write-Host "$groupCount Groups processed."
						}
		"default"		{
			Write-Host "$objectClass : Invalid object type."
			continue
		}
    }

}


################################################################################
# CLEANUP
################################################################################
[Void]$sqlConnection.Close
$sqlConnection.Dispose()
Write-Host "***** Process completed ******"

