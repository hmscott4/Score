/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeRawInsert]    Script Date: 1/16/2019 8:32:48 AM ******/

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
GO
GRANT EXECUTE ON [pm].[spLogicalVolumeSizeRawInsert] TO [pmUpdate] AS [dbo]
GO
