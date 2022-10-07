/****** Object:  View [cm].[DatabaseInstanceLoginView]    Script Date: 1/16/2019 8:32:48 AM ******/
CREATE VIEW [cm].[DatabaseInstanceLoginView]

AS

SELECT [dbl].[objectGUID]
      ,[dbl].[DatabaseInstanceGUID]
      ,[c].[objectGUID] as [ComputerGUID]
	  ,[c].[dnsHostName]
	  ,[dbi].[InstanceName] as [DatabaseInstance]
      ,[dbl].[Name]
      ,[dbl].[Sid]
      ,[dbl].[LoginType]
      ,[dbl].[DefaultDatabase]
      ,[dbl].[HasAccess]
      ,[dbl].[IsDisabled]
      ,[dbl].[IsLocked]
      ,[dbl].[IsPasswordExpired]
      ,[dbl].[PasswordExpirationEnabled]
      ,[dbl].[PasswordPolicyEnforced]
      ,[dbl].[IsSysAdmin]
      ,[dbl].[IsSecurityAdmin]
      ,[dbl].[IsSetupAdmin]
      ,[dbl].[IsProcessAdmin]
      ,[dbl].[IsDiskAdmin]
      ,[dbl].[IsDBCreator]
      ,[dbl].[IsBulkAdmin]
      ,[dbl].[CreateDate]
      ,[dbl].[DateLastModified]
      ,[dbl].[State]
      ,[dbl].[Active]
      ,[dbl].[dbAddDate]
      ,[dbl].[dbLastUpdate]
  FROM 
	[cm].[DatabaseInstanceLogin] dbl INNER JOIN [cm].[DatabaseInstance] dbi ON
		[dbl].[DatabaseInstanceGUID] = [dbi].[objectGUID]
	INNER JOIN [cm].[Computer] c ON
		[dbi].[ComputerGUID] = [c].[objectGUID]