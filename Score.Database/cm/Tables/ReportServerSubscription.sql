CREATE TABLE [cm].[ReportServerSubscription] (
    [objectGUID]            UNIQUEIDENTIFIER CONSTRAINT [DF_cm_ReportServerSubscription_objectGUID] DEFAULT (newid()) NOT NULL,
    [ReportingInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [Owner]                 NVARCHAR (255)   NOT NULL,
    [Path]                  NVARCHAR (1024)  NOT NULL,
    [VirtualPath]           NVARCHAR (1024)  NOT NULL,
    [Report]                NVARCHAR (1024)  NOT NULL,
    [Description]           NVARCHAR (1204)  NULL,
    [Status]                NVARCHAR (128)   NOT NULL,
    [SubscriptionActive]    BIT              NOT NULL,
    [LastExecuted]          DATETIME2 (3)    NULL,
    [ModifiedBy]            NVARCHAR (255)   NOT NULL,
    [ModifiedDate]          DATETIME2 (3)    NOT NULL,
    [EventType]             NVARCHAR (128)   NOT NULL,
    [IsDataDriven]          BIT              NOT NULL,
    [Active]                BIT              NOT NULL,
    [dbAddDate]             DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]          DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_ReportServerSubscription] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_ReportServerSubscription_ReportingInstance] FOREIGN KEY ([ReportingInstanceGUID]) REFERENCES [cm].[ReportingInstance] ([objectGUID])
);

