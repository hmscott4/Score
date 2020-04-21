/*
2019/02/12
SCORE Permissions
Hugh Scott
--------------------------------------------------------------------------------------
 This script contains role permission scripts for the SCORE database.
 1. Run this script after the Schema create script
 2. Run against the SCORE database
 3. Run with Text resuts (CTRL-T)
 4. Copy the results into a new query window AND execute			
--------------------------------------------------------------------------------------
*/
USE [SCORE]
GO

SET NOCOUNT ON

SELECT 'GRANT SELECT, REFERENCES ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO adRead;'
FROM sys.objects where type in ('U','V') AND SCHEMA_NAME(schema_id) = 'ad'
UNION ALL
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO adUpdate;'
FROM sys.objects where type in ('P') AND SCHEMA_NAME(schema_id) = 'ad'
ORDER BY 1

SELECT 'GRANT SELECT, REFERENCES ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO scomRead;'
FROM sys.objects where type in ('U','V') AND SCHEMA_NAME(schema_id) = 'scom'
UNION ALL
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO scomUpdate;'
FROM sys.objects where type in ('P') AND SCHEMA_NAME(schema_id) = 'scom'
UNION ALL
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO scomRead;'
FROM sys.objects where type in ('P') AND SCHEMA_NAME(schema_id) = 'scom' AND object_name(object_id) like '%select%'
ORDER BY 1

SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO scomRead;'
FROM sys.objects where type in ('P') AND SCHEMA_NAME(schema_id) = 'dbo' AND object_name(object_id) like '%select%' AND OBJECTPROPERTY(object_id,'IsMSShipped') = 0
UNION ALL
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO scomUpdate;'
FROM sys.objects where type in ('P') AND SCHEMA_NAME(schema_id) = 'dbo' AND OBJECTPROPERTY(object_id,'IsMSShipped') = 0
ORDER BY 1
