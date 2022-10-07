CREATE PROC [dbo].[spReportContentSelectByReportNameAndSortSequence]
@ReportName nvarchar(255),
@SortSequence int 

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
  AND [SortSequence] = @SortSequence