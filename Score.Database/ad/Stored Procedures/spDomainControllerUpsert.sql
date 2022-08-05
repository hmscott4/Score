
CREATE PROC [ad].[spDomainControllerUpsert]
(
	@Domain nvarchar(128)
	, @DNSHostName nvarchar(255)
	, @Type nvarchar(128)
	, @dbLastUpdate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

UPDATE [ad].[DomainController]
   SET 
      [Type] = @Type
      ,[Active] = 1
      ,[dbLastUpdate] = @dbLastUpdate
 WHERE 
	[Domain] = @Domain
	AND [DNSHostName] = @DNSHostName

IF @@ROWCOUNT = 0
BEGIN

	INSERT INTO [ad].[DomainController]
			   ([Domain]
			   ,[DNSHostName]
			   ,[Type]
			   ,[Active]
			   ,[dbAddDate]
			   ,[dbLastUpdate])
		 VALUES
			   (@Domain
			   ,@DNSHostName
			   ,@Type
			   ,1
			   ,@dbLastUpdate
			   ,@dbLastUpdate)
END

COMMIT