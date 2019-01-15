
CREATE PROC [scom].[spWindowsComputerUpsert]
	@ID uniqueidentifier,
	@DNSHostName nvarchar(255),
	@IPAddress nvarchar(255),
	@ObjectSID nvarchar(255),
	@NetBIOSDomainName nvarchar(255),
	@DomainDNSName nvarchar(255),
	@OrganizationalUnit nvarchar(2048),
	@ForestDNSName nvarchar(255),
	@ActiveDirectorySite nvarchar(255),
	@IsVirtualMachine bit,
	@HealthState nvarchar(255),
	@StateLastModified datetime2(3),
	@IsAvailable bit,
	@AvailabilityLastModified datetime2(3),
	@InMaintenanceMode bit,
	@MaintenanceModeLastModified datetime2(3),
	@ManagementGroup nvarchar(255),
	@Active bit,
	@dbLastUpdate datetime2(3)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

IF EXISTS (SELECT DNSHostName FROM scom.WindowsComputer WHERE (DNSHostName = @DNSHostName AND [ID] != @ID))
BEGIN
	DELETE 
	FROM scom.WindowsComputer
	WHERE DNSHostName = @DNSHostName
END

BEGIN TRAN

	MERGE [scom].[WindowsComputer] as [target]
	USING (SELECT 	
		@ID ,
		@DNSHostName,
		@IPAddress,
		@ObjectSID,
		@NetBIOSDomainName,
		@DomainDNSName,
		@OrganizationalUnit,
		@ForestDNSName,
		@ActiveDirectorySite,
		@IsVirtualMachine,
		@HealthState,
		@StateLastModified,
		@IsAvailable ,
		@AvailabilityLastModified,
		@InMaintenanceMode ,
		@MaintenanceModeLastModified,
		@ManagementGroup,
		@Active ,
		@dbLastUpdate ,
		@dbLastUpdate ) as [Source]

		(ID,
		DNSHostName,
		IPAddress,
		ObjectSID,
		NetBIOSDomainName,
		DomainDNSName,
		OrganizationalUnit,
		ForestDNSName,
		ActiveDirectorySite,
		IsVirtualMachine,
		HealthState,
		StateLastModified,
		IsAvailable,
		AvailabilityLastModified,
		InMaintenanceMode,
		MaintenanceModeLastModified,
		ManagementGroup,
		Active,
		dbAddDate,
		dbLastUpdate) on ([target].ID = @ID)


	WHEN MATCHED 
	THEN UPDATE 
	   SET [ID] = @ID
		  ,[DNSHostName] = @DNSHostName
		  ,[IPAddress] = @IPAddress
		  ,[ObjectSID] = @ObjectSID
		  ,[NetBIOSDomainName] = @NetBIOSDomainName
		  ,[DomainDNSName] = @DomainDNSName
		  ,[OrganizationalUnit] = @OrganizationalUnit
		  ,[ForestDNSName] = @ForestDNSName
		  ,[ActiveDirectorySite] = @ActiveDirectorySite
		  ,[IsVirtualMachine] = @IsVirtualMachine
		  ,[HealthState] = @HealthState
		  ,[StateLastModified] = @StateLastModified
		  ,[IsAvailable] = @IsAvailable
		  ,[AvailabilityLastModified] = @AvailabilityLastModified
		  ,[InMaintenanceMode] = @InMaintenanceMode
		  ,[MaintenanceModeLastModified] = @MaintenanceModeLastModified
		  ,[ManagementGroup] = @ManagementGroup
		  ,[Active] = @Active
		  ,[dbLastUpdate] = @dbLastUpdate

	WHEN NOT MATCHED
	THEN INSERT (
			ID,
			DNSHostName,
			IPAddress,
			ObjectSID,
			NetBIOSDomainName,
			DomainDNSName,
			OrganizationalUnit,
			ForestDNSName,
			ActiveDirectorySite,
			IsVirtualMachine,
			HealthState,
			StateLastModified,
			IsAvailable,
			AvailabilityLastModified,
			InMaintenanceMode,
			MaintenanceModeLastModified,
			ManagementGroup,
			Active,
			dbAddDate,
			dbLastUpdate)
		VALUES (
			@ID ,
			@DNSHostName,
			@IPAddress,
			@ObjectSID,
			@NetBIOSDomainName,
			@DomainDNSName,
			@OrganizationalUnit,
			@ForestDNSName,
			@ActiveDirectorySite,
			@IsVirtualMachine,
			@HealthState,
			@StateLastModified,
			@IsAvailable ,
			@AvailabilityLastModified,
			@InMaintenanceMode ,
			@MaintenanceModeLastModified,
			@ManagementGroup,
			@Active ,
			@dbLastUpdate,
			@dbLastUpdate
		)
	;
COMMIT

