/****************************************************************
* Name: cm.spApplicationUpsert
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationUpsert] 
    @Name nvarchar(255),
    @Version nvarchar(128) = NULL,
    @Vendor nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Application] AS target
	USING (SELECT @Vendor, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Vendor], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Name] = @Name and [Version] = @Version)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Vendor] = @Vendor, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Name], [Version], [Vendor], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Name, @Version, @Vendor, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Name], [Version], [Vendor], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Application]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
