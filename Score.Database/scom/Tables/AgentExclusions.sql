﻿CREATE TABLE [scom].[AgentExclusions] (
    [ID]           INT             IDENTITY (1, 1) NOT NULL,
    [Domain]       NVARCHAR (128)  NOT NULL,
    [DNSHostName]  NVARCHAR (255)  NOT NULL,
    [Reason]       NVARCHAR (1024) NOT NULL,
    [dbAddDate]    DATETIME2 (3)   NOT NULL,
    [dbLastUpdate] DATETIME2 (3)   NOT NULL,
    CONSTRAINT [PK_AgentExclusions_ID] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [IX_scom_AgentExclusion_DNSHostName]
    ON [scom].[AgentExclusions]([DNSHostName] ASC) WITH (FILLFACTOR = 80);

