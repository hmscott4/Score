/****************************************************************
* Name: cm.spNetworkAdapterConfigurationInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterConfigurationInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[NetworkAdapterConfiguration]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([computerGUID] = @ComputerGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Index], [MACAddress], [IPV4Address], [SubnetMask], [DefaultIPGateway], [DNSDomainSuffixSearchOrder], [DNSServerSearchOrder], [DNSEnabledForWINSResolution], [FullDNSRegistrationEnabled], [DHCPEnabled], [DHCPLeaseObtained], [DHCPLeaseExpires], [DHCPServer], [WINSPrimaryServer], [WINSSecondaryServer], [IPEnabled], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[NetworkAdapterConfiguration]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
