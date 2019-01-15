CREATE PROC [cm].[spDrivePartitionMapSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [ObjectGUID], [ComputerGUID], [PartitionName], [DriveName], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DrivePartitionMap] 
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
