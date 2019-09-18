/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
/**********************************************************************
* ADD IsOpen Column to scom.AlertResolutionState
* HMS, Issue 19,20,21
* 2019/09/18
***********************************************************************/
-- Add Columns
ALTER TABLE scom.AlertResolutionState
ADD [IsOpen] bit DEFAULT 1
GO

-- Update Column, default is 1
UPDATE scom.AlertResolutionState
SET [IsOpen] = 1
WHERE Name != N'Closed'
GO

-- Update IsOpen, set 'Closed' to 0
UPDATE scom.AlertResolutionState
SET [IsOpen] = 0
WHERE Name = N'Closed'
GO

-- Set Column to NOT NULL
ALTER TABLE scom.AlertResolutionState ALTER COLUMN [IsOpen] BIT NOT NULL
GO