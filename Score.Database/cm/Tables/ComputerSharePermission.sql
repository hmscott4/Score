CREATE TABLE [cm].[ComputerSharePermission] (
    [objectGUID]        UNIQUEIDENTIFIER CONSTRAINT [DF_cm_ComputerSharePermission_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [ComputerShareGUID] UNIQUEIDENTIFIER NOT NULL,
    [SecurityPrincipal] NVARCHAR (128)   NOT NULL,
    [FileSystemRights]  NVARCHAR (128)   NOT NULL,
    [AccessControlType] NVARCHAR (128)   NOT NULL,
    [IsInherited]       BIT              NOT NULL,
    [InheritanceFlags]  NVARCHAR (128)   NOT NULL,
    [PropagationFlags]  NVARCHAR (128)   NOT NULL,
    [Active]            BIT              NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]      DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_ComputerSharePermission] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

GO
CREATE INDEX IX_ComputerSharePermission_ComputerShareGUID ON [cm].[ComputerSharePermission](ComputerShareGUID)
