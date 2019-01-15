CREATE VIEW [cm].[WindowsUpdateInstallationView]

AS

SELECT
	[wu].objectGUID
	,[c].[objectGUID] as [ComputerGUID]
	,[c].[dnsHostName]
	,[wu].[HotfixID]
	,[wu].[Description]
	,[wu].[Caption]
	,[wu].[FixComments]
	,[wui].[InstallDate]
	,[wui].[InstallBy]
	,[wui].[Active]
	,[wui].[dbAddDate]
	,[wui].[dbLastUpdate]
FROM [cm].[WindowsUpdateInstallation] wui INNER JOIN [cm].[WindowsUpdate] wu ON
		[wui].[WindowsUpdateGUID] = [wu].[objectGUID]
	INNER JOIN [cm].[Computer] c ON
		[c].[objectGUID] = [wui].[ComputerGUID]
