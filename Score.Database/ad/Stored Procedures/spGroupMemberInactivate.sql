
/****** Object:  StoredProcedure [ad].[spGroupMemberInactivate]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: ad.spGroupMemberInactivate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberInactivate] 
    @ID bigint,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[GroupMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [ID] = @ID
	              
	COMMIT
GO
GRANT EXECUTE ON [ad].[spGroupMemberInactivate] TO [adUpdate] AS [dbo]
GO
