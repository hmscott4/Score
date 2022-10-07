CREATE TABLE [ad].[GroupSensitivity] (
    [ObjectID]     INT            IDENTITY (1, 1) NOT NULL,
    [Domain]       NVARCHAR (128) NOT NULL,
    [GroupName]    NVARCHAR (255) NOT NULL,
    [Sensitivity]  INT            NOT NULL,
    [Active]       BIT            NOT NULL,
    [dbAddDate]    DATETIME       NOT NULL,
    [dbLastUpdate] DATETIME       NOT NULL,
    CONSTRAINT [PK_GroupSensitivity] PRIMARY KEY CLUSTERED ([ObjectID] ASC)
);

