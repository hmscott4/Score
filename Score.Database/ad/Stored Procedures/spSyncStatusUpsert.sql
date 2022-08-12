/****************************************************************
* Name: ad.spSyncStatusUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSyncStatusUpsert] 
    @Domain nvarchar(128),
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

	MERGE [ad].[SyncStatus] AS target
	USING (SELECT @SyncType, @StartDate, @EndDate, @Count, @Status) 
		AS source 
		([SyncType], [StartDate], [EndDate], [Count], [Status])
	-- !!!! Check the criteria for match
	ON ([Domain] = @Domain AND [ObjectClass] = @ObjectClass)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [SyncType] = @SyncType, [StartDate] = @StartDate, [EndDate] = @EndDate, [Count] = @Count, [Status] = @Status
	WHEN NOT MATCHED THEN
		INSERT ([Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status])
		VALUES (@Domain, @ObjectClass, @SyncType, @StartDate, @EndDate, @Count, @Status)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status]
	FROM   [ad].[SyncStatus]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO


