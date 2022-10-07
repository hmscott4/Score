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