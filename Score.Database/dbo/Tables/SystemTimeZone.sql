﻿CREATE TABLE [dbo].[SystemTimeZone] (
    [ZoneID]                     UNIQUEIDENTIFIER CONSTRAINT [DF_SystemTimeZone_ZoneID] DEFAULT (newid()) NOT NULL,
    [ID]                         NVARCHAR (255)   NOT NULL,
    [DisplayName]                NVARCHAR (255)   NOT NULL,
    [StandardName]               NVARCHAR (255)   NOT NULL,
    [DaylightName]               NVARCHAR (255)   NOT NULL,
    [BaseUTCOffset]              INT              NOT NULL,
    [CurrentUTCOffset]           INT              NOT NULL,
    [SupportsDaylightSavingTime] BIT              NOT NULL,
    [Display]                    BIT              NOT NULL,
    [DefaultTimeZone]            BIT              NOT NULL,
    [Active]                     BIT              NOT NULL,
    [dbAddDate]                  DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]               DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_SystemTimeZone] PRIMARY KEY CLUSTERED ([ZoneID] ASC) WITH (FILLFACTOR = 80)
);


GO

/****** Object:  Index [UX_SystemTimeZone_ID]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_SystemTimeZone_ID] ON [dbo].[SystemTimeZone]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO

GO

GO

GO