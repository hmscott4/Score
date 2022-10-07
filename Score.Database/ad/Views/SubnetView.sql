--select * from ad.Subnet

CREATE VIEW ad.SubnetView

AS

SELECT
	objectGUID
	, Domain
	, [Name]
	, [Description]
	, [Location]
	, [Site]
	, [DistinguishedName]
	, LEFT([name], charindex('/',[name])-1) as [Subnet]
	, CASE
			WHEN right([Name],2) = '/1' then '128.0.0.0'
			WHEN right([Name],2) = '/2' then '192.0.0.0'
			WHEN right([Name],2) = '/3' then '224.0.0.0'
			WHEN right([Name],2) = '/4' then '240.0.0.0'
			WHEN right([Name],2) = '/5' then '248.0.0.0'
			WHEN right([Name],2) = '/6' then '252.0.0.0'
			WHEN right([Name],2) = '/7' then '254.0.0.0'
			WHEN right([Name],2) = '/8' then '255.0.0.0'
			WHEN right([Name],2) = '/9' then '255.128.0.0'
			WHEN right([Name],3) = '/10' then '255.192.0.0'
			WHEN right([Name],3) = '/11' then '255.224.0.0'
			WHEN right([Name],3) = '/12' then '255.240.0.0'
			WHEN right([Name],3) = '/13' then '255.248.0.0'
			WHEN right([Name],3) = '/14' then '255.252.0.0'
			WHEN right([Name],3) = '/15' then '255.254.0.0'	
			WHEN right([Name],3) = '/16' then '255.255.0.0'
			WHEN right([Name],3) = '/17' then '255.255.128.0'
			WHEN right([Name],3) = '/18' then '255.255.192.0'
			WHEN right([Name],3) = '/19' then '255.255.224.0'
			WHEN right([Name],3) = '/20' then '255.255.240.0'
			WHEN right([Name],3) = '/21' then '255.255.248.0'
			WHEN right([Name],3) = '/22' then '255.255.252.0'
			WHEN right([Name],3) = '/23' then '255.255.254.0'
			WHEN right([Name],3) = '/24' then '255.255.255.0'
			WHEN right([Name],3) = '/25' then '255.255.255.128'
			WHEN right([Name],3) = '/26' then '255.255.255.192'
			WHEN right([Name],3) = '/27' then '255.255.255.224'
			WHEN right([Name],3) = '/28' then '255.255.255.240'
			WHEN right([Name],3) = '/29' then '255.255.255.248'
			WHEN right([Name],3) = '/30' then '255.255.255.252'
			WHEN right([Name],3) = '/31' then '255.255.255.254'
		END as SubnetMask
		, Active
		, whenChanged
		, whenCreated
		, dbAddDate
		, dbLastUpdate
FROM ad.Subnet