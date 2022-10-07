/****************************************************************
* Name: cm.spComputerGroupMemberUpsert
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerGroupMemberUpsert] 
    @dnsHostName nvarchar(255),
    @GroupName nvarchar(128),
    @MemberName nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ComputerGUID uniqueidentifier
	SELECT @ComputerGUID = [objectGUID] 
	FROM [cm].[Computer]
	WHERE [dnsHostName] = @dnsHostName

	MERGE [cm].[ComputerGroupMember] AS target
	USING (SELECT @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerGUID] = @ComputerGUID AND [GroupName] = @GroupName AND [MemberName] = @MemberName)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerGUID], [GroupName], [MemberName], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerGUID, @GroupName, @MemberName, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [GroupName], [MemberName], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerGroupMember]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT