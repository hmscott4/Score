/****************************************************************
* Name: ad.spGroupMemberUpsert
* Author: huscott
* Date: 2015-02-24
*
* Description:
*
****************************************************************/
CREATE PROC [ad].[spGroupMemberUpsert] 
    @Domain nvarchar(128),
    @GroupGUID uniqueidentifier,
    @MemberGUID uniqueidentifier,
    @MemberType nvarchar(128),
    @Active bit,
    @dbLastUpdate datetime2(3) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [ad].[GroupMember] AS target
	USING (SELECT @MemberType, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		([MemberType], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([Domain] = @Domain AND [GroupGUID] = @GroupGUID AND [MemberGUID] = @MemberGUID)
       WHEN MATCHED THEN 
		UPDATE 
		SET    [Domain] = @Domain, [GroupGUID] = @GroupGUID, [MemberGUID] = @MemberGUID, [MemberType] = @MemberType, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([Domain], [GroupGUID], [MemberGUID], [MemberType], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@Domain, @GroupGUID, @MemberGUID, @MemberType, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [ID], [Domain], [GroupGUID], [MemberGUID], [MemberType], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [ad].[GroupMember]
	WHERE  [ID] = @ID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT