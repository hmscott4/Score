/****** Object:  StoredProcedure [cm].[spComputerSharePermissionUpsert]    Script Date: 1/16/2019 8:32:48 AM ******/
/****************************************************************
* Name: cm.spComputerSharePermissionUpsert
* Author: huscott
* Date: 2015-03-18
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spComputerSharePermissionUpsert] 
    @dnsHostName nvarchar(255),
	@ShareName nvarchar(255),
    @SecurityPrincipal nvarchar(128),
    @FileSystemRights nvarchar(128),
    @AccessControlType nvarchar(128),
    @IsInherited bit,
    @InheritanceFlags nvarchar(128),
    @PropagationFlags nvarchar(128),
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

	DECLARE @ComputerShareGUID uniqueidentifier
	SELECT @ComputerShareGUID = [objectGUID]
	FROM [cm].[ComputerShare]
	WHERE [ComputerGUID] = @ComputerGUID AND [Name] = @ShareName

	MERGE [cm].[ComputerSharePermission] AS target
	USING (SELECT @FileSystemRights, @IsInherited, @InheritanceFlags, @PropagationFlags, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([FileSystemRights], [IsInherited], [InheritanceFlags], [PropagationFlags], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ComputerShareGUID] = @ComputerShareGUID AND [SecurityPrincipal] = @SecurityPrincipal AND [AccessControlType] = @AccessControlType)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [FileSystemRights] = @FileSystemRights, [IsInherited] = @IsInherited, [InheritanceFlags] = @InheritanceFlags, [PropagationFlags] = @PropagationFlags, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ComputerShareGUID], [SecurityPrincipal], [FileSystemRights], [AccessControlType], [IsInherited], [InheritanceFlags], [PropagationFlags], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ComputerShareGUID, @SecurityPrincipal, @FileSystemRights, @AccessControlType, @IsInherited, @InheritanceFlags, @PropagationFlags, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerShareGUID], [SecurityPrincipal], [FileSystemRights], [AccessControlType], [IsInherited], [InheritanceFlags], [PropagationFlags], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ComputerSharePermission]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT