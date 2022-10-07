/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spNetworkAdapterConfigurationSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Index], [MACAddress], [IPV4Address], [SubnetMask], [DefaultIPGateway], [DNSDomainSuffixSearchOrder], [DNSServerSearchOrder], [DNSEnabledForWINSResolution], [FullDNSRegistrationEnabled], [DHCPEnabled], [DHCPLeaseObtained], [DHCPLeaseExpires], [DHCPServer], [WINSPrimaryServer], [WINSSecondaryServer], [IPEnabled], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[NetworkAdapterConfiguration] 
	WHERE  ([computerGUID] = @ComputerGUID) 

	COMMIT