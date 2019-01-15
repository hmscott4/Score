
CREATE PROC [scom].[spSyncStatusViewSelect] 
    @ManagementGroup nvarchar(128),
	@ObjectClass nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ManagementGroup], [ObjectClass], [Status], [SyncType], [LastFullSync], [LastIncrementalSync]
	FROM   [scom].[SyncStatusView] 
	WHERE  ([ManagementGroup] = @ManagementGroup AND [ObjectClass] = @ObjectClass) 

	COMMIT

