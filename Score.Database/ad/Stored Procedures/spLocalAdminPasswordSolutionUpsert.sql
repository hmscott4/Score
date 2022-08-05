
CREATE PROC [ad].[spLocalAdminPasswordSolutionUpsert] (
	@objectGUID uniqueidentifier 
	, @AdmPwdExpiration datetime2(3)
	, @AdmPassword nvarchar(255) 
	, @dbLastUpdate datetime2(3) 
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRANSACTION;

OPEN SYMMETRIC KEY score_key
	DECRYPTION BY CERTIFICATE score_encrypt

DECLARE @AdmPasswordEncrypted varbinary(255)
-- SET @AdmPasswordEncrypted = ENCRYPTBYKEY(KEY_GUID('score_key'), @AdmPassword, 1, HASHBYTES('SHA2_256', CONVERT(VARBINARY, @AdmPassword)))
SET @AdmPasswordEncrypted = ENCRYPTBYKEY(KEY_GUID('score_key'), @AdmPassword)

UPDATE [ad].[LocalAdminPasswordSolution]
   SET [AdmPwdExpiration] = @AdmPwdExpiration
      ,[AdmPassword] = @AdmPasswordEncrypted
      ,[dbLastUpdate] = @dbLastUpdate
 WHERE [objectGUID] = @objectGUID


IF @@ROWCOUNT = 0
BEGIN
	INSERT INTO [ad].[LocalAdminPasswordSolution]
			   ([objectGUID]
			   ,[AdmPwdExpiration]
			   ,[AdmPassword]
			   ,[dbAddDate]
			   ,[dbLastUpdate])
		 VALUES
			   (@objectGUID
			   ,@AdmPwdExpiration
			   ,@AdmPasswordEncrypted
			   ,@dbLastUpdate
			   ,@dbLastUpdate)
END


COMMIT;