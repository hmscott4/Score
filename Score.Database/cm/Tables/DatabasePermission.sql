CREATE TABLE [cm].[DatabasePermission] (
    [objectGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_cm_DatabasePermission_objectGUID] DEFAULT (newid()) NOT NULL,
    [DatabaseInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [DatabaseName]         NVARCHAR (128)   NOT NULL,
    [PermissionSource]     NVARCHAR (32)    NOT NULL,
    [PermissionState]      NVARCHAR (128)   NOT NULL,
    [PermissionType]       NVARCHAR (128)   NOT NULL,
    [Grantor]              NVARCHAR (128)   NOT NULL,
    [ObjectName]           NVARCHAR (128)   NOT NULL,
    [Grantee]              NVARCHAR (128)   NOT NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_DatabasePermission] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_DatabasePermission_DatabaseInstance] FOREIGN KEY ([DatabaseInstanceGUID]) REFERENCES [cm].[DatabaseInstance] ([objectGUID])
);

