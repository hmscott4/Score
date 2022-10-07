
/****************************************************************
* Name: ad.spClusterNamedObjectUpsert
* Author: huscott
* Date: 2019-06-20
*
* Description:
* Insert entries into ad.ClusterNamedObject table
* Join to ad.Computer table to determine which objects are Cluster 
* Named Objects (Virtual Computer Accounts)
*
****************************************************************/
CREATE PROC [ad].[spClusterNamedObjectUpsert]
(@ObjectGUID uniqueidentifier,
 @Domain nvarchar(128),
 @DNSHostName nvarchar(255),
 @Comment nvarchar(1024),
 @dbLastUpdate datetime2(3)
 )

 AS

 SET NOCOUNT ON
 SET XACT_ABORT ON

 IF EXISTS (SELECT DNSHostName FROM ad.ClusterNamedObject WHERE ([DNSHostName] = @DNSHostName))
BEGIN
	UPDATE ad.ClusterNamedObject
	SET dbLastUpdate = @dbLastUpdate
	WHERE Domain = @Domain 
		AND DNSHostName = @DNSHostName
END

ELSE

BEGIN
	INSERT INTO ad.ClusterNamedObject (ObjectGUID, Domain, DNSHostName, Comment, dbAddDate, dbLastUpdate)
	VALUES (@ObjectGUID, @Domain, @DNSHostName, @Comment, @dbLastUpdate, @dbLastUpdate)
END