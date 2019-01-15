/****************************************************************
* Name: cm.spNetworkAdapterInactivateByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterInactivateByComputer] 
    @dnsHostName nvarchar(255),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[NetworkAdapter]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([computerGUID] = @ComputerGUID) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [Index], [Name], [NetConnectionID], [AdapterType], [Manufacturer], [MACAddress], [PhysicalAdapter], [Speed], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[NetworkAdapter]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
