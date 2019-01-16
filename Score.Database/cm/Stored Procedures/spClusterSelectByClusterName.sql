/****** Object:  StoredProcedure [cm].[spClusterSelectByClusterName]    Script Date: 1/16/2019 8:32:48 AM ******/
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
GO
