﻿/****************************************************************
* Name: ad.spServiceAccountInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spServiceAccountInactivate] 
    @objectGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[ServiceAccount]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [objectGUID] = @objectGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT