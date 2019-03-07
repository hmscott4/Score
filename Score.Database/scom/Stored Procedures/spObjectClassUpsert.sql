/****************************************************************
* Name: scom.spObjectClassUpsert
* Author: huscott
* Date: 2019-03-05
*
* Description:
*
****************************************************************/
CREATE PROC scom.spObjectClassUpsert
(
	@ID nvarchar(255)
	,@Name nvarchar(255)
	,@DisplayName nvarchar(255)
	,@GenericName nvarchar(255)
	,@ManagementPackName nvarchar(255)
	,@Description nvarchar(1024)
	,@DistributedApplication bit
	,@Active bit
	,@dbLastUpdate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS (SELECT Name FROM scom.[ObjectClass] WHERE (Name = @Name AND [ID] != @ID))
BEGIN
	DELETE 
	FROM scom.[ObjectClass]
	WHERE [Name] = @Name
END

IF EXISTS (SELECT ID FROM scom.[ObjectClass] WHERE ([ID] = @ID))
BEGIN

	UPDATE [scom].[ObjectClass]
	   SET [Name] = @Name
		  ,[DisplayName] = @DisplayName
		  ,[GenericName] = @GenericName
		  ,[ManagementPackName] = @ManagementPackName
		  ,[Description] = @Description
		  ,[DistributedApplication] = @DistributedApplication
		  ,[Active] = @Active
		  ,[dbLastUpdate] = @dbLastUpdate
	 WHERE 
		[ID] = @ID
END

ELSE

BEGIN

	INSERT INTO [scom].[ObjectClass]
			   ([ID]
			   ,[Name]
			   ,[DisplayName]
			   ,[GenericName]
			   ,[ManagementPackName]
			   ,[Description]
			   ,[DistributedApplication]
			   ,[Active]
			   ,[dbAddDate]
			   ,[dbLastUpdate])
		 VALUES
			   (@ID
			   ,@Name
			   ,@DisplayName
			   ,@GenericName
			   ,@ManagementPackName
			   ,@Description
			   ,@DistributedApplication
			   ,@Active
			   ,@dbLastUpdate
			   ,@dbLastUpdate)
END