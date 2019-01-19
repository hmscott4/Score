/****************************************************************
* Name: dbo.spComputerSelectByAgentName
* Author: huscott
* Date: 2015-03-09
*
* Description:
*
****************************************************************/
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
