
/****** Object:  StoredProcedure [ad].[spGroupMemberDelete]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: ad.spGroupMemberDelete
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberDelete] 
    @ID bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [ad].[GroupMember]
	WHERE  [ID] = @ID

	COMMIT
GO
GRANT EXECUTE ON [ad].[spGroupMemberDelete] TO [adUpdate] AS [dbo]
GO
