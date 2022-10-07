/****** Object:  StoredProcedure [cm].[spNetworkAdapterUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spNetworkAdapterUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterUpsert] 
    @dnsHostName nvarchar(255),
    @Index int,
    @Name nvarchar(255),
    @NetConnectionID nvarchar(255) = NULL,
    @AdapterType nvarchar(255) = NULL,
    @Manufacturer nvarchar(255) = NULL,
    @MACAddress nvarchar(128) = NULL,
    @PhysicalAdapter bit = NULL,
    @Speed bigint = NULL,
	@NetEnabled bit = NULL,
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

	MERGE [cm].[NetworkAdapter] AS target
	USING (SELECT @Name, @NetConnectionID, @AdapterType, @Manufacturer, @MACAddress, @PhysicalAdapter, @Speed, @NetEnabled, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Name], [NetConnectionID], [AdapterType], [Manufacturer], [MACAddress], [PhysicalAdapter], [Speed], [NetEnabled], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Index] = @Index)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Name] = @Name, [NetConnectionID] = @NetConnectionID, [AdapterType] = @AdapterType, [Manufacturer] = @Manufacturer, [MACAddress] = @MACAddress, [PhysicalAdapter] = @PhysicalAdapter, [Speed] = @Speed, [NetEnabled] = @NetEnabled, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Index], [Name], [NetConnectionID], [AdapterType], [Manufacturer], [MACAddress], [PhysicalAdapter], [Speed], [NetEnabled], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Index, @Name, @NetConnectionID, @AdapterType, @Manufacturer, @MACAddress, @PhysicalAdapter, @Speed, @NetEnabled, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Index], [Name], [NetConnectionID], [AdapterType], [Manufacturer], [MACAddress], [PhysicalAdapter], [Speed], [NetEnabled], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[NetworkAdapter]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT