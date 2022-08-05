CREATE TABLE [ad].[DomainController] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [Domain]       NVARCHAR (128) NOT NULL,
    [DNSHostName]  NVARCHAR (255) NOT NULL,
    [Type]         NVARCHAR (128) NOT NULL,
    [Active]       BIT            NOT NULL,
    [dbAddDate]    DATETIME2 (3)  NOT NULL,
    [dbLastUpdate] DATETIME2 (3)  NOT NULL,
    CONSTRAINT [PK_DomainControllers] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_ad_DomainControllers]
    ON [ad].[DomainController]([DNSHostName] ASC);

