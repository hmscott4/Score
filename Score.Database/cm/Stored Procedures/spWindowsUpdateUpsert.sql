/****************************************************************
* Name: cm.spWindowsUpdateUpsert
* Author: huscott
* Date: 2015-03-13
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spWindowsUpdateUpsert] 
    @HotfixID nvarchar(128),
    @Description nvarchar(128),
    @Caption nvarchar(128) = NULL,
    @FixComments nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[WindowsUpdate] AS target
	USING (SELECT @Description, @Caption, @FixComments, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([HotfixID] = @HotfixID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Description] = @Description, [Caption] = @Caption, [FixComments] = @FixComments, [Active] = @Active, [dbAddDate] = @dbLastUpdate, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([HotfixID], [Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@HotfixID, @Description, @Caption, @FixComments, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [HotfixID], [Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[WindowsUpdate]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT