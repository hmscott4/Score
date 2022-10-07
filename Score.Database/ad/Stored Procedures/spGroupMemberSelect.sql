CREATE PROC [ad].[spGroupMemberSelect] 
    @ID bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [Domain], [GroupGUID], [MemberGUID], [MemberType], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [ad].[GroupMember] 
	WHERE  ([ID] = @ID OR @ID IS NULL) 

	COMMIT