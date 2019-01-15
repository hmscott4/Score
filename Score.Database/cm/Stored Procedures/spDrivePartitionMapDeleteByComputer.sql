/****************************************************************
* Name: cm.spDrivePartitionMapDeleteByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDrivePartitionMapDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	DELETE
	FROM   [cm].[DrivePartitionMap]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
