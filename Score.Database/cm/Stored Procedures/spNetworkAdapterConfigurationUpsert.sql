/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spNetworkAdapterConfigurationUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterConfigurationUpsert] 
    @dnsHostName nvarchar(255),
    @Index int,
    @MACAddress nvarchar(128) = NULL,
    @IPV4Address nvarchar(255) = NULL,
    @SubnetMask nvarchar(128) = NULL,
    @DefaultIPGateway nvarchar(128) = NULL,
    @DNSDomainSuffixSearchOrder nvarchar(255) = NULL,
    @DNSServerSearchOrder nvarchar(255) = NULL,
    @DNSEnabledForWINSResolution bit,
    @FullDNSRegistrationEnabled bit,
    @DHCPEnabled bit,
    @DHCPLeaseObtained datetime2(3) = NULL,
    @DHCPLeaseExpires datetime2(3) = NULL,
    @DHCPServer nvarchar(128) = NULL,
    @WINSPrimaryServer nvarchar(128) = NULL,
    @WINSSecondaryServer nvarchar(128) = NULL,
    @IPEnabled bit,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[NetworkAdapterConfiguration] AS target
	USING (SELECT @MACAddress, @IPV4Address, @SubnetMask, @DefaultIPGateway, @DNSDomainSuffixSearchOrder, @DNSServerSearchOrder, @DNSEnabledForWINSResolution, @FullDNSRegistrationEnabled, @DHCPEnabled, @DHCPLeaseObtained, @DHCPLeaseExpires, @DHCPServer, @WINSPrimaryServer, @WINSSecondaryServer, @IPEnabled, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([MACAddress], [IPV4Address], [SubnetMask], [DefaultIPGateway], [DNSDomainSuffixSearchOrder], [DNSServerSearchOrder], [DNSEnabledForWINSResolution], [FullDNSRegistrationEnabled], [DHCPEnabled], [DHCPLeaseObtained], [DHCPLeaseExpires], [DHCPServer], [WINSPrimaryServer], [WINSSecondaryServer], [IPEnabled], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [Index] = @Index)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [MACAddress] = @MACAddress, [IPV4Address] = @IPV4Address, [SubnetMask] = @SubnetMask, [DefaultIPGateway] = @DefaultIPGateway, [DNSDomainSuffixSearchOrder] = @DNSDomainSuffixSearchOrder, [DNSServerSearchOrder] = @DNSServerSearchOrder, [DNSEnabledForWINSResolution] = @DNSEnabledForWINSResolution, [FullDNSRegistrationEnabled] = @FullDNSRegistrationEnabled, [DHCPEnabled] = @DHCPEnabled, [DHCPLeaseObtained] = @DHCPLeaseObtained, [DHCPLeaseExpires] = @DHCPLeaseExpires, [DHCPServer] = @DHCPServer, [WINSPrimaryServer] = @WINSPrimaryServer, [WINSSecondaryServer] = @WINSSecondaryServer, [IPEnabled] = @IPEnabled, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [Index], [MACAddress], [IPV4Address], [SubnetMask], [DefaultIPGateway], [DNSDomainSuffixSearchOrder], [DNSServerSearchOrder], [DNSEnabledForWINSResolution], [FullDNSRegistrationEnabled], [DHCPEnabled], [DHCPLeaseObtained], [DHCPLeaseExpires], [DHCPServer], [WINSPrimaryServer], [WINSSecondaryServer], [IPEnabled], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @Index, @MACAddress, @IPV4Address, @SubnetMask, @DefaultIPGateway, @DNSDomainSuffixSearchOrder, @DNSServerSearchOrder, @DNSEnabledForWINSResolution, @FullDNSRegistrationEnabled, @DHCPEnabled, @DHCPLeaseObtained, @DHCPLeaseExpires, @DHCPServer, @WINSPrimaryServer, @WINSSecondaryServer, @IPEnabled, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Index], [MACAddress], [IPV4Address], [SubnetMask], [DefaultIPGateway], [DNSDomainSuffixSearchOrder], [DNSServerSearchOrder], [DNSEnabledForWINSResolution], [FullDNSRegistrationEnabled], [DHCPEnabled], [DHCPLeaseObtained], [DHCPLeaseExpires], [DHCPServer], [WINSPrimaryServer], [WINSSecondaryServer], [IPEnabled], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[NetworkAdapterConfiguration]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT