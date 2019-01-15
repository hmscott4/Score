/****************************************************************
* Name: cm.spDatabasePropertyUpsert
* Author: huscott
* Date: 2015-03-03
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDatabasePropertyUpsert] 
    @DatabaseGUID uniqueidentifier,
    @PropertyName nvarchar(128),
    @PropertyValue nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[DatabaseProperty] AS target
	USING (SELECT @PropertyValue, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([PropertyValue], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([DatabaseGUID]=@DatabaseGUID AND [PropertyName]=@PropertyName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [PropertyValue] = @PropertyValue, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([DatabaseGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@DatabaseGUID, @PropertyName, @PropertyValue, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [DatabaseGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DatabaseProperty]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
