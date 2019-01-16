/****** Object:  StoredProcedure [cm].[spClusterDeleteByClusterName]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spClusterDeleteByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterDeleteByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[Cluster]
	WHERE  ([ClusterName] = @ClusterName)

	COMMIT
GO
