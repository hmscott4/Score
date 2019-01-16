/****** Object:  StoredProcedure [cm].[spComputerSelect]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spComputerSelect] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [Domain], [dnsHostName], [netBIOSName], [IPv4Address], [DomainRole], [CurrentTimeZone], [DaylightInEffect], [Status], [Manufacturer], [Model], [PCSystemType], [SystemType], [AssetTag], [SerialNumber], [TotalPhysicalMemory], [NumberOfLogicalProcessors], [NumberOfProcessors], [IsVirtual], [IsClusterResource], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Computer] 
	WHERE  ([dnsHostName] = @dnsHostName) 

	COMMIT
GO