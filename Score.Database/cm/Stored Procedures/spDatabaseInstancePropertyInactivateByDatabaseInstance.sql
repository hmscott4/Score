/****************************************************************
* Name: cm.spDatabaseInstancePropertyInactivateByDatabaseInstance
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstancePropertyInactivateByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [cm].[DatabaseInstanceProperty]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseInstanceProperty]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
