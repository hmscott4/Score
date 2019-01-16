/****** Object:  StoredProcedure [cm].[spApplicationInstallationDeleteByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
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
GO