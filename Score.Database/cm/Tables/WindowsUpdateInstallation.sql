CREATE TABLE [cm].[WindowsUpdateInstallation] (
    [objectGUID]        UNIQUEIDENTIFIER CONSTRAINT [DF_cm_WindowsUpdateInstallation] DEFAULT (newid()) NOT NULL,
    [ComputerGUID]      UNIQUEIDENTIFIER NOT NULL,
    [WindowsUpdateGUID] UNIQUEIDENTIFIER NOT NULL,
    [InstallDate]       DATETIME2 (3)    NULL,
    [InstallBy]         NVARCHAR (128)   NULL,
    [Active]            BIT              NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]      DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_WindowsUpdateInstallation] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cm_WindowsUpdateInstallation]
    ON [cm].[WindowsUpdateInstallation]([ComputerGUID] ASC, [WindowsUpdateGUID] ASC);

