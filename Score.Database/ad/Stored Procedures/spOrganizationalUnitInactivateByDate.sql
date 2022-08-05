
/****************************************************************
* Name: ad.spOrganizationalUnitInactivateByDate
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spOrganizationalUnitInactivateByDate] 
	@Domain nvarchar(128),
    @BeforeDate datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[OrganizationalUnit]
	SET [Active] = 0--, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain AND [dbLastUpdate] < DateAdd(Minute, -15, @BeforeDate)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT