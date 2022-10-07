/****************************************************************
* Name: cm.spClusterUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterUpsert] 
    @ClusterName nvarchar(255),
    @OperatingSystem nvarchar(255) = NULL,
    @OperatingSystemVersion nvarchar(128) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[Cluster] AS target
	USING (SELECT @OperatingSystem, @OperatingSystemVersion, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([OperatingSystem], [OperatingSystemVersion], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ClusterName] = @ClusterName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [OperatingSystem] = @OperatingSystem, [OperatingSystemVersion] = @OperatingSystemVersion, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ClusterName], [OperatingSystem], [OperatingSystemVersion], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ClusterName, @OperatingSystem, @OperatingSystemVersion, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterName], [OperatingSystem], [OperatingSystemVersion], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Cluster]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT