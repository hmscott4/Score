/****** Object:  StoredProcedure [cm].[spLogicalVolumeInactivateByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spLogicalVolumeInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLogicalVolumeInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	UPDATE [cm].[LogicalVolume]
	SET Active = 0, dbLastUpdate = @dbLastUpdate
	WHERE ComputerGUID = @computerGUID
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Name], [DriveLetter], [Label], [FileSystem], [BlockSize], [Capacity], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[LogicalVolume]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT