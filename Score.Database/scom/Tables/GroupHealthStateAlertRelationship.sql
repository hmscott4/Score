CREATE TABLE [scom].[GroupHealthStateAlertRelationship] (
    [GroupID]      UNIQUEIDENTIFIER NOT NULL,
    [AlertID]      UNIQUEIDENTIFIER NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_scom_GroupHealthStateAlertRelationship] PRIMARY KEY CLUSTERED ([GroupID] ASC, [AlertID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_scom_GroupHealthStateAlertRelationship_Alert] FOREIGN KEY ([AlertID]) REFERENCES [scom].[Alert] ([AlertId]),
    CONSTRAINT [FK_scom_GroupHealthStateAlertRelationship_GroupHealthState] FOREIGN KEY ([GroupID]) REFERENCES [scom].[GroupHealthState] ([Id])
);



