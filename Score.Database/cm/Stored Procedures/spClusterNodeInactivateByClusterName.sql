/****************************************************************
* Name: cm.spClusterNodeInactivateByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterNodeInactivateByClusterName] 
    @ClusterName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName
	
	UPDATE [cm].[ClusterNode]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ClusterGUID] = @ClusterGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterGUID], [ComputerGUID], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ClusterNode]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT