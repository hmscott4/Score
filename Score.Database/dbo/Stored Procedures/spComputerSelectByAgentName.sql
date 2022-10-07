CREATE PROC [dbo].[spComputerSelectByAgentName]
	@AgentName nvarchar(128) = NULL,
	@Active bit = 1

AS

SELECT [dnsHostName]
  FROM [dbo].[Computer]
 WHERE ([AgentName] = @AgentName OR @AgentName is NULL)
       AND [Active] >= @Active