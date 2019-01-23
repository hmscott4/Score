CREATE ROLE [scomUpdate]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [scomUpdate] ADD MEMBER [abcd\opsmgrreader];

