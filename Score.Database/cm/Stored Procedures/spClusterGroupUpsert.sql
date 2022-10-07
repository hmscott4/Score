﻿/****************************************************************
* Name: cm.spClusterGroupUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterGroupUpsert] 
    @objectGUID uniqueidentifier,
    @ClusterName nvarchar(255),
    @GroupName nvarchar(255),
    @Description nvarchar(1024) = NULL,
    @OwnerNode nvarchar(255),
    @State nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ClusterGUID uniqueidentifier
	SELECT @ClusterGUID = [objectGUID]
	FROM [cm].[Cluster]
	WHERE [ClusterName] = @ClusterName

	MERGE [cm].[ClusterGroup] AS target
	USING (SELECT @GroupName, @Description, @OwnerNode, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([GroupName], [Description], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ClusterGUID] = @ClusterGUID AND [objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET   [GroupName] = @GroupName, [Description] = @Description, [OwnerNode] = @OwnerNode, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [ClusterGUID], [GroupName], [Description], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @ClusterGUID, @GroupName, @Description, @OwnerNode, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterGUID], [ClusterGroupGUID], [GroupName], [Description], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ClusterGroup]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT