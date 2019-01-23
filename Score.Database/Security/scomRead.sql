CREATE ROLE [scomRead]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [scomRead] ADD MEMBER [abcd\opsmgrreader];

