CREATE TABLE [ad].[UserAccountControl] (
    [ID]           INT             NOT NULL,
    [HexValue]     NVARCHAR (128)  NOT NULL,
    [Property]     NVARCHAR (255)  NOT NULL,
    [Definition]   NVARCHAR (2048) NOT NULL,
    [Active]       BIT             NOT NULL,
    [dbAddDate]    DATETIME2 (3)   NOT NULL,
    [dbLastUpdate] DATETIME2 (3)   NOT NULL,
    CONSTRAINT [PK_UserAccountControl] PRIMARY KEY CLUSTERED ([ID] ASC)
);

