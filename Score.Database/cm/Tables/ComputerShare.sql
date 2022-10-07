CREATE TABLE [cm].[ComputerShare] (
    [objectGUID]   UNIQUEIDENTIFIER CONSTRAINT [DF_cm_ComputerShare_objectGUID] DEFAULT (newid()) NOT NULL,
    [ComputerGUID] UNIQUEIDENTIFIER NOT NULL,
    [Name]         NVARCHAR (128)   NOT NULL,
    [Description]  NVARCHAR (128)   NOT NULL,
    [Path]         NVARCHAR (2048)  NOT NULL,
    [Status]       NVARCHAR (128)   NULL,
    [Type]         NVARCHAR (128)   NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_ComputerShare] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_ComputerShare_Computer] FOREIGN KEY ([ComputerGUID]) REFERENCES [cm].[Computer] ([objectGUID])
);

