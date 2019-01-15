/****************************************************************
* Name: cm.spDatabaseRoleMemberInactivateByDatabase
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseRoleMemberInactivateByDatabase] 
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128),
    @dbLastUpdate datetime2(3)

AS

	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseRoleMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [DatabaseName], [RoleName], [RoleMember], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseRoleMember]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
