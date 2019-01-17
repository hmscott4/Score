#************************************************************************************************************************************
# FileName:		MonitorAdmin.ps1
# Date:			2015/03/09
# Author:		Hugh Scott
#
# Description:
# This module is intended for two purposes:
# 1.  Adding new servers in to the monitoring framework (with associated credentials)
# 2.  Adding new credentials (or updating passwords for existing credentials)
#
# Parameters:
#	$ComputerName
#	$AgentName
#	$CredentialName
#	$Action
#
# Usage:
#   ./MonitorAdmin.ps1 -ComputerName <name.domain.com> -Action AddComputer
#   ./MonitorAdmin.ps1 -ComputerName <name.domain.com> -Action InactivateComputer
#   ./MonitorAdmin.ps1 -ComputerName <name.domain.com> -Action ReActivateComputer
#
# Modification History:
# Date			Developer		Comments
# 2015/03/09	Hugh Scott		- Original
#
#************************************************************************************************************************************
[CmdletBinding()]
Param(
	[Parameter(ParameterSetName="SnglComputerMgmt",Mandatory=$True,Position=0)]
	[Parameter(ParameterSetName="MultComputerMgmt",Mandatory=$True,Position=0)]	
	[Parameter(ParameterSetName="CredentialMgmt",Mandatory=$True,Position=0)]
	[Parameter(ParameterSetName="KeyMgmt",Mandatory=$True,Position=0)]
	[ValidateSet("AddComputer","RemoveComputer","UpdateComputer","InactivateComputer","ReactivateComputer","AddCredential","UpdateCredential","RemoveCredential","CreateKeyFile")]
	[string]$Action,
	[Parameter(ParameterSetName="SnglComputerMgmt",Mandatory=$True,Position=1)]
	[string]$ComputerName,
	[Parameter(ParameterSetName="SnglComputerMgmt",Mandatory=$False)]
	[Parameter(ParameterSetName="MultComputerMgmt",Mandatory=$False)]
	[string]$AgentName,
	[Parameter(ParameterSetName="SnglComputerMgmt",Mandatory=$False)]
	[Parameter(ParameterSetName="MultComputerMgmt",Mandatory=$False)]
	[Parameter(ParameterSetName="CredentialMgmt",Mandatory=$True)]
	[string]$credentialName=$null,
	[Parameter(ParameterSetName="MultComputerMgmt",Mandatory=$True)]
	[string]$fileName=$null
)

#************************************************************************************************************************************
# function Test-ADCredentials
#
# Parameters:
# 	$username
#	$password
#	$domain
# 	
# Stored Procedures:
#
# Verifies account credentials
#************************************************************************************************************************************
Function Test-ADCredentials {
	Param($username, $password, $domain)
	Add-Type -AssemblyName System.DirectoryServices.AccountManagement
	$contextType = [System.DirectoryServices.AccountManagement.ContextType]::Domain
	$principalContext = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($contextType, $domain)
	Return New-Object PSObject -Property @{
		UserName = $username;
		IsValid = $principalContext.ValidateCredentials($username, $password).ToString()
	}
}

#************************************************************************************************************************************
# function AddComputer
#
# Parameters:
# 	$dnsHostName
#	$AgentName
#	$credentialName
#	$sqlConnections
# 	
# Stored Procedures:
#	dbo.spComputerUpsert
#
# Adds Computer to monitoring framework
#************************************************************************************************************************************
function AddComputer {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
	[Parameter(Mandatory=$True,Position=2)]
	[string]$AgentName,
	[Parameter(Mandatory=$False,Position=3)]
	[string]$credentialName,
	[Parameter(Mandatory=$False,Position=4)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)

    ################################################################################
    # TEST CONNECTIVITY
    ################################################################################  
    $testPing = GetNetworkPingStatus -dnsHostName $dnsHostName
    if($testPing -eq $null){
        Write-Host "Unable to ping computer: $dnsHostName"
		AddLogEntry -Reference $dnsHostName -Status "Error" -moduleName "MonitorAdmin: Add Computer" -messageString "Unable to ping computer: $dnsHostName." -sqlConnection $sqlConnection
        return "Failed: Unable to ping."
    }

    $testPort = TestPort -ComputerName $dnsHostName -Port 135 -Protocol "TCP"
    if($testPort -eq "Failed"){
        Write-Host "Unable to communicate on port 135 with computer: $dnsHostName" -ForegroundColor Red
		AddLogEntry -Reference $dnsHostName -Status "Error" -moduleName "MonitorAdmin: Add Computer" -messageString "Unable to communicate on port 135 with computer: $dnsHostName." -sqlConnection $sqlConnection
        return "Failed: Unable to communicate on port 135"
    }	

    ################################################################################
    # DERIVE DOMAIN FROM FQDN; UGLY, UGLY, UGLY
    ################################################################################
	[string]$Domain = $dnsHostName.Substring($dnsHostName.IndexOf(".")+1,($dnsHostName.Length - $dnsHostName.IndexOf("."))-1)
	
	$sqlCommand = GetStoredProc $sqlConnection "dbo.spComputerUpsert"
	[Void]$sqlCommand.Parameters.Add("@Domain", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@AgentName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@CredentialName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
	[Void]$sqlCommand.Parameters.Add("@dbAddDate", [system.data.SqlDbType]::datetime)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	
	$timeNow = (Get-Date)
	$sqlCommand.Parameters["@Domain"].Value = $Domain
	$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
	$sqlCommand.Parameters["@AgentName"].Value = $agentName
	$sqlCommand.Parameters["@CredentialName"].Value = $credentialName
	$sqlCommand.Parameters["@Active"].Value = $true
	$sqlCommand.Parameters["@dbAddDate"].Value = $timeNow
	$sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow
	[void]$sqlCommand.ExecuteNonQuery()
	
	$sqlCommand.Dispose()
	
	AddLogEntry $dnsHostName "Info" "MonitorAdmin: Add Computer" "Added computer $dnsHostName to monitored list." $sqlConnection
	
	return "Success.  Added computer $dnsHostName with credential ($credentialName)."
}

#************************************************************************************************************************************
# function RemoveComputer
#
# Parameters:
# 	$dnsHostName
#	$sqlConnections
# 	
# Stored Procedures:
#	dbo.spComputerDelete
#
# Removes Computer to monitoring framework
#************************************************************************************************************************************
function RemoveComputer {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
	[Parameter(Mandatory=$False,Position=2)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)

	# Remove entry from dbo.Computer (list of monitored computers)
	$sqlCommand = GetStoredProc $sqlConnection "dbo.spComputerDelete"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	
	$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
	[void]$sqlCommand.ExecuteNonQuery()
	
	$sqlCommand.Dispose()
	
	# Inactivate entries in configuration database
	$sqlCommand = GetStoredProc $sqlConnection "dbo.spComputerInactivate"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	
	$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
	$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
	[void]$sqlCommand.ExecuteNonQuery()
	
	$sqlCommand.Dispose()	
	
	AddLogEntry $dnsHostName "Info" "MonitorAdmin: Remove Computer" "Removed computer $dnsHostName from monitored list." $sqlConnection
	
	return "Success.  Removed computer $dnsHostName."	
}

#************************************************************************************************************************************
# function InactivateComputer
#
# Parameters:
# 	$dnsHostName
#	$sqlConnections
# 	
# Stored Procedures:
#	dbo.spComputerDelete
#
# Inactivates computer currently in monitoring framework.  The computer object remains, but monitoring is temporarily turned off.
#************************************************************************************************************************************
function InactivateComputer {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
	[Parameter(Mandatory=$False,Position=2)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
	# Put in some connectivity checks here!!!!
	$sqlCommand = GetStoredProc $sqlConnection "dbo.spComputerInactivate"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
	$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
	[void]$sqlCommand.ExecuteNonQuery()
	
	$sqlCommand.Dispose()
	
	AddLogEntry $dnsHostName "Info" "MonitorAdmin: Inactivate Computer" "Inactivated computer $dnsHostName from monitored list." $sqlConnection

	return "Success.  Inactivated computer $dnsHostName."	
}

#************************************************************************************************************************************
# function ReactivateComputer
#
# Parameters:
# 	$dnsHostName
#	$sqlConnections
# 	
# Stored Procedures:
#	dbo.spComputerDelete
#
# Reactivates an inactivated computer in the monitoring framework
#************************************************************************************************************************************
function ReactivateComputer {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	[string]$dnsHostName,
	[Parameter(Mandatory=$False,Position=2)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
	# Put in some connectivity checks here!!!!
	$sqlCommand = GetStoredProc $sqlConnection "dbo.spComputerReactivate"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	
	$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
	$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
	[void]$sqlCommand.ExecuteNonQuery()
	
	$sqlCommand.Dispose()
	
	AddLogEntry $dnsHostName "Info" "MonitorAdmin: Reactivate Computer" "Reactivated computer $dnsHostName on monitored list." $sqlConnection

	return "Success.  Reactivated computer $dnsHostName."	
}

#************************************************************************************************************************************
# function AddCredential
#
# Parameters:
#	$credentialName
#	$sqlConnection
# 	
# Stored Procedures:
#	dbo.spCredentialUpsert
#
# Inserts/Updates Credential with encrypted password.
#************************************************************************************************************************************
function AddCredential {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	[string]$credentialName,
	[Parameter(Mandatory=$False,Position=2)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)

	If(!Test-Path $global:KEY_FILE){
		Throw "Password key file does not exist; please create first!"
	} else {
		$keyString = Get-Content $global:KEY_FILE
		do {
			$credentialType = Read-Host -Prompt "Enter account type (SQL/Windows) "
		} until ($credentialType -eq "SQL" -or $credentialType -eq "Windows")
		if($credentialType -eq "Windows"){
			$credential = Get-Credential
			$domain = $credential.UserName.Substring(0,$credential.UserName.IndexOf("\"))
			$username = $credential.UserName.Replace($domain + "\", "")
			$response = Test-ADCredentials $username $credential.GetNetworkCredential().Password $domain
			
			if($response.IsValid){
				$credentialAccountName = $credential.UserName
				$encryptedPassword = $credential.Password | ConvertFrom-SecureString
			} else {
				Throw "Credential entry failed validation!"
			}			
		} else {
			$credentialAccountName = Read-Host -Prompt "Enter SQL account name            "
			$securePassword = Read-Host -Prompt "Enter SQL password                " -AsSecureString
			
			$encryptedPassword = $securePassword | ConvertFrom-SecureString -Key $keyString
		}
		
		
		$sqlCommand = GetStoredProc $sqlConnection "dbo.spCredentialUpsert"
		[Void]$sqlCommand.Parameters.Add("@Name", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@CredentialType", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@AccountName", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Password", [system.data.SqlDbType]::nvarchar)
		[Void]$sqlCommand.Parameters.Add("@Active", [system.data.SqlDbType]::bit)
		[Void]$sqlCommand.Parameters.Add("@dbAddDate", [system.data.SqlDbType]::datetime)
		[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
		
		$timeNow = (Get-Date)
		$sqlCommand.Parameters["@Name"].Value = $credentialName
		$sqlCommand.Parameters["@CredentialType"].Value = $credentialType
		$sqlCommand.Parameters["@AccountName"].Value = $credentialAccountName
		$sqlCommand.Parameters["@Password"].Value = $encryptedPassword
		$sqlCommand.Parameters["@Active"].Value = $true
		$sqlCommand.Parameters["@dbAddDate"].Value = $timeNow
		$sqlCommand.Parameters["@dbLastUpdate"].Value = $timeNow
		[void]$sqlCommand.ExecuteNonQuery()
		
		$sqlCommand.Dispose()
	}
	
	AddLogEntry "AddCredential" "Info" "MonitorAdmin" "Added credential $credentialName ($credentialType) to credential list." $sqlConnection
	
}

function InactivateCredential {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	[string]$credentialName,
	[Parameter(Mandatory=$False,Position=2)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
}

function ReactivateCredential {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$True,Position=1)]
	[string]$credentialName,
	[Parameter(Mandatory=$False,Position=2)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
}

#************************************************************************************************************************************
# function CreateKeyFile
#
# Parameters:
#	$sqlConnection
# 	
# Stored Procedures:
#
# Creates random Key file for Encryption
#************************************************************************************************************************************
function CreateKeyFile {
[CmdletBinding()]
Param (
	[Parameter(Mandatory=$False,Position=1)]
	[System.Data.SqlClient.SqlConnection]$sqlConnection
)
	If(Test-Path $global:KEY_FILE){
		Throw "File $global:KEY_FILE already exists! Overwriting will result in the loss of existing credential passwords!"
	} else {
		Try {
			$keyValue = New-Object Byte[] 24   # You can use 16, 24, or 32 for AES
			[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($keyValue)
			$keyValue | out-file $global:KEY_FILE
			AddLogEntry "CreateKeyFile" "Info" "MonitorAdmin: Create Key File" "Created encryption key file." $sqlConnection
			[string]$result = "Success"
			
		} Catch [System.Exception] {
			$msg = $_.Exception.Message
			AddLogEntry "CreateKeyFile" "Error" "MonitorAdmin: Create Key File" "$msg" $sqlConnection
			[string]$result = "Failure"
		}
	}
	return $result	
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
Set-Variable KEY_FILE -Scope "Global" -Value ".\AES.key"
Set-Variable CONFIG_FILE -Scope "Global" -Value ".\app.monitor.config"

################################################################################
# LOAD APPLICATION CONFIGURATION FILE
################################################################################
If(Test-Path $global:CONFIG_FILE){
	Try {
		[xml]$appConfig = Get-Content $global:CONFIG_FILE
	} Catch {
		Throw "Unable to process XML in configuration file!"
	}
} else {
	Throw "Unable to load config file!"
}

################################################################################
# SET AGENT NAME FROM CONFIG FILE (IF NOT SPECIFIED)
################################################################################
if(($agentName -eq $null) -or ($agentName.Length -eq 0)) {
	$agentName = $appConfig.configuration.settings.AgentName.Value
}

################################################################################
# ESTABLISH CONNECTION TO CENTRAL REPOSITORY
################################################################################
[string]$sqlConnectionString = $appConfig.configuration.connectionstrings.centralrepository.connectionstring
[System.Data.SqlClient.SqlConnection]$sqlConnection = GetSQLConnection -sqlConnectionString $sqlConnectionString

# Check connection to repository
if ($sqlConnection.State -ne "Open")	{
	Throw "Unable to open central repository database.  Application terminating."
}

################################################################################
# GET LIST OF COMPUTERS TO UPDATE; PLACE INTO ARRAY
################################################################################
$computers = @()

if($fileName){
	if(Test-Path $fileName){
		$computers = Get-Content $fileName
	} else {
		Throw "Unable to access $fileName."
	}
} else {
	$computers += $ComputerName
}

################################################################################
# ITERATE THROUGH LIST OF COMPUTERS AND PERFORM SPECIFIED ACTION
################################################################################
Switch ($Action) {
	"AddComputer" {
		foreach($entry in $computers) {
			$status = AddComputer $entry $agentName $credentialName $sqlConnection
			Write-Host $status
		}
	}
	"UpdateComputer" {
		foreach($entry in $computers) {	
			$status = AddComputer $entry $agentName $credentialName $sqlConnection
			Write-Host $status
		}
	}	
	"RemoveComputer" {
		foreach($entry in $computers) {
			RemoveComputer $entry $sqlConnection
		}			
	}
	"InactivateComputer" {
		foreach($entry in $computers) {
			InactivateComputer $entry $sqlConnection
		}
	}
	"ReactivateComputer" {
		foreach($entry in $computers) {	
			ReactivateComputer $entry $sqlConnection
		}
	}
	"AddCredential" {
		AddCredential $credentialName $sqlConnection
	}
	"UpdateCredential" {
		AddCredential $credentialName $sqlConnection
	}
	"InactivateCredential" {
		InactivateCredential $credentialName $sqlConnection
	}
	"ReactivateCredential" {
		ReactivateCredential $credentialName $sqlConnection
	}
	"CreateKeyFile" {
		CreateKeyFile $sqlConnection
	}
	Default { Write-Host "$Action not implemented!"}
}

