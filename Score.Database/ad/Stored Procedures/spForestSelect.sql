
/****** Object:  StoredProcedure [ad].[spForestSelect]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [ad].[spForestSelect] 
    @Name nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [Name], [DomainNamingMaster], [SchemaMaster], [RootDomain], [ForestMode], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Forest] 
	WHERE  ([Name] = @Name OR @Name IS NULL) 

	COMMIT
GO
GRANT EXECUTE ON [ad].[spForestSelect] TO [adUpdate] AS [dbo]
GO
