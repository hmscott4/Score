CREATE PROC [cm].[spComputerGroupMemberSelectByComputer] 
    @dnsHostName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID] 
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	SELECT [objectGUID], [ComputerGUID], [GroupName], [MemberName], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[ComputerGroupMember] 
	WHERE  ([ComputerGUID] = @ComputerGUID) 

	COMMIT
