/****************************************************************
* Name: cm.spComputerGroupMemberInactivateByComputer
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerGroupMemberInactivateByComputer] 
    @dnsHostName nvarchar(255),
	@GroupName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID] 
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName
	
	UPDATE [cm].[ComputerGroupMember]
	SET [Active] = 0, dbLastUpdate = GETUTCDATE()
	WHERE  ([ComputerGUID] = @ComputerGUID AND [GroupName] = @GroupName) 
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [GroupName], [MemberName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerGroupMember]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT
