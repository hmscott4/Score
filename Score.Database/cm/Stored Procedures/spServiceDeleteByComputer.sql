/****** Object:  StoredProcedure [cm].[spServiceDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spServiceDeleteByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spServiceDeleteByComputer] 
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
	FROM   [cm].[Service]
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO