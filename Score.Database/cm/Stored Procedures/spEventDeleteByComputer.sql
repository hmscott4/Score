/****** Object:  StoredProcedure [cm].[spEventDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spEventDeleteByComputer
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spEventDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[Event]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
GO
GRANT EXECUTE ON [cm].[spEventDeleteByComputer] TO [cmUpdate] AS [dbo]
GO
