CREATE TABLE [cm].[ReportServerItem] (
    [objectGUID]            UNIQUEIDENTIFIER CONSTRAINT [DF_cm_ReportServerItem_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [ReportingInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [Name]                  NVARCHAR (425)   NOT NULL,
    [Path]                  NVARCHAR (425)   NOT NULL,
    [VirtualPath]           NVARCHAR (1024)  NOT NULL,
    [TypeName]              NVARCHAR (128)   NOT NULL,
    [Size]                  INT              NOT NULL,
    [Description]           NVARCHAR (1024)  NULL,
    [Hidden]                BIT              NOT NULL,
    [CreationDate]          DATETIME2 (3)    NOT NULL,
    [ModifiedDate]          DATETIME2 (3)    NOT NULL,
    [ModifiedBy]            NVARCHAR (255)   NOT NULL,
    [Active]                BIT              NOT NULL,
    [dbAddDate]             DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]          DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_ReportServerItem] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_ReportServerItem_ReportingInstance] FOREIGN KEY ([ReportingInstanceGUID]) REFERENCES [cm].[ReportingInstance] ([objectGUID])
);

