/****** Object:  StoredProcedure [cm].[spNetworkAdapterConfigurationDelete]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spNetworkAdapterConfigurationDelete
* Author: huscott
* Date: 2015-02-27
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spNetworkAdapterConfigurationDelete] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	DELETE
	FROM   [cm].[NetworkAdapterConfiguration]
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT