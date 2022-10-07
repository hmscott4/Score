CREATE TABLE [cm].[WebApplication] (
    [objectGUID]   UNIQUEIDENTIFIER CONSTRAINT [DF_WebApplication_objectGUID] DEFAULT (newid()) NOT NULL,
    [Name]         NVARCHAR (255)   NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_WebApplication] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

