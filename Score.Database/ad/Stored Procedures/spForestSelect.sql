/****************************************************************
* Name: ad.spForestSelect
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/

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
