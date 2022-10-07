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