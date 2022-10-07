/****** Object:  StoredProcedure [cm].[spWebApplicationUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spWebApplicationUpsert
* Author: huscott
* Date: 2015-03-17
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWebApplicationUpsert] 
    @Name nvarchar(255),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[WebApplication] AS target
	USING (SELECT @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Name] = @Name)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Active] = @Active, [dbAddDate] = @dbLastUpdate, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Name], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Name, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [Name], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WebApplication]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT