CREATE PROC dbo.spReportHeaderSelectByReportName
@ReportName nvarchar(255)

AS

SET NOCOUNT ON
SET XACT_ABORT ON


SELECT [Id]
      ,[ReportName]
      ,[ReportDisplayName]
      ,[ReportBackground]
      ,[TitleBackground]
      ,[TitleFont]
      ,[TitleFontColor]
      ,[TitleFontSize]
      ,[TableHeaderBackground]
      ,[TableHeaderFont]
      ,[TableHeaderFontColor]
      ,[TableHeaderFontSize]
      ,[TableFooterBackground]
      ,[TableFooterFont]
      ,[TableFooterFontColor]
      ,[TableFooterFontSize]
      ,[RowEvenBackground]
      ,[RowEvenFont]
      ,[RowEvenFontColor]
      ,[RowEvenFontSize]
      ,[RowOddBackground]
      ,[RowOddFont]
      ,[RowOddFontColor]
      ,[RowOddFontSize]
      ,[dbAddDate]
      ,[dbModDate]
  FROM [dbo].[ReportHeader]
  WHERE [ReportName] = @ReportName