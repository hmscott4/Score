﻿CREATE TABLE [scom].[Alert] (
    [AlertId]                           UNIQUEIDENTIFIER NOT NULL,
    [Name]                              NVARCHAR (255)   NOT NULL,
    [Description]                       NVARCHAR (2000)  NOT NULL,
    [MonitoringObjectId]                UNIQUEIDENTIFIER NOT NULL,
    [MonitoringClassId]                 UNIQUEIDENTIFIER NOT NULL,
    [MonitoringObjectDisplayName]       NTEXT            NOT NULL,
    [MonitoringObjectName]              NTEXT            NULL,
    [MonitoringObjectPath]              NVARCHAR (MAX)   NULL,
    [MonitoringObjectFullName]          NTEXT            NOT NULL,
    [IsMonitorAlert]                    BIT              NOT NULL,
    [ProblemId]                         UNIQUEIDENTIFIER NOT NULL,
    [MonitoringRuleId]                  UNIQUEIDENTIFIER NOT NULL,
    [ResolutionState]                   TINYINT          NOT NULL,
    [ResolutionStateName]               NVARCHAR (50)    NOT NULL,
    [Priority]                          TINYINT          NOT NULL,
    [Severity]                          TINYINT          NOT NULL,
    [Category]                          NVARCHAR (255)   NOT NULL,
    [Owner]                             NVARCHAR (255)   NULL,
    [ResolvedBy]                        NVARCHAR (255)   NULL,
    [TimeRaised]                        DATETIME2 (3)    NOT NULL,
    [TimeAdded]                         DATETIME2 (3)    NOT NULL,
    [LastModified]                      DATETIME2 (3)    NOT NULL,
    [LastModifiedBy]                    NVARCHAR (255)   NOT NULL,
    [TimeResolved]                      DATETIME2 (3)    NULL,
    [TimeResolutionStateLastModified]   DATETIME2 (3)    NOT NULL,
    [CustomField1]                      NVARCHAR (255)   NULL,
    [CustomField2]                      NVARCHAR (255)   NULL,
    [CustomField3]                      NVARCHAR (255)   NULL,
    [CustomField4]                      NVARCHAR (255)   NULL,
    [CustomField5]                      NVARCHAR (255)   NULL,
    [CustomField6]                      NVARCHAR (255)   NULL,
    [CustomField7]                      NVARCHAR (255)   NULL,
    [CustomField8]                      NVARCHAR (255)   NULL,
    [CustomField9]                      NVARCHAR (255)   NULL,
    [CustomField10]                     NVARCHAR (255)   NULL,
    [TicketId]                          NVARCHAR (150)   NULL,
    [Context]                           NTEXT            NULL,
    [ConnectorId]                       UNIQUEIDENTIFIER NULL,
    [LastModifiedByNonConnector]        DATETIME2 (3)    NOT NULL,
    [MonitoringObjectInMaintenanceMode] BIT              NOT NULL,
    [MaintenanceModeLastModified]       DATETIME2 (3)    NOT NULL,
    [MonitoringObjectHealthState]       TINYINT          NOT NULL,
    [StateLastModified]                 DATETIME2 (3)    NOT NULL,
    [ConnectorStatus]                   INT              NOT NULL,
    [TopLevelHostEntityId]              UNIQUEIDENTIFIER NULL,
    [RepeatCount]                       INT              NOT NULL,
    [AlertStringId]                     UNIQUEIDENTIFIER NULL,
    [AlertStringName]                   NVARCHAR (MAX)   NULL,
    [LanguageCode]                      NVARCHAR (3)     NULL,
    [AlertStringDescription]            NTEXT            NULL,
    [AlertParams]                       NTEXT            NULL,
    [SiteName]                          NVARCHAR (255)   NULL,
    [TfsWorkItemId]                     NVARCHAR (150)   NULL,
    [TfsWorkItemOwner]                  NVARCHAR (255)   NULL,
    [HostID]                            INT              NULL,
    [Active]                            BIT              NOT NULL,
    [dbAddDate]                         DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]                      DATETIME2 (3)    NOT NULL,
    [ManagementGroup]                   NVARCHAR (255)   NULL,
    CONSTRAINT [PK_scom_Alert] PRIMARY KEY CLUSTERED ([AlertId] ASC) WITH (FILLFACTOR = 80)
);


GO

