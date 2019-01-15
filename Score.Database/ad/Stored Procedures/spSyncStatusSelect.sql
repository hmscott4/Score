CREATE PROC [ad].[spSyncStatusSelect] 
    @Domain nvarchar(128),
	@ObjectClass nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status] 
	FROM   [ad].[SyncStatus] 
	WHERE  ([Domain] = @Domain AND [ObjectClass] = @ObjectClass) 

	COMMIT
