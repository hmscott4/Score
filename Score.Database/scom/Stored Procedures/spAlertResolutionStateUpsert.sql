
CREATE PROCEDURE [scom].[spAlertResolutionStateUpsert] (
	@ResolutionStateID uniqueidentifier,
	@ResolutionState tinyint,
	@Name nvarchar(255),
	@IsSystem bit,
	@ManagementGroup nvarchar(255),
	@Active bit,
	@dbLastUpdate datetime2(3)
)

AS

SET NOCOUNT ON 
SET XACT_ABORT ON  

IF EXISTS (SELECT Name FROM scom.AlertResolutionState WHERE ResolutionState = @ResolutionState AND ResolutionStateID != @ResolutionStateID)
BEGIN
	DELETE 
	FROM scom.AlertResolutionState 
	WHERE ResolutionStateID = @ResolutionStateID
END

BEGIN TRAN

MERGE [scom].[AlertResolutionState] AS [target]
USING 
           (SELECT @ResolutionStateID
           ,@ResolutionState
           ,@Name
           ,@IsSystem
           ,@ManagementGroup
           ,@Active
           ,@dbLastUpdate) AS [source]

           ([ResolutionStateID]
           ,[ResolutionState]
           ,[Name]
           ,[IsSystem]
           ,[ManagementGroup]
           ,[Active]
           ,[dbLastUpdate])

	ON ( [target].[ResolutionStateID] = @ResolutionStateID)

	WHEN MATCHED THEN

		UPDATE 
		   SET [ResolutionStateID] = @ResolutionStateID
			  ,[ResolutionState] = @ResolutionState
			  ,[Name] = @Name
			  ,[IsSystem] = @IsSystem
			  ,[ManagementGroup] = @ManagementGroup
			  ,[Active] = @Active
			  ,[dbLastUpdate] = @dbLastUpdate

	WHEN NOT MATCHED THEN

INSERT 
           ([ResolutionStateID]
           ,[ResolutionState]
           ,[Name]
           ,[IsSystem]
           ,[ManagementGroup]
           ,[Active]
		   ,[dbAddDate]
           ,[dbLastUpdate])
     VALUES
           (@ResolutionStateID
           ,@ResolutionState
           ,@Name
           ,@IsSystem
           ,@ManagementGroup
           ,@Active
		   ,@dbLastUpdate
           ,@dbLastUpdate)

	;
COMMIT