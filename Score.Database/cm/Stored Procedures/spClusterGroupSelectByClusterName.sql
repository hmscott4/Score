/****** Object:  StoredProcedure [cm].[spClusterGroupSelectByClusterName]    Script Date: 1/16/2019 8:32:48 AM ******/
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
GO