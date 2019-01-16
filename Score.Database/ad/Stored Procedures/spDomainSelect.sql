
/****** Object:  StoredProcedure [ad].[spDomainSelect]    Script Date: 1/16/2019 8:32:48 AM ******/

CREATE PROC [ad].[spDomainSelect] 
    @objectGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [SID], [Forest], [Name], [DNSRoot], [NetBIOSName], [DistinguishedName], [InfrastructureMaster], [PDCEmulator], [RIDMaster], [DomainFunctionality], [ForestFunctionality], [UserName], [Password], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[Domain] 
	WHERE  ([objectGUID] = @objectGUID OR @objectGUID IS NULL) 

	COMMIT
GO
GRANT EXECUTE ON [ad].[spDomainSelect] TO [adUpdate] AS [dbo]
GO
