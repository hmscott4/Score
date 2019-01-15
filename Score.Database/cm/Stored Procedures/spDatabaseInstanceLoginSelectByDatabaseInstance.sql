CREATE PROC [cm].[spDatabaseInstanceLoginSelectByDatabaseInstance] 
    @DatabaseInstanceGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseInstanceGUID], [Name], [Sid], [LoginType], [DefaultDatabase], [HasAccess], [IsDisabled], [IsLocked], [IsPasswordExpired], [PasswordExpirationEnabled], [PasswordPolicyEnforced], [IsSysAdmin], [IsSecurityAdmin], [IsSetupAdmin], [IsProcessAdmin], [IsDiskAdmin], [IsDBCreator], [IsBulkAdmin], [CreateDate], [DateLastModified], [State], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseInstanceLogin] 
	WHERE  ([DatabaseInstanceGUID] = @DatabaseInstanceGUID) 

	COMMIT
