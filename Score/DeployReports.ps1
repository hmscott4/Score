<#

.SYNOPSIS

	This script is used to deploy reports to a SQL Server Reporting Services instance.  It will
	deploy reports, data sources and data sets.  


.DESCRIPTION

	This script is used to deploy reports to a SQL Server Reporting Services instance.  It will
	deploy reports, data sources and data sets.

	Instructions:
	1. Copy script to a folder (any empty folder will do, make one called "tmp"
	2. Create a new, empty subfolder called "Reports"
	3. Copy the Reports (.rdl), Data Sources (.rds) and Data sets (.rsd) files to the "Reports" folder.
    4. Execute the script.


.INPUTS

  The script will prompt the user for the Report Server URL (the base URL, without /ReportServer).

.OUTPUTS

  Reports are deployed to the report server.

.NOTES

  Version:        1.0
  Author:         Stefan Daneels
  Creation Date:  2017/01/24

  This script was "liberated" from "https://kohera.be/blog/sql-server/automated-deployment-ssrs-reports-powershell/".

#>
try{
Write-Output "This script only runs in Powershell 2.0 or above"
#Requires -Version 2.0
}
catch {
$valError = $_.Exception.Message;
echo $_.Exception.Message;
pause
}

#Original Source: http://social.technet.microsoft.com/wiki/contents/articles/34521.powershell-script-for-ssrs-project-deployment.aspx

#Setting PowerShell Execution Policy
<# Syntax -ExecutionPolicy Policy A new execution policy for the shell. Bypass Nothing is blocked and there are no warnings or prompts. -Force Suppress all prompts. By default, Set-ExecutionPolicy displays a warning whenever the execution policy is changed. -Scope ExecutionPolicyScope The scope of the execution policy. Process Affect only the current PowerShell process. #>
Set-ExecutionPolicy -scope Process -executionpolicy Bypass -force

#Checking if User has Admin Rights
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
exit
}

#Set variables with configure values

$CurrentWorkingFolder = split-path -parent $MyInvocation.MyCommand.Definition

$Environment = "DEV" #specifiying Dev/Test/Prod Environment
$reportPath ="/" # Rool Level

#$SourceDirectory = "E:\Test" # Local drive where actual RDL/RDS/RSD files contains
$SourceDirectory = "$CurrentWorkingFolder\Reports"

# Set server IP address based on Environment provided from Config file
IF( $Environment -eq "DEV")
{
$webServiceUrl = Read-Host -Prompt 'Reporting Host URL (Http://hostname or Http://xxx.xxx.xx.xx)' # you can also give like "Http://xxx.xxx.xx.xx"
$RPServerName = Read-Host -Prompt 'Reporting server name (ReportServer)'#"ReportServer"
$reportFolder = Read-Host -Prompt 'Folder to be deployed TO'
$DataSourcePath = "Data Sources" #Folder where we need to create Datasource
$DataSet_Folder = "Datasets" # Folder where we need to create DataSet
}
<#ELSEIF ( $Environment -eq "TEST") { $webServiceUrl = "http://localhost" $RPServerName = "ReportServer" $reportFolder = "TEST_DemoReports" $DataSourcePath = "/TEST_DemoReports" #Folder where we need to create Datasource $DataSet_Folder = "/TEST_DemoReports" # Folder where we need to create DataSet } ELSEIF ($Environment -eq "PROD") { $webServiceUrl = "http://localhost" $RPServerName = "ReportServer" $reportFolder = "PROD_DemoReports" $DataSourcePath = "/PROD_DemoReports" #Folder where we need to create Datasource $DataSet_Folder = "/PROD_DemoReports" # Folder where we need to create DataSet }#>

#Overwrite properties
$IsOverwriteDataSource = switch (Read-Host -Prompt 'Overwrite DataSources? [Y],[N]')
{
"Y" {[Boolean] 1}
default {[Boolean] 0}
}
$IsOverwriteDataSet = switch (Read-Host -Prompt 'Overwrite DataSet? [Y],[N]')
{
"Y" {[Boolean] 1}
default {[Boolean] 0}
}
$IsOverwriteReport = switch (Read-Host -Prompt 'Overwrite Reports? [Y],[N]')
{
"N" {[Boolean] 0}
default {[Boolean] 1}
}

#Connecting to SSRS
Write-Host "Reportserver: $webServiceUrl" -ForegroundColor Magenta
Write-Host "Creating Proxy, connecting to : $webServiceUrl/$RPServerName/ReportService2010.asmx?WSDL" #Version SQL2012
Write-Host ""
$ssrsProxy = New-WebServiceProxy -Uri $webServiceUrl'/'$RPServerName'/ReportService2010.asmx?WSDL' -UseDefaultCredential

$reportFolder_Final = $reportPath + $reportFolder
$dataSourceFolder_Final = $reportPath + $DataSourcePath
$dataSetFolder_Final = $reportPath + $DataSet_Folder

##########################################
#Create Report Folder
Write-host ""
try
{
$ssrsProxy.CreateFolder($reportFolder, $reportPath, $null)
Write-Host "Created new folder: $reportFolder_Final"
}
catch [System.Web.Services.Protocols.SoapException]
{
if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
{
Write-Host "Folder: $reportFolder already exists."
}
else
{
$msg = "Error creating folder: $reportFolder. Msg: '{0}'" -f $_.Exception.Detail.InnerText
Write-Error $msg
}

}
##########################################
#Create DataSource Folder
Write-host ""
try
{
$ssrsProxy.CreateFolder($DataSourcePath, $reportPath, $null)
Write-Host "Created new folder: $dataSourceFolder_Final"
}
catch [System.Web.Services.Protocols.SoapException]
{
if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
{
Write-Host "Folder: $DataSourcePath already exists."
}
else
{
$msg = "Error creating folder: $DataSourcePath. Msg: '{0}'" -f $_.Exception.Detail.InnerText
Write-Error $msg
}

}
##########################################
#Create DataSet Folder
Write-host ""
try
{
$ssrsProxy.CreateFolder($DataSet_Folder, $reportPath, $null)
Write-Host "Created new folder: $dataSetFolder_Final"
}
catch [System.Web.Services.Protocols.SoapException]
{
if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
{
Write-Host "Folder: $DataSet_Folder already exists."
}
else
{
$msg = "Error creating folder: $DataSet_Folder. Msg: '{0}'" -f $_.Exception.Detail.InnerText
Write-Error $msg
}

}

##########################################
#Create datasource

foreach($rdsfile in Get-ChildItem $SourceDirectory -Filter *.rds)
{
Write-host $rdsfile

#create data source
try
{

$rdsf = [System.IO.Path]::GetFileNameWithoutExtension($rdsfile);

$RdsPath = $SourceDirectory+"\"+$rdsf+".rds"

Write-host "Reading data from $RdsPath"

$Rds = Get-Content -Path $RdsPath
$ConnProps = $Rds.RptDataSource.ConnectionProperties

$type = $ssrsProxy.GetType().Namespace
$datatype = ($type + '.DataSourceDefinition')
$datatype_Prop = ($type + '.Property')

$DescProp = New-Object($datatype_Prop)
$DescProp.Name = 'Description'
$DescProp.Value = ''
$HiddenProp = New-Object($datatype_Prop)
$HiddenProp.Name = 'Hidden'
$HiddenProp.Value = 'false'
$Properties = @($DescProp, $HiddenProp)

$Definition = New-Object ($datatype)
$Definition.ConnectString = $ConnProps.ConnectString
$Definition.Extension = $ConnProps.Extension
if ([Convert]::ToBoolean($ConnProps.IntegratedSecurity)) {
$Definition.CredentialRetrieval = 'Integrated'
}

$DataSource = New-Object -TypeName PSObject -Property @{
Name = $Rds.RptDataSource.Name
Path = $dataSourceFolder_Final + '/' + $Rds.RptDataSource.Name
}

<# if ($IsOverwriteDataSource -eq 1) { [boolean]$IsOverwriteDataSource = 1 } else { [boolean]$IsOverwriteDataSource = 0 } #>

$warnings = $ssrsProxy.CreateDataSource($rdsf, $dataSourceFolder_Final ,$IsOverwriteDataSource, $Definition, $Properties)

# Write-Host $warnings

}
catch [System.IO.IOException]
{
$msg = "Error while reading rds file : '{0}', Message: '{1}'" -f $rdsfile, $_.Exception.Message
Write-Error msgcler
}
catch [System.Web.Services.Protocols.SoapException]
{
if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
{
Write-Host "DataSource: $rdsf already exists."
}
else
{

$msg = "Error uploading report: $rdsf. Msg: '{0}'" -f $_.Exception.Detail.InnerText
Write-Error $msg
}

}
}

##########################################
# Create Dataset
Write-host "dataset changes start"
foreach($rsdfile in Get-ChildItem $SourceDirectory -Filter *.rsd)
{
Write-host ""

$rsdf = [System.IO.Path]::GetFileNameWithoutExtension($rsdfile)
$RsdPath = $SourceDirectory+'\'+$rsdf+'.rsd'

Write-Verbose "New-SSRSDataSet -RsdPath $RsdPath -Folder $DataSet_Folder"

$RawDefinition = Get-Content -Encoding Byte -Path $RsdPath
$warnings = $null

$Results = $ssrsProxy.CreateCatalogItem("DataSet", $rsdf, $dataSetFolder_Final, $IsOverwriteDataSet, $RawDefinition, $null, [ref]$warnings)

write-host "dataset created successfully"

}

#############################
#For each RDL file in Folder

foreach($rdlfile in Get-ChildItem $SourceDirectory -Filter *.rdl)
{
Write-host ""

#ReportName
$reportName = [System.IO.Path]::GetFileNameWithoutExtension($rdlFile);
write-host $reportName -ForegroundColor Green
#Upload File
try
{
#Get Report content in bytes
Write-Host "Getting file content of : $rdlFile"
$byteArray = gc $rdlFile.FullName -encoding byte
$msg = "Total length: {0}" -f $byteArray.Length
Write-Host $msg

Write-Host "Uploading to: $reportFolder_Final"

$type = $ssrsProxy.GetType().Namespace
$datatype = ($type + '.Property')

$DescProp = New-Object($datatype)
$DescProp.Name = 'Description'
$DescProp.Value = ''
$HiddenProp = New-Object($datatype)
$HiddenProp.Name = 'Hidden'
$HiddenProp.Value = 'false'
$Properties = @($DescProp, $HiddenProp)

#Call Proxy to upload report

$warnings = $null

$Results = $ssrsProxy.CreateCatalogItem("Report", $reportName,$reportFolder_Final, $IsOverwriteReport,$byteArray,$Properties,[ref]$warnings)

if($warnings.length -le 1)
{ Write-Host "Upload Success." -ForegroundColor Green
}
else
{ write-host $warnings
}

}
catch [System.IO.IOException]
{
$msg = "Error while reading rdl file : '{0}', Message: '{1}'" -f $rdlFile, $_.Exception.Message
Write-Error msg
}
catch [System.Web.Services.Protocols.SoapException]
{

$msg = "Error uploading report: $reportName. Msg: '{0}'" -f $_.Exception.Detail.InnerText
Write-Error $msg

}

##########################################
##Change Datasource on report
$reportFullName = $reportFolder_Final+"/"+$reportName
Write "datasource record $reportFullName"

$rep = $ssrsProxy.GetItemDataSources($reportFullName)
$rep | ForEach-Object {
$proxyNamespace = $_.GetType().Namespace

$constDatasource = New-Object ("$proxyNamespace.DataSource")

$constDatasource.Item = New-Object ("$proxyNamespace.DataSourceReference")
$FinalDatasourcePath = $dataSourceFolder_Final+"/" + $($_.Name)
$constDatasource.Item.Reference = $FinalDatasourcePath

$_.item = $constDatasource.Item
$ssrsProxy.SetItemDataSources($reportFullName, $_)
Write-Host "Changing datasource `"$($_.Name)`" to $($_.Item.Reference)"
}

}

Write-host ""
Write-host " We have successfully Deployed SSRS Project" -ForegroundColor Magenta
Write-host ""

#Open IE
$RPServernameUI = $RPServerName.Replace('ReportServer','Reports')
Start-Process "iexplore.exe" $webServiceUrl'/'$RPServernameUI"/Pages/Folder.aspx"