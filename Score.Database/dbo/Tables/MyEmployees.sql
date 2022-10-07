CREATE TABLE [dbo].[MyEmployees] (
    [EmployeeID] SMALLINT      NOT NULL,
    [FirstName]  NVARCHAR (30) NOT NULL,
    [LastName]   NVARCHAR (40) NOT NULL,
    [Title]      NVARCHAR (50) NOT NULL,
    [DeptID]     SMALLINT      NOT NULL,
    [ManagerID]  INT           NULL,
    CONSTRAINT [PK_EmployeeID] PRIMARY KEY CLUSTERED ([EmployeeID] ASC)
);

