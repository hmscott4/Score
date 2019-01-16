/****** Object:  StoredProcedure [cm].[spApplicationSelect]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spApplicationSelect] 
    @Name nvarchar(255),
    @Version nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Name], [Version], [Vendor], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Application] 
	WHERE  [Name] = @Name and [Version] = @Version

	COMMIT
GO
