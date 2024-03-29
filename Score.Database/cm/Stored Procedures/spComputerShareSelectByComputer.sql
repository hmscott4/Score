﻿/****** Object:  StoredProcedure [cm].[spComputerShareSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spComputerShareSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Name], [Description], [Path], [Status], [Type], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ComputerShare] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT