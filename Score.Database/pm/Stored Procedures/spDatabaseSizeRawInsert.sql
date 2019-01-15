CREATE PROC [pm].[spDatabaseSizeRawInsert]
	@DateTime datetime2(3),
	@DatabaseGUID uniqueidentifier,
	@DataFileSize bigint,
	@DataFileSpaceUsed bigint,
	@LogFileSize bigint,
	@LogFileSpaceUsed bigint,
	@dbAddDate datetime2(3)
AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

INSERT INTO [pm].[DatabaseSizeRaw]
           ([DateTime]
           ,[DatabaseGUID]
           ,[DataFileSize]
           ,[DataFileSpaceUsed]
           ,[LogFileSize]
           ,[LogFileSpaceUsed]
           ,[dbAddDate])
     VALUES
           (@DateTime
           ,@DatabaseGUID
           ,@DataFileSize
           ,@DataFileSpaceUsed
           ,@LogFileSize
           ,@LogFileSpaceUsed
           ,@dbAddDate)
COMMIT
