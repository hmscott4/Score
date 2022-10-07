/****************************************************************
* Name: ad.spSyncHistoryInsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spSyncHistoryInsert] 
    @Domain nvarchar(128),
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


	INSERT INTO ad.SyncHistory ([Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status])
	VALUES (@Domain, @ObjectClass, @SyncType, @StartDate, @EndDate, @Count, @Status)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [ObjectClass], [SyncType], [StartDate], [EndDate], [Count], [Status]
	FROM   [ad].[SyncHistory]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT