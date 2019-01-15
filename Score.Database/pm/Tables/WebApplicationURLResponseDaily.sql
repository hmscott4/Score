CREATE TABLE [pm].[WebApplicationURLResponseDaily] (
    [ID]                    INT              IDENTITY (1, 1) NOT NULL,
    [Date]                  DATE             NOT NULL,
    [WebApplicationURLGUID] UNIQUEIDENTIFIER NOT NULL,
    [FailedCheckCount]      INT              NOT NULL,
    [SuccessCheckCount]     INT              NOT NULL,
    [AvgResponseTime]       DECIMAL (18, 3)  NOT NULL,
    [MinResponseTime]       INT              NOT NULL,
    [MaxResponseTime]       INT              NOT NULL,
    [StDevResponseTime]     DECIMAL (18, 3)  NOT NULL,
    [Count]                 INT              NOT NULL,
    [dbAddDate]             DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_WebApplicationResponseDaily] PRIMARY KEY CLUSTERED ([ID] ASC)
);

