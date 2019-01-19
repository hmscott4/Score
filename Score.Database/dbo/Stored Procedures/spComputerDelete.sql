/****** Object:  StoredProcedure [dbo].[spComputerDelete]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: dbo.spComputerDelete
* Author: huscott
* Date: 2015-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerDelete] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Computer]
	WHERE  [dnsHostName] = @dnsHostName

	COMMIT
GO
