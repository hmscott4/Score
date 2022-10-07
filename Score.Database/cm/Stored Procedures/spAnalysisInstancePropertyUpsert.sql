/****************************************************************
* Name: cm.spAnalysisInstancePropertyUpsert
* Author: huscott
* Date: 2015-03-16
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstancePropertyUpsert] 
    @AnalysisInstanceGUID uniqueidentifier,
	@Name nvarchar(128),
    @PropertyName nvarchar(128),
	@Category nvarchar(128),
    @PropertyValue nvarchar(128),
	@Type nvarchar(32),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[AnalysisInstanceProperty] AS target
	USING (SELECT @PropertyName, @Category, @PropertyValue, @Type, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([PropertyName], [Category], [PropertyValue], [Type], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([AnalysisInstanceGUID] = @AnalysisInstanceGUID AND [Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [PropertyName] = @PropertyName, [Category] = @Category, [PropertyValue] = @PropertyValue, [Type] = @Type, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([AnalysisInstanceGUID], [Name], [PropertyName], [Category], [PropertyValue], [Type], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@AnalysisInstanceGUID, @Name, @PropertyName, @Category, @PropertyValue, @Type, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [AnalysisInstanceGUID], [Name], [PropertyName], [Category], [PropertyValue], [Type], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisInstanceProperty]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT