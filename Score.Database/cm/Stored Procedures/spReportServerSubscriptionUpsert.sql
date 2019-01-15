/****************************************************************
* Name: cm.spReportServerSubscriptionUpsert
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionUpsert] 
	@objectGUID uniqueidentifier,
    @ReportingInstanceGUID uniqueidentifier,
    @Owner nvarchar(255),
    @Path nvarchar(1024),
    @VirtualPath nvarchar(1024),
    @Report nvarchar(1024),
    @Description nvarchar(1204) = NULL,
    @Status nvarchar(128),
    @SubscriptionActive bit,
    @LastExecuted datetime2(3) = NULL,
    @ModifiedBy nvarchar(255),
    @ModifiedDate datetime2(3),
    @EventType nvarchar(128),
    @IsDataDriven bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[ReportServerSubscription] AS target
	USING (SELECT @ReportingInstanceGUID, @Owner, @Path, @VirtualPath, @Report, @Description, @Status, @SubscriptionActive, @LastExecuted, @ModifiedBy, @ModifiedDate, @EventType, @IsDataDriven, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([ReportingInstanceGUID], [Owner], [Path], [VirtualPath], [Report], [Description], [Status], [SubscriptionActive], [LastExecuted], [ModifiedBy], [ModifiedDate], [EventType], [IsDataDriven], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [VirtualPath] = @VirtualPath, [Report] = @Report, [Description] = @Description, [Status] = @Status, [SubscriptionActive] = @SubscriptionActive, [LastExecuted] = @LastExecuted, [ModifiedBy] = @ModifiedBy, [ModifiedDate] = @ModifiedDate, [EventType] = @EventType, [IsDataDriven] = @IsDataDriven, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [ReportingInstanceGUID], [Owner], [Path], [VirtualPath], [Report], [Description], [Status], [SubscriptionActive], [LastExecuted], [ModifiedBy], [ModifiedDate], [EventType], [IsDataDriven], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @ReportingInstanceGUID, @Owner, @Path, @VirtualPath, @Report, @Description, @Status, @SubscriptionActive, @LastExecuted, @ModifiedBy, @ModifiedDate, @EventType, @IsDataDriven, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportingInstanceGUID], [Owner], [Path], [VirtualPath], [Report], [Description], [Status], [SubscriptionActive], [LastExecuted], [ModifiedBy], [ModifiedDate], [EventType], [IsDataDriven], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerSubscription]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
