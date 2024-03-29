﻿/****** Object:  StoredProcedure [cm].[spDatabaseInstanceDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstanceDelete
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstanceDeleteByComputer] 
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
	FROM   [cm].[DatabaseInstance]
	WHERE ([ComputerGUID] = @ComputerGUID)

	COMMIT