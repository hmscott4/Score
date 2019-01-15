CREATE PROC [cm].[spDatabaseFileSelect] 
    @DatabaseGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseGUID], [FileID], [FileGroup], [LogicalName], [PhysicalName], [FileSize], [MaxSize], [SpaceUsed], [Growth], [GrowthType], [IsReadOnly], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseFile] 
	WHERE  ([databaseGUID] = @DatabaseGUID) 

	COMMIT
