CREATE TABLE [cm].[DatabaseInstanceProperty] (
    [objectGUID]           UNIQUEIDENTIFIER CONSTRAINT [DF_cm_DatabaseInstanceProperty_objectGUID] DEFAULT (newid()) NOT NULL,
    [DatabaseInstanceGUID] UNIQUEIDENTIFIER NOT NULL,
    [PropertyName]         NVARCHAR (128)   NOT NULL,
    [PropertyValue]        NVARCHAR (128)   NULL,
    [Active]               BIT              NOT NULL,
    [dbAddDate]            DATETIME2 (3)    NOT NULL,
    [dbLastUpdate]         DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_DatabaseInstanceProperty] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_DatabaseInstanceProperty_DatabaseInstance] FOREIGN KEY ([DatabaseInstanceGUID]) REFERENCES [cm].[DatabaseInstance] ([objectGUID])
);

