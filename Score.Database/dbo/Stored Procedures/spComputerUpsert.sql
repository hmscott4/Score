/****** Object:  StoredProcedure [dbo].[spComputerUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: dbo.spComputerUpsert
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spComputerUpsert] 
	@Domain nvarchar(128),
    @dnsHostName nvarchar(255),
	@AgentName nvarchar(128),
    @CredentialName nvarchar(255) = NULL,
    @Active bit,
    @dbAddDate datetime2(3) = NULL,
    @dbLastUpdate datetime2(3) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [dbo].[Computer] AS target
	USING (SELECT @AgentName, @CredentialName, @Active, @dbAddDate, @dbLastUpdate) 
		AS source 
		([AgentName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Domain] = @Domain AND [dnsHostName] = @dnsHostName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [AgentName] = @AgentName, [CredentialName] = @CredentialName, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Domain], [dnsHostName], [AgentName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Domain, @dnsHostName, @AgentName, @CredentialName, @Active, @dbAddDate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [dnsHostName], [AgentName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [dbo].[Computer]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
GO
GRANT EXECUTE ON [dbo].[spComputerUpsert] TO [cmUpdate] AS [dbo]
GO
