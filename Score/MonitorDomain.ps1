#Requires -Version 4.0
#Requires -Modules ActiveDirectory
<#

.SYNOPSIS

	This script is intended to retrieve data from a Active Directory and store it in the SCORE data warehouse.


.DESCRIPTION

	This script is intended to retrieve data from a Active Directory and store it in the SCORE data warehouse.


.PARAMETER adDomain

    The Active Directory domain from which objects will be retrieved.  This is the DNS name for the Domain (e.g. abcd.lcl).

.PARAMETER adObjectType

	List of ObjectClasses to retrieve.  This is a constrained list.  Currently valid values are:
	"forest","domain","computer","user","site","group","groupmember","subnet"

	"forest" - Information about the Active Directory Forest
	"domain" - Information about the Active Directory Domain
	"site" - Information about Active Directory Sites; should only be used when pointed to the root Forest
	"subnet" - Information about Active Directory Subnets; should only be used when pointed to the root Forest
	"computer" - Information about Windows computer objects (workstations and servers both)
    "server" - Information about Windows Server computer objects only
	"user" - Information about Active Directory Users
	"group" - Information about Active Directory Groups
	"groupmember" - Associates Groups and Group Members (users or computers)
    "serviceaccount" - Information about Group Managed Service Accounts
    "organizationalunit" - Information about Organizational Units

.PARAMETER SyncType

	Type of Synchronization to run
	Full - Synchronize all objects
	Incremental - Synchronize only those objects that have changed since the last synchronziation was executed

.PARAMETER adSearchRoot

	String value of OU (in DN Format) where the search will start from; can be used to narrow search criteria

.PARAMETER Credential

    An automation credential object used to access remote (untrusted) domains; this ONLY impacts AD queries, not database operations.

.PARAMETER Force

    A switch parameter used to override when the last synch was aborted.  Last Synch status will show "In Process".

.PARAMETER LapsPassword

    A switch parameter used to allow the collection of Local Administrator Password (LAPS) data for computer objects.  
	LAPS is a solution to randomize Local Administrator Account passwords.  If a computer object is deleted or other
	issues arise, the password may be retrieved from the database.  The password is encrypted in the database.


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

	Example 1: Full Synchronization of Active Directory Forest, Domain, Site and Subnet
	.\MonitorDomain.ps1 -adDomain abcd.lcl -adObjectType "Forest","Domain","Site","Subnet" -SyncType Full

.EXAMPLE

	Example 2: Full Synchronization of Windows Computers
	.\MonitorDomain.ps1 -adDomain abcd.lcl -adObjectType WindowsComputer -SyncType Full

.EXAMPLE
	Example 3: Full Synchronization of Active Directory Forest, Domain, Site and Subnet for an untrusted forest
	.\MonitorDomain.ps1 -adDomain abcd.lcl -adObjectType "Forest","Domain","Site","Subnet" -SyncType Full -Credential $cred

.EXAMPLE
	Example 4: Incremental Synchronization of Windows Computer objects
	.\MonitorDomain.ps1 -adDomain abcd.lcl -adObjectType WindowsComputer -SyncType Incremental

#>
[CmdletBinding()]
Param(  
	[Parameter(Mandatory=$True,Position=1)]
	[string]$adDomain,	
	[Parameter(Mandatory=$True,Position=2)]
	[ValidateSet("forest","domain","computer","user","site","group","groupmember","subnet","serviceaccount","server","organizationalunit")]
	[string[]]$adObjectType,
	[Parameter(Mandatory=$False,Position=3)]
	[ValidateSet("Full","Incremental")]
	[string]$syncType="Full",
	[Parameter(Mandatory=$false)]
	[string]$adSearchRoot=$null	,
	[Parameter(Mandatory=$false)]
	[System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty),
	[Parameter(Mandatory=$false)]
	[switch]$Force,
	[Parameter(Mandatory=$false)]
	[switch]$LapsPassword
)

Set-StrictMode -Version Latest

# Set current location
[string]$shellFolder = Split-Path $MyInvocation.MyCommand.Path

# Change path to working folder
Set-Location $shellFolder	

# Dot Source MonitorFunctions.ps1
. ".\MonitorFunctions.ps1"

#region GetSyncStatus
#************************************************************************************************************************************
# Function GetSyncStatus
#
# Parameters:
# 	- Domain
#	- Object
#   - syncType
#
# Returns:
#   - Last Update Type (varchar: Full | Incremental)
#   - Start Date (datetime)
#   - End Date (datetime)
#   - syncType
#
# Function to retrieve AD Domain stats for object from ad.Module
#
#************************************************************************************************************************************
Function GetSyncStatus {
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$adDomain,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$adObjectType,
	[Parameter(Mandatory=$True,Position=3)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection,
	[Parameter(Mandatory=$False,Position=4)]
	[System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
)

    [int]$errorCounter = 0
    [string]$moduleName = "GetSyncStatus"

    try {
	    If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
            $oDomain = Get-ADDomain -Server $adDomain -Credential $Credential
        } Else {
            $oDomain = Get-ADDomain -Server $adDomain
        }
	
        # Retrieve stored procedure
	    $sqlCommand = GetStoredProc $sqlConnection "ad.spSyncStatusViewSelect"

	    [Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@ObjectClass", [system.data.SqlDbType]::nvarchar)
	
        $sqlCommand.Parameters["@Domain"].value = $oDomain.DNSRoot
        $sqlCommand.Parameters["@ObjectClass"].value = $adObjectType
	    $sqlReader = $sqlCommand.ExecuteReader()
	    $sqlCommand.Dispose()

	    $dataTable = New-Object System.Data.DataTable
	    $dataTable.Load($SqlReader)
	
	    # Get results from last Synch
	    # IF
        #  - Requested synch does not exist, perform a full synch
	    #  - Requested synch is incremental and no previous synch has been performed, perform a full synch
        #  - Requested synch is already in progress, then return the start time of the last synch (logic elsewhere will stop the synch 
        #    if it was started less than 90 minutes ago)
	    if($dataTable.Rows.Count -gt 0) {
            # A record exists, we've checked this domain before
            if($dataTable.Rows[0]["LastStatus"] -eq "Starting...") {
			    # If the status is "Starting...", then it means that a process is running or aborted the last run
		        [string]$lastSyncType = "In process" 
                If($dataTable.Rows[0]["lastStartDate"] -eq [System.DBNull]::Value)
                {
		            [datetime]$lastStartDate = "1/1/1970"
                }
                Else
                {
                    [datetime]$lastStartDate = $dataTable.Rows[0]["lastStartDate"]
                }
                If($dataTable.Rows[0]["lastFullSync"] -eq [System.DBNull]::Value)
                {
		            [datetime]$lastFullSync = "1/1/1970"
                }
                Else
                {
                    [datetime]$lastFullSync = $dataTable.Rows[0]["lastFullSync"]
                }
                If($dataTable.Rows[0]["lastIncrementalSync"] -eq [System.DBNull]::Value)
                {
		            [datetime]$lastIncrementalSync = "1/1/1970"
                }
                Else
                {
                    [datetime]$lastIncrementalSync = $dataTable.Rows[0]["lastIncrementalSync"]
                }
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
		    AddLogEntry $adDomain "Error" $moduleName $msg $sqlConnection
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
# 	- adDomain
#	- adObjectType
#   - syncType (varchar: Full | Incremental)
#   - startDate (datetime)
#   - endDate (datetime)
#   - objectCount
#   - syncStatus
#
# Returns:
#
# Function to set AD Domain stats for object in ad.SyncStatus
# 
# May be called to set the beginning status (no end date) or to update upon completion (end date specified)
#
#************************************************************************************************************************************
Function SetSyncStatus {
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$adDomain,
	[Parameter(Mandatory=$True,Position=2)]
	[ValidateSet("domain","forest","site","computer","user","group","groupmember","subnet","serviceaccount","server","organizationalunit")]
	[string]$adObjectType,
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
	[System.Data.SqlClient.SqlConnection]$sqlConnection,
	[Parameter(Mandatory=$False,Position=9)]
	[System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
)  
    [int]$errorCounter = 0
    [string]$moduleName = "SetSyncStatus"

	try {
        If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    	    $oDomain = Get-ADDomain -Server $adDomain -Credential $Credential
        } Else {
            $oDomain = Get-ADDomain -Server $adDomain
        }
	
	    $sqlCommand = GetStoredProc $sqlConnection "ad.spSyncStatusUpsert"

	    [Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@ObjectClass", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@SyncType", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@StartDate", [system.data.SqlDbType]::DateTime)
	    [Void]$sqlCommand.Parameters.Add("@EndDate", [system.data.SqlDbType]::DateTime)
	    [Void]$sqlCommand.Parameters.Add("@Count", [system.data.SqlDbType]::Int)
	    [Void]$sqlCommand.Parameters.Add("@Status", [system.data.SqlDbType]::nvarchar)
	
		if($endDate){
		    $sqlCommand.Parameters["@Domain"].value = $oDomain.DNSRoot
		    $sqlCommand.Parameters["@ObjectClass"].value = $adObjectType
		    $sqlCommand.Parameters["@SyncType"].value = $syncType
		    $sqlCommand.Parameters["@StartDate"].value = $startDate
		    $sqlCommand.Parameters["@EndDate"].value = $endDate
		    $sqlCommand.Parameters["@Count"].value = $objectCount
		    $sqlCommand.Parameters["@Status"].value = $syncStatus
		} else {
		    $sqlCommand.Parameters["@Domain"].value = $oDomain.DNSRoot
		    $sqlCommand.Parameters["@ObjectClass"].value = $adObjectType
		    $sqlCommand.Parameters["@SyncType"].value = $syncType
		    $sqlCommand.Parameters["@StartDate"].value = $startDate
			$sqlCommand.Parameters["@Status"].value = $syncStatus
		}
        [Void]$sqlCommand.ExecuteNonQuery()
	    $sqlCommand.Dispose()

        if($endDate){

	        $sqlCommand = GetStoredProc $sqlConnection "ad.spSyncHistoryInsert"

	        [Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@ObjectClass", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@SyncType", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@StartDate", [system.data.SqlDbType]::DateTime)
	        [Void]$sqlCommand.Parameters.Add("@EndDate", [system.data.SqlDbType]::DateTime)
	        [Void]$sqlCommand.Parameters.Add("@Count", [system.data.SqlDbType]::Int)
	        [Void]$sqlCommand.Parameters.Add("@Status", [system.data.SqlDbType]::nvarchar)
	
	        $sqlCommand.Parameters["@Domain"].value = $oDomain.DNSRoot
	        $sqlCommand.Parameters["@ObjectClass"].value = $adObjectType
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
	    AddLogEntry $adDomain "Error" $moduleName $msg $sqlConnection
        $errorCounter++
    }
}
#endregion

#region WriteForestInfo
#************************************************************************************************************************************
# Function WriteForestInfo
#
# Parameters:
# 	- Connection String
#
# Returns:
#   - Nothing
#
# Writes meta data about Forest to ad.Forest
#
#************************************************************************************************************************************
Function WriteForestInfo {
[CmdletBinding()]
param(
  	[Parameter(Mandatory=$True,Position=1)]
	[string]$adForest,
  	[Parameter(Mandatory=$True,Position=2)]
   	[System.Data.SqlClient.SqlConnection]$sqlConnection,
    [Parameter(Mandatory=$False,Position=3)]
    [System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
)
	[Int32]$warningCounter = 0
	[Int32]$errorCounter = 0
	[Int32]$objectCounter = 0

   	# Update Process log
	AddLogEntry $adForest "Info" "WriteForestInfo" "Starting Check..." $sqlConnection

	Try {
		# Get RootDSE Context
        If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    	    $Forest = Get-ADForest -Server $adForest -Credential $Credential
        } Else {
            $Forest = Get-ADForest -Server $adForest
        }
	    
	    # Open Connection to CMDB database
		$sqlCommand = GetStoredProc -sqlConnection $sqlConnection -sqlCommandName "ad.spForestUpsert"

	    [void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@DomainNamingMaster",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@SchemaMaster",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@RootDomain",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@ForestMode",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
		
	    $sqlCommand.Parameters["@Name"].Value = $Forest.Name
	    $sqlCommand.Parameters["@DomainNamingMaster"].Value = $Forest.DomainNamingMaster
	    $sqlCommand.Parameters["@SchemaMaster"].Value = $Forest.SchemaMaster
	    $sqlCommand.Parameters["@RootDomain"].Value = $Forest.RootDomain
	    $sqlCommand.Parameters["@ForestMode"].Value = $Forest.ForestMode
	    $sqlCommand.Parameters["@Active"].Value = $true
	    $sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
	    [void]$sqlCommand.ExecuteNonQuery()
		$sqlCommand.Dispose()
		$objectCounter++
	}
    Catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry $adForest "Error" "WriteForestInfo" $msg $sqlConnection
    }	

	if($errorCounter -gt 0) {$syncStatus = "Error"}
	elseif($warningCounter -gt 0) {$syncStatus = "Warning"}
	else {$syncStatus = "Success"}

    # Write Log Entry
    [string]$msg = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $syncStatus, $objectCounter, $errorCounter, $warningCounter
	AddLogEntry $adDomain "Info" "WriteForestInfo" "$msg" $sqlConnection
	
	return New-Object psobject -Property @{Status = $syncStatus; ErrorCount = $errorCounter; WarningCount = $warningCounter; ObjectCount = $objectCounter}		
	
}
#endregion

#region WriteDomainInfo
#************************************************************************************************************************************
# Function WriteDomainInfo
#
# Parameters:
# 	- Connection String
#
# Returns:
#   - Nothing
#
# Writes meta data about Domain and Domain RootDSE to ad.Domain
#
#************************************************************************************************************************************
Function WriteDomainInfo {
[CmdletBinding()]
param(
  	[Parameter(Mandatory=$True,Position=1)]
	[string]$adDomain,
  	[Parameter(Mandatory=$True,Position=2)]
   	[System.Data.SqlClient.SqlConnection]$sqlConnection,
    [Parameter(Mandatory=$False,Position=3)]
    [System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
)
	[Int32]$warningCounter = 0
	[Int32]$errorCounter = 0
	[Int32]$objectCounter = 0
	
   	# Update Process log
	AddLogEntry $adDomain "Info" "WriteDomainInfo" "Starting Check..." $sqlConnection

    # Set LastFullSync to current time stamp
    [datetime]$LastFullSync = (Get-Date)

	Try {
		# Connect to Domain object
        If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    		$Domain = Get-ADDomain -Server $adDomain -Credential $Credential
        } Else {
            $Domain = Get-ADDomain -Server $adDomain
        }

	    # Open Connection to CMDB database
		$sqlCommand = GetStoredProc $sqlConnection "ad.spDomainUpsert"

	    [void]$sqlCommand.Parameters.Add("@objectGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	    [void]$sqlCommand.Parameters.Add("@SID",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Forest",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@DNSRoot",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@NetBIOSName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@DistinguishedName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@InfrastructureMaster",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@PDCEmulator",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@RIDMaster",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@DomainFunctionality",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@ForestFunctionality",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@UserName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Password",  [System.Data.SqlDbType]::varbinary)
	    [void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)

	    $sqlCommand.Parameters["@objectGUID"].Value = $Domain.objectGUID
	    $sqlCommand.Parameters["@SID"].Value = $Domain.DomainSID.ToString()
	    $sqlCommand.Parameters["@Forest"].Value = $Domain.Forest
	    $sqlCommand.Parameters["@Name"].Value = $Domain.Name
	    $sqlCommand.Parameters["@DNSRoot"].Value = $Domain.DNSRoot
	    $sqlCommand.Parameters["@NetBIOSName"].Value = $Domain.NetBIOSName
	    $sqlCommand.Parameters["@DistinguishedName"].Value = $Domain.DistinguishedName
	    $sqlCommand.Parameters["@InfrastructureMaster"].Value = $Domain.InfrastructureMaster
	    $sqlCommand.Parameters["@PDCEmulator"].Value = $Domain.PDCEmulator
	    $sqlCommand.Parameters["@RIDMaster"].Value = $Domain.RIDMaster
	    $sqlCommand.Parameters["@Active"].Value = $true
	    $sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)

        If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    		$DomainSE = Get-ADRootDSE -Server $adDomain -Credential $Credential
        } Else {
            $DomainSE = Get-ADRootDSE -Server $adDomain
        }
	    $sqlCommand.Parameters["@DomainFunctionality"].value = $DomainSE.DomainFunctionality
	    $sqlCommand.Parameters["@ForestFunctionality"].value = $DomainSE.ForestFunctionality	

	    [Void]$sqlCommand.ExecuteNonQuery()
		$sqlCommand.Dispose()
		$objectCounter++
	}
    Catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry $adDomain "Error" "WriteDomainInfo" $msg $sqlConnection
		$errorCounter++
    }

    ## ADDED SECTION: ENUMERATE DOMAIN CONTROLLERS
	Try {
		$sqlCommand = GetStoredProc $sqlConnection "ad.spDomainControllerUpsert"
	    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@DNSHostName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Type",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)

        foreach($dc in $Domain.ReplicaDirectoryServers)
        {

	        $sqlCommand.Parameters["@Domain"].Value = $Domain.DNSRoot
	        $sqlCommand.Parameters["@DNSHostName"].Value = $dc
	        $sqlCommand.Parameters["@Type"].Value = 'DomainController'
	        $sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
	        [Void]$sqlCommand.ExecuteNonQuery()
        }

        foreach($dc in $Domain.ReadOnlyReplicaDirectoryServers)
        {

	        $sqlCommand.Parameters["@Domain"].Value = $Domain.DNSRoot
	        $sqlCommand.Parameters["@DNSHostName"].Value = $dc
	        $sqlCommand.Parameters["@Type"].Value = 'ReadOnlyDomainController'
	        $sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
	        [Void]$sqlCommand.ExecuteNonQuery()
        }

    }
    Catch {
		$msg = $_.Exception.Message
	    AddLogEntry $adDomain "Warning" "WriteDomainInfo" $msg $sqlConnection
		$warningCounter++
    }
    $sqlCommand.Dispose()

    ## ADDED SECTION: INACTIVATE DOMAIN CONTROLLERS
	# Inactivate Domain Controllers that were not updated recently
	$sqlCommand = GetStoredProc $sqlConnection "ad.spDomainControllerInactivateByDate"
	[void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@BeforeDate",  [System.Data.SqlDbType]::datetime)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@Domain"].Value = $adDomain
	$sqlCommand.Parameters["@BeforeDate"].Value = $lastFullSync
	$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()	
	$sqlCommand.Dispose()

	if($errorCounter -gt 0) {$syncStatus = "Error"}
	elseif($warningCounter -gt 0) {$syncStatus = "Warning"}
	else {$syncStatus = "Success"}

    # Write Log Entry
    [string]$msg = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $syncStatus, $objectCounter, $errorCounter, $warningCounter
	AddLogEntry $adDomain "Info" "WriteDomainInfo" "$msg" $sqlConnection
	
	return New-Object psobject -Property @{Status = $syncStatus; ErrorCount = $errorCounter; WarningCount = $warningCounter; ObjectCount = $objectCounter}		
}
#endregion

#region WriteComputerInfo
#************************************************************************************************************************************
# Function WriteComputerInfo
#
# Parameters:
# 	- Connection String
#
# Returns:
#   - Nothing
#
# Writes AD information about servers to ad.Computer
#
#************************************************************************************************************************************
Function WriteComputerInfo {
[CmdletBinding()]
param(
  	[Parameter(Mandatory=$True,Position=1)]
	[string]$adDomain,
  	[Parameter(Mandatory=$True,Position=2)]
	[string]$adDomainSearchRoot,
  	[Parameter(Mandatory=$True,Position=3)]
	[string]$syncType,
  	[Parameter(Mandatory=$True,Position=4)]
	[datetime]$lastUpdate,
  	[Parameter(Mandatory=$True,Position=5)]
	[datetime]$lastFullSync,
  	[Parameter(Mandatory=$True,Position=6)]
   	[System.Data.SqlClient.SqlConnection]$sqlConnection,
    [Parameter(Mandatory=$False)]
    [System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty),
    [Parameter(Mandatory=$False)]
	[ValidateSet("server","all")]
    [string]$subClass="server"

)

	# Update Process log
	AddLogEntry $adDomain "Info" "WriteComputerInfo" "Starting $syncType Check..." $sqlConnection
	
	[Int32]$warningCounter = 0
	[Int32]$errorCounter = 0
	[Int32]$objectCounter = 0
	Try {
		If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
            $oDomain = Get-ADDomain -Server $adDomain -Credential $Credential
            $oRootDSE = Get-ADRootDSE -Server $adDomain -Credential $Credential
        } Else {
            $oDomain = Get-ADDomain -Server $adDomain
            $oRootDSE = Get-ADRootDSE -Server $adDomain
        }

        # Retrieving just servers? or servers and workstations?
        if($subClass -eq 'all')
        {
            $operatingSystemFilter = "*Windows*"
        }
        Else
        {
            $operatingSystemFilter = "*Windows*Server*"
        }
		
        # Set filter 
        if(($syncType -eq "Incremental") -and ($lastUpdate -gt "01/01/1970")) {
            [string]$sFilter = "whenChanged -ge '$lastUpdate' -and OperatingSystem -like '$operatingSystemFilter'"
        } Else {
            [string]$sFilter = "OperatingSystem -like '$operatingSystemFilter'"
        }

        # ADDED TO SUPPORT LAPS
		# Check for existence of LAPS attribute; if it exists, retrieve LAPS properties
		# $lapsCN = "CN=ms-Mcs-AdmPwdExpirationTime,CN=Schema,CN=Configuration," + $oDomain.DistinguishedName
		$lapsCN = "CN=ms-Mcs-AdmPwdExpirationTime," + $oRootDSE.schemaNamingContext
		Try
		{
			$lapsObject = Get-ADObject -Identity $lapsCN -Server $oDomain.Forest
			# $lapsObject = Get-ADObject -Identity $lapsCN -Server $adDomain
			[bool]$bLAPS = $true
			$PropList = @("LastLogonDate", "whenCreated", "whenChanged", "OperatingSystem", "OperatingSystemServicePack", "OperatingSystemVersion", "Description", "TrustedForDelegation","IPv4Address","objectGUID","LastLogonTimeStamp","UserAccountControl","msDS-SupportedEncryptionTypes","ms-Mcs-AdmPwdExpirationTime","ms-Mcs-AdmPwd")

		}
		Catch
		{
			# Did not find LAPS 
			$Error.Clear()
			[bool]$bLAPS = $false
			$PropList = @("LastLogonDate", "whenCreated", "whenChanged", "OperatingSystem", "OperatingSystemServicePack", "OperatingSystemVersion", "Description", "TrustedForDelegation","IPv4Address","objectGUID","LastLogonTimeStamp","UserAccountControl","msDS-SupportedEncryptionTypes")
		}

        # Query AD (with or without credential)
        If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    		$computers = Get-ADComputer -Server $adDomain -searchBase $adDomainSearchRoot -Filter $sFilter -Properties $PropList -Credential $Credential
        } Else {
            $computers = Get-ADComputer -Server $adDomain -searchBase $adDomainSearchRoot -Filter $sFilter -Properties $PropList
        }
		
    	$sqlCommand = GetStoredProc -sqlConnection $sqlConnection -sqlCommandName "ad.spComputerUpsert"
		[Void]$sqlCommand.Parameters.Add("@objectGUID", [system.data.SqlDbType]::uniqueidentifier)
		[Void]$sqlCommand.Parameters.Add("@SID", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@IPv4Address", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Trusted", [system.data.SqlDbType]::bit)
		[Void]$sqlCommand.Parameters.Add("@OperatingSystem", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@OperatingSystemVersion", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@OperatingSystemServicePack", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Description", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@DistinguishedName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@UserAccountControl", [system.data.SqlDbType]::int)
		[Void]$sqlCommand.Parameters.Add("@SupportedEncryptionTypes", [system.data.SqlDbType]::int)
		[Void]$sqlCommand.Parameters.Add("@Enabled", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@LastLogon", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@whenCreated", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@whenChanged", [system.data.SqlDbType]::DateTime)
        [Void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::Datetime)


		$sqlCommandLAPS = GetStoredProc -sqlConnection $sqlConnection -sqlCommandName "ad.spLocalAdminPasswordSolutionUpsert"
		[Void]$sqlCommandLAPS.Parameters.Add("@objectGUID", [system.data.SqlDbType]::uniqueidentifier)
		[Void]$sqlCommandLAPS.Parameters.Add("@AdmPwdExpiration", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommandLAPS.Parameters.Add("@AdmPassword", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommandLAPS.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::Datetime)

		
		foreach($computer in $computers)
		{
			try {
				if($null -eq $computer.LastLogonDate){$dLastLogon = [System.DBNull]::Value} else {$dLastLogon = [DateTime]::FromFileTime([Int64] $computer.lastlogontimestamp)}

				$sqlCommand.Parameters["@objectGUID"].value = $computer.objectGUID
				$sqlCommand.Parameters["@SID"].value = $computer.SID.ToString()
				$sqlCommand.Parameters["@Domain"].value = $oDomain.DNSRoot
				$sqlCommand.Parameters["@Name"].value = $computer.Name	
				$sqlCommand.Parameters["@dnsHostName"].value = NullToString -value1 $computer.dnsHostName -value2 ""
				$sqlCommand.Parameters["@IPV4Address"].value = NullToString -value1 $computer.IPV4Address -value2 ""
				$sqlCommand.Parameters["@Trusted"].value = $computer.TrustedForDelegation
				$sqlCommand.Parameters["@OperatingSystem"].value = $computer.OperatingSystem
				$sqlCommand.Parameters["@OperatingSystemVersion"].value = $computer.OperatingSystemVersion
				$sqlCommand.Parameters["@OperatingSystemServicePack"].value = $computer.OperatingSystemServicePack
				$sqlCommand.Parameters["@Description"].value = $computer.Description
				$sqlCommand.Parameters["@DistinguishedName"].value = $computer.DistinguishedName
				$sqlCommand.Parameters["@UserAccountControl"].value = $computer.UserAccountControl
				$sqlCommand.Parameters["@SupportedEncryptionTypes"].value = $computer.'msDS-SupportedEncryptionTypes'
				$sqlCommand.Parameters["@Enabled"].value = $computer.Enabled
				$sqlCommand.Parameters["@Active"].value = $true
				$sqlCommand.Parameters["@LastLogon"].value = $dLastLogon
				$sqlCommand.Parameters["@whenCreated"].value = $computer.whenCreated
				$sqlCommand.Parameters["@whenChanged"].value = $computer.whenChanged
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			
				[Void]$sqlCommand.ExecuteNonQuery()

				# SECTION ADDED TO SUPPORT LAPS
				if($bLAPS -and $LapsPassword)
				{
					If($null -eq $computer.'ms-Mcs-AdmPwdExpirationTime')
					{ 
						$admPwdExpiration = [System.DBNull]::Value
					} Else 
					{
						$admPwdExpiration = [DateTime]::FromFileTime([Int64] $computer.'ms-Mcs-AdmPwdExpirationTime')
					}
					If($null -eq $computer.'ms-Mcs-AdmPwd')
					{ 
						$admPassword = [System.DBNull]::Value
					} Else 
					{
						$admPassword = $computer.'ms-Mcs-AdmPwd'
					}

					$sqlCommandLAPS.Parameters["@ObjectGUID"].value = $computer.objectGUID
					$sqlCommandLAPS.Parameters["@AdmPwdExpiration"].value = $admPwdExpiration
					$sqlCommandLAPS.Parameters["@AdmPassword"].value = $admPassword
					$sqlCommandLAPS.Parameters["@dbLastUpdate"].Value = (Get-Date)
			
					[Void]$sqlCommandLAPS.ExecuteNonQuery()
				}
				
			} Catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $adDomain "Warning" "WriteComputerInfo" "$computer : $msg" $sqlConnection
				$warningCounter++
			}
		    $objectCounter++
		}
		$sqlCommandLAPS.Dispose()
 		$sqlCommand.Dispose()

		# This section added to deal with MS Cluster Virtual Computer Objects
		# These objects exist in Active Directory, but will never receive an agent
		# These records are added to the scom.AgentExclusions table. 
		$PropList = @("DNSHostName")
        If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    		$exclusions = Get-ADObject -Server $adDomain -searchBase $adDomainSearchRoot -LDAPFilter '(ServicePrincipalName=MSClusterVirtual*)' -Properties $PropList -Credential $Credential
        } Else {
            $exclusions = Get-ADObject -Server $adDomain -searchBase $adDomainSearchRoot -LDAPFilter '(ServicePrincipalName=MSClusterVirtual*)' -Properties $PropList
        }

    	$sqlCommand = GetStoredProc -sqlConnection $sqlConnection -sqlCommandName "scom.spAgentExclusionsUpsert"
		[Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@DNSHostName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Reason", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::Datetime)

    	$sqlCommandAD = GetStoredProc -sqlConnection $sqlConnection -sqlCommandName "ad.spClusterNamedObjectUpsert"
		[Void]$sqlCommandAD.Parameters.Add("@ObjectGUID", [system.data.SqlDbType]::uniqueidentifier)
		[Void]$sqlCommandAD.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommandAD.Parameters.Add("@DNSHostName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommandAD.Parameters.Add("@Comment", [system.data.SqlDbType]::nvarchar)
        [Void]$sqlCommandAD.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::Datetime)
		
	    foreach($exclusion in $exclusions)
	    {
			try {
				
				$sqlCommand.Parameters["@Domain"].value = $adDomain
				$sqlCommand.Parameters["@DNSHostName"].value = $exclusion.DNSHostName
				$sqlCommand.Parameters["@Reason"].value = "MS Cluster Virtual Object"
				$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
				[Void]$sqlCommand.ExecuteNonQuery()


				$sqlCommandAD.Parameters["@ObjectGUID"].value = $exclusion.objectGUID
				$sqlCommandAD.Parameters["@Domain"].value = $adDomain
				$sqlCommandAD.Parameters["@DNSHostName"].value = $exclusion.DNSHostName
				$sqlCommandAD.Parameters["@Comment"].value = "MS Cluster Virtual Object"
				$sqlCommandAD.Parameters["@dbLastUpdate"].value = (Get-Date)
				[Void]$sqlCommandAD.ExecuteNonQuery()
				
			} Catch [System.Exception] {
				$msg = $_.Exception.Message
			    AddLogEntry $adDomain "Warning" "WriteComputerInfo" "$computer : $msg" $sqlConnection
				$warningCounter++
			}
		}
        $sqlCommand.Dispose()
        $sqlCommandAD.Dispose()


		# If this sync is full, then inactivate any object (for this domain) that wasn't touched
		if($syncType -eq "Full"){
			$sqlCommand = GetStoredProc $sqlConnection "ad.spComputerInactivateByDate"
		    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
		    [void]$sqlCommand.Parameters.Add("@BeforeDate",  [System.Data.SqlDbType]::datetime)
		    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			$sqlCommand.Parameters["@Domain"].Value = $adDomain
			$sqlCommand.Parameters["@BeforeDate"].Value = $lastFullSync
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
		    [Void]$sqlCommand.ExecuteNonQuery()	
			$sqlCommand.Dispose()
		}		
	}
    Catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry $adDomain "Error" "WriteComputerInfo" "$msg" $sqlConnection
		$errorCounter++
    }
	if($errorCounter -gt 0) {$syncStatus = "Error"}
	elseif($warningCounter -gt 0) {$syncStatus = "Warning"}
	else {$syncStatus = "Success"}

    # Write Log Entry
    [string]$msg = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $syncStatus, $objectCounter, $errorCounter, $warningCounter
	AddLogEntry $adDomain "Info" "WriteComputerInfo" "$msg" $sqlConnection

    return New-Object psobject -Property @{Status = $syncStatus; ErrorCount = $errorCounter; WarningCount = $warningCounter; ObjectCount = $objectCounter}

}
#endregion

#region WriteUserInfo
#************************************************************************************************************************************
# Function WriteUserInfo
#
# Parameters:
# 	- Connection String
#
# Returns:
#   - Nothing
#
# Writes AD information about users to ad.User
#
#************************************************************************************************************************************
Function WriteUserInfo {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$adDomain,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$adDomainSearchRoot,
	[Parameter(Mandatory=$True,Position=3)]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=4)]
	[datetime]$lastUpdate,
	[Parameter(Mandatory=$True,Position=5)]
	[datetime]$lastFullSync,
	[Parameter(Mandatory=$True,Position=6)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection,
    [Parameter(Mandatory=$False,Position=7)]
    [System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
)
	# Update Process log
	AddLogEntry $adDomain "Info" "WriteUserInfo" "Starting $syncType check..." $sqlConnection

	[Int32]$warningCounter = 0
	[Int32]$errorCounter = 0
	[Int32]$objectCounter = 0
	Try {
        If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    		$Domain = Get-ADDomain -Server $adDomain -Credential $Credential
        } Else {
            $Domain = Get-ADDomain -Server $adDomain
        }
	
	    # Retrieve users from AD
		$PropList = @("DisplayName","GivenName","Surname","Company","Title","EmployeeID","ProfilePath","HomeDirectory","LockedOut","PasswordExpired","PasswordLastSet","PasswordNeverExpires","PasswordNotRequired","TrustedForDelegation","TrustedToAuthForDelegation","Office","Department","Division","StreetAddress","City","State","PostalCode","ManagedBy","MobilePhone","telephoneNumber","Fax","Pager","mail","Enabled","LastLogonDate", "whenCreated","whenChanged","objectGUID","LastLogonTimeStamp","msDS-SupportedEncryptionTypes","UserAccountControl")
		if(($syncType -eq "Incremental") -and ($lastUpdate -gt "01/01/1970")) {
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$users = Get-ADUser -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'whenChanged -ge $lastUpdate -and Name -like "*"' -Properties $PropList -Credential $Credential
            } Else {
            	$users = Get-ADUser -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'whenChanged -ge $lastUpdate -and Name -like "*"' -Properties $PropList
            }
		} else {
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$users = Get-ADUser -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'Name -like "*"' -Properties $PropList -Credential $Credential
            } Else {
            	$users = Get-ADUser -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'Name -like "*"' -Properties $PropList
            }
		}
				
	    $sqlCommand = GetStoredProc $sqlConnection "ad.spUserUpsert"
        
	    [void]$sqlCommand.Parameters.Add("@objectGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	    [void]$sqlCommand.Parameters.Add("@SID",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@FirstName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@LastName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@DisplayName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@JobTitle",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@EmployeeNumber",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@ProfilePath",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@HomeDirectory",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Company",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Office",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Department",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Division",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@StreetAddress",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@City",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@State",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@PostalCode",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Manager",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@MobilePhone",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@PhoneNumber",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Fax",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Pager",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@EMail",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@LockedOut",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@PasswordExpired",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@PasswordLastSet",  [System.Data.SqlDbType]::datetime)
	    [void]$sqlCommand.Parameters.Add("@PasswordNeverExpires",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@PasswordNotRequired",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@TrustedForDelegation",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@TrustedToAuthForDelegation",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@UserAccountControl",  [System.Data.SqlDbType]::int)
	    [void]$sqlCommand.Parameters.Add("@SupportedEncryptionTypes",  [System.Data.SqlDbType]::int)
	    [void]$sqlCommand.Parameters.Add("@DistinguishedName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Enabled",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@LastLogon",  [System.Data.SqlDbType]::datetime)
	    [void]$sqlCommand.Parameters.Add("@whenCreated",  [System.Data.SqlDbType]::datetime)
	    [void]$sqlCommand.Parameters.Add("@whenChanged",  [System.Data.SqlDbType]::datetime)
	    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)

	    foreach($user in $users)
	    {
            try {
			    if($null -eq $user.LastLogonDate){$dLastLogon = [System.DBNull]::Value} else {$dLastLogon = [DateTime]::FromFileTime([Int64]$user.lastlogontimestamp)}
                
		        $sqlCommand.Parameters["@objectGUID"].Value = $user.objectGUID
		        $sqlCommand.Parameters["@SID"].Value = $user.SID.ToString()
		        $sqlCommand.Parameters["@Domain"].Value = $oDomain.DNSRoot 
		        $sqlCommand.Parameters["@Name"].Value = $user.SamAccountName
		        $sqlCommand.Parameters["@FirstName"].Value = NullToDBNull -value1 $user.GivenName
		        $sqlCommand.Parameters["@LastName"].Value = NullToDBNull -value1 $user.Surname
		        $sqlCommand.Parameters["@DisplayName"].Value = $user.DisplayName
		        $sqlCommand.Parameters["@Description"].Value = NullToDBNull -value1 $user.Description
		        $sqlCommand.Parameters["@JobTitle"].Value = NullToDBNull -value1 $user.Title
		        $sqlCommand.Parameters["@EmployeeNumber"].Value = NullToDBNull -value1 $user.EmployeeID
		        $sqlCommand.Parameters["@ProfilePath"].Value = NullToDBNull -value1 $user.ProfilePath
		        $sqlCommand.Parameters["@HomeDirectory"].Value = NullToDBNull -value1 $user.HomeDirectory
		        $sqlCommand.Parameters["@Company"].Value = $user.Company
		        $sqlCommand.Parameters["@Office"].Value = $user.Office
		        $sqlCommand.Parameters["@Department"].Value = $user.Department
		        $sqlCommand.Parameters["@Division"].Value = $user.Division
		        $sqlCommand.Parameters["@StreetAddress"].Value = NullToDBNull -value1 $user.StreetAddress
		        $sqlCommand.Parameters["@City"].Value = NullToDBNull -value1 $user.City
		        $sqlCommand.Parameters["@State"].Value = NullToDBNull -value1 $user.State
		        $sqlCommand.Parameters["@PostalCode"].Value = NullToDBNull -value1 $user.PostalCode
		        $sqlCommand.Parameters["@Manager"].Value = $user.Manager
		        $sqlCommand.Parameters["@MobilePhone"].Value = NullToDBNull -value1 $user.MobilePhone
		        $sqlCommand.Parameters["@PhoneNumber"].Value = NullToDBNull -value1 $user.telephonenumber
		        $sqlCommand.Parameters["@Fax"].Value = NullToDBNull -value1 $user.Fax
		        $sqlCommand.Parameters["@Pager"].Value = NullToDBNull -value1 $user.Pager
		        $sqlCommand.Parameters["@EMail"].Value = NullToDBNull -value1 $user.mail
				$sqlCommand.Parameters["@LockedOut"].Value = $user.LockedOut
				$sqlCommand.Parameters["@PasswordExpired"].Value = $user.PasswordExpired
				$sqlCommand.Parameters["@PasswordLastSet"].Value = $user.PasswordLastSet
				$sqlCommand.Parameters["@PasswordNeverExpires"].Value = $user.PasswordNeverExpires
				$sqlCommand.Parameters["@PasswordNotRequired"].Value = $user.PasswordNotRequired
				$sqlCommand.Parameters["@TrustedForDelegation"].Value = $user.TrustedForDelegation
				$sqlCommand.Parameters["@TrustedToAuthForDelegation"].Value = $user.TrustedToAuthForDelegation
		        $sqlCommand.Parameters["@DistinguishedName"].Value = $user.DistinguishedName
		        $sqlCommand.Parameters["@UserAccountControl"].Value = $user.UserAccountControl
		        $sqlCommand.Parameters["@SupportedEncryptionTypes"].Value = $user.'msDS-SupportedEncryptionTypes'
		        $sqlCommand.Parameters["@Enabled"].Value = $user.Enabled
		        $sqlCommand.Parameters["@Active"].Value = $true
		        $sqlCommand.Parameters["@LastLogon"].Value = $dLastLogon
		        $sqlCommand.Parameters["@whenCreated"].Value = $user.whenCreated
		        $sqlCommand.Parameters["@whenChanged"].Value = $user.whenChanged
		        $sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)

	            [Void]$sqlCommand.ExecuteNonQuery()
			} Catch [System.Exception] {
				$msg = $_.Exception.Message
			    AddLogEntry $adDomain "Warning" "WriteUserInfo" "$user : $msg" $sqlConnection
				$warningCounter++
			}
			$objectCounter++
	    }
		$sqlCommand.Dispose()
		
		# If this sync is full, then inactivate any object (for this domain) that wasn't touched
		if($syncType -eq "Full"){
			$sqlCommand = GetStoredProc $sqlConnection "ad.spUserInactivateByDate"
		    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
		    [void]$sqlCommand.Parameters.Add("@BeforeDate",  [System.Data.SqlDbType]::datetime)
		    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			$sqlCommand.Parameters["@Domain"].Value = $adDomain
			$sqlCommand.Parameters["@BeforeDate"].Value = $lastFullSync
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
		    [Void]$sqlCommand.ExecuteNonQuery()	
			$sqlCommand.Dispose()
		}
	}
    Catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry $adDomain "Error" "WriteUserInfo" "$msg" $sqlConnection
		$errorCounter++
    } 	
	if($errorCounter -gt 0) {$syncStatus = "Error"}
	elseif($warningCounter -gt 0) {$syncStatus = "Warning"}
	else {$syncStatus = "Success"}

    # Write Log Entry
    [string]$msg = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $syncStatus, $objectCounter, $errorCounter, $warningCounter
	AddLogEntry $adDomain "Info" "WriteUserInfo" "$msg" $sqlConnection
	
	return New-Object psobject -Property @{Status = $syncStatus; ErrorCount = $errorCounter; WarningCount = $warningCounter; ObjectCount = $objectCounter}	
}
#endregion

#region WriteGroupInfo
#************************************************************************************************************************************
# Function WriteGroupInfo
#
# Parameters:
# 	- Connection String
#
# Returns:
#   - Nothing
#
# Writes AD information about groups to ad.Group
#
#************************************************************************************************************************************
Function WriteGroupInfo {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$adDomain,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$adDomainSearchRoot,
	[Parameter(Mandatory=$True,Position=3)]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=4)]
	[datetime]$lastUpdate,
	[Parameter(Mandatory=$True,Position=5)]
	[datetime]$lastFullSync,
	[Parameter(Mandatory=$True,Position=6)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection,
    [Parameter(Mandatory=$False,Position=7)]
    [System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
)
	# Update Process log
	AddLogEntry $adDomain "Info" "WriteGroupInfo" "Starting $syncType check..." $sqlConnection
	
	If($Credential -ne ([System.Management.Automation.PSCredential]::Empty))
	{
		$oDomain = Get-ADDomain -Server $adDomain -credential $Credential
	}
	Else
	{
		$oDomain = Get-ADDomain -Server $adDomain
	}

	[Int32]$warningCounter = 0
	[Int32]$errorCounter = 0
	[Int32]$objectCounter = 0
	Try {
	    # Retrieve groups from AD
		$PropList = @("whenCreated","whenChanged","mail","Description","objectGUID", "GroupScope", "GroupCategory")
		if(($syncType -eq "Incremental") -and ($lastUpdate -gt "01/01/1970")) {
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$groups = Get-ADGroup -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'whenChanged -ge $lastUpdate -and Name -like "*"' -Properties $PropList -Credential $Credential
            } Else {
            	$groups = Get-ADGroup -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'whenChanged -ge $lastUpdate -and Name -like "*"' -Properties $PropList
            }
		} else {
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$groups = Get-ADGroup -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'Name -like "*"' -Properties $PropList -Credential $Credential
            } Else {
            	$groups = Get-ADGroup -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'Name -like "*"' -Properties $PropList
            }
		}
	    		
        $sqlCommand = GetStoredProc $sqlConnection "ad.spGroupUpsert"
	    [void]$sqlCommand.Parameters.Add("@objectGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	    [void]$sqlCommand.Parameters.Add("@SID",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Scope",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Category",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Email",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@DistinguishedName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@whenCreated",  [System.Data.SqlDbType]::datetime)
	    [void]$sqlCommand.Parameters.Add("@whenChanged",  [System.Data.SqlDbType]::datetime)
	    [void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)


	    foreach($group in $groups)
	    {
            try {
		        $sqlCommand.Parameters["@objectGUID"].Value = $group.objectGUID
		        $sqlCommand.Parameters["@SID"].Value = $group.SID.ToString()
		        $sqlCommand.Parameters["@Domain"].Value = $oDomain.dnsRoot # $domainNetBIOSName
		        $sqlCommand.Parameters["@Name"].Value = $group.Name
		        $sqlCommand.Parameters["@Scope"].Value = $group.GroupScope
		        $sqlCommand.Parameters["@Category"].Value = $group.GroupCategory
		        $sqlCommand.Parameters["@Description"].Value = NullToString -value1 $group.Description -value2 ""
		        $sqlCommand.Parameters["@Email"].Value = NullToString -value1 $group.Mail -value2 ""
		        $sqlCommand.Parameters["@DistinguishedName"].Value = $group.DistinguishedName
		        $sqlCommand.Parameters["@whenCreated"].Value = $group.whenCreated
		        $sqlCommand.Parameters["@whenChanged"].Value = $group.whenChanged
		        $sqlCommand.Parameters["@Active"].Value = $true
		        $sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
	        
	            [Void]$sqlCommand.ExecuteNonQuery()
			} 
            Catch [System.Exception] {
				$msg = $_.Exception.Message
			    AddLogEntry $adDomain "Warning" "WriteGroupInfo" "$group : $msg" $sqlConnection
				$warningCounter++
			}
		    $objectCounter++
	    }
		$sqlCommand.Dispose()

		# If this sync is full, then inactivate any object (for this domain) that wasn't touched
		if($syncType -eq "Full"){
			$sqlCommand = GetStoredProc $sqlConnection "ad.spGroupInactivateByDate"
		    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
		    [void]$sqlCommand.Parameters.Add("@BeforeDate",  [System.Data.SqlDbType]::datetime)
		    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			$sqlCommand.Parameters["@Domain"].Value = $adDomain
			$sqlCommand.Parameters["@BeforeDate"].Value = $lastFullSync
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
		    [Void]$sqlCommand.ExecuteNonQuery()	
			$sqlCommand.Dispose()
		}		
	}
    Catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry $adDomain "Error" "WriteGroupInfo" "$msg" $sqlConnection
		$errorCounter++
    }
	
	if($errorCounter -gt 0) {$syncStatus = "Error"}
	elseif($warningCounter -gt 0) {$syncStatus = "Warning"}
	else {$syncStatus = "Success"}

    # Write Log Entry
    [string]$msg = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $syncStatus, $objectCounter, $errorCounter, $warningCounter
	AddLogEntry $adDomain "Info" "WriteGroupInfo" "$msg" $sqlConnection
	
	return New-Object psobject -Property @{Status = $syncStatus; ErrorCount = $errorCounter; WarningCount = $warningCounter; ObjectCount = $objectCounter}	
}
#endregion

#region WriteGroupMemberInfo
#************************************************************************************************************************************
# Function WriteGroupMemberInfo
#
# Parameters:
# 	- Connection String
#
# Returns:
#   - Nothing
#
# Writes AD information about group membership to ad.GroupMember
#
#************************************************************************************************************************************
function WriteGroupMemberInfo {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$adDomain,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$adDomainSearchRoot,
	[Parameter(Mandatory=$True,Position=3)]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=4)]
	[datetime]$lastUpdate,
	[Parameter(Mandatory=$True,Position=5)]
	[datetime]$lastFullSync,
	[Parameter(Mandatory=$True,Position=6)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection,
    [Parameter(Mandatory=$False,Position=7)]
    [System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
)
	# Update Process log
	AddLogEntry $adDomain "Info" "WriteGroupMemberInfo" "Starting $syncType check..." $sqlConnection

	[Int32]$warningCounter = 0
	[Int32]$errorCounter = 0
	[Int32]$objectCounter = 0
	try {
		
        If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    		$Domain = Get-ADDomain -Server $adDomain -Credential $Credential
        } Else {
            $Domain = Get-ADDomain -Server $adDomain
        }
		
	    # Retrieve Security groups from AD
		$PropList = @("Members","objectGUID")
		if(($syncType -eq "Incremental") -and ($lastUpdate -gt "01/01/1970")) {
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$groups = Get-ADGroup -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'whenChanged -ge $lastUpdate -and Name -like "*"' -Properties $PropList -Credential $Credential
            } Else {
            	$groups = Get-ADGroup -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'whenChanged -ge $lastUpdate -and Name -like "*"' -Properties $PropList
            }
		} else {
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$groups = Get-ADGroup -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'Name -like "*"' -Properties $PropList -Credential $Credential
            } Else {
            	$groups = Get-ADGroup -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'Name -like "*"' -Properties $PropList
            }
		}
	    
        $sqlCommand = GetStoredProc $sqlConnection "ad.spGroupMemberUpsert"
        [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
        [void]$sqlCommand.Parameters.Add("@GroupGUID",  [System.Data.SqlDbType]::uniqueidentifier)
        [void]$sqlCommand.Parameters.Add("@MemberGUID",  [System.Data.SqlDbType]::uniqueidentifier)
        [void]$sqlCommand.Parameters.Add("@MemberType",  [System.Data.SqlDbType]::nvarchar)
        [void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
        [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
		
	    foreach($group in $groups)
	    {
			# Get members of class "Group"
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$groupMembers = Get-ADGroupMember -Identity $group -Server $adDomain -Credential $Credential | Where-object {$_.ObjectClass -eq "group"}
            } Else {
            	$groupMembers = Get-ADGroupMember -Identity $group -Server $adDomain | Where-object {$_.ObjectClass -eq "group"}
            }	

	        foreach($groupMember in $groupMembers)
			{
				try {
					#$PropList = @("objectGUID")
					#$adObject = Get-ADObject -Server $adDomain -Identity $groupMember -Properties $PropList
					#if($adObject.objectGUID -and $adObject.objectClass){

					$sqlCommand.Parameters["@Domain"].Value = $oDomain.DNSRoot # $domainNetBIOSName
					$sqlCommand.Parameters["@GroupGUID"].Value = $group.objectGUID
					$sqlCommand.Parameters["@MemberGUID"].Value = $groupMember.objectGUID
					$sqlCommand.Parameters["@MemberType"].Value = $groupMember.objectClass
					$sqlCommand.Parameters["@Active"].Value = $true
					$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)

					[Void]$sqlCommand.ExecuteNonQuery()
					
				} Catch [System.Exception] {
					$msg = $_.Exception.Message
					AddLogEntry $adDomain "Warning" "WriteGroupMemberInfo" "$group : $groupMember : $msg" $sqlConnection
					$warningCounter++
				}
				$objectCounter++
			}

			# Get recursive list of membership (which does not return groups)
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$groupMembers = Get-ADGroupMember -Identity $group -Server $adDomain -Credential $Credential -recursive
            } Else {
            	$groupMembers = Get-ADGroupMember -Identity $group -Server $adDomain -recursive
            }	
					
	        foreach($groupMember in $groupMembers)
			{
				try {
					#$PropList = @("objectGUID")
					#$adObject = Get-ADObject -Server $adDomain -Identity $groupMember -Properties $PropList
					#if($adObject.objectGUID -and $adObject.objectClass){

					$sqlCommand.Parameters["@Domain"].Value = $oDomain.DNSRoot # $domainNetBIOSName
					$sqlCommand.Parameters["@GroupGUID"].Value = $group.objectGUID
					$sqlCommand.Parameters["@MemberGUID"].Value = $groupMember.objectGUID
					$sqlCommand.Parameters["@MemberType"].Value = $groupMember.objectClass
					$sqlCommand.Parameters["@Active"].Value = $true
					$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)

					[Void]$sqlCommand.ExecuteNonQuery()
					
				} Catch [System.Exception] {
					$msg = $_.Exception.Message
					AddLogEntry $adDomain "Warning" "WriteGroupMemberInfo" "$group : $groupMember : $msg" $sqlConnection
					$warningCounter++
				}
				$objectCounter++
			}			
        }
		$sqlCommand.Dispose()

		# If this sync is full, then inactivate any object (for this domain) that wasn't touched
		if($syncType -eq "Full"){
			$sqlCommand = GetStoredProc $sqlConnection "ad.spGroupMemberInactivateByDate"
		    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
		    [void]$sqlCommand.Parameters.Add("@BeforeDate",  [System.Data.SqlDbType]::datetime)
		    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			$sqlCommand.Parameters["@Domain"].Value = $adDomain
			$sqlCommand.Parameters["@BeforeDate"].Value = $lastFullSync
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
		    [Void]$sqlCommand.ExecuteNonQuery()	
			$sqlCommand.Dispose()
		}		
	}
    Catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry $adDomain "Error" "WriteGroupMemberInfo" "$msg" $sqlConnection
		$errorCounter++
    }

	if($errorCounter -gt 0) {$syncStatus = "Error"}
	elseif($warningCounter -gt 0) {$syncStatus = "Warning"}
	else {$syncStatus = "Success"}

    # Write Log Entry
    [string]$msg = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $syncStatus, $objectCounter, $errorCounter, $warningCounter
	AddLogEntry $adDomain "Info" "WriteGroupMemberInfo" "$msg" $sqlConnection
	
    return New-Object psobject -Property @{Status = $syncStatus; ErrorCount = $errorCounter; WarningCount = $warningCounter; ObjectCount = $objectCounter}	
}
#endregion

