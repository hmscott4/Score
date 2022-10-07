/****************************************************************
* Name: ad.spDomainInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spDomainInactivate] 
    @objectGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Domain]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @objectGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Forest], [Name], [DNSRoot], [NetBIOSName], [DistinguishedName], [InfrastructureMaster], [PDCEmulator], [RIDMaster], [DomainFunctionality], [ForestFunctionality], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Domain]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT