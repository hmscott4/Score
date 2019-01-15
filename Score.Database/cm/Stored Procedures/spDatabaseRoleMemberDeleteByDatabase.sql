/****************************************************************
* Name: cm.spDatabaseRoleMemberDeleteByDatabase
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseRoleMemberDeleteByDatabase]  
    @DatabaseInstanceGUID uniqueidentifier,
    @DatabaseName nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[DatabaseRoleMember]
	WHERE ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [DatabaseName] = @DatabaseName)

	COMMIT