#region WriteSiteInfo
#************************************************************************************************************************************
# Function WriteSiteInfo
#
# Parameters:
# 	- Connection String
#
# Returns:
#   - Nothing
#
# Writes AD information about sites to ad.Site
#
#************************************************************************************************************************************
Function WriteSiteInfo {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$adForest,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$rootConfigurationNamingContext,
	[Parameter(Mandatory=$True,Position=3)]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=4)]
	[datetime]$lastUpdate,
	[Parameter(Mandatory=$True,Position=5)]
	[datetime]$lastFullSync,
	[Parameter(Mandatory=$True,Position=6)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection,
    [Parameter(Mandatory=$False,Position=7)]
    [System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
)
	# Update Process log
	AddLogEntry $adForest "Info" "WriteSiteInfo" "Starting $syncType check..." $sqlConnection

	[Int32]$warningCounter = 0
	[Int32]$errorCounter = 0
	[Int32]$objectCounter = 0
	try {
        If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
        	$oDomain = Get-ADDomain -Server $adForest -Credential $Credential
        } Else {
            $oDomain = Get-ADDomain -Server $adForest
        }
		
		$sSearchBase = $rootConfigurationNamingContext
		
	    # Retrieve sites from AD
		$Proplist = @("whenCreated","whenChanged","Description","location","objectGUID")
		if(($syncType -eq "Incremental") -and ($lastUpdate -gt "1/1/1970")) {
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$Sites = Get-ADObject -Filter 'whenChanged -ge $lastUpdate -and ObjectClass -eq "site"' -Server $adForest -SearchBase $sSearchBase -Properties $PropList -Credential $Credential
            } Else {
                $Sites = Get-ADObject -Filter 'whenChanged -ge $lastUpdate -and ObjectClass -eq "site"' -Server $adForest -SearchBase $sSearchBase -Properties $PropList
            }
		} else {
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)) {
    			$Sites = Get-ADObject -Filter 'ObjectClass -eq "site"' -Server $adForest -SearchBase $sSearchBase -Properties $PropList -Credential $Credential
            } Else {
                $Sites = Get-ADObject -Filter 'ObjectClass -eq "site"' -Server $adForest -SearchBase $sSearchBase -Properties $PropList
            }
		}
		
        $sqlCommand = GetStoredProc $sqlConnection "ad.spSiteUpsert"
	    [void]$sqlCommand.Parameters.Add("@objectGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Location",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@DistinguishedName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@whenCreated",  [System.Data.SqlDbType]::datetime)
	    [void]$sqlCommand.Parameters.Add("@whenChanged",  [System.Data.SqlDbType]::datetime)
	    [void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
		
		# Iterate through sites, updating the database
		foreach ($Site in $Sites) {
            try {	        
		        $sqlCommand.Parameters["@objectGUID"].Value = $site.objectGUID
		        $sqlCommand.Parameters["@Domain"].Value = $oDomain.DNSRoot
		        $sqlCommand.Parameters["@Name"].Value = $site.Name
		        $sqlCommand.Parameters["@Description"].Value = $site.Description
		        $sqlCommand.Parameters["@Location"].Value = NullToString -value1 $site.Location -value2 ""
		        $sqlCommand.Parameters["@DistinguishedName"].Value = $site.DistinguishedName
		        $sqlCommand.Parameters["@whenCreated"].Value = $site.whenCreated
		        $sqlCommand.Parameters["@whenChanged"].Value = $site.whenChanged
		        $sqlCommand.Parameters["@Active"].Value = $true
		        $sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)

	            [Void]$sqlCommand.ExecuteNonQuery()
            }
            Catch [System.Exception] {
				$msg = $_.Exception.Message
			    AddLogEntry $adDomain "Warning" "WriteSiteInfo" "$site : $msg" $sqlConnection
				$warningCounter++
			}
			$objectCounter++
	    }
		$sqlCommand.Dispose()
		
		# If this sync is full, then inactivate any object (for this domain) that wasn't touched
		if($syncType -eq "Full"){
			$sqlCommand = GetStoredProc $sqlConnection "ad.spSiteInactivateByDate"
		    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
		    [void]$sqlCommand.Parameters.Add("@BeforeDate",  [System.Data.SqlDbType]::datetime)
		    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			$sqlCommand.Parameters["@Domain"].Value = $adDomain
			$sqlCommand.Parameters["@BeforeDate"].Value = $lastFullSync
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
		    [Void]$sqlCommand.ExecuteNonQuery()	
			$sqlCommand.Dispose()
		}
	}		
    Catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry $adDomain "Error" "WriteSiteInfo" $msg $sqlConnection
		$errorCounter++
    }

	if($errorCounter -gt 0) {$syncStatus = "Error"}
	elseif($warningCounter -gt 0) {$syncStatus = "Warning"}
	else {$syncStatus = "Success"}

    # Write Log Entry
    [string]$msg = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $syncStatus, $objectCounter, $errorCounter, $warningCounter
	AddLogEntry $adDomain "Info" "WriteSiteInfo" "$msg" $sqlConnection
	
	return New-Object psobject -Property @{Status = $syncStatus; ErrorCount = $errorCounter; WarningCount = $warningCounter; ObjectCount = $objectCounter}		
}
#endregion

#region WriteSubnetInfo
#************************************************************************************************************************************
# Function WriteSubnetInfo
#
# Parameters:
# 	- Connection String
#	- Domain Configuration Naming Context
#
# Returns:
#   - Nothing
#
# Writes AD information about subnets to ad.Subnet
#
#************************************************************************************************************************************
Function WriteSubnetInfo {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$adForest,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$rootConfigurationNamingContext,
	[Parameter(Mandatory=$True,Position=3)]
	[string]$syncType,
	[Parameter(Mandatory=$True,Position=4)]
	[datetime]$lastUpdate,
	[Parameter(Mandatory=$True,Position=5)]
	[datetime]$lastFullSync,
	[Parameter(Mandatory=$True,Position=6)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection,
    [Parameter(Mandatory=$False,Position=7)]
    [System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
)
	# Update Process log
	AddLogEntry $adForest "Info" "WriteSubnetInfo" "Starting $syncType check..." $sqlConnection

	[Int32]$warningCounter = 0
	[Int32]$errorCounter = 0
	[Int32]$objectCounter = 0
	try {
	    # Retrieve subnets from AD
        If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    		$oDomain = Get-ADDomain -Server $adForest -Credential $Credential
        } Else {
            $oDomain = Get-ADDomain -Server $adForest
        }		
		$sSearchBase = $rootConfigurationNamingContext
		
		$Proplist = @("whenCreated","whenChanged","Description","objectGUID","Location","siteObject")
		if(($syncType -eq "Incremental") -and ($lastUpdate -gt "1/1/1970")) {
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$subNets = Get-ADObject -Filter 'whenChanged -ge $lastUpdate -and ObjectClass -eq "subnet"' -Server $adForest -SearchBase $sSearchBase -Properties $PropList -Credential $Credential
            } Else {
                $subNets = Get-ADObject -Filter 'whenChanged -ge $lastUpdate -and ObjectClass -eq "subnet"' -Server $adForest -SearchBase $sSearchBase -Properties $PropList
            }
		} else {
            If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    			$subNets = Get-ADObject -Filter 'ObjectClass -eq "subnet"' -Server $adForest -SearchBase $sSearchBase -Properties $PropList -Credential $Credential
            } Else {
                $subNets = Get-ADObject -Filter 'ObjectClass -eq "subnet"' -Server $adForest -SearchBase $sSearchBase -Properties $PropList
            }
		}
		
		$sqlCommand = GetStoredProc $sqlConnection "ad.spSubnetUpsert"
	    [void]$sqlCommand.Parameters.Add("@objectGUID",  [System.Data.SqlDbType]::uniqueidentifier)
	    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Location",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@Site",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@DistinguishedName",  [System.Data.SqlDbType]::nvarchar)
	    [void]$sqlCommand.Parameters.Add("@whenCreated",  [System.Data.SqlDbType]::datetime)
	    [void]$sqlCommand.Parameters.Add("@whenChanged",  [System.Data.SqlDbType]::datetime)
	    [void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
	
		foreach ($subNet in $subNets) {
            try {
		        $sqlCommand.Parameters["@objectGUID"].Value = $subnet.objectGUID
		        $sqlCommand.Parameters["@Domain"].Value = $oDomain.DNSRoot
		        $sqlCommand.Parameters["@Name"].Value = $subnet.Name
		        $sqlCommand.Parameters["@Description"].Value = $subnet.Description
		        $sqlCommand.Parameters["@Location"].Value = NullToString -value1 $subnet.Location -value2 ""
		        $sqlCommand.Parameters["@Site"].Value = $subnet.siteObject
		        $sqlCommand.Parameters["@DistinguishedName"].Value = $subnet.DistinguishedName
		        $sqlCommand.Parameters["@whenCreated"].Value = $subnet.whenCreated
		        $sqlCommand.Parameters["@whenChanged"].Value = $subnet.whenChanged
		        $sqlCommand.Parameters["@Active"].Value = $true
		        $sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)

	            [Void]$sqlCommand.ExecuteNonQuery()
            }
            Catch [System.Exception] {
				$msg = $_.Exception.Message
			    AddLogEntry $adDomain "Warning" "WriteSubnetInfo" "$subnet : $msg" $sqlConnection
				$warningCounter++
			}
			$objectCounter++			
	    }  
		$sqlCommand.Dispose()

		# If this sync is full, then inactivate any object (for this domain) that wasn't touched
		if($syncType -eq "Full"){
			$sqlCommand = GetStoredProc $sqlConnection "ad.spSubnetInactivateByDate"
		    [void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
		    [void]$sqlCommand.Parameters.Add("@BeforeDate",  [System.Data.SqlDbType]::datetime)
		    [void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			$sqlCommand.Parameters["@Domain"].Value = $adDomain
			$sqlCommand.Parameters["@BeforeDate"].Value = $lastFullSync
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
		    [Void]$sqlCommand.ExecuteNonQuery()	
			$sqlCommand.Dispose()
		}
	}
    Catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry $adForest "Error" "WriteSubnetInfo" $msg $sqlConnection
		$errorCounter++
    } 

	if($errorCounter -gt 0) {$syncStatus = "Error"}
	elseif($warningCounter -gt 0) {$syncStatus = "Warning"}
	else {$syncStatus = "Success"}

    # Write Log Entry
    [string]$msg = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $syncStatus, $objectCounter, $errorCounter, $warningCounter
	AddLogEntry $adDomain "Info" "WriteSubnetInfo" "$msg" $sqlConnection
	
	return New-Object psobject -Property @{Status = $syncStatus; ErrorCount = $errorCounter; WarningCount = $warningCounter; ObjectCount = $objectCounter}	
}
#endregion



