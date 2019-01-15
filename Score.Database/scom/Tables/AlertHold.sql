CREATE TABLE [scom].[AlertHold] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [Name]            NVARCHAR (255)   NOT NULL,
    [ResolutionState] TINYINT          NOT NULL,
    [Priority]        VARCHAR (255)    NOT NULL,
    [Severity]        VARCHAR (255)    NOT NULL,
    [TimeRaised]      DATETIME2 (3)    NOT NULL,
    [TimeAdded]       DATETIME2 (3)    NOT NULL,
    [LastModified]    DATETIME2 (3)    NOT NULL,
    [LastModifiedBy]  VARCHAR (255)    NOT NULL,
    [TimeResolved]    DATETIME2 (3)    NULL,
    [Active]          BIT              NOT NULL,
    [dbAddDate]       DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]    DATETIME2 (3)    NOT NULL,
    [IncidentGroupID] INT              NULL
);

