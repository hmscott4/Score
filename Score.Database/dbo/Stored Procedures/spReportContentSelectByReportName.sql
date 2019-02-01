CREATE PROC [dbo].[spReportContentSelectByReportName]
@ReportName nvarchar(255)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @ReportId uniqueidentifier

SELECT @ReportID = Id
FROM dbo.ReportHeader
WHERE ReportName = @ReportName

SELECT [Id]
      ,[ReportId]
      ,[SortSequence]
      ,[ItemBackground]
      ,[ItemFont]
      ,[ItemFontSize]
      ,[ItemFontColor]
      ,[ItemParameters]
      ,[dbAddDate]
      ,[dbModDate]
  FROM [dbo].[ReportContent]
  WHERE [ReportId] = @ReportId
  ORDER BY [SortSequence]