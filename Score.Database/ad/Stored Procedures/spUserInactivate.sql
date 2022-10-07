/****************************************************************
* Name: ad.spUserInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spUserInactivate] 
    @objectGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[User]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @objectGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [FirstName], [LastName], [DisplayName], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[User]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT