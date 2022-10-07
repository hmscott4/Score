/****** Object:  StoredProcedure [cm].[spReportingInstanceInactivate]    Script Date: 1/16/2019 8:32:48 AM ******/

/****************************************************************
* Name: cm.spReportingInstanceInactivate
* Author: huscott
* Date: 2015-03-02
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportingInstanceInactivate] 
    @ReportingInstanceGUID uniqueidentifier,
	@IncludeChildObjects bit = 1,
	@dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [cm].[ReportingInstance]
	SET [Active] = 0, dbLastUpdate = @dbLastUpdate, ServiceState = N'Removed'
	WHERE  ([objectGUID] = @ReportingInstanceGUID)

	IF @IncludeChildObjects = 1
	BEGIN
		UPDATE [cm].[ReportServerItem]
		SET Active = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([ReportingInstanceGUID] = @ReportingInstanceGUID)

		UPDATE [cm].[ReportServerSubscription]
		SET Active = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([ReportingInstanceGUID] = @ReportingInstanceGUID)

		UPDATE [cm].[ReportServerSubscriptionParameter]
		SET Active = 0, dbLastUpdate = @dbLastUpdate
		WHERE ([ReportServerSubscriptionGUID] IN (SELECT [objectGUID] FROM [cm].ReportServerSubscription WHERE [ReportingInstanceGUID] = @ReportingInstanceGUID))

	END
	
	/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ComputerGUID], [InstanceName], [ProductName], [ProductEdition], [ProductVersion], [ProductServicePack], [ConnectionString], [RSConfiguration], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportingInstance]
	WHERE  [objectGUID] = @objectGUID
	-- End Return Select <- do not remove*/*/*/*/*/*/
               
	COMMIT