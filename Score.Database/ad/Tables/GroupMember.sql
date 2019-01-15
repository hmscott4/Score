CREATE TABLE [ad].[GroupMember] (
    [ID]           BIGINT           IDENTITY (1, 1) NOT NULL,
    [Domain]       NVARCHAR (128)   NOT NULL,
    [GroupGUID]    UNIQUEIDENTIFIER NOT NULL,
    [MemberGUID]   UNIQUEIDENTIFIER NOT NULL,
    [MemberType]   NVARCHAR (128)   NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NULL,
    [dbLastUpdate] DATETIME2 (3)    NULL,
    CONSTRAINT [PK_ad_GroupMember] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_GroupMember_Unique]
    ON [ad].[GroupMember]([Domain] ASC, [GroupGUID] ASC, [MemberGUID] ASC);

