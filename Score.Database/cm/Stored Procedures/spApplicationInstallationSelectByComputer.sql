﻿/****************************************************************
* Name: cm.spApplicationInstallationSelectByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationInstallationSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [ApplicationGUID], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ApplicationInstallation] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT