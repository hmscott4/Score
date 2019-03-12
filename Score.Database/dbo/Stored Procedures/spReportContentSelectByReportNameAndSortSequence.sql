CREATE PROC [dbo].[spReportContentSelectByReportNameAndSortSequence]
@ReportName nvarchar(255),
@SortSequence int 

AS

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @ReportId uniqueidentifier

SELECT @ReportId = Id
FROM dbo.ReportHeader
WHERE ReportName = @ReportName

SELECT [Id]
      ,[ReportId]
      ,[SortSequence]
      ,[ItemBackground]
      ,[ItemFont]
      ,[ItemFontSize]
      ,[ItemFontColor]
	  ,[DisplayName]
      ,[ItemParameters]
      ,[dbAddDate]
      ,[dbModDate]
  FROM [dbo].[ReportContent]
  WHERE [ReportId] = @ReportId
  AND [SortSequence] = @SortSequence