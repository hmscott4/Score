CREATE ROLE [pmRead]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [pmRead] ADD MEMBER [ABCD\opsmgraction];


GO
ALTER ROLE [pmRead] ADD MEMBER [abcd\opsmgrreader];

