CREATE TABLE [cm].[ComputerGroupMember] (
    [objectGUID]   UNIQUEIDENTIFIER CONSTRAINT [DF_cm_ComputerGroupMember_objectGUID] DEFAULT (newsequentialid()) NOT NULL,
    [ComputerGUID] UNIQUEIDENTIFIER NOT NULL,
    [GroupName]    NVARCHAR (128)   NOT NULL,
    [MemberName]   NVARCHAR (128)   NOT NULL,
    [Active]       BIT              NOT NULL,
    [dbAddDate]    DATETIME2 (3)    NOT NULL,
    [dbLastUpdate] DATETIME2 (3)    NOT NULL,
    CONSTRAINT [PK_cm_ComputerGroupMember] PRIMARY KEY CLUSTERED ([objectGUID] ASC),
    CONSTRAINT [FK_ComputerGroupMember_Computer] FOREIGN KEY ([ComputerGUID]) REFERENCES [cm].[Computer] ([objectGUID])
);

GO
CREATE INDEX IX_ComputerGroupMember_ComputerGUID ON [cm].[ComputerGroupMember](ComputerGUID)