#region WriteServiceAccountInfo
#************************************************************************************************************************************
# Function WriteServiceAccountInfo
#
# Parameters:
# 	- Connection String
#
# Returns:
#   - Nothing
#
# Writes AD information about servers to ad.ServiceAccount
#
#************************************************************************************************************************************
Function WriteServiceAccountInfo {
	[CmdletBinding()]
	param(
		  [Parameter(Mandatory=$True,Position=1)]
		[string]$adDomain,
		  [Parameter(Mandatory=$True,Position=2)]
		[string]$adDomainSearchRoot,
		  [Parameter(Mandatory=$True,Position=3)]
		[string]$syncType,
		  [Parameter(Mandatory=$True,Position=4)]
		[datetime]$lastUpdate,
		  [Parameter(Mandatory=$True,Position=5)]
		[datetime]$lastFullSync,
		  [Parameter(Mandatory=$True,Position=6)]
		   [System.Data.SqlClient.SqlConnection]$sqlConnection,
		[Parameter(Mandatory=$False,Position=7)]
		[System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
	)
	
	# Update Process log
	AddLogEntry $adDomain "Info" "WriteServiceAccountInfo" "Starting $syncType Check..." $sqlConnection
		
	[Int32]$warningCounter = 0
	[Int32]$errorCounter = 0
	[Int32]$objectCounter = 0
	Try {
		If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
			$oDomain = Get-ADDomain -Server $adDomain -Credential $Credential
		} Else {
			$oDomain = Get-ADDomain -Server $adDomain
		}
		# $domainNetBIOSName = $oDomain.NetBIOSName
			
		# Retrieve service accounts from AD where OSName is like *Server*
		$PropList = @("LastLogonDate", "whenCreated", "whenChanged", "Description", "TrustedForDelegation","objectGUID","dnsHostName","LastLogonTimeStamp","userAccountControl","msDS-SupportedEncryptionTypes","servicePrincipalName","msDS-GroupMSAMembership")
		if(($syncType -eq "Incremental") -and ($lastUpdate -gt "01/01/1970")) {
			If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
				$serviceAccounts = Get-ADServiceAccount -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'whenChanged -ge $lastUpdate -and Name -like "*"' -Properties $PropList -Credential $Credential
			} Else {
				$serviceAccounts = Get-ADServiceAccount -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'whenChanged -ge $lastUpdate -and Name -like "*"' -Properties $PropList
			}
		} else {
			If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
				$serviceAccounts = Get-ADServiceAccount -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'Name -like "*"' -Properties $PropList -Credential $Credential
			} Else {
				$serviceAccounts = Get-ADServiceAccount -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'Name -like "*"' -Properties $PropList
			}
		}
			
		$sqlCommand = GetStoredProc -sqlConnection $sqlConnection -sqlCommandName "ad.spServiceAccountUpsert"
		[Void]$sqlCommand.Parameters.Add("@objectGUID", [system.data.SqlDbType]::uniqueidentifier)
		[Void]$sqlCommand.Parameters.Add("@SID", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Trusted", [system.data.SqlDbType]::bit)
		[Void]$sqlCommand.Parameters.Add("@Description", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@DistinguishedName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@PrincipalsAllowedToRetrievePassword", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@UserAccountControl", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@ServicePrincipalNames", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@SupportedEncryptionTypes", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Enabled", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@LastLogon", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@whenCreated", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@whenChanged", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::Datetime)
			
		foreach($serviceAccount in $serviceAccounts)
		{
			try {
				if($null -eq $serviceAccount.LastLogonDate){$dLastLogon = [System.DBNull]::Value} else {$dLastLogon = [DateTime]::FromFileTime([Int64] $serviceAccount.lastlogontimestamp)}
				$passwordPrincipals = ""

				$sqlCommand.Parameters["@objectGUID"].value = $serviceAccount.objectGUID
				$sqlCommand.Parameters["@SID"].value = $serviceAccount.SID.ToString()
				$sqlCommand.Parameters["@Domain"].value = $oDomain.DNSRoot
				$sqlCommand.Parameters["@Name"].value = $serviceAccount.Name	
				$sqlCommand.Parameters["@dnsHostName"].value = NullToString -value1 $serviceAccount.dnsHostName -value2 ""
				$sqlCommand.Parameters["@Trusted"].value = $serviceAccount.TrustedForDelegation
				$sqlCommand.Parameters["@Description"].value = NullToString -value1 $serviceAccount.Description -value2 ""
				$sqlCommand.Parameters["@DistinguishedName"].value = $serviceAccount.DistinguishedName
				$sqlCommand.Parameters["@PrincipalsAllowedToRetrievePassword"].value = $passwordPrincipals
				$sqlCommand.Parameters["@UserAccountControl"].value = $serviceAccount.UserAccountControl
				$sqlCommand.Parameters["@ServicePrincipalNames"].value = NullToString -value1 $serviceAccount.servicePrincipalName -value2 ""
				$sqlCommand.Parameters["@SupportedEncryptionTypes"].value = NullToString -value1 $serviceAccount.'msDS-SupportedEncryptionTypes' -value2 ""
				$sqlCommand.Parameters["@Enabled"].value = $serviceAccount.Enabled
				$sqlCommand.Parameters["@Active"].value = $true
				$sqlCommand.Parameters["@LastLogon"].value = $dLastLogon
				$sqlCommand.Parameters["@whenCreated"].value = $serviceAccount.whenCreated
				$sqlCommand.Parameters["@whenChanged"].value = $serviceAccount.whenChanged
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				
				[Void]$sqlCommand.ExecuteNonQuery()
					
			} Catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $adDomain "Warning" "WriteServiceAccountInfo" "$serviceaccount : $msg" $sqlConnection
				$warningCounter++
			}
			$objectCounter++
		}
		$sqlCommand.Dispose()
	
		# If this sync is full, then inactivate any object (for this domain) that wasn't touched
		if($syncType -eq "Full"){
			$sqlCommand = GetStoredProc $sqlConnection "ad.spServiceAccountInactivateByDate"
			[void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@BeforeDate",  [System.Data.SqlDbType]::datetime)
			[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			$sqlCommand.Parameters["@Domain"].Value = $adDomain
			$sqlCommand.Parameters["@BeforeDate"].Value = $lastFullSync
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			[Void]$sqlCommand.ExecuteNonQuery()	
			$sqlCommand.Dispose()
		}		
	}
	Catch [System.Exception] {
		$msg = $_.Exception.Message
		AddLogEntry $adDomain "Error" "WriteServiceAccountInfo" "$msg" $sqlConnection
		$errorCounter++
	}
	if($errorCounter -gt 0) {$syncStatus = "Error"}
	elseif($warningCounter -gt 0) {$syncStatus = "Warning"}
	else {$syncStatus = "Success"}
	
	# Write Log Entry
	[string]$msg = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $syncStatus, $objectCounter, $errorCounter, $warningCounter
	AddLogEntry $adDomain "Info" "WriteServiceAccountInfo" "$msg" $sqlConnection
	
	return New-Object psobject -Property @{Status = $syncStatus; ErrorCount = $errorCounter; WarningCount = $warningCounter; ObjectCount = $objectCounter}
	
}
#endregion


#region WriteOrganizationalUnitInfo
#************************************************************************************************************************************
# Function WriteOrganizationalUnitInfo
#
# Parameters:
# 	- Connection String
#
# Returns:
#   - Nothing
#
# Writes AD information about OrganizationalUnit to ad.OrganizationalUnit
#
#************************************************************************************************************************************
Function WriteOrganizationalUnitInfo {
	[CmdletBinding()]
	param(
		  [Parameter(Mandatory=$True,Position=1)]
		[string]$adDomain,
		  [Parameter(Mandatory=$True,Position=2)]
		[string]$adDomainSearchRoot,
		  [Parameter(Mandatory=$True,Position=3)]
		[string]$syncType,
		  [Parameter(Mandatory=$True,Position=4)]
		[datetime]$lastUpdate,
		  [Parameter(Mandatory=$True,Position=5)]
		[datetime]$lastFullSync,
		  [Parameter(Mandatory=$True,Position=6)]
		   [System.Data.SqlClient.SqlConnection]$sqlConnection,
		[Parameter(Mandatory=$False,Position=7)]
		[System.Management.Automation.CredentialAttribute()]$Credential=([System.Management.Automation.PSCredential]::Empty)
	)
	
	# Update Process log
	AddLogEntry $adDomain "Info" "WriteOrganizationalUnitInfo" "Starting $syncType Check..." $sqlConnection
		
	[Int32]$warningCounter = 0
	[Int32]$errorCounter = 0
	[Int32]$objectCounter = 0
	Try {
		If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
			$oDomain = Get-ADDomain -Server $adDomain -Credential $Credential
		} Else {
			$oDomain = Get-ADDomain -Server $adDomain
		}
			
		# Retrieve service accounts from AD where OSName is like *Server*
		# $PropList = @("LastLogonDate", "whenCreated", "whenChanged", "Description", "TrustedForDelegation","objectGUID","dnsHostName","LastLogonTimeStamp","userAccountControl","msDS-SupportedEncryptionTypes","servicePrincipalName","msDS-GroupMSAMembership")
		if(($syncType -eq "Incremental") -and ($lastUpdate -gt "01/01/1970")) {
			If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
				$OrganizationalUnits = Get-ADOrganizationalUnit -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'whenChanged -ge $lastUpdate -and Name -like "*"' -Properties * -Credential $Credential
			} Else {
				$OrganizationalUnits = Get-ADOrganizationalUnit -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'whenChanged -ge $lastUpdate -and Name -like "*"' -Properties *
			}
		} else {
			If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
				$Containers = Get-ADObject -LDAPFilter '(objectClass=container)' -Server $adDomain -searchBase $adDomainSearchRoot -properties "*" -Credential $Credential | Where-Object {$_.IsSystemCriticalObject -eq $true} 
				$OrganizationalUnits = Get-ADOrganizationalUnit -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'Name -like "*"' -Properties "*" -Credential $Credential
			} Else {
				$Containers = Get-ADObject -LDAPFilter '(objectClass=container)' -Server $adDomain -searchBase $adDomainSearchRoot -properties "*" | Where-Object {$_.IsSystemCriticalObject -eq $true} 
				$OrganizationalUnits = Get-ADOrganizationalUnit -Server $adDomain -searchBase $adDomainSearchRoot -Filter 'Name -like "*"' -Properties "*"
			}
		}
			
		$sqlCommand = GetStoredProc -sqlConnection $sqlConnection -sqlCommandName "ad.spOrganizationalUnitUpsert"
		[Void]$sqlCommand.Parameters.Add("@objectGUID", [system.data.SqlDbType]::uniqueidentifier)
		[Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Description", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@DistinguishedName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@StreetAddress", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@City", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@State", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Country", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@PostalCode", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Protected", [system.data.SqlDbType]::bit)
		[Void]$sqlCommand.Parameters.Add("@whenCreated", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@whenChanged", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::Datetime)
			
		foreach($OrganizationalUnit in $OrganizationalUnits)
		{
			try {

				$sqlCommand.Parameters["@objectGUID"].value = $OrganizationalUnit.objectGUID
				$sqlCommand.Parameters["@Domain"].value = $oDomain.DNSRoot
				$sqlCommand.Parameters["@Name"].value = $OrganizationalUnit.Name	
				$sqlCommand.Parameters["@Description"].value = NullToString -value1 $OrganizationalUnit.Description -value2 ""
				$sqlCommand.Parameters["@DistinguishedName"].value = $OrganizationalUnit.DistinguishedName
				$sqlCommand.Parameters["@StreetAddress"].value = NullToString -value1 $OrganizationalUnit.StreetAddress -value2 ""
				$sqlCommand.Parameters["@City"].value = NullToString -value1 $OrganizationalUnit.City -value2 ""
				$sqlCommand.Parameters["@State"].value = NullToString -value1 $OrganizationalUnit.State -value2 ""
				$sqlCommand.Parameters["@Country"].value = NullToString -value1 $OrganizationalUnit.Country -value2 ""
				$sqlCommand.Parameters["@PostalCode"].value = NullToString -value1 $OrganizationalUnit.PostalCode -value2 ""
				$sqlCommand.Parameters["@Protected"].value = $OrganizationalUnit.ProtectedFromAccidentalDeletion
				$sqlCommand.Parameters["@whenCreated"].value = $OrganizationalUnit.whenCreated
				$sqlCommand.Parameters["@whenChanged"].value = $OrganizationalUnit.whenChanged
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				
				[Void]$sqlCommand.ExecuteNonQuery()
					
			} Catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $adDomain "Warning" "WriteOrganizationalUnitInfo" "$OrganizationalUnit : $msg" $sqlConnection
				$warningCounter++
			}
			$objectCounter++
		}

		foreach($Container in $Containers)
		{
			try {

				$sqlCommand.Parameters["@objectGUID"].value = $Container.objectGUID
				$sqlCommand.Parameters["@Domain"].value = $Container.DNSRoot
				$sqlCommand.Parameters["@Name"].value = $Container.Name	
				$sqlCommand.Parameters["@Description"].value = NullToString -value1 $Container.Description -value2 ""
				$sqlCommand.Parameters["@DistinguishedName"].value = $Container.DistinguishedName
				$sqlCommand.Parameters["@StreetAddress"].value = [System.DBNull]::Value
				$sqlCommand.Parameters["@City"].value = [System.DBNull]::Value
				$sqlCommand.Parameters["@State"].value = [System.DBNull]::Value
				$sqlCommand.Parameters["@Country"].value = [System.DBNull]::Value
				$sqlCommand.Parameters["@PostalCode"].value = [System.DBNull]::Value
				$sqlCommand.Parameters["@Protected"].value = $Container.ProtectedFromAccidentalDeletion
				$sqlCommand.Parameters["@whenCreated"].value = $Container.whenCreated
				$sqlCommand.Parameters["@whenChanged"].value = $Container.whenChanged
				$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
				
				[Void]$sqlCommand.ExecuteNonQuery()
					
			} Catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $adDomain "Warning" "WriteOrganizationalUnitInfo" "$OrganizationalUnit : $msg" $sqlConnection
				$warningCounter++
			}
			$objectCounter++
		}		
		$sqlCommand.Dispose()
	
		# If this sync is full, then inactivate any object (for this domain) that wasn't touched
		if($syncType -eq "Full"){
			$sqlCommand = GetStoredProc $sqlConnection "ad.spOrganizationalUnitInactivateByDate"
			[void]$sqlCommand.Parameters.Add("@Domain",  [System.Data.SqlDbType]::nvarchar)
			[void]$sqlCommand.Parameters.Add("@BeforeDate",  [System.Data.SqlDbType]::datetime)
			[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
			$sqlCommand.Parameters["@Domain"].Value = $oDomain.DNSRoot
			$sqlCommand.Parameters["@BeforeDate"].Value = $lastFullSync
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			[Void]$sqlCommand.ExecuteNonQuery()	
			$sqlCommand.Dispose()
		}		
	}
	Catch [System.Exception] {
		$msg = $_.Exception.Message
		AddLogEntry $adDomain "Error" "WriteOrganizationalUnitInfo" "$msg" $sqlConnection
		$errorCounter++
	}
	if($errorCounter -gt 0) {$syncStatus = "Error"}
	elseif($warningCounter -gt 0) {$syncStatus = "Warning"}
	else {$syncStatus = "Success"}
	
	# Write Log Entry
	[string]$msg = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $syncStatus, $objectCounter, $errorCounter, $warningCounter
	AddLogEntry $adDomain "Info" "WriteOrganizationalUnitInfo" "$msg" $sqlConnection
	
	return New-Object psobject -Property @{Status = $syncStatus; ErrorCount = $errorCounter; WarningCount = $warningCounter; ObjectCount = $objectCounter}
	
}
#endregion


################################################################################
# SET UP ENVIRONMENT
# 1. CONNECT TO SQL 
# 2. LOAD AD COMPONENTS
# 3. CONNECT TO AD
################################################################################

################################################################################
# LOAD APPLICATION CONFIGURATION FILE
################################################################################
If(Test-Path "app.monitor.config"){
	Try {
		[xml]$appConfig = Get-Content "app.monitor.config"
	} Catch {
		Throw "Unable to process XML in configuration file!"
	}
} else {
	Throw "Unable to load config file!"
}

################################################################################
# ESTABLISH CONNECTION TO CENTRAL REPOSITORY
################################################################################
[string]$sqlConnectionString = $appConfig.configuration.connectionstrings.centralrepository.connectionstring
[System.Data.SqlClient.SqlConnection]$sqlConnection = GetSQLConnection -sqlConnectionString $sqlConnectionString

# Check state of the connection object
if ($sqlConnection.State -ne "Open")	{
	Throw "Error: Unable to connect to central repository.  Application terminating."
}

################################################################################
# ADD ACTIVE DIRECTORY MODULE
################################################################################
Try {
  Import-Module ActiveDirectory -ErrorAction Stop
}
Catch {
  Throw "Error: ActiveDirectory Module couldn't be loaded; be sure it has been installed." 
}

################################################################################
# CONNECT TO ACTIVE DIRECTORY
################################################################################
try {
    If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    	$domainDSE = Get-ADRootDSE -Server $adDomain -ErrorAction Stop -Credential $Credential
    } Else {
        $domainDSE = Get-ADRootDSE -Server $adDomain -ErrorAction Stop
    }
}
Catch {
	Throw "Error: Unable to connect to domain $adDomain." 
}

################################################################################
# NEATNESS AND CONSISTENCY COUNT; CONVERT PARAMS TO LOWER CASE
################################################################################
$adDomain = $adDomain.ToLower()

$syncType = $syncType.ToLower()


################################################################################
# BEGIN MAIN PORTION OF SCRIPT
################################################################################
Write-Host "****** Starting process ******"
Write-Host "Domain:      $adDomain"
Write-Host "Objects:     $adObjectType"
Write-Host "SyncType:    $SyncType"
Write-Host "Search root: $adSearchRoot"
Write-Host "******************************"

# Collect Forest Information
if($adObjectType -contains "forest"){
    If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
        $oForest = Get-ADForest -Server $adDomain -Credential $Credential
        $adForest = $oForest.RootDomain
        # $oForestDomain = Get-ADDomain -Server $adForest -Credential $Credential
    } Else {
        $oForest = Get-ADForest -Server $adDomain
        $adForest = $oForest.RootDomain
        # $oForestDomain = Get-ADDomain -Server $adForest
    }
}

# Collect Domain Information
If($Credential -ne ([System.Management.Automation.PSCredential]::Empty)){
    $oDomain = Get-ADDomain -Server $adDomain -Credential $Credential
    $domainDNSRoot = $oDomain.DNSRoot.ToLower()
} Else {
    $oDomain = Get-ADDomain -Server $adDomain
    $domainDNSRoot = $oDomain.DNSRoot.ToLower()
}

# Collect Domain Naming contexts
$domainDefaultNamingContext = $domainDSE.DefaultNamingContext
$domainConfigurationNamingContext = $domainDSE.ConfigurationNamingContext

# Validate the domain search context (or set to default if not supplied
if(!$adSearchRoot){
	[string]$domainSearchRoot = $domainDefaultNamingContext
} else {
	Try {
		if([adsi]::Exists("LDAP://$adSearchRoot")) {
			[string]$domainSearchRoot = $adSearchRoot
		} else {
			Throw "Search root: $adSearchRoot does not exist."
		}
	}
	Catch {
		Throw "Search root: $adSearchRoot is invalid."
	}
}

# Set error counters
[int]$errorCounter = 0
[int]$warningCounter = 0

# Loop through each of the object types to be sync'ed
foreach ($object in $adObjectType) {
	$object = $object.ToLower()
	
	# Get the last synch status
	$lastSyncStatus = GetSyncStatus -adDomain $domainDNSRoot -adObjectType $object -sqlConnection $sqlConnection -Credential $Credential
	if($lastSyncStatus.LastSyncType -eq "In process") {
		# There is a synch already in process, check if it's more than an hour old
        [datetime]$lastStart = $lastSyncStatus.LastStartDate
        [datetime]$currentTime = (Get-Date)
        [timespan]$timeDiff = New-TimeSpan -Start $lastStart -End $currentTime
        If($timeDiff.TotalMinutes -gt 90 -or $Force){
		    # An old, probably stale synch, let's try to restart it (cringe); retrieve values for $lastUpdate and $lastFullSync
		    [datetime]$lastUpdate = MaxDate $lastSyncStatus.LastFullSync $lastSyncStatus.LastIncrementalSync
		    [datetime]$lastFullSync = $lastSyncStatus.LastFullSync
        } else {
    		Write-Host "$object : A synchronization is already in process. Wait 90 minutes to retry, or use -Force option." -ForegroundColor Red
	    	AddLogEntry $domainDNSRoot "Warning" "GetSyncStatus" "$object : A synchronization is already in process. Wait 90 minutes to retry, or use -Force option." $sqlConnection
		    $warningCounter++
		    continue
        }
	} elseif ($lastSyncStatus.LastSyncType -eq "None") {
		# There has not been a successful previous sync, set $syncType to full
		$syncType = "Full"
		[datetime]$lastUpdate = MaxDate $lastSyncStatus.LastFullSync $lastSyncStatus.LastIncrementalSync
		[datetime]$lastFullSync = $lastSyncStatus.LastFullSync
	} else {
		# This is the normal condition; retrieve values for $lastUpdate and $lastFullSync
		[datetime]$lastUpdate = MaxDate $lastSyncStatus.LastFullSync $lastSyncStatus.LastIncrementalSync
		[datetime]$lastFullSync = $lastSyncStatus.LastFullSync
	}
	
    # Update ad.SyncStatus to indicate a sync is starting
	$startDate = Get-Date
    SetSyncStatus -adDomain $domainDNSRoot -adObjectType $object -SyncType $syncType -startDate $startDate -syncStatus "Starting..." -sqlConnection $sqlConnection -Credential $Credential

	switch ($object) {
		"forest" 		{
                            $result = WriteForestInfo -adForest $adForest -sqlConnection $sqlConnection -Credential $Credential
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}
		"domain" 		{
							$result = WriteDomainInfo -adDomain $domainDNSRoot -sqlConnection $sqlConnection -Credential $Credential
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}
		"computer" 		{
                            $result = WriteComputerInfo -adDomain $domainDNSRoot -adDomainSearchRoot $domainSearchRoot -SyncType $syncType -LastUpdate $lastUpdate -lastFullSync $lastFullSync -sqlConnection $sqlConnection -Credential $Credential -subClass all 
                            $errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}
		"server" 		{
                            $result = WriteComputerInfo -adDomain $domainDNSRoot -adDomainSearchRoot $domainSearchRoot -SyncType $syncType -LastUpdate $lastUpdate -lastFullSync $lastFullSync -sqlConnection $sqlConnection -Credential $Credential -subClass server
                            $errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}
		"user" 			{
                            $result = WriteUserInfo -adDomain $domainDNSRoot -adDomainSearchRoot $domainSearchRoot -SyncType $syncType -LastUpdate $lastUpdate -lastFullSync $lastFullSync -sqlConnection $sqlConnection -Credential $Credential
                            $errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}
		"group"			{
                            $result = WriteGroupInfo -adDomain $domainDNSRoot -adDomainSearchRoot $domainSearchRoot -SyncType $syncType -lastUpdate $lastUpdate -lastFullSync $lastFullSync -sqlConnection $sqlConnection -Credential $Credential
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}		
		"groupmember"	{
                            $result = WriteGroupMemberInfo -adDomain $domainDNSRoot -adDomainSearchRoot $domainSearchRoot -SyncType $syncType -lastUpdate $lastUpdate -lastFullSync $lastFullSync -sqlConnection $sqlConnection -Credential $Credential
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}
		"site"			{
							$result = WriteSiteInfo -adForest $adForest -rootConfigurationNamingContext $domainConfigurationNamingContext -syncType $syncType -lastUpdate $lastUpdate -lastFullSync $lastFullSync -sqlConnection $sqlConnection -Credential $Credential
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}
		"subnet"		{
							$result = WriteSubnetInfo -adForest $adForest -rootConfigurationNamingContext $domainConfigurationNamingContext -syncType $syncType -lastUpdate $lastUpdate -lastFullSync $lastFullSync -sqlConnection $sqlConnection -Credential $Credential
							$errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}
		"serviceaccount"{
                            $result = WriteServiceAccountInfo -adDomain $domainDNSRoot -adDomainSearchRoot $domainSearchRoot -SyncType $syncType -LastUpdate $lastUpdate -lastFullSync $lastFullSync -sqlConnection $sqlConnection -Credential $Credential
                            $errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}
		"organizationalunit"{
                            $result = WriteOrganizationalUnitInfo -adDomain $domainDNSRoot -adDomainSearchRoot $domainSearchRoot -SyncType $syncType -LastUpdate $lastUpdate -lastFullSync $lastFullSync -sqlConnection $sqlConnection -Credential $Credential
                            $errorCounter += $result.ErrorCount
							$warningCounter += $result.WarningCount
						}
		"default"		{
			Write-Host "$object : Invalid object type."
			continue
		}
	}

	$endDate = Get-Date	
	
	# Update ad.SyncStatus to indicate a sync is completed
	[string]$syncStatus = "{0} : {1} object(s) : {2} error(s); {3} warning(s)" -f $result.Status, $result.ObjectCount, $result.ErrorCount, $result.WarningCount
	SetSyncStatus -adDomain $domainDNSRoot -adObjectType $object -SyncType $syncType -startDate $startDate -endDate $endDate -objectCount $result.ObjectCount -syncStatus $syncStatus -sqlConnection $sqlConnection -Credential $Credential
	[string]$objectString = $object.PadRight(14," ")
	Write-Host "$objectString : $syncStatus"
}

################################################################################
# CLEANUP
################################################################################
[Void]$sqlConnection.Close
$sqlConnection.Dispose()
Write-Host "***** Process completed ******"

