﻿CREATE TABLE [scom].[AlertAgingBuckets] (
    [AgeID]        INT            IDENTITY (1, 1) NOT NULL,
    [LowValue]     INT            NOT NULL,
    [HighValue]    INT            NOT NULL,
    [Label]        NVARCHAR (128) NOT NULL,
    [SortOrder]    INT            NOT NULL,
    [Active]       BIT            NOT NULL,
    [dbAddDate]    DATETIME2 (3)  NOT NULL,
    [dbLastUpdate] DATETIME2 (3)  NOT NULL
);

