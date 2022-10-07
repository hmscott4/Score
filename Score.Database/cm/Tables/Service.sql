CREATE TABLE [cm].[Service] (
    [objectGUID]   UNIQUEIDENTIFIER CONSTRAINT [DF_cm_Service_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [ComputerGUID] UNIQUEIDENTIFIER NOT NULL,
    [Name]         NVARCHAR (255)   NOT NULL,
    [DisplayName]  NVARCHAR (255)   NULL,
    [Description]  NVARCHAR (2048)  NULL,
    [Status]       NVARCHAR (128)   NULL,
    [State]        NVARCHAR (128)   NULL,
    [StartMode]    NVARCHAR (128)   NULL,
    [StartName]    NVARCHAR (255)   NULL,
    [PathName]     NVARCHAR (255)   NULL,
    [AcceptStop]   BIT              NOT NULL,
    [AcceptPause]  BIT              NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_Service] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_Service_Computer] FOREIGN KEY ([ComputerGUID]) REFERENCES [cm].[Computer] ([objectGUID])
);

