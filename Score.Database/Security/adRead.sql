CREATE ROLE [adRead]
    AUTHORIZATION [dbo];




GO
ALTER ROLE [adRead] ADD MEMBER [abcd\opsmgrreader];

