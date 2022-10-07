/****** Object:  StoredProcedure [cm].[spJobSelectByInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spJobSelectByInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [JobID], [DatabaseInstanceGUID], [OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [LastRunOutcome], [HasSchedule], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Job] 
	WHERE  [DatabaseInstanceGUID] = @DatabaseInstanceGUID

	COMMIT