/****************************************************************
* Name: ad.spDatabaseSizeDailyUpsert
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [pm].[spDatabaseSizeDailyUpsert]
	@ForDate DateTime2 = null

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF @ForDate IS NULL
BEGIN
	SET @ForDate = Cast(Convert(varchar(10), CURRENT_TIMESTAMP, 120) AS DATETIME2)
END

DECLARE @CurrentTime datetime2
SET @CurrentTime = CURRENT_TIMESTAMP


	MERGE [pm].[DatabaseSizeDaily] AS [target]
	USING (
		SELECT 
			@ForDate as [Date]
			, [DatabaseGUID]
			, AVG([DataFileSize]) as [DataFileSize]
			, AVG([DataFileSpaceUsed]) as [DataFileSpaceUsed]
			, AVG([LogFileSize]) as [LogFileSize]
			, AVG([LogFileSpaceUsed]) as [LogFileSpaceUsed]
			, COUNT(*) AS [Count]
			, @CurrentTime as [dbAddDate]
		FROM
			[pm].[DatabaseSizeRaw]
		WHERE 
			[DateTime] BETWEEN @ForDate AND DateAdd(DAY, 1, @ForDate)
		GROUP BY
			[DatabaseGUID]
	)
	AS [source] (
		[Date]
        ,[DatabaseGUID]
        ,[DataFileSize]
        ,[DataFileSpaceUsed]
        ,[LogFileSize]
        ,[LogFileSpaceUsed]
        ,[Count]
        ,[dbAddDate]
	)
	ON ([target].[Date] = [source].[Date] AND [target].[DatabaseGUID] = [source].[DatabaseGUID])

	WHEN MATCHED THEN
	UPDATE
	SET [target].[DataFileSize] = [source].[DataFileSize], [target].[DataFileSpaceUsed] = [source].[DataFileSpaceUsed], [target].[LogFileSize] = [source].[LogFileSize], [target].[LogFileSpaceUsed] = [source].[LogFileSpaceUsed], [target].[Count] = [source].[Count], [target].[dbAddDate] = [source].[dbAddDate]

	WHEN NOT MATCHED THEN
	INSERT ([Date]
           ,[DatabaseGUID]
           ,[DataFileSize]
           ,[DataFileSpaceUsed]
           ,[LogFileSize]
           ,[LogFileSpaceUsed]
           ,[Count]
           ,[dbAddDate])
	VALUES ([source].[Date]
           ,[source].[DatabaseGUID]
           ,[source].[DataFileSize]
           ,[DataFileSpaceUsed]
           ,[source].[LogFileSize]
           ,[source].[LogFileSpaceUsed]
           ,[source].[Count]
           ,[source].[dbAddDate])
	;