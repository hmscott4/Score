/****************************************************************
* Name: cm.spAnalysisInstanceInactivateByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spAnalysisInstanceInactivateByComputer]  
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
	
	UPDATE [cm].[AnalysisInstance]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  ([ComputerGUID] = @ComputerGUID)
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [IsClustered], [ActiveNode], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[AnalysisInstance]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT