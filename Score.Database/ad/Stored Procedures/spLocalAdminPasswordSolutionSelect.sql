
CREATE PROC [ad].[spLocalAdminPasswordSolutionSelect] (
	@DNSHostName nvarchar(255) = NULL
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

OPEN SYMMETRIC KEY score_key
	DECRYPTION BY CERTIFICATE score_encrypt

SELECT 
	[laps].[objectGUID]
	, [c].[DNSHostName]
	, [c].[LastLogon]
	, [c].[OperatingSystem]
	, CONVERT(nvarchar,DecryptByKey([laps].[AdmPassword])) AS [AdmPassword]
	, [laps].[AdmPwdExpiration]

FROM
	[ad].[Computer] as [c] LEFT OUTER JOIN [ad].[LocalAdminPasswordSolution] as [laps]
		ON [laps].[objectGUID] = [c].[objectGUID]
WHERE
	(
		[c].[DNSHostName] = @DNSHostName
		OR
		@DNSHostNAme IS NULL
	)