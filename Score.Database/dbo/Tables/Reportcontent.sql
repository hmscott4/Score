CREATE TABLE [dbo].[ReportContent]
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [ReportHeader] UNIQUEIDENTIFIER NOT NULL, 
    [SortSequence] INT NOT NULL,
	[ItemBackground] INT NOT NULL, 
    [ItemFont] NVARCHAR(255) NOT NULL, 
    [ItemFontSize] INT NOT NULL, 
    [ItemFontColor] INT NOT NULL, 
    [ItemParameters] NVARCHAR(MAX) NULL, 
    [dbAddDate] DATETIME2(3) NOT NULL DEFAULT GetDate(), 
    [dbModDate] DATETIME2(3) NOT NULL DEFAULT GetDate(),
)
