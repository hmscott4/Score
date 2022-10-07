/****************************************************************
* Name: ad.spWebApplicationURLResponseDailyUpsert
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROCEDURE [pm].[spWebApplicationURLResponseDailyUpsert]
	@ForDate [Date] = null

AS

	SET NOCOUNT ON
	SET XACT_ABORT ON

	IF @ForDate IS NULL
	BEGIN
		SET @ForDate = Cast(Convert(varchar(10), CURRENT_TIMESTAMP, 120) AS Date)
	END

	DECLARE @CurrentTime datetime2(3)
	SET @CurrentTime = CURRENT_TIMESTAMP


	MERGE [pm].[WebApplicationURLResponseDaily] AS [target]
	USING (
		SELECT @ForDate AS [Date]
			, [WebApplicationURLGUID]
			, SUM(CASE WHEN [StatusCode] < 400 THEN 0 ELSE 1 END) AS [FailedCheckCount]
			, SUM(CASE WHEN [StatusCode] < 400 THEN 1 ELSE 0 END) AS [SuccessCheckCount]
			, AVG([LastResponseTime]) AS [AvgResponseTime]
			, MIN([LastResponseTime]) AS [MinResponseTime]
			, MAX([LastResponseTime]) AS [MaxResponseTime]
			, ISNULL(STDEV([LastResponseTime]),0) AS [StDevResponseTime]
			, COUNT(*) AS [COUNT]
			, @CurrentTime AS [dbAddDate]	
		FROM
			[pm].[WebApplicationURLResponseRaw]
		WHERE 
			[DateTime] BETWEEN @ForDate AND DateAdd(DAY, 1, @ForDate)
		GROUP BY
			[WebApplicationURLGUID]
		) 
	AS [source]
           ([Date]
           ,[WebApplicationURLGUID]
           ,[FailedCheckCount]
           ,[SuccessCheckCount]
           ,[AvgResponseTime]
           ,[MinResponseTime]
           ,[MaxResponseTime]
           ,[StDevResponseTime]
           ,[Count]
           ,[dbAddDate])
	ON ([target].[Date] = [source].[Date] AND [target].[WebApplicationURLGUID] = [source].[WebApplicationURLGUID])
	WHEN MATCHED THEN
		UPDATE
		SET [target].[FailedCheckCount] = [source].[FailedCheckCount], [target].[SuccessCheckCount] = [source].[SuccessCheckCount], [target].[AvgResponseTime] = [source].[AvgResponseTime], [target].[MinResponseTime] = [source].[MinResponseTime], [target].[MaxResponseTime] = [source].[MaxResponseTime], [target].[StDevResponseTime] = [source].[StDevResponseTime], [target].[Count] = [source].[Count], [target].[dbAddDate] = [source].[dbAddDate]

	WHEN NOT MATCHED THEN
		INSERT (
			[Date]
           ,[WebApplicationURLGUID]
           ,[FailedCheckCount]
           ,[SuccessCheckCount]
           ,[AvgResponseTime]
           ,[MinResponseTime]
           ,[MaxResponseTime]
           ,[StDevResponseTime]
           ,[Count]
           ,[dbAddDate])
		VALUES (
			[source].[Date]
           ,[source].[WebApplicationURLGUID]
           ,[source].[FailedCheckCount]
           ,[source].[SuccessCheckCount]
           ,[source].[AvgResponseTime]
           ,[source].[MinResponseTime]
           ,[source].[MaxResponseTime]
           ,[source].[StDevResponseTime]
           ,[source].[Count]
           ,[source].[dbAddDate])
	;