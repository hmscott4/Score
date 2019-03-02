<#

.SYNOPSIS

	This script will deploy reports and data sources from a folder to a Report Server.


.DESCRIPTION

	This script will deploy reports and data sources from a folder to a Report Server.

	Instructions:
	1. Create a new (empty folder)
	2. Copy script file into new folder
	3. Create a new subfolder called Reports
	4. Copy Reports, Data Sources and Data Sets into folder "Reports"
	5. Execute script
	6. Update Data Source credentials to match requirements


.INPUTS

	Script will prompt the user for the following:
	1. Report Server name (url to base report server, not including "/Reportserver" or "/Reports")
    2. Report Server instance name (default "ReportServer")
	3. Target Folder for reports (default SCORE)
    4. Target Folder for Shared Data sources (default "Data Sources")
    5. Target Folder for Shared Data Sets (default "Datasets")
	3. Overwrite Data Sources (Y/N)
	4. Overwrite Data Sets (Y/N)
	5. Overwrite Reports (Y/N)
  	
.OUTPUTS
	
	Data Sources, Data Sets and Reports are written to report server.

.NOTES

  Version:        1.0
  Author:         Steffen Daneels
  Creation Date:  2017/01/24

  This script was "liberated" from https://kohera.be/blog/sql-server/automated-deployment-ssrs-reports-powershell/
  I made one minor fix to the Data Sources deployment process to fix a minor bug.

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

###################################################################################
# WORKING VARIABLES
###################################################################################
$CurrentWorkingFolder = split-path -parent $MyInvocation.MyCommand.Definition
$sourceDirectory = "$CurrentWorkingFolder\Reports"

###################################################################################
# OBTAIN RUNTIME VALUES
###################################################################################
# Set server IP address based on Environment provided from Config file
$webServiceUrl = Read-Host -Prompt 'Reporting Host URL (Http://hostname or Http://xxx.xxx.xx.xx)' # you can also give like "Http://xxx.xxx.xx.xx"

$defaultInstance = 'ReportServer'
$prompt = Read-Host "Reporting server instance name [$($defaultInstance)]"
$RPServerName = ($defaultInstance,$prompt)[[bool]$prompt]

$defaultFolder = 'SCORE'
$prompt = Read-Host "Reports Folder [$($defaultFolder)]"
$reportFolder = ($defaultFolder,$prompt)[[bool]$prompt]

$defaultDataSourceFolder = "Data Sources"
$prompt = Read-Host "Data Sources Folder [$($defaultDataSourceFolder)]"
$dataSourceFolder = ($defaultDataSourceFolder,$prompt)[[bool]$prompt]

$defaultDataSetFolder = "Datasets"
$prompt = Read-Host "Dataset Folder [$($defaultDataSetFolder)]"
$dataSetFolder = ($defaultDataSetFolder,$prompt)[[bool]$prompt]

#Overwrite properties
$IsOverwriteDataSource = switch (Read-Host -Prompt 'Overwrite DataSources (Y,N)? [N]')
{
    "Y" {[Boolean] 1}
    default {[Boolean] 0}
}
$IsOverwriteDataSet = switch (Read-Host -Prompt 'Overwrite DataSet (Y,N)? [N]')
{
    "Y" {[Boolean] 1}
    default {[Boolean] 0}
}
$IsOverwriteReport = switch (Read-Host -Prompt 'Overwrite Reports (Y,N)? [Y]')
{
    "N" {[Boolean] 0}
    default {[Boolean] 1}
}

$reportPath ="/" # Rool Level
$rsReportFolder = $reportPath + $reportFolder
$rsDataSourceFolder = $reportPath + $defaultDataSourceFolder
$rsDataSetFolder = $reportPath + $defaultDataSetFolder

###################################################################################
# CONNECT TO SSRS
###################################################################################

#Connecting to SSRS
Write-Host "Reportserver: $webServiceUrl" -ForegroundColor Magenta
Write-Host "Creating Proxy, connecting to : $webServiceUrl/$RPServerName/ReportService2010.asmx?WSDL" -ForegroundColor Magenta
Write-Host ""
$ssrsProxy = New-WebServiceProxy -Uri $webServiceUrl'/'$RPServerName'/ReportService2010.asmx?WSDL' -UseDefaultCredential

If($ssrsProxy -eq $null)
{
    Write-Error "Unable to connect to $webServiceURL; check URL, port, transport and permissions"
    Exit
}


###################################################################################
# CREATE REPORTS FOLDER
###################################################################################
Write-host ""
try
{
    $result = $ssrsProxy.CreateFolder($reportFolder, $reportPath, $null)
    Write-Host "Created new folder: $rsReportFolder"
}
catch [System.Web.Services.Protocols.SoapException]
{
    if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
    {
        write-verbose "Folder: $reportFolder already exists."
    }
    else
    {
        $msg = "Error creating folder: $reportFolder. Msg: '{0}'" -f $_.Exception.Detail.InnerText
        Write-Error $msg
    }

}
###################################################################################
# CREATE DATA SOURCE FOLDER
###################################################################################
Write-host ""
try
{
    $result = $ssrsProxy.CreateFolder($dataSourceFolder, $reportPath, $null)
    Write-Host "Created new folder: $rsDataSourceFolder"
}
catch [System.Web.Services.Protocols.SoapException]
{
    if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
    {
        Write-Verbose "Folder: $dataSourceFolder already exists."
    }
    else
    {
        $msg = "Error creating folder: $dataSourceFolder. Msg: '{0}'" -f $_.Exception.Detail.InnerText
        Write-Error $msg
    }
}

###################################################################################
# CREATE DATASET FOLDER
###################################################################################
Write-host ""
try
{
    $result = $ssrsProxy.CreateFolder($dataSetFolder, $reportPath, $null)
    Write-Host "Created new folder: $rsDataSetFolder"
}
catch [System.Web.Services.Protocols.SoapException]
    {
    if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
    {
        Write-Verbose "Folder: $dataSetFolder already exists."
    }
    else
    {
        $msg = "Error creating folder: $dataSetFolder. Msg: '{0}'" -f $_.Exception.Detail.InnerText
        Write-Error $msg
    }

}
Write-Host ""

###################################################################################
# CREATE DATA SOURCES
###################################################################################
Write-host "Uploading Shared Data Sources to $dataSourceFolder" -ForegroundColor Green

foreach($rdsFile in Get-ChildItem $sourceDirectory -Filter *.rds)
{
    Write-Verbose "Uploading $rdsFile"

    #create data source
    try
    {

        $rdsf = [System.IO.Path]::GetFileNameWithoutExtension($rdsFile);

        $rdsPath = $sourceDirectory+"\"+$rdsf+".rds"

        Write-Verbose "Reading data from $rdsPath"

        [xml]$Rds = Get-Content -Path $rdsPath
        $ConnProps = $Rds.RptDataSource.ConnectionProperties

        $type = $ssrsProxy.GetType().Namespace
        $datatype = ($type + '.DataSourceDefinition')
        $datatype_Prop = ($type + '.Property')

        $DescProp = New-Object($datatype_Prop)
        $DescProp.Name = 'Description'
        $DescProp.Value = ''
        $HiddenProp = New-Object($datatype_Prop)
        $HiddenProp.Name = 'Hidden'
        $HiddenProp.Value = 'true'
        $Properties = @($DescProp, $HiddenProp)

        $Definition = New-Object ($datatype)
        $Definition.ConnectString = $ConnProps.ConnectString
        $Definition.Extension = $ConnProps.Extension
        if ([Convert]::ToBoolean($ConnProps.IntegratedSecurity)) {
            $Definition.CredentialRetrieval = 'Integrated'
        }

        $DataSource = New-Object -TypeName PSObject -Property @{
            Name = $Rds.RptDataSource.Name
            Path = $rsDataSourceFolder + '/' + $Rds.RptDataSource.Name
        }


        $warnings = $ssrsProxy.CreateDataSource($rdsf, $rsDataSourceFolder ,$IsOverwriteDataSource, $Definition, $Properties)

        # Write-Host $warnings

    }
    catch [System.IO.IOException]
    {
        $msg = "Error while reading rds file : '{0}', Message: '{1}'" -f $rdsFile, $_.Exception.Message
        Write-Error msgcler
    }
    catch [System.Web.Services.Protocols.SoapException]
    {
        if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
        {
            Write-Verbose "Data Source: $rdsf already exists."
        }
        else
        {

            $msg = "Error uploading report: $rdsf. Msg: '{0}'" -f $_.Exception.Detail.InnerText
            Write-Error $msg
        }

    }
}
Write-Host ""


