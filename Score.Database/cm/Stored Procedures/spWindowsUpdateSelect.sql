CREATE PROC [cm].[spWindowsUpdateSelect] 
    @HotfixID nvarchar(128)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [objectGUID], [HotfixID], [Description], [Caption], [FixComments], [Active], [dbAddDate], [dbLastUpdate] 
	FROM   [cm].[WindowsUpdate] 
	WHERE  ([HotfixID] = @HotfixID OR @HotfixID IS NULL) 

	COMMIT
