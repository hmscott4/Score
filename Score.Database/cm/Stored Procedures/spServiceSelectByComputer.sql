CREATE PROC [cm].[spServiceSelectByComputer] 
    @dnsHostName nvarchar(255),
	@Active bit = 1
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer] 
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [Name], [DisplayName], [Description], [Status], [State], [StartMode], [StartName], [PathName], [AcceptStop], [AcceptPause], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Service] 
	WHERE  ([ComputerGUID] = @ComputerGUID AND [Active] >= @Active) 

	COMMIT
