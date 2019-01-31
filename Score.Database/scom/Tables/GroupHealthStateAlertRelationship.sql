CREATE TABLE [scom].[GroupHealthStateAlertRelationship] (
    [GroupID]      UNIQUEIDENTIFIER NOT NULL,
    [AlertID]      UNIQUEIDENTIFIER NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_scom_GroupHealthStateAlertRelationship] PRIMARY KEY CLUSTERED ([GroupID] ASC, [AlertID] ASC) WITH (FILLFACTOR = 80)
);

