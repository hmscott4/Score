CREATE TABLE [cm].[ApplicationInstallation] (
    [objectGUID]      UNIQUEIDENTIFIER CONSTRAINT [DF_cm_ApplicationInstallation_objectGUID] DEFAULT (newid()) NOT NULL,
    [ComputerGUID]    UNIQUEIDENTIFIER NOT NULL,
    [ApplicationGUID] UNIQUEIDENTIFIER NOT NULL,
    [InstallDate]     DATETIME2 (7)    NULL,
    [Active]          BIT              NOT NULL,
    [dbAddDate]       DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]    DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_ApplicationInstallation] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_ApplicationInstallation_Computer] FOREIGN KEY ([ComputerGUID]) REFERENCES [cm].[Computer] ([objectGUID])
);

