/****** Object:  StoredProcedure [dbo].[spConfigSelect]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [dbo].[spConfigSelect] 
    @ConfigName nvarchar(255)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ID], [ConfigName], [ConfigValue], [dbAddDate], [dbAddBy], [dbModDate], [dbModBy] 
	FROM   [dbo].[Config] 
	WHERE  ([ConfigName] = @ConfigName OR @ConfigName IS NULL) 

	COMMIT
GO
GRANT EXECUTE ON [dbo].[spConfigSelect] TO [cmRead] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[spConfigSelect] TO [cmUpdate] AS [dbo]
GO
