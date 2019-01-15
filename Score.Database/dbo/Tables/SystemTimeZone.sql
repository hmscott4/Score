CREATE TABLE [dbo].[SystemTimeZone] (
    [ZoneID]                     UNIQUEIDENTIFIER CONSTRAINT [DF_SystemTimeZone_ZoneID] DEFAULT (newid()) NOT NULL,
    [ID]                         NVARCHAR (255)   NOT NULL,
    [DisplayName]                NVARCHAR (255)   NOT NULL,
    [StandardName]               NVARCHAR (255)   NOT NULL,
    [DaylightName]               NVARCHAR (255)   NOT NULL,
    [BaseUTCOffset]              INT              NOT NULL,
    [CurrentUTCOffset]           INT              NOT NULL,
    [SupportsDaylightSavingTime] BIT              NOT NULL,
    [DefaultTimeZone]            BIT              NOT NULL,
    [Display]                    BIT              NOT NULL,
    [Active]                     BIT              NOT NULL,
    [dbAddDate]                  DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]               DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_SystemTimeZone] PRIMARY KEY CLUSTERED ([ZoneID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_SystemTimeZones_ID]
    ON [dbo].[SystemTimeZone]([ID] ASC);

