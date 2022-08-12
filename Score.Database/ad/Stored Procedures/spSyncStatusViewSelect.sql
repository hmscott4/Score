CREATE PROC [ad].[spSyncStatusViewSelect] 
    @Domain nvarchar(128),
	@ObjectClass nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [Domain], [ObjectClass], [LastStatus], [LastSyncType], [LastStartDate], [LastFullSync], [LastIncrementalSync]
	FROM   [ad].[SyncStatusView] 
	WHERE  ([Domain] = @Domain AND [ObjectClass] = @ObjectClass) 

	COMMIT
GO


