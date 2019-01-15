CREATE TABLE [cm].[ReportServerSubscriptionParameter] (
    [objectGUID]                   UNIQUEIDENTIFIER CONSTRAINT [DF_cm_ReportServerSubscriptionParameter_objectGUID] DEFAULT (newid()) NOT NULL,
    [ReportServerSubscriptionGUID] UNIQUEIDENTIFIER NOT NULL,
    [ParameterName]                NVARCHAR (255)   NOT NULL,
    [ParameterValue]               NVARCHAR (255)   NULL,
    [Active]                       BIT              NOT NULL,
    [dbAddDate]                    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]                 DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_ReportServerSubscriptionParameter] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_ReportServerSubscriptionParameter_ReportServerSubscription] FOREIGN KEY ([ReportServerSubscriptionGUID]) REFERENCES [cm].[ReportServerSubscription] ([objectGUID])
);

