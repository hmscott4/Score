CREATE TABLE [scom].[ObjectHealthStateAlertRelationship] (
    [ObjectID]     UNIQUEIDENTIFIER NOT NULL,
    [AlertID]      UNIQUEIDENTIFIER NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_scom_ObjectAlertRelationship] PRIMARY KEY CLUSTERED ([ObjectID] ASC, [AlertID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_scom_ObjectHealthStateAlertRelationship_Alert] FOREIGN KEY ([AlertID]) REFERENCES [scom].[Alert] ([AlertId]),
    CONSTRAINT [FK_scom_ObjectHealthStateAlertRelationship_ObjectHealthState] FOREIGN KEY ([ObjectID]) REFERENCES [scom].[ObjectHealthState] ([ID])
);

