
/****** Object:  StoredProcedure [ad].[spGroupMemberInactivateByGroup]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: ad.spGroupMemberInactivateByGroup
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberInactivateByGroup] 
    @Domain nvarchar(128),
    @GroupGUID uniqueidentifier,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[GroupMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain
		AND [GroupGUID] = @GroupGUID
	
               
	COMMIT
GO
GRANT EXECUTE ON [ad].[spGroupMemberInactivateByGroup] TO [adUpdate] AS [dbo]
GO
