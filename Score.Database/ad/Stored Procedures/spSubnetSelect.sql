
/****** Object:  StoredProcedure [ad].[spSubnetSelect]    Script Date: 1/16/2019 8:32:48 AM ******/

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
GO
GRANT EXECUTE ON [ad].[spSubnetSelect] TO [adUpdate] AS [dbo]
GO
