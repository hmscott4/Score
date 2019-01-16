
/****** Object:  StoredProcedure [ad].[spSubnetSelectBySubnet]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [ad].[spSubnetSelectBySubnet] 
    @Name varchar(255) = NULL,
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Domain], [Name], [Description], [Location], [Site], [DistinguishedName], [whenCreated], [whenChanged], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Subnet] 
	WHERE  ([Name] = @Name OR @Name IS NULL) and Active >= @Active

	COMMIT
GO
