/****** Object:  StoredProcedure [cm].[spClusterResourceDeleteByClusterName]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spClusterResourceDeleteByClusterName
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterResourceDeleteByClusterName] 
    @ClusterName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	DELETE
	FROM   [cm].[ClusterResource]
	WHERE ([ClusterGUID] = @ClusterGUID)

	COMMIT
GO
