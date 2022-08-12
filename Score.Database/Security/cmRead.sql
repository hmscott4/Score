CREATE ROLE [cmRead]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [cmRead] ADD MEMBER [ABCD\opsmgraction];


GO
ALTER ROLE [cmRead] ADD MEMBER [abcd\opsmgrreader];

