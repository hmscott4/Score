CREATE TABLE [cm].[DatabaseProperty] (
    [objectGUID]    UNIQUEIDENTIFIER CONSTRAINT [DF_cm_DatabaseProperty_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [DatabaseGUID]  UNIQUEIDENTIFIER NOT NULL,
    [PropertyName]  NVARCHAR (128)   NOT NULL,
    [PropertyValue] NVARCHAR (128)   NULL,
    [Active]        BIT              NOT NULL,
    [dbAddDate]     DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]  DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_DatabaseProperty] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_DatabaseProperty_Database] FOREIGN KEY ([DatabaseGUID]) REFERENCES [cm].[Database] ([objectGUID])
);

GO
CREATE NONCLUSTERED INDEX [IX_DatabaseProperty_DatabaseGUID]
    ON [cm].[DatabaseProperty](DatabaseGUID)

