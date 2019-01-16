/****** Object:  StoredProcedure [cm].[spApplicationInstallationSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spApplicationInstallationSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID]
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [ApplicationGUID], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ApplicationInstallation] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
GO
