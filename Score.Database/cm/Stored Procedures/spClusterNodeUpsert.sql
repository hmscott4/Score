/****************************************************************
* Name: cm.spClusterNodeUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spClusterNodeUpsert] 
    @ClusterName nvarchar(255),
    @NodeName nvarchar(255),
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

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @NodeName

	MERGE [cm].[ClusterNode] AS target
	USING (SELECT @State, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([State], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ClusterGUID] = @ClusterGUID AND [ComputerGUID] = @ComputerGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [ClusterGUID] = @ClusterGUID, [ComputerGUID] = @ComputerGUID, [State] = @State, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ClusterGUID], [ComputerGUID], [State], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ClusterGUID, @ComputerGUID, @State, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ClusterGUID], [ComputerGUID], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ClusterNode]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
