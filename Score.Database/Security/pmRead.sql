CREATE ROLE [pmRead]
    AUTHORIZATION [dbo];




GO
ALTER ROLE [pmRead] ADD MEMBER [abcd\opsmgrreader];

