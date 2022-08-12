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

GO
