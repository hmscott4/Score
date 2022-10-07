/****************************************************************
* Name: cm.spClusterGroupSelectByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterGroupSelectByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	SELECT [objectGUID], [ClusterGUID], [GroupName], [Description], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ClusterGroup] 
	WHERE  ([ClusterGUID] = @ClusterGUID)

	COMMIT