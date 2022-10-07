/****************************************************************
* Name: ad.spDomainUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spDomainUpsert] 
    @objectGUID uniqueidentifier,
    @SID nvarchar(128),
    @Forest nvarchar(128),
    @Name nvarchar(128),
    @DNSRoot nvarchar(128),
    @NetBIOSName nvarchar(128),
    @DistinguishedName nvarchar(255),
    @InfrastructureMaster nvarchar(128),
    @PDCEmulator nvarchar(128),
    @RIDMaster nvarchar(128),
    @DomainFunctionality nvarchar(128) = NULL,
    @ForestFunctionality nvarchar(128) = NULL,
    @UserName nvarchar(128) = NULL,
    @Password varbinary(256) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [ad].[Domain] AS target
	USING (SELECT @SID, @Forest, @Name, @DNSRoot, @NetBIOSName, @DistinguishedName, @InfrastructureMaster, @PDCEmulator, @RIDMaster, @DomainFunctionality, @ForestFunctionality, @UserName, @Password, @dbLastUpdate, @Active, @dbLastUpdate) 
		AS source 
		([SID], [Forest], [Name], [DNSRoot], [NetBIOSName], [DistinguishedName], [InfrastructureMaster], [PDCEmulator], [RIDMaster], [DomainFunctionality], [ForestFunctionality], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([objectGUID] = @objectGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [objectGUID] = @objectGUID, [SID] = @SID, [Forest] = @Forest, [Name] = @Name, [DNSRoot] = @DNSRoot, [NetBIOSName] = @NetBIOSName, [DistinguishedName] = @DistinguishedName, [InfrastructureMaster] = @InfrastructureMaster, [PDCEmulator] = @PDCEmulator, [RIDMaster] = @RIDMaster, [DomainFunctionality] = @DomainFunctionality, [ForestFunctionality] = @ForestFunctionality, [UserName] = @UserName, [Password] = @Password, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([objectGUID], [SID], [Forest], [Name], [DNSRoot], [NetBIOSName], [DistinguishedName], [InfrastructureMaster], [PDCEmulator], [RIDMaster], [DomainFunctionality], [ForestFunctionality], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@objectGUID, @SID, @Forest, @Name, @DNSRoot, @NetBIOSName, @DistinguishedName, @InfrastructureMaster, @PDCEmulator, @RIDMaster, @DomainFunctionality, @ForestFunctionality, @UserName, @Password, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [SID], [Forest], [Name], [DNSRoot], [NetBIOSName], [DistinguishedName], [InfrastructureMaster], [PDCEmulator], [RIDMaster], [DomainFunctionality], [ForestFunctionality], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[Domain]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT