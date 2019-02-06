/****************************************************************
* Name: scom.spSyncStatusViewSelect
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
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

GRANT EXEC ON [scom].[spSyncStatusViewSelect] TO [scomUpdate]
GO

GRANT EXEC ON [scom].[spSyncStatusViewSelect] TO [scomRead]
GO