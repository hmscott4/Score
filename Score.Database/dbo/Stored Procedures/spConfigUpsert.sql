/****************************************************************
* Name: dbo.spConfigUpsert
* Author: huscott
* Date: 2015-03-11
*
* Description:
*
****************************************************************/
CREATE PROC [dbo].[spConfigUpsert] 
    @ConfigName nvarchar(255),
    @ConfigValue nvarchar(255),
    @dbModDate datetime2(3),
    @dbModBy nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [dbo].[Config] AS target
	USING (SELECT @ConfigValue, @dbModDate, @dbModBy, @dbModDate, @dbModBy) 
		AS source 
		([ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy])
	-- !!!! Check the criteria for match
	ON ([ConfigName] = @ConfigName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [ConfigValue] = @ConfigValue, [dbModDate] = @dbModDate, [dbModBy] = @dbModBy
	WHEN NOT MATCHED THEN
		INSERT ([ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy])
		VALUES (@ConfigName, @ConfigValue, @dbModDate, @dbModBy, @dbModDate, @dbModBy)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy]
	FROM   [dbo].[Config]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
