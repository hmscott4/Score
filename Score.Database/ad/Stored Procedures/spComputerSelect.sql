
/****** Object:  StoredProcedure [ad].[spComputerSelect]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [ad].[spComputerSelect] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Computer] 
	WHERE  ([dnsHostName] = @dnsHostName) 

	COMMIT
GO
GRANT EXECUTE ON [ad].[spComputerSelect] TO [adUpdate] AS [dbo]
GO
