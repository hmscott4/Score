/****** Object:  StoredProcedure [cm].[spEventInsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spEventInsert
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spEventInsert] 
    @ComputerGUID uniqueidentifier,
	@LogName nvarchar(255),
    @MachineName nvarchar(255),
    @EventId int,
    @Source nvarchar(255),
    @TimeGenerated datetime2(3),
    @EntryType nvarchar(128),
    @Message nvarchar(max),
    @UserName nvarchar(255) = NULL,
    @dbAddDate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	INSERT INTO [cm].[Event] ([ComputerGUID], [LogName], [MachineName], [EventId], [Source], [TimeGenerated], [EntryType], [Message], [UserName], [dbAddDate])
	VALUES (@ComputerGUID, @LogName, @MachineName, @EventId, @Source, @TimeGenerated, @EntryType, @Message, @UserName, @dbAddDate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [ComputerGUID], [LogName], [MachineName], [EventId], [Source], [TimeGenerated], [EntryType], [Message], [UserName], [dbAddDate]
	FROM   [cm].[Event]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT