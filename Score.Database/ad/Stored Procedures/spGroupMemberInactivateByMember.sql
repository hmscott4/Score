/****************************************************************
* Name: ad.spGroupMemberInactivateByMember
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberInactivateByMember] 
    @Domain nvarchar(128),
    @MemberGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[GroupMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain
		AND [MemberGUID] = @MemberGUID
               
	COMMIT
