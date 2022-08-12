/****************************************************************
* Name: ad.spComputerUpsert_Import
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spComputerUpsert_Import] 

AS

	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	-- TEST FOR UNIQUENESS
	--IF EXISTS (SELECT [DistinguishedName] FROM [ad].[Computer] WHERE [DistinguishedName] = DistinguishedName AND [objectGUID] != objectGUID)
	--BEGIN
	--	INSERT INTO [ad].[DeletedObject] ([objectGUID],[SID],[Domain],[Name],[DistinguishedName],[objectType],[dbAddDate],[dbDelDate])
	--	SELECT [objectGUID], [SID], [Domain], [Name], [DistinguishedName], N'Computer', dbAddDate, CURRENT_TIMESTAMP 
	--	FROM [ad].[Computer]
	--	WHERE [DistinguishedName] = DistinguishedName

	--	DELETE FROM [ad].[Computer] 
	--	WHERE DistinguishedName = DistinguishedName
	--END
	
	BEGIN TRAN

	MERGE [ad].[Computer] AS [target]
	USING (SELECT [objectGUID], [SID], right(DNSHostName, len(DNSHostName) - (len([Name])+1)) as [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [LastLogonDate] as LastLogon, [whenCreated], [whenChanged] 
			FROM ad.ComputerImport
			WHERE (LEN(DNSHostName) > 0 AND CHARINDEX('.',DNSHostName) > 0)) 
		AS source 
		([objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [LastLogon], [whenCreated], [whenChanged])
	-- !!!! Check the criteria for match
	ON (source.[objectGUID] = [target].[objectGUID])
       WHEN MATCHED THEN 
		UPDATE 
		SET    [SID] = source.[SID], [Domain] = source.[Domain], [Name] = source.[Name], [DNSHostName] = source.[DNSHostName], [IPv4Address] = source.IPv4Address, [Trusted] = source.Trusted, [OperatingSystem] = source.OperatingSystem, [OperatingSystemVersion] = source.OperatingSystemVersion, [OperatingSystemServicePack] = source.OperatingSystemServicePack, [Description] = source.Description, [DistinguishedName] = source.DistinguishedName, [Enabled] = source.Enabled, [LastLogon] = source.LastLogon, [whenCreated] = source.whenCreated, [Active] = 1, [whenChanged] = source.whenChanged, [dbLastUpdate] = current_timestamp
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate])
		VALUES (source.objectGUID, source.SID, source.Domain, source.Name, source.DNSHostName, source.IPv4Address, source.Trusted, source.OperatingSystem, source.OperatingSystemVersion, source.OperatingSystemServicePack, source.Description, source.DistinguishedName, source.Enabled, 1, source.LastLogon, source.whenCreated, source.whenChanged, current_timestamp, current_timestamp)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT



GO


