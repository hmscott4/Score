/****** Object:  StoredProcedure [cm].[spComputerGroupMemberSelectByComputer]    Script Date: 1/16/2019 8:32:48 AM ******/
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
GO