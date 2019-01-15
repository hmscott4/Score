CREATE PROC [cm].[spClusterSelectByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [ClusterName], [OperatingSystem], [OperatingSystemVersion], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[Cluster] 
	WHERE  ([ClusterName] = @ClusterName) 

	COMMIT
