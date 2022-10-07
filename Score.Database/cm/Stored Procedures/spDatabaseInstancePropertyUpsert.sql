/****** Object:  StoredProcedure [cm].[spDatabaseInstancePropertyUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDatabaseInstancePropertyUpsert
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabaseInstancePropertyUpsert] 
    @DatabaseInstanceGUID uniqueidentifier,
    @PropertyName nvarchar(128),
    @PropertyValue nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseInstanceProperty] AS target
	USING (SELECT  @PropertyValue, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([PropertyValue], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseInstanceGUID] = @DatabaseInstanceGUID AND [PropertyName] = @PropertyName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [PropertyValue] = @PropertyValue, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseInstanceGUID, @PropertyName, @PropertyValue, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseInstanceGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseInstanceProperty]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT