/****************************************************************
* Name: cm.spClusterInactivateByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterInactivateByClusterName] 
    @ClusterName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [cm].[Cluster]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ClusterName] = @ClusterName)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterName], [OperatingSystem], [OperatingSystemVersion], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[Cluster]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT