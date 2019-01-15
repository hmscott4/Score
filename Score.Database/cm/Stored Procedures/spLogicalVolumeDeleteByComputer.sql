/****************************************************************
* Name: cm.spLogicalVolumeDeleteByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spLogicalVolumeDeleteByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @computerGUID uniqueidentifier
	SELECT @computerGUID = objectGUID from [cm].[Computer] 
	WHERE dnsHostName = @dnsHostName

	DELETE
	FROM   [cm].[LogicalVolume]
	WHERE  [ComputerGUID] = @ComputerGUID

	COMMIT
