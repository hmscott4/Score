CREATE TABLE [cm].[DatabaseRoleMember] (
    [objectGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_cm_DatabaseRoleMember_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [DatabaseInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [DatabaseName]         NVARCHAR (128)   NOT NULL,
    [RoleName]             NVARCHAR (128)   NOT NULL,
    [RoleMember]           NVARCHAR (128)   NOT NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_DatabaseRoleMember] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

