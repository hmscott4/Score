/****************************************************************
* Name: cm.spJobUpsert
* Author: huscott
* Date: 2015-03-04
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spJobUpsert] 
    @JobID uniqueidentifier,
    @DatabaseInstanceGUID uniqueidentifier,
    @OriginatingServer nvarchar(255),
    @Name nvarchar(255),
    @IsEnabled bit,
    @Description nvarchar(2048),
    @Category nvarchar(255),
    @Owner nvarchar(255),
    @DateCreated datetime2(3) = NULL,
    @DateModified datetime2(3) = NULL,
    @VersionNumber int,
    @LastRunDate datetime2(3) = NULL,
    @NextRunDate datetime2(3) = NULL,
    @CurrentRunStatus nvarchar(128),
	@LastRunOutcome nvarchar(128),
	@HasSchedule bit ,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Job] AS target
	USING (SELECT @OriginatingServer, @Name, @IsEnabled, @Description, @Category, @Owner, @DateCreated, @DateModified, @VersionNumber, @LastRunDate, @NextRunDate, @CurrentRunStatus, @LastRunOutcome, @HasSchedule, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [LastRunOutcome], [HasSchedule], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([JobID] = @JobID)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [OriginatingServer] = @OriginatingServer, [Name] = @Name, [IsEnabled] = @IsEnabled, [Description] = @Description, [Category] = @Category, [Owner] = @Owner, [DateCreated] = @DateCreated, [DateModified] = @DateModified, [VersionNumber] = @VersionNumber, [LastRunDate] = @LastRunDate, [NextRunDate] = @NextRunDate, [CurrentRunStatus] = @CurrentRunStatus, [LastRunOutcome] = @LastRunOutcome, [HasSchedule] = @HasSchedule, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([JobID], [DatabaseInstanceGUID], [OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [LastRunOutcome], [HasSchedule], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@JobID, @DatabaseInstanceGUID, @OriginatingServer, @Name, @IsEnabled, @Description, @Category, @Owner, @DateCreated, @DateModified, @VersionNumber, @LastRunDate, @NextRunDate, @CurrentRunStatus, @LastRunOutcome, @HasSchedule, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [JobID], [DatabaseInstanceGUID], [OriginatingServer], [Name], [IsEnabled], [Description], [Category], [Owner], [DateCreated], [DateModified], [VersionNumber], [LastRunDate], [NextRunDate], [CurrentRunStatus], [LastRunOutCome], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Job]
	WHERE  [JobID] = @JobID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
