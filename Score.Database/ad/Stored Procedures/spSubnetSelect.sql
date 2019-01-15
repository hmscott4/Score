CREATE PROC [ad].[spSubnetSelect] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Subnet] 
	WHERE  ([objectGUID] = @objectGUID OR @objectGUID IS NULL) 

	COMMIT
