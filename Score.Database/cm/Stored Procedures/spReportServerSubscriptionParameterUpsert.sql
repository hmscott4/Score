/****************************************************************
* Name: cm.spReportServerSubscriptionParameterUpsert
* Author: huscott
* Date: 2015-03-19
*
* Description:
*
****************************************************************/
CREATE PROC [cm].[spReportServerSubscriptionParameterUpsert] 
    @ReportServerSubscriptionGUID uniqueidentifier,
    @ParameterName nvarchar(255),
    @ParameterValue nvarchar(255) = NULL,
    @Active bit,
    @dbLastUpdate datetime2(3)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	MERGE [cm].[ReportServerSubscriptionParameter] AS target
	USING (SELECT @ParameterValue, @Active, @dbLastUpdate, @dbLastUpdate) 
		AS source 
		( [ParameterValue], [Active], [dbAddDate], [dbLastUpdate])
	-- !!!! Check the criteria for match
	ON ([ReportServerSubscriptionGUID] = @ReportServerSubscriptionGUID AND [ParameterName] = @ParameterName)
       WHEN MATCHED THEN 
		UPDATE 
		SET     [ParameterValue] = @ParameterValue, [Active] = @Active, [dbLastUpdate] = @dbLastUpdate
	WHEN NOT MATCHED THEN
		INSERT ([ReportServerSubscriptionGUID], [ParameterName], [ParameterValue], [Active], [dbAddDate], [dbLastUpdate])
		VALUES (@ReportServerSubscriptionGUID, @ParameterName, @ParameterValue, @Active, @dbLastUpdate, @dbLastUpdate)
	;
	
	/*/*/*/*/*/*/*/*-- Begin Return Select <- do not remove
	SELECT [objectGUID], [ReportServerSubscriptionGUID], [ParameterName], [ParameterValue], [Active], [dbAddDate], [dbLastUpdate]
	FROM   [cm].[ReportServerSubscriptionParameter]
	WHERE  [objectGUID] = @objectGUID	
	-- End Return Select <- do not remove*/*/*/*/*/*/*/*/

	COMMIT
