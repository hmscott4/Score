/****** Object:  StoredProcedure [cm].[spComputerUpsertForCluster]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: cm.spComputerUpsertForCluster
* Author: huscott
* Date: 2015-02-24
*
* Description:
* cm.Computer is the pk table for many objects such as SQL
* instances.  An entry is needed in the table for virtual network
* names that represent these objects.
*
****************************************************************/
CREATE PROC [cm].[spComputerUpsertForCluster] 
    @Domain nvarchar(128),
    @dnsHostName nvarchar(255),
    @netBIOSName nvarchar(255),
	@IsClusterResource bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Computer] AS target
	USING (SELECT @Domain, @netBIOSName, @IsClusterResource, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Domain], [netBIOSName], [IsClusterResource], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([dnsHostName] = @dnsHostName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Domain] = @Domain, [netBIOSName] = @netBIOSName, [IsVirtual] = 0, [IsClusterResource] = @IsClusterResource, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Domain], [dnsHostName], [netBIOSName], [IsVirtual], [IsClusterResource], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Domain, @dnsHostName, @netBIOSName, 0, @IsClusterResource, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Domain], [dnsHostName], [netBIOSName], [IPv4Address], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Computer]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT