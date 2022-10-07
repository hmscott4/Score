/****** Object:  StoredProcedure [cm].[spDrivePartitionMapInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDrivePartitionMapInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDrivePartitionMapInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName
	
	UPDATE [cm].[DrivePartitionMap]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ComputerGUID] = @ComputerGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ObjectGUID], [ComputerGUID], [PartitionName], [DriveName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[DrivePartitionMap]
	WHERE  [ObjectGUID] = @ObjectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT