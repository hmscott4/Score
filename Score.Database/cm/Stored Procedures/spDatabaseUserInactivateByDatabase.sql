/****** Object:  StoredProcedure [cm].[spDatabaseUserInactivateByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseUserInactivateByDatabase
* Author: huscott
* Date: 2015-03-06
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseUserInactivateByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseUser]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [UserName], [Login], [UserType], [LoginType], [HasDBAccess], [CreateDate], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseUser]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT