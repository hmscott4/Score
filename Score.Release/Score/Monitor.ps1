#************************************************************************************************************************************
# FileName:		Monitor.ps1
# Date:			2015/01/18
# Author:		Hugh Scott
#
# Description:
# This script contains utility functions and a wrapper process to check various aspects of a computer's
# performance and configuration.  Performance metrics and configurations are written 
# to a database for centralized reporting and monitoring.
#
# Parameters:
#	$Checks			- Array of strings of checks to perform (see below)
#	$Maintenance	- Array of strings of maintenance to perform (see below)
#	[$filename]		- [optional] Filename with list of servers to check
#	[$AgentName]	- [optional] If using the database to source list of servers, this can be used to filter selections
#
# Valid values for checkString are:
#		"Comp"  	Check computersystem; all
#		"Os"  		Check operatingsystem; all
#		"Disk"  	Check logical volume, physical disk and partitions; phys only
#		"DiskSpc"  	Check logical volume space utilization; phys only
#		"Clus"   	Check cluster configuration; all
#		"CompShr"  	Check for computer share information; all
#		"InstApp"   Check installed applications; phys only
#		"Net"  		Check network configuration; phys only
#		"NLB"  		Check network load balance configuration and state; phys only
#		"Svcs"  	Check services; phys only
#		"HotFix"  	Check installed hotfixes; phys only
#		"DiscSQL"  	Discover installed SQL instances; all
#		"RptSvr"  	Check SQL Reporting Services; only for discovered instances
#		"SQLEng"  	Check SQL Database Engine; only for discovered instances
#		"SQLSize"  	Check SQL Database Size; only for discovered instances
#		"Olap"  	Check SQL OLAP Engine; only for discovered instances
#		"SQLJob"  	Check SQL Agent Jobs; only for discovered instances
#		"SQLPerm"  	Check SQL Permissions; only for discovered instances
#		"WebURL"	Check URL; URLs must be manually entered
#		"SysEvtLog" Check Windows System Event Log for critical events (WARNING!!!!! This can consume a large amount of space and time); phys only
#		"AppEvtLog" Check Windows Application Event Log for critical events (WARNING!!!!! This can consume a large amount of space and time); phys only
#
# Valid values for maintenanceString: are:
#		"WriteHist" - Update daily history tables for Storage, Database Size and Analysis Server Database Size
#		"PurgeLog" - Purge entries from Process Log
#		"PurgeEvt" - Purge entries from Process Log
#		"PurgeHist" - Purge entries from History tables
#
# Usage:
#   ./Monitor.ps1 -Checks "Comp","OS" -fileName <myServerList.txt>
#   ./Monitor.ps1 -Maintenance "Hist"
#   ./Monitor.ps1 -Checks "Comp","OS"
#   ./Monitor.ps1 -Checks "Comp","OS" -Maintenance "Hist"
#
#
# Modification History:
# Date			Developer		Comments
# 2015/03/02	Hugh Scott		Complete rewrite of old code
#
#************************************************************************************************************************************
[CmdletBinding()]
Param(
	[Parameter(ParameterSetName="Monitor",Mandatory=$false,Position=0)]
	[ValidateSet("Comp","Os","Disk","DiskSpc","Clus","CompShr","Hotfix","InstApp","Net","NLB","Svcs","DiscSQL","RptSvr","SQLEng","SQLSize","Olap","SQLRpt","SQLJob","SQLPerm","SysEvtLog","AppEvtLog","WebURL")]  
	[string[]]$Checks=$null,
	[Parameter(ParameterSetName="Maintenance",Mandatory=$false,Position=1)]
	[ValidateSet("PurgeLog","PurgeEvt","PurgeHist","WriteHist")]
	[string[]]$Maintenance=$null,
	[Parameter(ParameterSetName="Monitor",Mandatory=$false,Position=2)]
	[string]$fileName=$null,
	[Parameter(ParameterSetName="Monitor",Mandatory=$false,Position=3)]
	[string]$agentName=$null,
	[Parameter(ParameterSetName="Monitor",Mandatory=$false,Position=4)]
	[Parameter(ParameterSetName="Maintenance",Mandatory=$false,Position=4)]
	[switch]$WhatIf=$false
)

Set-StrictMode -Version Latest

