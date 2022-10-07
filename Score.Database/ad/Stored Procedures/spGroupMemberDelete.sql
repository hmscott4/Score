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