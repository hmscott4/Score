CREATE PROC [dbo].[spReportContentSelectByReportName]
@ReportName nvarchar(255)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @ReportID uniqueidentifier

SELECT @ReportID = ID
FROM dbo.ReportHeader
WHERE ReportName = @ReportName

SELECT [Id]
      ,[ReportId]
      ,[SortSequence]
      ,[ItemBackground]
      ,[ItemFont]
      ,[ItemFontSize]
      ,[ItemFontColor]
	  ,[ItemDisplay]
      ,[ItemParameters]
      ,[dbAddDate]
      ,[dbModDate]
  FROM [dbo].[ReportContent]
  WHERE [ReportId] = @ReportID
  ORDER BY [SortSequence]