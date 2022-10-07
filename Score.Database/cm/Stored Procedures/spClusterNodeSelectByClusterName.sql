/****************************************************************
* Name: cm.spClusterNodeSelectByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterNodeSelectByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	SELECT [objectGUID], [ClusterGUID], [ComputerGUID], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ClusterNode] 
	WHERE  ([ClusterGUID] = @ClusterGUID) 

	COMMIT