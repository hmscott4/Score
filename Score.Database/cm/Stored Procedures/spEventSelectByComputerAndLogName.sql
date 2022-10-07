/****** Object:  StoredProcedure [cm].[spEventSelectByComputerAndLogName]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spEventSelectByComputerAndLogName] 
    @dnsHostName nvarchar(255),
	@LogName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [ID], [ComputerGUID], [LogName], [MachineName], [EventId], [Source], [TimeGenerated], [EntryType], [Message], [UserName], [dbAddDate] 
	FROM   [cm].[Event] 
	WHERE  [ComputerGUID] = @ComputerGUID AND [LogName] = @LogName

	COMMIT