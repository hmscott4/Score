/****** Object:  StoredProcedure [cm].[spApplicationDelete]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spApplicationDelete
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationDelete] 
    @Name nvarchar(255),
    @Version nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[Application]
	WHERE  [Name] = @Name and [Version] = @Version

	COMMIT
GO