/****************************************************************
* Name: cm.spApplicationInstallationDeleteByComputer
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spApplicationInstallationDeleteByComputer] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [cm].[ApplicationInstallation]
	WHERE  [objectGUID] = @objectGUID

	COMMIT
