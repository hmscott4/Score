
/****** Object:  StoredProcedure [ad].[spUserSelect]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [ad].[spUserSelect] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [SID], [Domain], [Name], [FirstName], [LastName], [DisplayName], [Company], [Office], [Department], [Division], [StreetAddress], [City], [State], [PostalCode], [Manager], [MobilePhone], [PhoneNumber], [Fax], [Pager], [EMail], [DistinguishedName], [Enabled], [Active], [LastLogon], [whenCreated], [whenChanged], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[User] 
	WHERE  ([objectGUID] = @objectGUID OR @objectGUID IS NULL) 

	COMMIT
GO
