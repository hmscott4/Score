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
