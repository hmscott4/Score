/****************************************************************
* Name: ad.spWebApplicationURLResponseRawInsert
* Author: huscott
* Date: 2019-01-18
*
* Description:
*
****************************************************************/
CREATE PROC [pm].[spWebApplicationURLResponseRawInsert] (
	@WebApplicationURLGUID uniqueidentifier,
	@StatusCode int,
	@StatusDescription nvarchar(128),
	@LastResponseTime int,
	@dbAddDate datetime2(3)
)

AS

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRAN

	INSERT INTO [pm].[WebApplicationURLResponseRaw]
			   ([DateTime]
			   ,[WebApplicationURLGUID]
			   ,[StatusCode]
			   ,[StatusDescription]
			   ,[LastResponseTime]
			   ,[dbAddDate])
		 VALUES
			   (@dbAddDate
			   ,@WebApplicationURLGUID
			   ,@StatusCode
			   ,@StatusDescription
			   ,@LastResponseTime
			   ,@dbAddDate)

COMMIT