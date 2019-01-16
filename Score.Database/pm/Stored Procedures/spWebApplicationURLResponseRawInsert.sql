/****** Object:  StoredProcedure [pm].[spWebApplicationURLResponseRawInsert]    Script Date: 1/16/2019 8:32:48 AM ******/

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
GO
GRANT EXECUTE ON [pm].[spWebApplicationURLResponseRawInsert] TO [pmUpdate] AS [dbo]
GO
