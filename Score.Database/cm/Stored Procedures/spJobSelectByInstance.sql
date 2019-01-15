CREATE PROC [cm].[spJobSelectByInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [JobID], [DatabaseInstanceGUID], [OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [LastRunOutCome], [HasSchedule], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Job] 
	WHERE  [DatabaseInstanceGUID] = @DatabaseInstanceGUID

	COMMIT
