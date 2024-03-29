﻿CREATE TABLE [ad].[DeletedObject] (
    [objectGUID]        UNIQUEIDENTIFIER NOT NULL,
    [SID]               NVARCHAR (255)   NOT NULL,
    [Domain]            NVARCHAR (128)   NOT NULL,
    [Name]              NVARCHAR (255)   NOT NULL,
    [DistinguishedName] NVARCHAR (255)   NOT NULL,
    [objectType]        NVARCHAR (128)   NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NULL,
    [dbDelDate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ad_DeletedObject] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

