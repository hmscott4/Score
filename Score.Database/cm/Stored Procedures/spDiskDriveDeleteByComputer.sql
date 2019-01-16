/****** Object:  StoredProcedure [cm].[spDiskDriveDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spDiskDriveDelete
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spDiskDriveDeleteByComputer] 
    @dnsHostName nvarchar(255) 
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	DELETE
	FROM   [cm].[DiskDrive]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
GO
