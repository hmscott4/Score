CREATE TABLE [dbo].[Config] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [ConfigName]  NVARCHAR (255) NOT NULL,
    [ConfigValue] NVARCHAR (255) NOT NULL,
    [dbAddDate]   DATETIME2 (3)  NOT NULL,
    [dbAddBy]     NVARCHAR (255) NOT NULL,
    [dbModDate]   DATETIME2 (3)  NOT NULL,
    [dbModBy]     NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_Config] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Config_Unique]
    ON [dbo].[Config]([ConfigName] ASC);

