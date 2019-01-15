CREATE PROC [ad].[spSiteSelect] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Site] 
	WHERE  ([objectGUID] = @objectGUID OR @objectGUID IS NULL) 

	COMMIT
