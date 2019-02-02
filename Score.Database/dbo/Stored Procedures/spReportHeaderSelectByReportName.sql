CREATE PROC [dbo].[spReportHeaderSelectByReportName]
@ReportName nvarchar(255)

AS

SET NOCOUNT ON
SET XACT_ABORT ON


SELECT TOP 1 [Id]
      ,[ReportName]
      ,[ReportDisplayName]
      ,[ReportBackground]
      ,[TitleBackground]
      ,[TitleFont]
      ,[TitleFontColor]
      ,[TitleFontSize]
      ,[SubTitleBackground]
      ,[SubTitleFont]
      ,[SubTitleFontColor]
      ,[SubTitleFontSize]
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
      ,[FooterBackground]
      ,[FooterFont]
      ,[FooterFontColor]
      ,[FooterFontSize]
  FROM [dbo].[ReportHeader]
  WHERE [ReportName] = @ReportName OR [ReportName] = '<default>'
  ORDER BY [ReportName] DESC