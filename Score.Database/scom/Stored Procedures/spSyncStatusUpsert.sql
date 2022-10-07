/****************************************************************
* Name: scom.spSyncStatusUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spSyncStatusUpsert] 
    @ManagementGroup nvarchar(128),
    @ObjectClass nvarchar(128),
    @SyncType nvarchar(64),
    @StartDate datetime2(3) = NULL,
    @EndDate datetime2(3) = NULL,
    @Count int = NULL,
    @Status nvarchar(128) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [scom].[SyncStatus] AS target
	USING (SELECT @SyncType, @StartDate, @EndDate, @Count, @Status) 
		AS source 
		([SyncType], [StartDate], [EndDate], [Count], [Status])
	-- !!!! Check the criteria for match
	ON ([ManagementGroup] = @ManagementGroup AND [ObjectClass] = @ObjectClass)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [SyncType] = @SyncType, [StartDate] = @StartDate, [EndDate] = @EndDate, [Count] = @Count, [Status] = @Status
	WHEN NOT MATCHED THEN
		INSERT ([ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status])
		VALUES (@ManagementGroup, @ObjectClass, @SyncType, @StartDate, @EndDate, @Count, @Status)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status]
	FROM   [scom].[SyncStatus]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT