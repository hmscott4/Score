#************************************************************************************************************************************
# function CheckComputerShare
#
# Parameters:
# 	- $dnsHostName
#	- $psCredential
#	- $sqlConnectionString
#	- $invocationPath
#
# Stored Procedures: 
#	- cm.spComputerShareUpsert
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
[string]$moduleName = "CheckComputerShare"

#************************************************************************************************************************************
# function GetShareType
#
# Parameters:
# 	- ShareType to convert
#
# Function to convert ShareType to string
#
#************************************************************************************************************************************
function GetShareType {
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
	[bigint]$shareType
)
	[string]$value = ""
	Switch($shareType){
		0 {$value = "Disk Drive"}
		1 {$value = "Print Queue"}
		2 {$value = "Device"}
		3 {$value = "IPC"}
		2147483648 {$value = "Disk Drive Admin"}
		2147483649 {$value = "Print Queue Admin"}
		2147483650 {$value = "Device Admin"}
		2147483651 {$value = "IPC Admin"}
		3221225472 {$value = "Cluster Disk Drive Admin"}
		default {$value = "Unknown: $shareType"}
	}
	
	return $value
}

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

try	{
	$queryString = "SELECT * FROM Win32_Share"
	$computerShares = GetCIMResult $dnsHostName $queryString $psCredential

	$sqlCommand = GetStoredProc $sqlConnection "cm.spComputerShareInactivateByComputer"
	[Void]$sqlCommand.Parameters.Add("@dnsHostName", [system.data.SqlDbType]::nvarchar)
	[Void]$sqlCommand.Parameters.Add("@dbLastUpdate", [system.data.SqlDbType]::datetime)
	$sqlCommand.Parameters["@dnsHostName"].value = $dnsHostName
	$sqlCommand.Parameters["@dbLastUpdate"].value = (Get-Date)

	[Void]$sqlCommand.ExecuteNonQuery()
	$sqlCommand.Dispose()
	
	$sqlCommand = GetStoredProc $sqlConnection "cm.spComputerShareUpsert"
	[void]$sqlCommand.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Name",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Description",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Path",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Status",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Type",  [System.Data.SqlDbType]::nvarchar)
	[void]$sqlCommand.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
	[void]$sqlCommand.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)
		
	foreach($computerShare in $computerShares) {
		Try {
			[string]$shareName = $computerShare.Name
			[string]$escShareName = $computerShare.Name.Replace("\","\\")
			$shareType = GetShareType $computerShare.Type
			
			$sqlCommand.Parameters["@dnsHostName"].Value = $dnsHostName
			$sqlCommand.Parameters["@Name"].Value = $computerShare.Name
			$sqlCommand.Parameters["@Description"].Value = $computerShare.Description
			$sqlCommand.Parameters["@Path"].Value = $computerShare.Path
			$sqlCommand.Parameters["@Status"].Value = $computerShare.Status
			$sqlCommand.Parameters["@Type"].Value = $shareType
			$sqlCommand.Parameters["@Active"].Value = $true
			$sqlCommand.Parameters["@dbLastUpdate"].Value = (Get-Date)
			
			[void]$sqlCommand.ExecuteNonQuery()
			
			if($shareType -eq "Disk Drive") {
				$acl = @() 
				$queryString = "SELECT * FROM Win32_LogicalShareSecuritySetting WHERE Name='$escShareName'"
			    $shareSecurity = GetCIMResult -dnsHostName $dnsHostName -queryString $queryString -psCredential $psCredential
			    try { 
			        $securityDescriptor = $shareSecurity.GetSecurityDescriptor().Descriptor   
			        foreach($ace in $securityDescriptor.DACL){  
			            $UserName = $ace.Trustee.Name     
			            If ($ace.Trustee.Domain -ne $Null) {$UserName = "$($ace.Trustee.Domain)\$UserName"}   
			            If ($ace.Trustee.Name -eq $Null) {$UserName = $ace.Trustee.SIDString }
						if ($ace.AccessMask -eq 270467583) { 
							continue 
						} else {
			            	$acl += New-Object Security.AccessControl.FileSystemAccessRule($UserName, $ace.AccessMask, $ace.AceType) 
						}
			        }           
			    } catch [System.Exception] {
					$msg=$_.Exception.Message
				    AddLogEntry $dnsHostName "Warning" $moduleName "$shareName : $msg" $sqlConnection
					$warningCounter++
				}

				try {
					$sqlCommand2 = GetStoredProc $sqlConnection "cm.spComputerSharePermissionUpsert"
					[void]$sqlCommand2.Parameters.Add("@dnsHostName",  [System.Data.SqlDbType]::nvarchar)
					[void]$sqlCommand2.Parameters.Add("@ShareName",  [System.Data.SqlDbType]::nvarchar)
					[void]$sqlCommand2.Parameters.Add("@SecurityPrincipal",  [System.Data.SqlDbType]::nvarchar)
					[void]$sqlCommand2.Parameters.Add("@FileSystemRights",  [System.Data.SqlDbType]::nvarchar)
					[void]$sqlCommand2.Parameters.Add("@AccessControlType",  [System.Data.SqlDbType]::nvarchar)
					[void]$sqlCommand2.Parameters.Add("@IsInherited",  [System.Data.SqlDbType]::bit)
					[void]$sqlCommand2.Parameters.Add("@InheritanceFlags",  [System.Data.SqlDbType]::nvarchar)
					[void]$sqlCommand2.Parameters.Add("@PropagationFlags",  [System.Data.SqlDbType]::nvarchar)
					[void]$sqlCommand2.Parameters.Add("@Active",  [System.Data.SqlDbType]::bit)
					[void]$sqlCommand2.Parameters.Add("@dbLastUpdate",  [System.Data.SqlDbType]::datetime)		
				
					foreach($entry in $acl){
						$sqlCommand2.Parameters["@dnsHostName"].Value = $dnsHostName
						$sqlCommand2.Parameters["@ShareName"].Value = $shareName
						$sqlCommand2.Parameters["@SecurityPrincipal"].Value = $entry.IdentityReference.ToString()
						$sqlCommand2.Parameters["@FileSystemRights"].Value = $entry.FileSystemRights
						$sqlCommand2.Parameters["@AccessControlType"].Value = $entry.AccessControlType
						$sqlCommand2.Parameters["@IsInherited"].Value = $entry.IsInherited
						$sqlCommand2.Parameters["@InheritanceFlags"].Value = $entry.InheritanceFlags
						$sqlCommand2.Parameters["@PropagationFlags"].Value = $entry.PropagationFlags
						$sqlCommand2.Parameters["@Active"].Value = $true
						$sqlCommand2.Parameters["@dbLastUpdate"].Value = (Get-Date)
						[void]$sqlCommand2.ExecuteNonQuery()				
					}
				} catch [System.Exception] {
					$msg=$_.Exception.Message
				    AddLogEntry $dnsHostName "Warning" $moduleName "$shareName : $msg" $sqlConnection
					$warningCounter++
				}
				$sqlCommand2.Dispose()
			}
		} Catch [System.Exception] {
			$msg=$_.Exception.Message
			AddLogEntry $dnsHostName "Warning" $moduleName "ShareName : $computerShare.Name : $msg" $sqlConnection
			$warningCounter++
		}
	}
	$sqlCommand.Dispose()
}	
catch [System.Exception] {
	$msg = $_.Exception.Message
    AddLogEntry $dnsHostName "Error" $moduleName "$msg" $sqlConnection
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

# Return global error count
Return New-Object psobject -Property @{ErrorCount = $errorCounter; WarningCount = $warningCounter}
}