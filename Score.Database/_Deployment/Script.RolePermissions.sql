/*
2019/02/12
SCORE Permissions
Hugh Scott
--------------------------------------------------------------------------------------
 This script contains role permission scripts for the SCORE database.
 1. Run this script after the Schema create script
 2. Run against the SCORE database
 3. Run with Text resuts (CTRL-T)
 4. Copy the results into a new query window and execute			
--------------------------------------------------------------------------------------
*/
SET NOCOUNT ON

SELECT 'GRANT SELECT, REFERENCES ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO cmRead;'
FROM sys.objects where type in ('U','V') and SCHEMA_NAME(schema_id) = 'cm'
union all
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO cmUpdate;'
FROM sys.objects where type in ('P') and SCHEMA_NAME(schema_id) = 'cm'
union all
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO cmRead;'
FROM sys.objects where type in ('P') and SCHEMA_NAME(schema_id) = 'cm' and object_name(object_id) like '%select%'
order by 1


SELECT 'GRANT SELECT, REFERENCES ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO adRead;'
FROM sys.objects where type in ('U','V') and SCHEMA_NAME(schema_id) = 'ad'
union all
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO adUpdate;'
FROM sys.objects where type in ('P') and SCHEMA_NAME(schema_id) = 'ad'
union all
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO adRead;'
FROM sys.objects where type in ('P') and SCHEMA_NAME(schema_id) = 'cm' and object_name(object_id) like '%select%'
order by 1


SELECT 'GRANT SELECT, REFERENCES ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO pmRead;'
FROM sys.objects where type in ('U','V') and SCHEMA_NAME(schema_id) = 'pm'
union all
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO pmUpdate;'
FROM sys.objects where type in ('P') and SCHEMA_NAME(schema_id) = 'pm'
union all
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO pmRead;'
FROM sys.objects where type in ('P') and SCHEMA_NAME(schema_id) = 'cm' and object_name(object_id) like '%select%'
order by 1

SELECT 'GRANT SELECT, REFERENCES ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO scomRead;'
FROM sys.objects where type in ('U','V') and SCHEMA_NAME(schema_id) = 'scom'
union all
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO scomUpdate;'
FROM sys.objects where type in ('P') and SCHEMA_NAME(schema_id) = 'scom'
union all
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO scomRead;'
FROM sys.objects where type in ('P') and SCHEMA_NAME(schema_id) = 'scom' and object_name(object_id) like '%select%'
order by 1

SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO cmUpdate;'
FROM sys.objects where type in ('P') and SCHEMA_NAME(schema_id) = 'dbo' and OBJECTPROPERTY(object_id,'IsMSShipped') = 0
union all
SELECT 'GRANT EXEC ON ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(object_name(object_id)) + ' TO cmRead;'
FROM sys.objects where type in ('P') and SCHEMA_NAME(schema_id) = 'dbo' and object_name(object_id) like '%select%' and OBJECTPROPERTY(object_id,'IsMSShipped') = 0
order by 1
