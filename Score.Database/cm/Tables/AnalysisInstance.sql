﻿CREATE TABLE [cm].[AnalysisInstance] (
    [objectGUID]         UNIQUEIDENTIFIER CONSTRAINT [DF_cm_AnalysisInstance_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [ComputerGUID]       UNIQUEIDENTIFIER NOT NULL,
    [InstanceName]       NVARCHAR (128)   NOT NULL,
    [ProductName]        NVARCHAR (128)   NOT NULL,
    [ProductEdition]     NVARCHAR (128)   NOT NULL,
    [ProductVersion]     NVARCHAR (128)   NOT NULL,
    [ProductServicePack] NVARCHAR (128)   NOT NULL,
    [ConnectionString]   NVARCHAR (255)   NOT NULL,
    [ServiceState]       NVARCHAR (128)   NOT NULL,
    [IsClustered]        BIT              NOT NULL,
    [ActiveNode]         NVARCHAR (255)   NOT NULL,
    [Active]             BIT              NOT NULL,
    [dbAddDate]          DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]       DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_AnalysisInstance] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

