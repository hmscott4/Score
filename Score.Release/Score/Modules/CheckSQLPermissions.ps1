#************************************************************************************************************************************
# function CheckSQLPermissions
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#	- $dbUserName
#	- $dbPassword
#
# Stored Procedures: 
#	- spDatabaseInstanceLoginsUpsert
#	- spDatabasePermissionUpsert
#	- spDatabaseUserUpsert
#	- spDatabaseRoleMemberUpsert
#
# Check SQL Permissions
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
	[string]$invocationPath,
	[Parameter(Mandatory=$False,Position=5)]
	[string]$dbUserName="",
	[Parameter(Mandatory=$False,Position=6)]
	[string]$dbPassword=""
)

Set-StrictMode -Version "Latest"

# Change path to working folder
Set-Location $invocationPath	

. ".\modules\MonitorFunctions.ps1"

# Initialize error variables
[int]$errorCounter = 0
[int]$warningCounter = 0
[string]$moduleName = "CheckSQLPermissions"

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
AddLogEntry $dnsHostName "Info" $moduleName "Starting check..."	$sqlConnection	

# Load the Mocrosoft SQL Server SMO model
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO")  | out-null	

# Retrieve instances installed on server
$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstanceSelectByComputer"
[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName

$sqlReader = $sqlCommand.ExecuteReader()
$sqlCommand.Dispose()

$dataTable = New-Object System.Data.DataTable
$dataTable.Load($SqlReader)

foreach($row in $dataTable) {
	[Guid]$databaseInstanceGUID = $row["objectGUID"]
	[string]$instanceName = $row["InstanceName"]
	[string]$connectionString = $row["ConnectionString"]
	
	If($row["InstanceName"] -eq "MSSQLSERVER"){
		[string]$serviceName = "MSSQLSERVER"
	} else {
		[string]$serviceName = "MSSQL`$$instanceName"
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
		Write-Verbose " : $dnsHostName : $moduleName : $instanceName : Service does not exist; no connection made." -ForegroundColor Red
		AddLogEntry $dnsHostName "Warning" $moduleName "$dnsHostName : $instanceName : Service does not exist; no connection made." $sqlConnection
		$errorCounter++
		continue	
	}

	$sqlServer = GetSMOConnection $connectionString $dbUserName $dbPassword
	
	if($sqlServer -eq $null){
		Write-Verbose " : $dnsHostName : $moduleName : $instanceName : Unable to connect to instance." -ForegroundColor Red
		AddLogEntry $dnsHostName "Error" $moduleName "$dnsHostName : $instanceName : Unable to connect to instance." $sqlConnection
		$errorCounter++
		continue
	}


	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstanceLoginInactivateByDatabaseInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)	
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	
	#region Instance Logins
	try {
		# First Pass: Retrieve logins
		$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstanceLoginUpsert"
        [Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
        [Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Sid", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@LoginType", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@DefaultDatabase", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@HasAccess", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@IsDisabled", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@IsLocked", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@IsPasswordExpired", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@PasswordExpirationEnabled", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@PasswordPolicyEnforced", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@IsSysAdmin", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@IsSecurityAdmin", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@IsSetupAdmin", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@IsProcessAdmin", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@IsDiskAdmin", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@IsDBCreator", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@IsBulkAdmin", [system.data.SqlDbType]::Bit)
		[Void]$sqlCommand.Parameters.Add("@CreateDate", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@DateLastModified", [system.data.SqlDbType]::DateTime)
		[Void]$sqlCommand.Parameters.Add("@State", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
		[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
			
		foreach($login in $sqlServer.Logins){
			if($login.LoginType -eq "WindowsUser" -or $login.LoginType -eq "WindowsGroup"){
				$bIsDisabled = [System.DBNull]::Value
				$bIsLocked = [System.DBNull]::Value
				$bPasswordExpirationEnabled = [System.DBNull]::Value
				$bPasswordPolicyEnforced = [System.DBNull]::Value
				$bIsPasswordExpired = [System.DBNull]::Value
			} else {
				$bIsDisabled = $login.IsDisabled
				$bIsLocked = $login.IsLocked
				$bPasswordExpirationEnabled = $login.PasswordExpirationEnabled
				$bPasswordPolicyEnforced = $login.PasswordPolicyEnforced
				$bIsPasswordExpired = $login.IsPasswordExpired			
			}
			[string]$sidString=""
			foreach($segment in $login.Sid){
				$sidString += '{0:x}' -f $segment
			}
			
            $sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
            $sqlCommand.Parameters["@Name"].value = $login.Name
            $sqlCommand.Parameters["@Sid"].value = "0x" + $sidString
			$sqlCommand.Parameters["@LoginType"].value = $login.LoginType
			$sqlCommand.Parameters["@DefaultDatabase"].value = $login.DefaultDatabase
			$sqlCommand.Parameters["@HasAccess"].value = $login.HasAccess
			$sqlCommand.Parameters["@IsDisabled"].value = $bIsDisabled
			$sqlCommand.Parameters["@IsLocked"].value = $bIsLocked
			$sqlCommand.Parameters["@IsPasswordExpired"].value = $bIsPasswordExpired
			$sqlCommand.Parameters["@PasswordExpirationEnabled"].value = $bPasswordExpirationEnabled
			$sqlCommand.Parameters["@PasswordPolicyEnforced"].value = $bPasswordPolicyEnforced
            $sqlCommand.Parameters["@IsSysAdmin"].value = $login.IsMember("sysadmin")
            $sqlCommand.Parameters["@IsSecurityAdmin"].value = $login.IsMember("securityadmin")
            $sqlCommand.Parameters["@IsSetupAdmin"].value = $login.IsMember("setupadmin")
            $sqlCommand.Parameters["@IsProcessAdmin"].value = $login.IsMember("processadmin")
            $sqlCommand.Parameters["@IsDiskAdmin"].value = $login.IsMember("diskadmin")
            $sqlCommand.Parameters["@IsDBCreator"].value = $login.IsMember("dbcreator")
            $sqlCommand.Parameters["@IsBulkAdmin"].value = $login.IsMember("bulkadmin")
            $sqlCommand.Parameters["@CreateDate"].value = $login.CreateDate
            $sqlCommand.Parameters["@DateLastModified"].value = $login.DateLastModified
            $sqlCommand.Parameters["@State"].value = $login.State
			$sqlCommand.Parameters["@Active"].value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
           	[Void]$sqlCommand.ExecuteNonQuery()
		}
    }
    catch [System.Exception] {
		$msg = $_.Exception.Message
		AddLogEntry $dnsHostName "Warning" $moduleName "Instance Logins: $msg" $sqlConnection
		$warningCounter++
    }
	$sqlCommand.Dispose()
	#endregion
	
	#region InactivateAllPermissionsForInstance
	# Inactivate DatabasePermission rows where PermissionSource = SERVER_PERMISSION
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseInstancePermissionInactivateByDatabaseInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)	
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()	
	
	# Inactivate DatabasePermission rows where PermissionSource = DATABASE_PERMISSION or OBJECT_PERMISSION
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabasePermissionInactivateByDatabaseInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()	
	
	# Inactivate DatabaseUser rows
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseUserInactivateByDatabaseInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	
	# Inactivate DatabaseRoleMember rows
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseRoleMemberInactivateByDatabaseInstance"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	#endregion
	
	#region ServerPermissions
	$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabasePermissionUpsert"
	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
	[Void]$sqlCommand.Parameters.Add("@DatabaseName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@PermissionSource", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@PermissionState", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@PermissionType", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Grantor", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@ObjectName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Grantee", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	
	foreach($serverPerm in $sqlServer.EnumServerPermissions()) {
		try {
		    $sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
		    $sqlCommand.Parameters["@DatabaseName"].value = "(na)"
		    $sqlCommand.Parameters["@PermissionSource"].value = "SERVER_PERMISSION"
		    $sqlCommand.Parameters["@PermissionState"].value = $serverPerm.PermissionState
		    $sqlCommand.Parameters["@PermissionType"].value = $serverPerm.PermissionType.ToString()
		    $sqlCommand.Parameters["@Grantor"].value = $serverPerm.Grantor
		    $sqlCommand.Parameters["@ObjectName"].value = $serverPerm.ObjectName
		    $sqlCommand.Parameters["@Grantee"].value = $serverPerm.Grantee
			$sqlCommand.Parameters["@Active"].value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
			
			[Void]$sqlCommand.ExecuteNonQuery()
		}
	    catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "Server Permissions: $msg" $sqlConnection
			$warningCounter++
	    }
		$sqlCommand.Dispose()
	}
	#endregion
			
	# Second Pass: Retrieve database users
	#Region Databases
	foreach($database in $sqlServer.Databases){
		if($database.Status -eq "Normal"){
		
			#region DatabaseUsers
			$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseUserUpsert"
        	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
            [Void]$sqlCommand.Parameters.Add("@DatabaseName", [system.data.SqlDbType]::nvarchar)
   			[Void]$sqlCommand.Parameters.Add("@UserName", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@Login", [system.data.SqlDbType]::nvarchar)
   			[Void]$sqlCommand.Parameters.Add("@UserType", [system.data.SqlDbType]::nvarchar)
   			[Void]$sqlCommand.Parameters.Add("@LoginType", [system.data.SqlDbType]::nvarchar)
            [Void]$sqlCommand.Parameters.Add("@HasDBAccess", [system.data.SqlDbType]::Bit)
            [Void]$sqlCommand.Parameters.Add("@CreateDate", [system.data.SqlDbType]::Datetime)
            [Void]$sqlCommand.Parameters.Add("@DateLastModified", [system.data.SqlDbType]::Datetime)
            [Void]$sqlCommand.Parameters.Add("@State", [system.data.SqlDbType]::nvarchar)
			[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
			[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	
			foreach($user in $database.Users) {
				try {
                	$sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
                	$sqlCommand.Parameters["@DatabaseName"].value = $database.Name
                	$sqlCommand.Parameters["@UserName"].value = $user.Name
                	$sqlCommand.Parameters["@Login"].value = $user.Login		
                	$sqlCommand.Parameters["@UserType"].value = $user.UserType
                	$sqlCommand.Parameters["@LoginType"].value = $user.LoginType		
                	$sqlCommand.Parameters["@HasDBAccess"].value = $user.HasDBAccess	
                	$sqlCommand.Parameters["@CreateDate"].value = $user.CreateDate
                	$sqlCommand.Parameters["@DateLastModified"].value = $user.DateLastModified	
                	$sqlCommand.Parameters["@State"].value = $user.State	
                	$sqlCommand.Parameters["@Active"].value = $true		
                	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
		            
		           	[Void]$sqlCommand.ExecuteNonQuery()
			    }
			    catch [System.Exception] {
					$msg = $_.Exception.Message
					AddLogEntry $dnsHostName "Warning" $moduleName " Database Users: $msg" $sqlConnection
					$warningCounter++
			    }					
				$sqlCommand.Dispose()
			}
			#endregion
	
			
			# Third Pass: Retrieve database object permissions
			if($database.Status -eq "Normal") {
			
				#region DatabasePermissions
				$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabasePermissionUpsert"
				[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
				[Void]$sqlCommand.Parameters.Add("@DatabaseName", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@PermissionSource", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@PermissionState", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@PermissionType", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@Grantor", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@ObjectName", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@Grantee", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
				[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)

				# Getting Database Permissions http://msdn.microsoft.com/en-us/library/ms205136.aspx
				foreach ($databasePerm in $database.EnumDatabasePermissions()) {
					try {
					    $sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
					    $sqlCommand.Parameters["@DatabaseName"].value = $database.Name
					    $sqlCommand.Parameters["@PermissionSource"].value = "DATABASE_PERMISSION"
					    $sqlCommand.Parameters["@PermissionState"].value = $databasePerm.PermissionState
					    $sqlCommand.Parameters["@PermissionType"].value = $databasePerm.PermissionType.ToString()
					    $sqlCommand.Parameters["@Grantor"].value = $databasePerm.Grantor
					    $sqlCommand.Parameters["@ObjectName"].value = $databasePerm.ObjectName
					    $sqlCommand.Parameters["@Grantee"].value = $databasePerm.Grantee
	                	$sqlCommand.Parameters["@Active"].value = $true	
	                	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
						
						[Void]$sqlCommand.ExecuteNonQuery()
						$sqlCommand.Dispose()
						
				    }
				    catch [System.Exception] {
						$msg = $_.Exception.Message
						AddLogEntry $dnsHostName "Warning" $moduleName "Database Permissions: $msg" $sqlConnection
						$warningCounter++
				    }
				} 
				#endregion
				
				#region ObjectPermissions
				$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabasePermissionUpsert"
				[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
				[Void]$sqlCommand.Parameters.Add("@DatabaseName", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@PermissionSource", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@PermissionState", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@PermissionType", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@Grantor", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@ObjectName", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@Grantee", [system.data.SqlDbType]::nvarchar)
				[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
				[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
				
				foreach ($objectPerm in $database.EnumobjectPermissions()) {
					try {
					    $sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
					    $sqlCommand.Parameters["@DatabaseName"].value = $database.Name
					    $sqlCommand.Parameters["@PermissionSource"].value = "OBJECT_PERMISSION"
					    $sqlCommand.Parameters["@PermissionState"].value = $objectPerm.PermissionState
					    $sqlCommand.Parameters["@PermissionType"].value = $objectPerm.PermissionType.ToString()
					    $sqlCommand.Parameters["@Grantor"].value = $objectPerm.Grantor
					    $sqlCommand.Parameters["@ObjectName"].value = $objectPerm.ObjectName
					    $sqlCommand.Parameters["@Grantee"].value = $objectPerm.Grantee
	                	$sqlCommand.Parameters["@Active"].value = $true	
	                	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)
						
						[Void]$sqlCommand.ExecuteNonQuery()
				    }
				    catch [System.Exception] {
						$msg = $_.Exception.Message
						AddLogEntry $dnsHostName "Warning" $moduleName "Object Permissions: $msg" $sqlConnection
						$warningCounter++
				    }
					$sqlCommand.Dispose()
				}
				#endregion				
			}			
			
			#region DatabaseRoleMembers
			# Final Pass: Get database roles and membership
			$sqlCommand = GetStoredProc $sqlConnection "cm.spDatabaseRoleMemberUpsert"
        	[Void]$sqlCommand.Parameters.Add("@DatabaseInstanceGUID", [system.data.SqlDbType]::uniqueidentifier)
			[Void]$sqlCommand.Parameters.Add("@DatabaseName", [system.data.SqlDbType]::nvarchar)
			[Void]$sqlCommand.Parameters.Add("@RoleName", [system.data.SqlDbType]::nvarchar)
			[Void]$sqlCommand.Parameters.Add("@RoleMember", [system.data.SqlDbType]::nvarchar)
			[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
			[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
			
			foreach($role in $database.Roles){
				foreach($member in $role.EnumMembers()){
					try {
	                	$sqlCommand.Parameters["@DatabaseInstanceGUID"].value = $databaseInstanceGUID
	                	$sqlCommand.Parameters["@DatabaseName"].value = $database.Name
	                	$sqlCommand.Parameters["@RoleName"].value = $role.Name
	                	$sqlCommand.Parameters["@RoleMember"].value = $member
	                	$sqlCommand.Parameters["@Active"].value = $true
	                	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)

						[Void]$sqlCommand.ExecuteNonQuery()

				    }
				    catch [System.Exception] {
						$msg = $_.Exception.Message
						AddLogEntry $dnsHostName "Warning" $moduleName "Role members: $member : $msg" $sqlConnection
						$warningCounter++
				    }
				}
			}
			$sqlCommand.Dispose()
			#endregion
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
	
Write-Verbose " : $dnsHostname : $moduleName : Finish"

# Return error count
Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}