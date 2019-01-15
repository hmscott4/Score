CREATE PROC [cm].[spDatabaseSizeUpdate]
	@DatabaseGUID uniqueidentifier,
	@DataFileSize bigint,
	@DataFileSpaceUsed bigint,
	@LogFileSize bigint,
	@LogFileSpaceUsed bigint,
	@VirtualLogFileCount int

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE [cm].[Database]
SET [DataFileSize] = @DataFileSize, 
	[DataFileSpaceUsed] = @DataFileSpaceUsed,
	[LogFileSize] = @LogFileSize,
	[LogFileSpaceUsed] = @LogFileSpaceUsed,
	[VirtualLogFileCount] = @VirtualLogFileCount
WHERE [objectGUID] = @DatabaseGUID

COMMIT
