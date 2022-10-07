/****************************************************************
* Name: scom.spSyncHistoryInsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [scom].[spSyncHistoryInsert] 
    @ManagementGroup nvarchar(128),
    @ObjectClass nvarchar(128),
    @SyncType nvarchar(64),
    @StartDate datetime2(3) = NULL,
    @EndDate datetime2(3) = NULL,
    @Count int = NULL,
    @Status nvarchar(255) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN


	INSERT INTO scom.SyncHistory ([ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status])
	VALUES (@ManagementGroup, @ObjectClass, @SyncType, @StartDate, @EndDate, @Count, @Status)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [ManagementGroup], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status]
	FROM   [ad].[SyncHistory]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT