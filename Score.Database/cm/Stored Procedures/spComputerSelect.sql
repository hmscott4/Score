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