###################################################################################
# CREATE DATASETS
###################################################################################
Write-host "Uploading Shared Datasets to $dataSetFolder" -ForegroundColor Green
foreach($rsdfile in Get-ChildItem $sourceDirectory -Filter *.rsd)
{
    Write-host ""

    try {
        $rsdf = [System.IO.Path]::GetFileNameWithoutExtension($rsdfile)
        $RsdPath = $sourceDirectory+'\'+$rsdf+'.rsd'

        # Write-Verbose "New-SSRSDataSet -RsdPath $RsdPath -Folder $dataSetFolder"

        $RawDefinition = Get-Content -Encoding Byte -Path $RsdPath
        $warnings = $null

        $Results = $ssrsProxy.CreateCatalogItem("DataSet", $rsdf, $rsDataSetFolder, $IsOverwriteDataSet, $RawDefinition, $null, [ref]$warnings)

        write-host "Shared Dataset $rsdf created successfully." -ForegroundColor Green
    }
    catch [System.IO.IOException]
    {
        $msg = "Error while reading rsd file : '{0}', Message: '{1}'" -f $rsdfile, $_.Exception.Message
        Write-Error msgcler
    }
    catch [System.Web.Services.Protocols.SoapException]
    {
        if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
        {
            Write-Verbose "Dataset: $rsdf already exists."
        }
        else
        {

            $msg = "Error uploading report: $rsdf. Msg: '{0}'" -f $_.Exception.Detail.InnerText
            Write-Error $msg
        }

    }


    ###################################################################################
    # UPDATE DATA SOURCE FOR DATA SET
    ###################################################################################
    $datasetFullName = "/" + $dataSetFolder + "/" + $rsdf
    Write-Verbose "Updating data sources for dataset $rsdf"

    $rep = $ssrsProxy.GetItemDataSources($datasetFullName)
    $rep | ForEach-Object {
        $proxyNamespace = $_.GetType().Namespace

        $thisDataSource = New-Object ("$proxyNamespace.DataSource")

        $thisDataSource.Item = New-Object ("$proxyNamespace.DataSourceReference")
        $rsDataSourcePath = $_.Item.Reference
        $thisDataSource.Item.Reference = $rsDataSourcePath

        $_.item = $thisDataSource.Item
        $ssrsProxy.SetItemDataSources($datasetFullName, $_)
        Write-Verbose "Changing datasource `"$($_.Name)`" to $($_.Item.Reference)"
    }

}

###################################################################################
# CREATE REPORTS
###################################################################################
foreach($rdlfile in Get-ChildItem $sourceDirectory -Filter *.rdl)
{
    Write-host ""

    $reportName = [System.IO.Path]::GetFileNameWithoutExtension($rdlFile);
    write-host "Uploading $reportName" -ForegroundColor Green
    try
    {
        #Get Report content in bytes
        Write-Verbose "Getting file content of : $rdlFile"
        $byteArray = gc $rdlFile.FullName -encoding byte
        $msg = "Total length: {0}" -f $byteArray.Length
        Write-Verbose $msg

        Write-Verbose "Uploading to: $rsReportFolder"

        $type = $ssrsProxy.GetType().Namespace
        $datatype = ($type + '.Property')

        $DescProp = New-Object($datatype)
        $DescProp.Name = 'Description'
        $DescProp.Value = ''
        $HiddenProp = New-Object($datatype)
        If($reportName -eq "Dash_OrganizationSummary"){
	
	        $HiddenProp.Name = 'Hidden'
	        $HiddenProp.Value = 'false'
        } Else {
	
	        $HiddenProp.Name = 'Hidden'
	        $HiddenProp.Value = 'true'
        }
        $Properties = @($DescProp, $HiddenProp)

        #Call Proxy to upload report

        $warnings = $null

        $Results = $ssrsProxy.CreateCatalogItem("Report", $reportName,$rsReportFolder, $IsOverwriteReport,$byteArray,$Properties,[ref]$warnings)

        if($warnings.length -le 1)
        { 
            Write-Host "Uploaded successfully." -ForegroundColor Green
        }
        else
        { 
            Write-Host "Uploaded with warnings; run with verbose to see detailed messages." -ForegroundColor Yellow
            foreach($warning in $warnings)
            {
                Write-Verbose $warning.message
            }
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

    ###################################################################################
    # UPDATE DATA SOURCES FOR REPORT
    ###################################################################################
    $reportFullName = $rsReportFolder+"/"+$reportName
    Write-Verbose "Updating data sources for $reportFullName"

    $rep = $ssrsProxy.GetItemDataSources($reportFullName)
    $rep | ForEach-Object {
        $proxyNamespace = $_.GetType().Namespace

        $thisDataSource = New-Object ("$proxyNamespace.DataSource")

        $thisDataSource.Item = New-Object ("$proxyNamespace.DataSourceReference")
        $rsDataSourcePath = $rsDataSourceFolder+"/" + $($_.Name)
        $thisDataSource.Item.Reference = $rsDataSourcePath

        $_.item = $thisDataSource.Item
        $ssrsProxy.SetItemDataSources($reportFullName, $_)
        Write-Verbose "Changing datasource `"$($_.Name)`" to $($_.Item.Reference)"
    }
    ###################################################################################
    # UPDATE SHARED DATA SETS FOR REPORT
    ###################################################################################
    $reportFullName = $rsReportFolder+"/"+$reportName
    Write-Verbose "Updating shared data sets for $reportFullName" 

    $ref = $ssrsProxy.GetItemReferences($reportFullName,"DataSet")
    $ref | ForEach-Object {
        Write-Host "Update Shared Data Set $($_.name) for report $ReportName." -foregroundcolor Red
        # $proxyNamespace = $_.GetType().Namespace

        # $thisDataSet = New-Object ("$proxyNamespace.ItemReferenceData")

        # $thisDataSet.Item = New-Object ("$proxyNamespace.ItemReferenceData")
        # $rsDataSetPath = $rsDataSetFolder + "/" + $($_.Name)
        # $thisDataSet.Name = $_.Name
        # $thisDataSet.Reference = $rsDataSetPath
        # $thisDataSet.ReferenceType = "DataSet"

        # $_.item = $thisDataSet.Item
        # $ssrsProxy.SetItemReferences($reportFullName, $_)
        # Write-Verbose "Changing dataset `"$($_.Name)`" to $($rsDataSetPath)"
    }
}

Write-host ""
Write-host " We have successfully Deployed SSRS Project" -ForegroundColor Magenta
Write-host ""

#Open IE
$RPServernameUI = $RPServerName.Replace('ReportServer','Reports')
Start-Process "iexplore.exe" $webServiceUrl'/'$RPServernameUI"/Pages/Folder.aspx"