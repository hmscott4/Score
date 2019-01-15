CREATE TABLE [scom].[ObjectAvailabilityHistory] (
    [ID]                                   BIGINT           IDENTITY (1, 1) NOT NULL,
    [ManagedEntityID]                      UNIQUEIDENTIFIER NOT NULL,
    [FullName]                             NVARCHAR (2048)  NOT NULL,
    [DateTime]                             DATETIME2 (3)    NOT NULL,
    [IntervalDurationMilliseconds]         INT              NOT NULL,
    [InWhiteStateMilliseconds]             INT              NOT NULL,
    [InGreenStateMilliseconds]             INT              NOT NULL,
    [InYellowStateMilliseconds]            INT              NOT NULL,
    [InRedStateMilliseconds]               INT              NOT NULL,
    [InDisabledStateMilliseconds]          INT              NOT NULL,
    [InPlannedMaintenanceMilliseconds]     INT              NOT NULL,
    [InUnplannedMaintenanceMilliseconds]   INT              NOT NULL,
    [HealthServiceUnavailableMilliseconds] INT              NOT NULL,
    CONSTRAINT [PK_ObjectAvailabilityHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);

