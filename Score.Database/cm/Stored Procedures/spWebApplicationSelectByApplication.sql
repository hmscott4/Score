/****** Object:  StoredProcedure [cm].[spWebApplicationSelectByApplication]    Script Date: 1/16/2019 8:32:48 AM ******/
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