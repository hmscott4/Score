/****** Object:  StoredProcedure [cm].[spDatabasePropertySelectByDatabase]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE PROC [cm].[spDatabasePropertySelectByDatabase] 
    @DatabaseGUID uniqueidentifier
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [DatabaseGUID], [PropertyName], [PropertyValue], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[DatabaseProperty] 
	WHERE  ([DatabaseGUID] = @DatabaseGUID) 

	COMMIT