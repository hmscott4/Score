CREATE PROC [dbo].[spReportContentSelectByReportID]
@ReportID uniqueidentifier

AS

SET NOCOUNT ON
SET XACT_ABORT ON

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