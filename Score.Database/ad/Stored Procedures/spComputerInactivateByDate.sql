
/****** Object:  StoredProcedure [ad].[spComputerInactivateByDate]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: ad.spComputerInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spComputerInactivateByDate] 
	@Domain nvarchar(128),
    @BeforeDate datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[Computer]
	SET [Active] = 0--, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain AND [dbLastUpdate] < @BeforeDate
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Domain], [Name], [DNSHostName], [IPv4Address], [Trusted], [OperatingSystem], [OperatingSystemVersion], [OperatingSystemServicePack], [Description], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Computer]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
GO
GRANT EXECUTE ON [ad].[spComputerInactivateByDate] TO [adUpdate] AS [dbo]
GO