#************************************************************************************************************************************
# function GetComputerListFromFile
#
# Parameters:
#   $fileName
#
# build a data table of computers to check from file
#************************************************************************************************************************************
function GetComputerListFromFile {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$true,Position=1)]
	[string]$fileName	
)
	$dataTable = New-Object system.Data.DataTable
	$col1 = New-Object system.Data.DataColumn dnsHostName, ([string])
	$dataTable.Columns.Add($col1)

	$computers = Get-Content($fileName)
	foreach($computer in $computers) {
		$dataTable.Rows.Add($computer) | Out-Null
	}
	# when a PowerShell function detects that you are retuning a enumerable object (such as a collection), 
	# it places each member of the collection on the pipeline as a separate item.
	# http://viziblr.com/news/2013/5/27/returning-collections-from-functions-in-powershell-a-tip-for.html
	return @(,$dataTable)

}

#************************************************************************************************************************************
# function GetComputerListFromRepository
#
# Parameters:
#   $sqlConnection: SQL Server connection object
#	$agentName: 	filter list of computers to retrieve
#
# build a data table of computers to check from central repository
#************************************************************************************************************************************
function GetComputerListFromRepository {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$true,Position=1)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection,
	[Parameter(Mandatory=$false,Position=2)]
	[string]$agentName=$null
)
	
	Try {
		# Retrieve list of computers by agent name
		$sqlCommand = GetStoredProc $sqlConnection "dbo.spComputerSelectByAgentName"
		[Void]$sqlCommand.Parameters.Add("@agentName", [system.data.SqlDbType]::nvarchar)
		$sqlCommand.Parameters["@agentName"].value = $agentName
		[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
		$sqlCommand.Parameters["@Active"].value = $true

		$sqlReader = $sqlCommand.ExecuteReader()
		$sqlCommand.Dispose()

		$dataTable = New-Object System.Data.DataTable
		$dataTable.Load($SqlReader)
	}
	Catch [System.Exception] {
		$dataTable = $null
		$msg = $_.Exception.Message
	    AddLogEntry "GetComputerListFromRepository" "Error" "MainModule" $msg $sqlConnection
		$errorCounter++
	}	
	# when a PowerShell function detects that you are retuning a enumerable object (such as a collection), 
	# it places each member of the collection on the pipeline as a separate item.
	# http://viziblr.com/news/2013/5/27/returning-collections-from-functions-in-powershell-a-tip-for.html

	return @(,$dataTable)

}

#************************************************************************************************************************************
# function PurgeProcessLog
#
# Parameters:
#   sqlConnection: SQL Server connection object
#
# function to purge activity log
#************************************************************************************************************************************
function PurgeProcessLog {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
	
	# Get Retention factor
	[int]$daysRetain = GetConfigValue -configName "ProcessLogRetainDays" -sqlConnection $sqlConnection
	
	# Set error variables
	[int]$errorCounter = 0
	[int]$warningCounter = 0
	
	If($daysRetain -gt 0 -and $daysRetain -le 365){
	
		AddLogEntry "DeleteProcessLog" "Info" "Maintenance" "Deleting ProcessLog entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting ProcessLog entries older than $daysRetain day(s)."
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "dbo.spProcessLogDelete"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "DeleteProcessLog" "Error" "Maintenance" $msg $sqlConnection
			$errorCounter++
		}
	} else {
		Throw "PurgeProcessLog: Invalid value for retention period: $daysRetain."
	}

	# Get Retention factor
	[int]$daysRetain = GetConfigValue -configName "SyncHistoryRetainDays" -sqlConnection $sqlConnection
	
	If($daysRetain -gt 0 -and $daysRetain -le 365){
	
		AddLogEntry "adDeleteSyncHistory" "Info" "Maintenance" "Deleting AD Sync History entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting SyncHistory entries older than $daysRetain day(s)."
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "ad.spSyncHistoryDeleteByDate"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "DeleteSyncHistory" "Error" "Maintenance" $msg $sqlConnection
			$errorCounter++
		}

		AddLogEntry "scomDeleteSyncHistory" "Info" "Maintenance" "Deleting SCOM Sync History entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting SyncHistory entries older than $daysRetain day(s)."
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "scom.spSyncHistoryDeleteByDate"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "DeleteSyncHistory" "Error" "Maintenance" $msg $sqlConnection
			$errorCounter++
		}
	} else {
		Throw "DeleteSyncHistory: Invalid value for retention period: $daysRetain."
	}
	
	Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}

