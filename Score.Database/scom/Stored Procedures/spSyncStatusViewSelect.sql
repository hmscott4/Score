/****** Object:  StoredProcedure [scom].[spSyncStatusViewSelect]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [scom].[spSyncStatusViewSelect] 
    @ManagementGroup nvarchar(128),
	@ObjectClass nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ManagementGroup], [ObjectClass], [LastStatus], [LastSyncType], [LastStartDate], [LastFullSync], [LastIncrementalSync]
	FROM   [scom].[SyncStatusView] 
	WHERE  ([ManagementGroup] = @ManagementGroup AND [ObjectClass] = @ObjectClass) 

	COMMIT

GO
