CREATE TABLE [cm].[WindowsUpdate] (
    [objectGUID]   UNIQUEIDENTIFIER CONSTRAINT [DF_cm_WindowsUpdate] DEFAULT (newid()) NOT NULL,
    [HotfixID]     NVARCHAR (128)   NOT NULL,
    [Description]  NVARCHAR (128)   NOT NULL,
    [Caption]      NVARCHAR (128)   NULL,
    [FixComments]  NVARCHAR (128)   NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_WindowsUpdate] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

