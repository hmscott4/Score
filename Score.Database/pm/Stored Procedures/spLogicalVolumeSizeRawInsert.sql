CREATE PROC [pm].[spLogicalVolumeSizeRawInsert] 
	@DateTime datetime2(3),
	@dnsHostName nvarchar(255),
	@LogicalVolumeName nvarchar(255),
	@SpaceUsed bigint,
	@dbAddDate datetime2(3)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @ComputerGUID uniqueidentifier
DECLARE @LogicalVolumeGUID uniqueidentifier

SELECT @ComputerGUID = [objectGUID]
FROM [cm].[Computer]
WHERE [dnsHostName] = @dnsHostName

SELECT @LogicalVolumeGUID = [objectGUID]
FROM [cm].[LogicalVolume] 
WHERE [ComputerGUID] = @ComputerGUID AND [Name] = @LogicalVolumeName

INSERT INTO [pm].[LogicalVolumeSizeRaw]
           ([DateTime]
           ,[ComputerGUID]
           ,[LogicalVolumeGUID]
           ,[SpaceUsed]
           ,[dbAddDate])
     VALUES
           (@DateTime
           ,@ComputerGUID
           ,@LogicalVolumeGUID
           ,@SpaceUsed
           ,@dbAddDate)

COMMIT
