/****** Object:  StoredProcedure [dbo].[spComputerSelectByAgentName]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [dbo].[spComputerSelectByAgentName]
	@AgentName nvarchar(128) = NULL,
	@Active bit = 1

AS

SELECT [dnsHostName]
  FROM [dbo].[Computer]
 WHERE ([AgentName] = @AgentName OR @AgentName is NULL)
       AND [Active] >= @Active
GO
GRANT EXECUTE ON [dbo].[spComputerSelectByAgentName] TO [cmRead] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[spComputerSelectByAgentName] TO [cmUpdate] AS [dbo]
GO