#************************************************************************************************************************************
# function PurgeEvents
#
# Parameters:
#   sqlConnection: SQL Server connection object
#
# function to purge event table
#************************************************************************************************************************************
function PurgeEvents {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
	
	# Get retention factor
	[int]$daysRetain = GetConfigValue -configName "EventLogRetainDays" -sqlConnection $sqlConnection
	
	# Set error variables	
	[int]$errorCounter = 0
	[int]$warningCounter = 0
	
	If($daysRetain -gt 0 -and $daysRetain -le 365){	
		AddLogEntry "DeleteEventLog" "Info" "Maintenance" "Deleting cm.Event entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting cm.Event entries older than $daysRetain day(s)."
		
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "cm.spEventDelete"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "DeleteProcessLog" "Error" "Maintenance" $msg $sqlConnection
			$errorCounter++
		}
	} else {
		Throw "PurgeEvents: Invalid value for retention period: $daysRetain."
	}
	
	Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}

}

#************************************************************************************************************************************
# function PurgeHistory
#
# Parameters:
#   sqlConnection: SQL Server connection object
#
# function to purge data from history tables
# TODO: Apply DRY; see if we can tighten this up, do it all in the stored proc, or build a hash table and iterate through it
#************************************************************************************************************************************
function PurgeHistory {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$True,Position=1)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)

	# Set error variables
	[int]$errorCounter = 0
	[int]$warningCounter = 0

		
	################################################################################
	# CONFIGURATION HISTORY
	################################################################################
	
	# Get retention factor
	[int]$daysRetain = GetConfigValue -configName "ConfigurationHistoryRetainDays" -sqlConnection $sqlConnection	
	
	If($daysRetain -gt 0 -and $daysRetain -le 365){
	
		AddLogEntry "PurgeHistory" "Info" "Maintenance" "Deleting Configuration History entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting Configuration History entries older than $daysRetain day(s)."
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "cm.spConfigurationHistoryDelete"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "PurgeHistory" "Error" "Maintenance" "Configuration History : $msg" $sqlConnection
			$errorCounter++
		}
	} else {
		Throw "PurgeHistory: Invalid value for retention period: $daysRetain."
	}
	
	
	################################################################################
	# LOGICALVOLUMESIZE HISTORY
	################################################################################
	
	# Get retention factor
	[int]$daysRetain = GetConfigValue -configName "DatabaseSizeDailyRetainDays" -sqlConnection $sqlConnection	
	
	If($daysRetain -gt 0 -and $daysRetain -le 2500){
	
		AddLogEntry "PurgeHistory" "Info" "Maintenance" "Deleting DatabaseSizeDaily entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting DatabaseSizeDaily entries older than $daysRetain day(s)."
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "pm.spDatabaseSizeDailyDelete"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "PurgeHistory" "Error" "Maintenance" "DatabaseSizeDaily : $msg" $sqlConnection
			$errorCounter++
		}
	} else {
		Throw "PurgeHistory: Invalid value for retention period: $daysRetain."
	}
	
	[int]$daysRetain = GetConfigValue -configName "DatabaseSizeRawRetainDays" -sqlConnection $sqlConnection
	
	If($daysRetain -gt 0 -and $daysRetain -le 90){
	
		AddLogEntry "PurgeHistory" "Info" "Maintenance" "Deleting DatabaseSizeRaw entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting DatabaseSizeRaw entries older than $daysRetain day(s)."
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "pm.spDatabaseSizeRawDelete"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "PurgeHistory" "Error" "Maintenance" "DatabaseSizeRaw : $msg" $sqlConnection
			$errorCounter++
		}
	} else {
		Throw "PurgeHistory: Invalid value for DatabaseSizeRawRetainDays retention period: $daysRetain."
	}
	

	################################################################################
	# LOGICALVOLUMESIZE HISTORY
	################################################################################
	[int]$daysRetain = GetConfigValue -configName "LogicalVolumeSizeDailyRetainDays" -sqlConnection $sqlConnection
	
	If($daysRetain -gt 0 -and $daysRetain -le 2500){
	
		AddLogEntry "PurgeHistory" "Info" "Maintenance" "Deleting LogicalVolumeSizeDaily entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting LogicalVolumeSizeDaily entries older than $daysRetain day(s)."
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "pm.spLogicalVolumeSizeDailyDelete"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "PurgeHistory" "Error" "Maintenance" "LogicalVolumeSizeDaily : $msg" $sqlConnection
			$errorCounter++
		}
	} else {
		Throw "PurgeHistory: Invalid value for LogicalVolumeSizeRaw retention period: $daysRetain."
	}
	
	[int]$daysRetain = GetConfigValue -configName "LogicalVolumeSizeRawRetainDays" -sqlConnection $sqlConnection
	
	If($daysRetain -gt 0 -and $daysRetain -le 90){
	
		AddLogEntry "PurgeHistory" "Info" "Maintenance" "Deleting LogicalVolumeSizeRaw entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting LogicalVolumeSizeRaw entries older than $daysRetain day(s)."
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "pm.spLogicalVolumeSizeRawDelete"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "PurgeHistory" "Error" "Maintenance" "LogicalVolumeSizeRaw : $msg" $sqlConnection
			$errorCounter++
		}
	} else {
		Throw "PurgeHistory: Invalid value for LogicalVolumeSizeRaw retention period: $daysRetain."
	}	

	################################################################################
	# WEBAPPLICATIONURL HISTORY
	################################################################################
	[int]$daysRetain = GetConfigValue -configName "WebApplicationURLResponseDailyRetainDays" -sqlConnection $sqlConnection
	
	If($daysRetain -gt 0 -and $daysRetain -le 2500){
	
		AddLogEntry "PurgeHistory" "Info" "Maintenance" "Deleting WebApplicationURLResponseDaily entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting WebApplicationURLResponseDaily entries older than $daysRetain day(s)."
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "pm.spWebApplicationURLResponseDailyDelete"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "PurgeHistory" "Error" "Maintenance" "WebApplicationURLResponseDaily : $msg" $sqlConnection
			$errorCounter++
		}
	} else {
		Throw "PurgeHistory: Invalid value for WebApplicationURLResponseDaily retention period: $daysRetain."
	}
	
	[int]$daysRetain = GetConfigValue -configName "WebApplicationURLResponseRawRetainDays" -sqlConnection $sqlConnection
	
	If($daysRetain -gt 0 -and $daysRetain -le 90){
	
		AddLogEntry "PurgeHistory" "Info" "Maintenance" "Deleting WebApplicationURLResponseRaw entries older than $daysRetain day(s)." $sqlConnection
		Write-Verbose " : Maintenance : Deleting WebApplicationURLResponseRaw entries older than $daysRetain day(s)."
		
		try	{
			$sqlCommand = GetStoredProc $sqlConnection "pm.spWebApplicationURLResponseRawDelete"
			[Void]$sqlCommand.Parameters.Add("@DaysRetain", [system.data.SqlDbType]::Int)
	        $sqlCommand.Parameters["@DaysRetain"].value = $daysRetain

			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
			
		}
		catch [System.Exception] {
			$msg = $_.Exception.Message
		    AddLogEntry "PurgeHistory" "Error" "Maintenance" "WebApplicationURLResponseRaw : $msg" $sqlConnection
			$errorCounter++
		}
	} else {
		Throw "PurgeHistory: Invalid value for WebApplicationURLResponseRaw retention period: $daysRetain."
	}		
	
	Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}

#************************************************************************************************************************************
# function WriteDailyHistory
#
# Parameters:
# 	
# Stored Procedures:
#   pm.spLogicalVolumeSizeDailyUpsert
#	pm.spDatabaseSizeDailyUpsert
#	pm.spWebApplicationURLResponseDailyUpsert
#
# function to update daily history
#************************************************************************************************************************************
function WriteDailyHistory {
[CmdletBinding()]
param (
	[Parameter(Mandatory=$True,Position=1)]
	$sqlConnection
)
	# TODO: I bet this can be rewritten as a loop
	
	# It's always assumed (I know that's bad) that history is being written for the prior day
	[datetime]$forDate = [datetime]::Today.AddDays(-1)
	
    AddLogEntry "WriteDailyHistory" "Info" "Maintenance" "Processing Daily History Update for $forDate" $sqlConnection
	Write-Verbose " : Maintenance : Processing Daily History Update for $forDate"
	[int]$errorCounter = 0
	[int]$warningCounter = 0
	try	{
		# Update pm.LogicalVolumeSizeDaily
		$sqlCommand = GetStoredProc $sqlConnection "pm.spLogicalVolumeSizeDailyUpsert"
		[Void]$sqlCommand.Parameters.Add("@ForDate", [system.data.SqlDbType]::Date)
        $sqlCommand.Parameters["@ForDate"].value = $forDate
		[Void]$sqlCommand.ExecuteNonQuery()
		$sqlCommand.Dispose()
	}
	catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry "WriteDailyHistory" "Error" "Maintenance" "Logical Volume : $msg" $sqlConnection
		$errorCounter++
	}		
	try {
		# Update pm.DatabaseSizeDaily
		$sqlCommand = GetStoredProc $sqlConnection "pm.spDatabaseSizeDailyUpsert"
		[Void]$sqlCommand.Parameters.Add("@ForDate", [system.data.SqlDbType]::Date)
        $sqlCommand.Parameters["@ForDate"].value = $forDate
		[Void]$sqlCommand.ExecuteNonQuery()
		$sqlCommand.Dispose()
	}
	catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry "WriteDailyHistory" "Error" "Maintenance" "Database Size : $msg" $sqlConnection
		$errorCounter++
	}
	try	{	
		# Update pm.WebApplicationURLResponseDaily
		$sqlCommand = GetStoredProc $sqlConnection "pm.spWebApplicationURLResponseDailyUpsert"
		[Void]$sqlCommand.Parameters.Add("@ForDate", [system.data.SqlDbType]::Date)
        $sqlCommand.Parameters["@ForDate"].value = $forDate
		[Void]$sqlCommand.ExecuteNonQuery()
		$sqlCommand.Dispose()
	}
	catch [System.Exception] {
		$msg = $_.Exception.Message
	    AddLogEntry "WriteDailyHistory" "Error" "Maintenance" "Web Application Response : $msg" $sqlConnection
		$errorCounter++
	}

#		# Update CM_ANALYSISSERVERDATABASESIZEHISTORY
#		$sqlCommand = GetStoredProc $sqlConnection "spUpdateAnalysisServerDatabaseSizeHistory"
#		[Void]$sqlCommand.Parameters.Add("@AS_INSTANCENAME", [system.data.SqlDbType]::nvarchar)
#		[Void]$sqlCommand.Parameters.Add("@FORDATE", [system.data.SqlDbType]::DateTime)
#        $sqlCommand.Parameters["@AS_INSTANCENAME"].value = [System.DBNull]::Value
#        $sqlCommand.Parameters["@FORDATE"].value = [System.DBNull]::Value
#
#		[Void]$sqlCommand.ExecuteNonQuery()
#		$sqlCommand.Dispose()
#	}
#	catch [System.Exception] {
#		$msg = $_.Exception.Message
#	    AddLogEntry "WriteDailyHistory" "Error" "Maintenance" "$msg" $sqlConnection
#		$errorCounter++
#	}

	Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}

#************************************************************************************************************************************
# function GetCheckModule
#
# Parameters:
# 	$checkName
# 	
# Stored Procedures:
#
# Returns the name of the PS module to load for the referenced Check
#************************************************************************************************************************************
function GetCheckModule {
[CmdletBinding()]
param (
  	[Parameter(Mandatory=$True,Position=1)]
	[string]$checkName
)
	switch($checkName) {
		"Comp"  	{ return "CheckComputer.ps1" }
		"Os"  		{ return "CheckOperatingSystem.ps1" }
		"Disk"  	{ return "CheckDisk.ps1" }
		"DiskSpc"  	{ return "CheckDiskSpace.ps1" }
		"Clus"      { return "CheckCluster.ps1" }
		"CompShr"  	{ return "CheckComputerShare.ps1" }
		"InstApp"   { return "CheckInstalledApplications.ps1" }
		"Hotfix"    { return "CheckInstalledHotfix.ps1" }
		"Net"  		{ return "CheckNetwork.ps1" }
		"NLB"  		{ return "CheckNLBCluster.ps1" }
		"Svcs"  	{ return "CheckServices.ps1" }
		"RptSvr"  	{ return "CheckSQLReportingServer.ps1" }
		"DiscSQL"  	{ return "CheckSQLInstance.ps1" }
		"SQLEng"  	{ return "CheckSQLEngine.ps1" }
		"SQLSize"  	{ return "CheckSQLDatabaseSize.ps1" }
		"Olap"  	{ return "CheckSQLAnalysisServer.ps1" }
		"SQLRpt"  	{ return "CheckSQLReporting.ps1" }
		"SQLJob"  	{ return "CheckSQLJobs.ps1" }
		"SQLPerm"  	{ return "CheckSQLPermissions.ps1" }
		"SysEvtLog"	{ return "CheckEvents.ps1" }
		"AppEvtLog"	{ return "CheckEvents.ps1" }
		"WebURL"	{ return "CheckWebURL.ps1" }
		default 	{ return $null }
	}
}

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
Set-Variable keyFile -Scope "Global" -Value ".\AES.key"
Set-Variable configFile -Scope "Global" -Value ".\app.monitor.config"

################################################################################
# BEGIN PARAMETER VALIDATION AND INITILIZATION
################################################################################

# Initialize variables
[int]$errorCounter = 0
[int]$warningCounter = 0

################################################################################
# LOAD APPLICATION CONFIGURATION FILE
################################################################################
If(Test-Path $global:configFile){
	Try {
		[xml]$appConfig = Get-Content $global:configFile
	} Catch {
		Throw "Unable to process XML in configuration file!"
	}
} else {
	Throw "Unable to load config file!"
}

# Load ThrottleLimit from configuration file
[int]$throttleLimit = $appConfig.configuration.settings.ThrottleLimit.Value

# If AgentName is null, then load from configuration file.
if(($agentName -eq $null) -or ($agentName.Length -eq 0)) {
	$agentName = $appConfig.configuration.settings.AgentName.Value
}

# Set connectionString from config file
[string]$sqlConnectionString = $appConfig.configuration.connectionStrings.CentralRepository.connectionString

################################################################################
# WRITE PROCESS HEADER
################################################################################
Write-Verbose "*********** Starting process ***********"
If($Checks){
	Write-Verbose "Checks       : $Checks"
	if($fileName){
		Write-Verbose "Filename     : $fileName"
	} else {
		Write-Verbose "AgentName    : $agentName"
	}
}
if($Maintenance){
	Write-Verbose "Maintenance  : $Maintenance"
}
Write-Verbose "ThrottleLimit: $throttleLimit"
If($WhatIf){
	Write-Verbose "WhatIf parameter specified"
}
Write-Verbose "****************************************"


################################################################################
# ESTABLISH CONNECTION TO CENTRAL REPOSITORY
################################################################################
[System.Data.SqlClient.SqlConnection]$sqlConnection = GetSQLConnection -sqlConnectionString $sqlConnectionString

# Check connection to repository
if ($sqlConnection.State -ne "Open")	{
	Throw "Unable to open central repository database.  Application terminating."
}

################################################################################
# WRITE INITIAL ENTRY TO PROCESS LOG
################################################################################
AddLogEntry -Reference "StartProcess" -Status "Info" -moduleName "MainModule" -messageString "Started processing for $Checks checks and $Maintenance maintenance tasks." -sqlConnection $sqlConnection

################################################################################
# CERTAIN CHECKS SHOULD NOT BE RUN ON CLUSTERS
################################################################################
$clusterNoChecks = @("CompShr","Clus","Disk","DiskSpc","HotFix","InstApp","Net","NLB","Svcs","SysEvtLog","AppEvtLog")

################################################################################
# SET UP THREADING
################################################################################ 
# Set up multi threading using PowerShell RunSpaceFactory
# Using guidelines seen on www.powershell.com
# Dr. Tobias Weltner

if(($null -eq $throttleLimit) -or ($throttleLimit -eq 0)){
	$throttleLimit = 4
}
$sessionState = [system.management.automation.runspaces.initialsessionstate]::CreateDefault()
$runPool = [runspacefactory]::CreateRunspacePool(1, $throttleLimit, $sessionState, $Host)
$runPool.Open()

$handles = @()
$threads = @()	

################################################################################
# COLLECT A LIST OF SERVERS TO CHECK
# 1. FROM THE LIST OF COMPUTERS PROVIDED IN $fileName
# 2. OR, FROM THE DATABASE
################################################################################
Try {
	If(!$Checks){
		$computers = $null
	} Else {
		If($fileName){
			If(Test-Path $fileName){
				$computers = GetComputerListFromFile $fileName
			} else {
				$computers = $null
				Throw "Invalid filename provided: $filename"
			}
		} Else {
			$computers = GetComputerListFromRepository $sqlConnection $agentName
		} 
	}
}
Catch [System.Exception] {
	$msg = $_.Exception.Message
    AddLogEntry "GetComputers" "Error" "MainModule" $msg $sqlConnection
	$errorCounter++
	$computers = $null
}

################################################################################
# ITERATE THROUGH LIST OF COMPUTERS (IF APPLICABLE)
################################################################################  
[int]$computersChecked = 0
foreach($row in $computers){

	# Retrieve dnsHostName from computers data table
	[string]$computer = $row["dnsHostName"]

    ################################################################################
    # TEST CONNECTIVITY
    ################################################################################  
    if(!(Test-Connection $computer -Quiet -Count 1)){
        Write-Verbose "Unable to ping computer: $computer"
		AddLogEntry -Reference "PingCheck" -Status "Error" -moduleName "MainModule" -messageString "Unable to ping computer: $computer." -sqlConnection $sqlConnection
        continue
    }

    $testPort = TestPort -ComputerName $computer -Port 135 -Protocol "TCP"
    if($testPort -eq "Failed"){
        Write-Verbose "Unable to communicate on port 135 with computer: $computer"
		AddLogEntry -Reference "PortCheck" -Status "Error" -moduleName "MainModule" -messageString "Unable to communicate on port 135 with computer: $computer." -sqlConnection $sqlConnection
        continue
    }	
	
    ################################################################################
    # GET USER NAME AND PASSWORD FOR ALTERNATE CREDENTIALS
    ################################################################################ 		

	# TODO: Get a reference to a secure PSCredential Object
	# $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
	# $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $psCredential, $securePassword
	[Management.Automation.PSCredential]$psCredential = $null
	
	# TODO: Pull dbUserName and Password from database
	[string]$dbTargetUser = $null
	[string]$dbTargetPassword = $null	

    ################################################################################
    # TEST FOR THE EXISTENCE OF THE BASE OBJECT (COMPUTER)
    ################################################################################ 		
	$sqlCommand = GetStoredProc $sqlConnection "cm.spComputerSelect"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
    $sqlCommand.Parameters["@dnsHostName"].value = $computer

	$sqlReader = $sqlCommand.ExecuteReader()

	$dataTable = New-Object System.Data.DataTable
	$dataTable.Load($SqlReader)
	
	if($dataTable.Rows.Count -eq 0){
		# The base object (cm.Computer) does not exist, let's add it.
		# Since this needs to finish before proceeding to the actual checks,
		# we execute it synchronously with invoke-command
		
		$scriptBlock = . ".\modules\CheckComputer.ps1"
		$result = Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $computer, $psCredential, $sqlConnectionString, $shellFolder
		$errorCounter += $result.ErrorCount
		$warningCounter += $result.WarningCount		
		
		# Re-execute the stored procedure
		$sqlReader = $sqlCommand.ExecuteReader()
		$dataTable = New-Object System.Data.DataTable
		$dataTable.Load($SqlReader)					
	}
	$sqlCommand.Dispose()


    # Reload data table
	$sqlReader = $sqlCommand.ExecuteReader()

	$dataTable = New-Object System.Data.DataTable
	$dataTable.Load($SqlReader)

    if($dataTable.Rows.Count -eq 0){
        [bool]$isCluster = $false
    } else {
	
	    # Check to see if this is a clustered resource or not; some checks are skipped for cluster nodes
	    $isCluster = $dataTable.Rows[0]["IsClusterResource"]
    }

    # If($isCluster -eq $null){$isCluster = $false}


	################################################################################
	# ITERATE THROUGH CHECKS
	################################################################################ 
	foreach($check in $checks){
		[string]$moduleName = GetCheckModule $check 
		if(!$moduleName){
			Write-Verbose "Invalid Check: $check"
			Continue
		}
		
		if($isCluster -and ($clusterNoChecks -contains $check)){
			Write-Verbose " : $computer : $check : Skipped"
		} elseif($WhatIf){
			Write-Verbose " : $computer : $check : Would be performed."
		} elseif($check -eq "SysEvtLog") {
			# System Event log needs a separate entry, to add parameter "System"
			$scriptBlock = . ".\modules\$moduleName"
			$handle = [PowerShell]::Create()
			[Void]$handle.AddScript($scriptBlock).AddArgument($computer).AddArgument($psCredential).AddArgument($sqlConnectionString).AddArgument($shellFolder).AddArgument("System")
			$handle.RunspacePool = $runPool
			$handles += $handle.BeginInvoke()
			$threads += $handle
		} elseif($check -eq "AppEvtLog") {
			# Application Event log needs a separate entry, to add parameter "Application"
			$scriptBlock = . ".\modules\$moduleName"
			$handle = [PowerShell]::Create()
			[Void]$handle.AddScript($scriptBlock).AddArgument($computer).AddArgument($psCredential).AddArgument($sqlConnectionString).AddArgument($shellFolder).AddArgument("Application")
			$handle.RunspacePool = $runPool
			$handles += $handle.BeginInvoke()
			$threads += $handle	
		} elseif($check -like "Sql*") {
			# SQLEng needs a separate entry, to add parameters $dbTargetUser and $dbTargetPassword
			$scriptBlock = . ".\modules\$moduleName"
			$handle = [PowerShell]::Create()
			[Void]$handle.AddScript($scriptBlock).AddArgument($computer).AddArgument($psCredential).AddArgument($sqlConnectionString).AddArgument($shellFolder).AddArgument($dbTargetUser).AddArgument($dbTargetPassword)
			$handle.RunspacePool = $runPool
			$handles += $handle.BeginInvoke()
			$threads += $handle		
		} elseif($check -eq "NLB") {
			# It appears that using get-NLBCluster and/or Get-NLBClusterNode don't like being run in parallel
			# so, we use invoke-command; it will be slower, but no error messages
			$scriptBlock = . ".\modules\$moduleName"
			$result = Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $computer, $psCredential, $sqlConnectionString, $shellFolder
			$errorCounter += $result.ErrorCount
			$warningCounter += $result.WarningCount			
		} else {
			# All others should be able to use the following "Standard" block
			$scriptBlock = . ".\modules\$moduleName"
			$handle = [PowerShell]::Create()
			[Void]$handle.AddScript($scriptBlock).AddArgument($computer).AddArgument($psCredential).AddArgument($sqlConnectionString).AddArgument($shellFolder)
			$handle.RunspacePool = $runPool
			$handles += $handle.BeginInvoke()
			$threads += $handle
		}
	}
	$computersChecked++
}

# For multithreading, spin through handles; determine if they have
# finished processing and call EndInvoke() when .IsCompleted -eq $true
# Adapted from www.powershell.com; Dr. Tobias Welter
do { 
	$threadCounter = 0
	$done = $true
	foreach ($handle in $handles) {
	if ($null -eq $handle) {
	  	if ($handle.IsCompleted) {
		    [psobject]$result = $threads[$threadCounter].EndInvoke($handle)
			$errorCounter += $result.ErrorCount
			$warningCounter += $result.WarningCount
		    $threads[$threadCounter].Dispose()
		    $handles[$threadCounter] = $null
			$result = $null
	    } else {
	    	$done = $false
	    }
	}
	$threadCounter++ 
	}
	if (-not $done) { Start-Sleep -Milliseconds 500 }
} until ($done) 

################################################################################
# MAINTENANCE TASKS (IF SPECIFIED)
################################################################################
foreach($item in $Maintenance){
	If($WhatIf){
		Write-Verbose "Maintenance task $item would be performed."
	} else {
		Switch($item) {
			"PurgeLog" 	{
				$purgeLogResp = PurgeProcessLog $sqlConnection
				$errorCounter += $purgeLogResp.ErrorCount
				$warningCounter += $purgeLogResp.WarningCount
			}
			"PurgeEvt" 	{
				$purgeEventsResp = PurgeEvents $sqlConnection
				$errorCounter += $purgeEventsResp.ErrorCount
				$warningCounter += $purgeEventsResp.WarningCount
			}
			"PurgeHist" {
				$purgeHistoryReport = PurgeHistory $sqlConnection
				$errorCounter += $purgeHistoryReport.ErrorCount
				$warningCounter += $purgeHistoryReport.WarningCount
			}
			"WriteHist" {
				$writeHistResp = WriteDailyHistory $sqlConnection
				$errorCounter += $writeHistResp.ErrorCount
				$warningCounter += $writeHistResp.WarningCount				
			}
			Default {Write-Verbose "Invalid Maintenance option: $item"}
		}
	}
}

################################################################################
# WRITE FINAL ENTRY TO PROCESS LOG
################################################################################
AddLogEntry "EndProcess" "Info" "MainModule" "Completed processing: checked $computersChecked computer(s) with $errorCounter errors and $warningCounter warnings." $sqlConnection
Write-Verbose "Completed processing: checked $computersChecked computer(s) with $errorCounter error(s) and $warningCounter warning(s)."
Write-Verbose "************ End Process ***************"

################################################################################
# CLEANUP
################################################################################
[Void]$sqlConnection.Close
$sqlConnection.Dispose()

# Check Error Count, if > 0, then exit w/ error code
if($errorCounter -gt 0){
	Exit 1
} else {
	Exit 0
}