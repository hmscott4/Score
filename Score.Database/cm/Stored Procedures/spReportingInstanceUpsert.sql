/****** Object:  StoredProcedure [cm].[spReportingInstanceUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spReportingInstanceUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportingInstanceUpsert] 
    @dnsHostName nvarchar(255),
    @InstanceName nvarchar(128),
    @ProductName nvarchar(128),
    @ProductEdition nvarchar(128),
    @ProductVersion nvarchar(128),
    @ProductServicePack nvarchar(128),
    @ConnectionString nvarchar(255),
	@ServiceState nvarchar(128),
    @RSConfiguration nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[ReportingInstance] AS target
	USING (SELECT @ProductName, @ProductEdition, @ProductVersion, @ProductServicePack, @ConnectionString, @ServiceState, @RSConfiguration, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [InstanceName] = @InstanceName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [ProductName] = @ProductName, [ProductEdition] = @ProductEdition, [ProductVersion] = @ProductVersion, [ProductServicePack] = @ProductServicePack, [ServiceState] = @ServiceState, [RSConfiguration] = @RSConfiguration, [Active] = @Active,[dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @InstanceName, @ProductName, @ProductEdition, @ProductVersion, @ProductServicePack, @ConnectionString, @ServiceState, @RSConfiguration, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [ServiceState], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportingInstance]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT