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

  Change Log:
  2019/02/01 HMS 
  This script was "liberated" from https://kohera.be/blog/sql-server/automated-deployment-ssrs-reports-powershell/
  I made one minor fix to the Data Sources deployment process to fix a minor bug.

  2019/03/01 HMS
  Substantial changes to script:
   - Added Try/Catch to Dataset
   - Updated user prompts to take in default values
   - Updated comments
   - Cleaned up variable names/standardized naming conventions
   - Cleaned up logig for re-associating reports to Data Sources (and Share Data Sets to Data Sources)
   - Added early exit if ReportServer connection does not work

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
$sourceDirectory = "$CurrentWorkingFolder\Score.Reports"

###################################################################################
# OBTAIN RUNTIME VALUES
###################################################################################
$webServiceUrl = Read-Host -Prompt 'Reporting Host URL (Http://hostname or Http://xxx.xxx.xx.xx)' # you can also give like "Http://xxx.xxx.xx.xx"

$defaultInstance = 'ReportServer'
$prompt = Read-Host "Reporting server instance name [$($defaultInstance)]"
$RPServerName = ($defaultInstance,$prompt)[[bool]$prompt]

$defaultFolder = 'SCORE'
$prompt = Read-Host "Reports Folder [$($defaultFolder)]"
$reportFolder = ($defaultFolder,$prompt)[[bool]$prompt]

$dfDataSourceFolder = "SCORE"
$prompt = Read-Host "Data Sources Folder [$($dfDataSourceFolder)]"
$dataSourceFolder = ($dfDataSourceFolder,$prompt)[[bool]$prompt]

$dfDataSetFolder = "SCORE"
$prompt = Read-Host "Dataset Folder [$($dfDataSetFolder)]"
$dataSetFolder = ($dfDataSetFolder,$prompt)[[bool]$prompt]

$IsInitialDeployment = switch (Read-Host -Prompt 'Initial Deployment (Y/N)? [N]')
{
    "Y" {[Boolean] 1}
    default {[Boolean] 0}
}

If($IsInitialDeployment)
{
    [bool]$IsOverwriteDataSource = $true
    [bool]$IsOverwriteDataSet = $true
    [bool]$IsOverwriteReport = $true    
}
Else
{
    # Overwrite properties
    $IsOverwriteDataSource = switch (Read-Host -Prompt 'Overwrite DataSources (Y/N)? [N]')
    {
        "Y" {[Boolean] 1}
        default {[Boolean] 0}
    }
    $IsOverwriteDataSet = switch (Read-Host -Prompt 'Overwrite DataSet (Y/N)? [N]')
    {
        "Y" {[Boolean] 1}
        default {[Boolean] 0}
    }
    $IsOverwriteReport = switch (Read-Host -Prompt 'Overwrite Reports (Y/N)? [Y]')
    {
        "N" {[Boolean] 0}
        default {[Boolean] 1}
    }
}

####################################################################################
# GET DATA SOURCE INSTANCE NAMES
####################################################################################
If($IsOverwriteDataSource -eq $true)
{
    [string]$dbInstanceOpsMgr = Read-Host "Operations Manager DB Instance"
    [string]$dbInstanceOpsMgrDW = Read-Host "Operations Manager DW Instance"
    [string]$dbInstanceSCORE = Read-Host "SCORE DB Instance"
}


$rootPath ="/" # Rool Level
$rsReportFolder = $rootPath + $reportFolder
$rsDataSourceFolder = $rootPath + $dataSourceFolder
$rsDataSetFolder = $rootPath + $dataSetFolder

###################################################################################
# CONNECT TO SSRS
###################################################################################
Write-Host "Testing connectivity to Reportserver: $webServiceUrl" -ForegroundColor Magenta
Write-Verbose "Creating Proxy, connecting to : $webServiceUrl/$RPServerName/ReportService2010.asmx?WSDL"
Write-Host ""
$ssrsProxy = New-WebServiceProxy -Uri $webServiceUrl'/'$RPServerName'/ReportService2010.asmx?WSDL' -UseDefaultCredential

If($ssrsProxy -eq $null)
{
    Write-Error "Unable to connect to $webServiceURL; check URL, port, transport and/or permissions"
    Exit
}

###################################################################################
# CONNECT TO SQL DATA SOURCES
###################################################################################
If($IsOverwriteDataSource)
{
    Write-Host "Testing connectity to SQL Instances " -ForegroundColor Magenta

    
    Write-Verbose "Testing connectity to SQL Instance $dbInstanceOpsMgrDW"
    $sqlConnection= New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Server=$dbInstanceOpsMgr;Database=OperationsManager;Integrated Security=SSPI"
    $sqlConnection.Open()
    If($sqlConnection.State -ne "Open")
    {
        Write-Error "Unable to connect to SQL Instance $dbInstanceOpsMgr; check hostname, port and/or permissions."
        Exit
    }
    Else
    {
        Write-Verbose "Connection successful!"
        $sqlConnection.Close()
    }



    Write-Verbose "Testing connectity to SQL Instance $dbInstanceOpsMgrDW"
    $sqlConnection= New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Server=$dbInstanceOpsMgrDW;Database=OperationsManagerDW;Integrated Security=SSPI"
    $sqlConnection.Open()
    If($sqlConnection.State -ne "Open")
    {
        Write-Error "Unable to connect to SQL Instance $dbInstanceOpsMgrDW; check hostname, port and/or permissions."
        Exit
    }
    Else
    {
        Write-Verbose "Connection successful!"
        $sqlConnection.Close()
    }

    Write-Verbose "Testing connectity to SQL Instance $dbInstanceSCORE"
    $sqlConnection= New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Server=$dbInstanceSCORE;Database=SCORE;Integrated Security=SSPI"
    $sqlConnection.Open()
    If($sqlConnection.State -ne "Open")
    {
        Write-Error "Unable to connect to SQL Instance $dbInstanceSCORE; check hostname, port and/or permissions."
        Exit
    }
    Else
    {
        Write-Verbose "Connection successful!"
        $sqlConnection.Close()
    }

    Write-Host ""
}

###################################################################################
# CREATE REPORTS FOLDER
###################################################################################
$tmpFolder = $ssrsProxy.ListChildren($rootPath,$false) | Where-Object {$_.Name -eq $reportFolder}
if($tmpFolder -eq $null) {
	Write-Host "Creating Reports Folder $rsReportFolder" -ForegroundColor Green
	try
	{
		$result = $ssrsProxy.CreateFolder($reportFolder, $rootPath, $null)
		Write-Verbose "Created new folder: $rsReportFolder"
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
    Write-Host ""
}
$tmpFolder = $null

###################################################################################
# CREATE DATA SOURCE FOLDER
###################################################################################
$tmpFolder = $ssrsProxy.ListChildren($rootPath,$false) | Where-Object {$_.Name -eq $dataSourceFolder}

if($tmpFolder -eq $null) {
	Write-host "Creating Data Sources Folder: $dataSourceFolder" -ForegroundColor Green
	try
	{
		$result = $ssrsProxy.CreateFolder($dataSourceFolder, $rootPath, $null)
		Write-Verbose "Created new folder: $rsDataSourceFolder"
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
    Write-Host ""
}
$tmpFolder = $null

###################################################################################
# CREATE DATASET FOLDER
###################################################################################
$tmpFolder = $ssrsProxy.ListChildren($rootPath,$false) | Where-Object {$_.Name -eq $dataSetFolder}

if($tmpFolder -eq $null) {
	Write-Host "Creating Datasets Folder: $dataSetFolder" -ForegroundColor Green
	try
	{
		$result = $ssrsProxy.CreateFolder($dataSetFolder, $rootPath, $null)
		Write-Verbose "Created new folder: $rsDataSetFolder"
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
}
$tmpFolder = $null

###################################################################################
# CREATE DATA SOURCES
###################################################################################
If($IsInitialDeployment -or $IsOverwriteDataSource)
{
    Write-host "Uploading Shared Data Sources to $dataSourceFolder" -ForegroundColor Green

    foreach($rdsFile in Get-ChildItem $sourceDirectory -Filter *.rds)
    {
        # Write-Verbose "Uploading $rdsFile"
        # Check for existence of data source
        $tmpDataSource = $ssrsProxy.ListChildren($rsDataSourceFolder, $false) | Where-Object {$_.Name -eq $rdsFile.BaseName}
        If($tmpDataSource -eq $null -or $IsOverwriteDataSource -eq 1) 
        {
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

                $descProp = New-Object($datatype_Prop)
                $descProp.Name = 'Description'
                $descProp.Value = ''
                $hiddenProp = New-Object($datatype_Prop)
                $hiddenProp.Name = 'Hidden'
                $hiddenProp.Value = 'true'
                $rsProperties = @($descProp, $hiddenProp)

                $Definition = New-Object ($datatype)
                switch ($rdsFile.BaseName) {
                    "OperationsManager" {$Definition.ConnectString = $ConnProps.ConnectString.Replace("__OPSMGR__",$dbInstanceOpsMgr)}
                    "OperationsManagerDW" {$Definition.ConnectString = $ConnProps.ConnectString.Replace("__OPSMGRDW__",$dbInstanceOpsMgrDW)}
                    "SCORE" {$Definition.ConnectString = $ConnProps.ConnectString.Replace("__SCORE__",$dbInstanceSCORE)}
                }
            
                $Definition.Extension = $ConnProps.Extension
                if ([Convert]::ToBoolean($ConnProps.IntegratedSecurity)) {
                    $Definition.CredentialRetrieval = 'Integrated'
                }

                $rsDataSource = New-Object -TypeName PSObject -Property @{
                    Name = $Rds.RptDataSource.Name
                    Path = $rsDataSourceFolder + '/' + $Rds.RptDataSource.Name
                }

                #### CREATE DATA SOURCE
                $warnings = $ssrsProxy.CreateDataSource($rdsf, $rsDataSourceFolder ,$IsOverwriteDataSource, $Definition, $rsProperties)


                #### RETRIEVE DATA SOURCE AND UPDATE CREDENTIALS
                #### THIS SECTION NOT FUNCTIONAL YET
                # $thisDataSource = $ssrsProxy.ListChildren($rsDataSourceFolder, $false) | Where-Object {$_.TypeName -eq "DataSource" -and $_.Name -eq $rdsFile.BaseName}
                # $dsObject = $reporting.GetDataSourceContents($DataSourceRef.path)[0]


                #If($WhatIfPreference.IsPresent)
                #{
                #    $msg = "  WHATIF: Updating password for UserName {0} on DataSource {1}" -f $userName, $dataSourceName
                #    write-verbose $msg

                #} 
                #Else 
                #{
                #    $dsObject.Username = $dataSourceCredential.UserName
                #    $dsObject.Password = $dataSourceCredential.GetNetworkCredential().Password

                #    Try{

                #        $reporting.SetDataSourceContents($dsObject.Path, $dsObject)
                #        $msg = "  ACTION: Updating password for UserName {0} on DataSource {1}" -f $userName, $dataSourceName
                #        write-verbose $msg

                #    } 
                #    Catch 
                #    {
                #
                #        $msg = $_.Exception.Message
                #        write-verbose $msg

                #    }

                #}
            ######################################################################


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
    }
}


###################################################################################
# CREATE DATASETS
###################################################################################
If($IsOverwriteDataSet)
{
    Write-host "Uploading Shared Datasets to $rsDataSetFolder" -ForegroundColor Green
    foreach($rsdfile in Get-ChildItem $sourceDirectory -Filter *.rsd)
    {

        $tmpDataSet = $ssrsProxy.ListChildren($rsDataSetFolder, $false) | Where-Object {$_.Name -eq $rsdFile.BaseName}
        If($tmpDataSet -eq $null -or $IsOverwriteDataSet -eq 1) 
        {

            try {
                $rsdf = [System.IO.Path]::GetFileNameWithoutExtension($rsdfile)
                $RsdPath = $sourceDirectory+'\'+$rsdf+'.rsd'

                # Write-Verbose "New-SSRSDataSet -RsdPath $RsdPath -Folder $dataSetFolder"

                $RawDefinition = Get-Content -Encoding Byte -Path $RsdPath
                $warnings = $null

                $Results = $ssrsProxy.CreateCatalogItem("DataSet", $rsdf, $rsDataSetFolder, $IsOverwriteDataSet, $RawDefinition, $null, [ref]$warnings)

                write-verbose "Shared Dataset $rsdf created successfully." 
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
            $datasetFullName = $rsDataSetFolder + "/" + $rsdf
            Write-Verbose "Updating data sources for dataset $rsdf"

            $rep = $ssrsProxy.GetItemDataSources($datasetFullName)
            $rep | ForEach-Object {
                $proxyNamespace = $_.GetType().Namespace

                [xml]$xmlDataSource=Get-Content ".\Reports\$rsdFile"
                $dataSourceName = $xmlDataSource.SharedDataset.DataSet.Query.DataSourceReference

                $thisDataSource = New-Object ("$proxyNamespace.DataSource")

                $thisDataSource.Item = New-Object ("$proxyNamespace.DataSourceReference")
                # $rsDataSourcePath = $_.Item.Reference
                $rsDataSourcePath = $rsDataSourceFolder + "/" + $dataSourceName
                $thisDataSource.Item.Reference = $rsDataSourcePath

                $_.item = $thisDataSource.Item
                $ssrsProxy.SetItemDataSources($datasetFullName, $_)
                Write-Verbose "Changing datasource `"$dataSourceName`" to $rsDataSourcePath"
            }

        }
    }
}


###################################################################################
# CREATE REPORTS
###################################################################################
Write-host "Uploading Reports to $rsReportFolder" -ForegroundColor Green
foreach($rdlfile in Get-ChildItem $sourceDirectory -Filter *.rdl)
{

    $reportName = [System.IO.Path]::GetFileNameWithoutExtension($rdlFile);
    write-verbose "Uploading $reportName" 
    try
    {
        #Get Report content in bytes
        Write-Verbose "Getting file content of : $rdlFile"
        $byteArray = gc $rdlFile.FullName -encoding byte
        $msg = "Total length: {0}" -f $byteArray.Length
        Write-Verbose $msg

        Write-Verbose "Uploading $reportName to: $rsReportFolder"

        $type = $ssrsProxy.GetType().Namespace
        $datatype = ($type + '.Property')

        $descProp = New-Object($datatype)
        $descProp.Name = 'Description'
        $descProp.Value = ''
        $hiddenProp = New-Object($datatype)
        If($reportName -eq "Dash_OrganizationSummary"){
	
	        $hiddenProp.Name = 'Hidden'
	        $hiddenProp.Value = 'false'
        } Else {
	
	        $hiddenProp.Name = 'Hidden'
	        $hiddenProp.Value = 'true'
        }
        $rsProperties = @($descProp, $hiddenProp)

        #Call Proxy to upload report

        $warnings = $null

        $Results = $ssrsProxy.CreateCatalogItem("Report", $reportName,$rsReportFolder, $IsOverwriteReport,$byteArray,$rsProperties,[ref]$warnings)

        if($warnings.length -le 1)
        { 
            Write-Verbose "Uploaded reportName successfully." 
        }
        else
        { 
            Write-Host "Uploaded $reportName with warnings; run with verbose to see detailed messages." -ForegroundColor Yellow
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
        Write-Verbose "Changing Data Source `"$($_.Name)`" to $($_.Item.Reference)"
    }
    ###################################################################################
    # UPDATE SHARED DATA SETS FOR REPORT
    ###################################################################################
    # THIS SECTION NOT YET FUNCTIONAL; FOR NOW, OUTPUT ERROR MESSAGE
    # ADMIN MUST GO INTO PROPERTIES OF REPORT (MANAGE) AND RELINK SHARED DATA SET
    ###################################################################################
    $reportFullName = $rsReportFolder+"/"+$reportName
    Write-Verbose "Updating shared data sets for $reportFullName" 

    $ref = $ssrsProxy.GetItemReferences($reportFullName,"DataSet")
    $ref | ForEach-Object {
        Write-Host "ERROR: Unable to update Shared Data Set $($_.name) for report $ReportName.  Please relink manually." -foregroundcolor Red
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
Write-host "Successfully Deployed SSRS Project" -ForegroundColor Magenta
Write-host ""

#Open IE
$RPServernameUI = $RPServerName.Replace('ReportServer','Reports')
Start-Process "iexplore.exe" $webServiceUrl'/'$RPServernameUI"/Pages/Folder.aspx"