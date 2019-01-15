CREATE PROC [cm].[spWebApplicationSelectByApplication] 
    @Name nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Name], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WebApplication] 
	WHERE  ([Name] = @Name) 

	COMMIT
