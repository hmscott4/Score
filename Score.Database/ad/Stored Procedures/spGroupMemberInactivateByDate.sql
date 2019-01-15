/****************************************************************
* Name: ad.spGroupMemberInactivateByDate
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberInactivateByDate] 
	@Domain nvarchar(128),
    @BeforeDate datetime2(3),
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	UPDATE [ad].[GroupMember]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate
	WHERE  [Domain] = @Domain AND [dbLastUpdate] < @BeforeDate
	              
	COMMIT
