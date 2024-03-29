﻿/****** Object:  StoredProcedure [cm].[spNetworkAdapterSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spNetworkAdapterSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Index], [Name], [NetConnectionID], [AdapterType], [Manufacturer], [MACAddress], [PhysicalAdapter], [Speed], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[NetworkAdapter] 
	WHERE  ([computerGUID] = @ComputerGUID) 

	COMMIT