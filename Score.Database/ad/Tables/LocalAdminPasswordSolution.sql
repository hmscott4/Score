CREATE TABLE [ad].[LocalAdminPasswordSolution] (
    [objectGUID]       UNIQUEIDENTIFIER NOT NULL,
    [AdmPwdExpiration] DATETIME2 (3)    NULL,
    [AdmPassword]      VARBINARY (255)  NULL,
    [dbAddDate]        DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]     DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_LocalAdminPasswordSolution] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

