/****** Object:  StoredProcedure [pm].[spLogicalVolumeSizeDailyUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [pm].[spLogicalVolumeSizeDailyUpsert]
	@ForDate [Date] = null

AS

	SET NOCOUNT ON
	SET XACT_ABORT ON

	IF @ForDate IS NULL
	BEGIN
		SET @ForDate = Cast(Convert(varchar(10), CURRENT_TIMESTAMP, 120) AS DATETIME2)
	END

	DECLARE @CurrentTime datetime2
	SET @CurrentTime = CURRENT_TIMESTAMP

	MERGE [pm].[LogicalVolumeSizeDaily] AS target
	USING (
	SELECT
		@ForDate as [Date]
		,[ComputerGUID]
		,[LogicalVolumeGUID]
		,AVG([SpaceUsed]) as AvgSpaceUsed
		,Max([SpaceUsed]) as MaxSpaceUsed
		,Min([SpaceUsed]) as MinSpaceUsed
		,IsNULL(StDev([SpaceUsed]),0) as StDevSpaceUsed
		,COUNT(*) as [Count]
		,@CurrentTime as [dbAddDate]
	FROM
		[pm].[LogicalVolumeSizeRaw]
	WHERE 
		[DateTime] BETWEEN @ForDate AND DateAdd(DAY, 1, @ForDate)
	GROUP BY 
		[ComputerGUID], [LogicalVolumeGUID])
	AS source
		(	[Date]
           ,[ComputerGUID]
		   ,[LogicalVolumeGUID]
           ,[AvgSpaceUsed]
           ,[MaxSpaceUsed]
           ,[MinSpaceUsed]
           ,[StDevSpaceUsed]
           ,[Count]
           ,[dbAddDate])
	ON (target.[Date] = source.[Date] AND target.[ComputerGUID] = source.[ComputerGUID] AND target.[LogicalVolumeGUID] = source.[LogicalVolumeGUID])

	WHEN MATCHED THEN
		UPDATE
		SET [target].[SpaceUsed] = source.[AvgSpaceUsed], target.[MaxSpaceUsed] = source.[MaxSpaceUsed], target.MinSpaceUsed = source.MinSpaceUsed, target.StDevSpaceUsed = source.StDevSpaceUsed, target.[Count] = source.[Count], target.dbAddDate = source.dbAddDate
	WHEN NOT MATCHED THEN
		INSERT ([Date], [ComputerGUID], [LogicalVolumeGUID], [SpaceUsed], [MaxSpaceUsed], [MinSpaceUsed], [StDevSpaceUsed], [Count], [dbAddDate])
		VALUES (source.[Date], source.[ComputerGUID], source.[LogicalVolumeGUID], source.[AvgSpaceUsed], source.[MaxSpaceUsed], source.[MinSpaceUsed], source.[StDevSpaceUsed], source.[Count], source.[dbAddDate])
	;