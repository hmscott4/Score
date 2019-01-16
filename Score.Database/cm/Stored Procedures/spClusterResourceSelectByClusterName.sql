/****** Object:  StoredProcedure [cm].[spClusterResourceSelectByClusterName]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spClusterResourceSelectByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	SELECT [objectGUID], [ClusterGUID], [ResourceName], [ResourceType], [OwnerGroup], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ClusterResource] 
	WHERE  ([ClusterGUID] = @ClusterGUID) 

	COMMIT
GO