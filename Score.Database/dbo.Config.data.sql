/* Initialize dbo.Config
* Hugh Scott
* 2019/01.17
*/
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'ProcessLogRetainDays', N'90', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'SyncHistoryRetainDays', N'90', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'EventLogRetainDays', N'7', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'DatabaseSizeDailyRetainDays', N'1825', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'DatabaseSizeRawRetainDays', N'30', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'LogicalVolumeSizeDailyRetainDays', N'1825', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'LogicalVolumeSizeRawRetainDays', N'30', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'WebApplicationResponseDailyRetainDays', N'365', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'WebApplicationResponseRawRetainDays', N'30', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'ConfigurationHistoryRetainDays', N'21', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'StoreConfigurationHistory', N'1', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'DefaultTimeZoneDisplayName', N'(UTC-05:00) Eastern Time (US & Canada)', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'OrganizationDisplayName', N'ABCD Corporation', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())
INSERT INTO [dbo].[Config] ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]) VALUES (N'DefaultTimeZoneCurrentOffset', N'-300', GetDate(), SUSER_SNAME(), GetDate(), SUSER_SNAME())

