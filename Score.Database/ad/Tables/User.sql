﻿/****** Object:  Table [ad].[User]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE TABLE [ad].[User] (
    [objectGUID]                 UNIQUEIDENTIFIER NOT NULL,
    [SID]                        NVARCHAR (255)   NOT NULL,
    [Domain]                     NVARCHAR (128)   NOT NULL,
    [Name]                       NVARCHAR (255)   NOT NULL,
    [FirstName]                  NVARCHAR (50)    NULL,
    [LastName]                   NVARCHAR (50)    NULL,
    [DisplayName]                NVARCHAR (100)   NULL,
    [Description]                NVARCHAR (255)   NULL,
    [JobTitle]                   NVARCHAR (255)   NULL,
    [EmployeeNumber]             NVARCHAR (255)   NULL,
    [ProfilePath]                NVARCHAR (1024)  NULL,
    [HomeDirectory]              NVARCHAR (1024)  NULL,
    [Company]                    NVARCHAR (255)   NULL,
    [Office]                     NVARCHAR (255)   NULL,
    [Department]                 NVARCHAR (255)   NULL,
    [Division]                   NVARCHAR (255)   NULL,
    [StreetAddress]              NVARCHAR (255)   NULL,
    [City]                       NVARCHAR (255)   NULL,
    [State]                      NVARCHAR (255)   NULL,
    [PostalCode]                 NVARCHAR (255)   NULL,
    [Manager]                    NVARCHAR (255)   NULL,
    [MobilePhone]                NVARCHAR (20)    NULL,
    [PhoneNumber]                NVARCHAR (20)    NULL,
    [Fax]                        NVARCHAR (20)    NULL,
    [Pager]                      NVARCHAR (20)    NULL,
    [EMail]                      NVARCHAR (255)   NULL,
    [LockedOut]                  BIT              NULL,
    [PasswordExpired]            BIT              NULL,
    [PasswordLastSet]            DATETIME2 (3)    NULL,
    [PasswordNeverExpires]       BIT              NULL,
    [PasswordNotRequired]        BIT              NULL,
    [TrustedForDelegation]       BIT              NULL,
    [TrustedToAuthForDelegation] BIT              NULL,
    [UserAccountControl]         INT              NULL,
    [SupportedEncryptionTypes]   INT              NULL,
    [DistinguishedName]          NVARCHAR (255)   NOT NULL,
    [Enabled]                    BIT              NOT NULL,
    [Active]                     BIT              NOT NULL,
    [LastLogon]                  DATETIME2 (3)    NULL,
    [whenCreated]                DATETIME2 (3)    NOT NULL,
    [whenChanged]                DATETIME2 (3)    NOT NULL,
    [dbAddDate]                  DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]               DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_ad_User] PRIMARY KEY CLUSTERED ([objectGUID] ASC) WITH (FILLFACTOR = 90)
);


GO

/****** Object:  Index [IX_ad_User_Unique]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_User_Unique] ON [ad].[User]
(
	[Domain] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
