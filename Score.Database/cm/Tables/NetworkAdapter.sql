CREATE TABLE [cm].[NetworkAdapter] (
    [objectGUID]      UNIQUEIDENTIFIER CONSTRAINT [DF_cm_NetworkAdapter_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [ComputerGUID]    UNIQUEIDENTIFIER NOT NULL,
    [Index]           INT              NOT NULL,
    [Name]            NVARCHAR (255)   NOT NULL,
    [NetConnectionID] NVARCHAR (255)   NULL,
    [AdapterType]     NVARCHAR (255)   NULL,
    [Manufacturer]    NVARCHAR (255)   NULL,
    [MACAddress]      NVARCHAR (128)   NULL,
    [PhysicalAdapter] BIT              NULL,
    [Speed]           BIGINT           NULL,
    [NetEnabled]      INT              NULL,
    [Active]          BIT              NOT NULL,
    [dbAddDate]       DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]    DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_NetworkAdapter] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_NetworkAdapter_Computer] FOREIGN KEY ([ComputerGUID]) REFERENCES [cm].[Computer] ([objectGUID])
);

