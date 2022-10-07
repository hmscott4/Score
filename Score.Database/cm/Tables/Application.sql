CREATE TABLE [cm].[Application] (
    [objectGUID]        UNIQUEIDENTIFIER CONSTRAINT [DF_cm_Application_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [Name]              NVARCHAR (255)   NOT NULL,
    [Version]           NVARCHAR (128)   NULL,
    [Vendor]            NVARCHAR (128)   NULL,
    [Licensed]          BIT              CONSTRAINT [DF_cm_Application_Licensed] DEFAULT ((0)) NULL,
    [LicenseMetric]     NVARCHAR (64)    CONSTRAINT [DF_cm_Application_LicenseMetric] DEFAULT (N'') NULL,
    [AvailableLicenses] INT              CONSTRAINT [DF_cm_Application_AvailableLicenses] DEFAULT ((0)) NULL,
    [AllocatedLicenses] INT              CONSTRAINT [DF_cm_Application_AllocatedLicenses] DEFAULT ((0)) NULL,
    [Active]            BIT              NOT NULL,
    [dbAddDate]         DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]      DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_Application] PRIMARY KEY CLUSTERED ([objectGUID] ASC)
);

