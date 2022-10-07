/****** Object:  StoredProcedure [cm].[spLogicalVolumeSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spLogicalVolumeSelectByComputer] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Name], [DriveLetter], [Label], [FileSystem], [BlockSize], [SerialNumber], [Capacity], [SpaceUsed], [SystemVolume], [IsClustered], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[LogicalVolume] 
	WHERE  ([ComputerGUID] = @computerGUID AND [Active] >= @Active) 

	COMMIT