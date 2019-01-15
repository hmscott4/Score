/****************************************************************
* Name: ad.spGroupInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupInactivateByDate] 
	@Domain nvarchar(128),
    @BeforeDate datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Group]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain AND [dbLastUpdate] < @BeforeDate
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [Scope], [Category], [Description], [Email], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Group]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
