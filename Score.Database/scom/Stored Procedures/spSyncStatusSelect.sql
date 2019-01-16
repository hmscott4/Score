/****** Object:  StoredProcedure [scom].[spSyncStatusSelect]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [scom].[spSyncStatusSelect] 
    @ManagementGroup nvarchar(128),
	@ObjectClass nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status] 
	FROM   [scom].[SyncStatus] 
	WHERE  ([ManagementGroup] = @ManagementGroup AND [ObjectClass] = @ObjectClass) 

	COMMIT

GO
