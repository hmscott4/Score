#************************************************************************************************************************************
# function CheckAnalysisServer
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- cm.spAnalysisInstancePropertyUpsert
#	- cm.spAnalysisDatabaseUpsert
#	- cm.spAnalysisDatabaseCubeUpsert
#
# Check Analysis Server, Properties, Databases and Cubes
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
[string]$moduleName = "CheckSQLAnalysis"
	
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

# Create reference to assembly
[Void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices")

# Retrieve instances discovered on server
$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisInstanceSelectByComputer"
[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::nvarchar)
$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
$sqlCommand.Parameters["@Active"].value = $true

$sqlReader = $sqlCommand.ExecuteReader()
$sqlCommand.Dispose()

$dataTable = New-Object System.Data.DataTable
$dataTable.Load($SqlReader)

foreach($row in $dataTable){
	[Guid]$analysisInstanceGUID = $row["objectGUID"]
	[string]$instanceName = $row["InstanceName"]
	[string]$connectionString = $row["ConnectionString"]
	
	If($row["InstanceName"] -eq "MSSQLSERVER"){
		[string]$serviceName = "MSSQLServerOLAPService"
		[string]$olapServerName = $dnsHostName
	} else {
		[string]$serviceName = "MSOLAP`$$instanceName"
		[string]$olapServerName = $dnsHostName + "\" + $instanceName
	}

	# Before attempting to connect, check to see if the service is running
	$serviceState = Get-Service -ComputerName $dnsHostName -Name $serviceName -ErrorAction SilentlyContinue
	If($serviceState){
		If($serviceState.Status -ne "Running"){
			Write-Verbose " : $dnsHostName : $moduleName : $instanceName : Service not running; no connection made." -ForegroundColor Yellow
			AddLogEntry $dnsHostName "Warning" $moduleName "$dnsHostName : $instanceName : Service not running; no connection made." $sqlConnection
			$warningCounter++
			continue
		}
	} else {
		# This should never happen
		Write-Verbose " : $dnsHostName : $moduleName : $instanceName : Service does not exist; no connection made." -ForegroundColor DarkRed
		AddLogEntry $dnsHostName "Error" $moduleName "$dnsHostName : $instanceName : Service does not exist; no connection made." $sqlConnection
		$errorCounter++
		continue	
	}
		
	# Create a server object.
	$srv = new-object Microsoft.AnalysisServices.Server
	$srv.Connect($connectionString)
	if (!$srv.Connected) {
		Write-Verbose " : $dnsHostName : $moduleName : $connectionString : Unable to connect to instance." -ForegroundColor Red
		AddLogEntry $dnsHostName "Error" $moduleName "$connectionString : Unable to connect to instance." $sqlConnection
		$errorCounter++
		continue
	}

	#region AnalysisServer Properties
	# Sets Active Flag = 0
	$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisInstancePropertyInactivateByAnalysisInstance"
	[Void]$sqlCommand.Parameters.Add("@AnalysisInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	$sqlCommand.Parameters["@AnalysisInstanceGUID"].value = $AnalysisInstanceGUID
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisInstancePropertyUpsert"
	[Void]$sqlCommand.Parameters.Add("@AnalysisInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@PropertyName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Category", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@PropertyValue", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Type", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::Bit)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
			
	# Check Analysis Server Properties
	foreach ($srvProperty in $srv.ServerProperties) {
		try {
			$sqlCommand.Parameters["@AnalysisInstanceGUID"].value = $AnalysisInstanceGUID
			$sqlCommand.Parameters["@Name"].value = $srvProperty.Name
			$sqlCommand.Parameters["@PropertyName"].value = $srvProperty.PropertyName
			$sqlCommand.Parameters["@Category"].value = $srvProperty.Category
			$sqlCommand.Parameters["@PropertyValue"].value = $srvProperty.Value.ToString()
			$sqlCommand.Parameters["@Type"].value = $srvProperty.Type
			$sqlCommand.Parameters["@Active"].value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
		}
	    catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "Instance Properties : $msg" $sqlConnection
			$warningCounter++
	    }
	}
	#endregion

	#region Databases
	# Sets Active Flag = 0 for databases
	$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisDatabaseInactivateByAnalysisInstance"
	[Void]$sqlCommand.Parameters.Add("@AnalysisInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	$sqlCommand.Parameters["@AnalysisInstanceGUID"].value = $AnalysisInstanceGUID
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	

	# Sets Active Flag = 0 for cubes
	$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisDatabaseCubeInactivateByAnalysisInstance"
	[Void]$sqlCommand.Parameters.Add("@AnalysisInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	$sqlCommand.Parameters["@AnalysisInstanceGUID"].value = $AnalysisInstanceGUID
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()	
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisDatabaseUpsert"
	[Void]$sqlCommand.Parameters.Add("@AnalysisInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@DatabaseName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Description", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@UpdateAbility", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@EstimatedSize", [system.data.SqlDbType]::BigInt)
	[Void]$sqlCommand.Parameters.Add("@CreateDate", [system.data.SqlDbType]::DateTime)
	[Void]$sqlCommand.Parameters.Add("@LastProcessedDate", [system.data.SqlDbType]::DateTime)
	[Void]$sqlCommand.Parameters.Add("@LastSchemaUpdate", [system.data.SqlDbType]::DateTime)
	[Void]$sqlCommand.Parameters.Add("@Collation", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@State", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::Bit)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
			
	# Check individual Databases
	foreach ($database in $srv.databases) {
		try {
			if(!$database.Description){$databaseDescription = ""} else {$databaseDescription = $database.Description}
            if($database.LastProcessed -le "01/01/1900") {$dLastProcessed = [System.DBNull]::Value} else {$dLastProcessed = $database.LastProcessed}
            if($database.LastSchemaUpdate -le "01/01/1900") {$dLastSchemaUpdate = [System.DBNull]::Value} else {$dLastSchemaUpdate = $database.LastSchemaUpdate}
            
			$sqlCommand.Parameters["@AnalysisInstanceGUID"].value = $AnalysisInstanceGUID
			$sqlCommand.Parameters["@DatabaseName"].value = $database.Name
			$sqlCommand.Parameters["@Description"].value = $databaseDescription
			$sqlCommand.Parameters["@UpdateAbility"].value = $database.ReadWriteMode
			$sqlCommand.Parameters["@EstimatedSize"].value = $database.EstimatedSize 
			$sqlCommand.Parameters["@CreateDate"].value = $database.CreatedTimeStamp
			$sqlCommand.Parameters["@LastProcessedDate"].value = $dLastProcessed
			$sqlCommand.Parameters["@LastSchemaUpdate"].value = $dLastSchemaUpdate
			$sqlCommand.Parameters["@Collation"].value = $database.Collation
			$sqlCommand.Parameters["@State"].value = $database.State
			$sqlCommand.Parameters["@Active"].value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
			[Void]$sqlCommand.ExecuteNonQuery()
			$sqlCommand.Dispose()
		}
	    catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "Update Database : $msg" $sqlConnection
			$warningCounter++
	    }
		
		$sqlCommand = GetStoredProc $sqlConnection "cm.spAnalysisDatabaseCubeUpsert"
		[Void]$sqlCommand.Parameters.Add("@AnalysisInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
		[Void]$sqlCommand.Parameters.Add("@DatabaseName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@CubeName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Description", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@CreateDate", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@LastProcessedDate", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@LastSchemaUpdate", [system.data.SqlDbType]::DateTime)
	    [Void]$sqlCommand.Parameters.Add("@Collation", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@StorageLocation", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@StorageMode", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@State", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
				
		# Enumerate Cubes in the database
		foreach ($cube in $database.Cubes) {
			try {
				if(!$cube.Description){$cubeDescription = ""} else {$cubeDescription = $cube.Description}
				if(!$cube.StorageLocation){$cubeStorageLocation = ""} else {$cubeStorageLocation = $cube.StorageLocation}
                if($cube.LastProcessed -le "01/01/1900") {$dLastProcessed = [System.DBNull]::Value} else {$dLastProcessed = $cube.LastProcessed}
                if($cube.LastSchemaUpdate -le "01/01/1900") {$dLastSchemaUpdate = [System.DBNull]::Value} else {$dLastSchemaUpdate = $cube.LastSchemaUpdate}
                
				$sqlCommand.Parameters["@AnalysisInstanceGUID"].value = $AnalysisInstanceGUID
				$sqlCommand.Parameters["@DatabaseName"].value = $cube.Name
				$sqlCommand.Parameters["@CubeName"].value = $database.Name
				$sqlCommand.Parameters["@Description"].value = $cubeDescription
				$sqlCommand.Parameters["@CreateDate"].value = $cube.CreatedTimeStamp
				$sqlCommand.Parameters["@LastProcessedDate"].value = $dLastProcessed
				$sqlCommand.Parameters["@LastSchemaUpdate"].value = $dLastSchemaUpdate
				$sqlCommand.Parameters["@Collation"].value = $cube.Collation
				$sqlCommand.Parameters["@StorageLocation"].value = $cubeStorageLocation
				$sqlCommand.Parameters["@StorageMode"].value = $cube.StorageMode
				$sqlCommand.Parameters["@State"].value = $cube.State
				$sqlCommand.Parameters["@Active"].value = $true
				$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
				
				[Void]$sqlCommand.ExecuteNonQuery()
				$sqlCommand.Dispose()
			}
		    catch [System.Exception] {
				$msg = $_.Exception.Message
				AddLogEntry $dnsHostName "Warning" $moduleName "Update Cube :  $msg" $sqlConnection
				$warningCounter++
		    }								
			
		} 
	} 
	#endregion
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