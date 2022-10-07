/****** Object:  StoredProcedure [cm].[spJobInactivateByInstance]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spJobInactivateByInstance
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spJobInactivateByInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[Job]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [DatabaseInstanceGUID] = @DatabaseInstanceGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [JobID], [DatabaseInstanceGUID], [OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Job]
	WHERE  [JobID] = @JobID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT