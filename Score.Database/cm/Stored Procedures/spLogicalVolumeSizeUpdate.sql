/****** Object:  StoredProcedure [cm].[spLogicalVolumeSizeUpdate]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [cm].[spLogicalVolumeSizeUpdate]
	@dnsHostName nvarchar(255),
	@LogicalVolumeName nvarchar(255),
	@Capacity bigint,
	@SpaceUsed bigint

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

DECLARE @ComputerGUID uniqueidentifier
SELECT @ComputerGUID = [objectGUID]
FROM [cm].[Computer]
WHERE [dnsHostName] = @dnsHostName

UPDATE [cm].[LogicalVolume]
SET [Capacity] = @Capacity, [SpaceUsed] = @SpaceUsed
WHERE [ComputerGUID] = @ComputerGUID AND [Name] = @LogicalVolumeName

COMMIT