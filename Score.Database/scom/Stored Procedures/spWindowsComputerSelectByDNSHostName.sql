CREATE PROC [scom].[spWindowsComputerSelectByDNSHostName] (
	@DNSHostName nvarchar(255)
)

AS

SELECT [ID]
      ,[DNSHostName]
      ,[IPAddress]
      ,[ObjectSID]
      ,[NetBIOSDomainName]
      ,[DomainDNSName]
      ,[OrganizationalUnit]
      ,[ForestDNSName]
      ,[ActiveDirectorySite]
      ,[IsVirtualMachine]
      ,[HealthState]
      ,[StateLastModified]
      ,[IsAvailable]
      ,[AvailabilityLastModified]
      ,[InMaintenanceMode]
      ,[MaintenanceModeLastModified]
      ,[ManagementGroup]
      ,[Active]
      ,[dbAddDate]
      ,[dbLastUpdate]
  FROM [scom].[WindowsComputer]
  WHERE [DNSHostName] = @DNSHostName