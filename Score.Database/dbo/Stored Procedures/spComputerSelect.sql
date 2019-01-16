/****** Object:  StoredProcedure [dbo].[spComputerSelect]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [dbo].[spComputerSelect] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Domain], [dnsHostName], [AgentName], [CredentialName], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [dbo].[Computer] 
	WHERE  ([dnsHostName] = @dnsHostName OR (@dnsHostName IS NULL AND [Active] >= @Active))

	COMMIT
GO
GRANT EXECUTE ON [dbo].[spComputerSelect] TO [cmRead] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[spComputerSelect] TO [cmUpdate] AS [dbo]
GO
