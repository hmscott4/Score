
/****** Object:  StoredProcedure [ad].[spSiteSelect]    Script Date: 1/16/2019 8:32:48 AM ******/

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
GO
GRANT EXECUTE ON [ad].[spSiteSelect] TO [adUpdate] AS [dbo]
GO
