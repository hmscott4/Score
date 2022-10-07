/****************************************************************
* Name: cm.spClusterResourceUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterResourceUpsert] 
	@objectGUID uniqueidentifier,
    @ClusterName nvarchar(255),
    @ResourceName nvarchar(255),
    @ResourceType nvarchar(255),
    @OwnerGroup nvarchar(255),
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

	MERGE [cm].[ClusterResource] AS target
	USING (SELECT @ResourceName, @ResourceType, @OwnerGroup, @OwnerNode, @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([ResourceName], [ResourceType], [OwnerGroup], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ClusterGUID] = @ClusterGUID AND [objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [ResourceName] = @ResourceName, [ResourceType] = @ResourceType, [OwnerGroup] = @OwnerGroup, [OwnerNode] = @OwnerNode, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [ClusterGUID], [ResourceName], [ResourceType], [OwnerGroup], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @ClusterGUID, @ResourceName, @ResourceType, @OwnerGroup, @OwnerNode, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterGUID], [ResourceName], [ResourceType], [OwnerGroup], [OwnerNode], [State], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ClusterResource]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT