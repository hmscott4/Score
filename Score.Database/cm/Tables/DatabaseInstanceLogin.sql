CREATE TABLE [cm].[DatabaseInstanceLogin] (
    [objectGUID]                UNIQUEIDENTIFIER CONSTRAINT [DF_cm_DatabaseInstanceLogin_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [DatabaseInstanceGUID]      UNIQUEIDENTIFIER NOT NULL,
    [Name]                      NVARCHAR (255)   NOT NULL,
    [Sid]                       NVARCHAR (255)   NOT NULL,
    [LoginType]                 NVARCHAR (128)   NOT NULL,
    [DefaultDatabase]           NVARCHAR (255)   NOT NULL,
    [HasAccess]                 BIT              NOT NULL,
    [IsDisabled]                BIT              NULL,
    [IsLocked]                  BIT              NULL,
    [IsPasswordExpired]         BIT              NULL,
    [PasswordExpirationEnabled] BIT              NULL,
    [PasswordPolicyEnforced]    BIT              NULL,
    [IsSysAdmin]                BIT              NOT NULL,
    [IsSecurityAdmin]           BIT              NOT NULL,
    [IsSetupAdmin]              BIT              NOT NULL,
    [IsProcessAdmin]            BIT              NOT NULL,
    [IsDiskAdmin]               BIT              NOT NULL,
    [IsDBCreator]               BIT              NOT NULL,
    [IsBulkAdmin]               BIT              NOT NULL,
    [CreateDate]                DATETIME2 (3)    NOT NULL,
    [DateLastModified]          DATETIME2 (3)    NOT NULL,
    [State]                     NVARCHAR (128)   NOT NULL,
    [Active]                    BIT              NOT NULL,
    [dbAddDate]                 DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]              DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_DatabaseInstanceLogin] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_DatabaseInstanceLogin_DatabaseInstance] FOREIGN KEY ([DatabaseInstanceGUID]) REFERENCES [cm].[DatabaseInstance] ([objectGUID])
);

GO
CREATE NONCLUSTERED INDEX [IX_DatabaseInstanceLogin_DatabaseInstanceGUID] 
    ON [cm].[DatabaseInstanceLogin](DatabaseInstanceGUID)