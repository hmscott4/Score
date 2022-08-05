CREATE TABLE [ad].[SupportedEncryptionTypes] (
    [ID]           INT             NOT NULL,
    [HexValue]     NVARCHAR (128)  NOT NULL,
    [Description]  NVARCHAR (1024) NOT NULL,
    [Active]       BIT             NOT NULL,
    [dbAddDate]    DATETIME2 (3)   NOT NULL,
    [dbLastUpdate] DATETIME2 (3)   NOT NULL,
    CONSTRAINT [PK_SupportedEncryptionTypes] PRIMARY KEY CLUSTERED ([ID] ASC)
);

