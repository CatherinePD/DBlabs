CREATE TABLE HierarchyidTable(
  hid hierarchyid NOT NULL PRIMARY KEY,
  userId int NOT NULL,
  userName nvarchar(50) NOT NULL,
);

INSERT INTO HierarchyidTable VALUES(hierarchyid::GetRoot(), 1, 'Петрович');

DECLARE @Id hierarchyid
SELECT @Id = MAX(hid) FROM HierarchyidTable WHERE hid.GetAncestor(1) = hierarchyid::GetRoot()
INSERT INTO HierarchyidTable VALUES(hierarchyid::GetRoot().GetDescendant(@id, null), 2, 'Матусевич');

SELECT @Id = MAX(hid) FROM HierarchyidTable WHERE hid.GetAncestor(1) = hierarchyid::GetRoot()
INSERT INTO HierarchyidTable VALUES(hierarchyid::GetRoot().GetDescendant(@id, null), 3, 'Зайцев');

SELECT @Id = MAX(hid) FROM HierarchyidTable WHERE hid.GetAncestor(1) = hierarchyid::GetRoot()
INSERT INTO HierarchyidTable VALUES(hierarchyid::GetRoot().GetDescendant(@id, null), 4, 'Грибовский');

DECLARE @phId hierarchyid

SELECT @phId = (SELECT hid FROM HierarchyidTable WHERE userId = 2);
SELECT Id = MAX(hid) FROM HierarchyidTable WHERE hid.GetAncestor(1) = @phId
INSERT INTO HierarchyidTable VALUES( @phId.GetDescendant(@id, null), 5, 'Образцов');

SELECT @phId = (SELECT hid FROM HierarchyidTable WHERE userId = 4);
SELECT Id = MAX(hid) FROM HierarchyidTable WHERE hid.GetAncestor(1) = @phId
INSERT INTO HierarchyidTable VALUES( @phId.GetDescendant(@id, null), 6, 'Лапошиц');

SELECT @phId = (SELECT hid FROM HierarchyidTable WHERE userId = 4);
SELECT @Id = MAX(hid) FROM HierarchyidTable WHERE hid.GetAncestor(1) = @phId
INSERT INTO HierarchyidTable VALUES( @phId.GetDescendant(@id, null), 7, 'Прокопенко');

GO
CREATE PROCEDURE GetSubordinate @id hierarchyid 
AS
BEGIN 
SELECT hid.GetLevel()[Level], * 
FROM HierarchyidTable 
WHERE hid.IsDescendantOf(@id) = 1
END

DECLARE @subId hierarchyid
SELECT @subId = hid FROM HierarchyidTable WHERE userId = 1
EXEC GetSubordinate @subId

GO
CREATE PROCEDURE CreateNode @id hierarchyid, @userid INT, @name NVARCHAR(20) 
AS
BEGIN 
INSERT INTO HierarchyidTable 
VALUES(hierarchyid::GetRoot().GetDescendant(@id, null), @userid, @name);
END
GO

DECLARE @Id hierarchyid
DECLARE @userid INT
DECLARE @name NVARCHAR(20)
SET @userid = 8
SET @name = 'Архипов'
SELECT @Id = MAX(hid) FROM HierarchyidTable WHERE hid.GetAncestor(1) = hierarchyid::GetRoot()
EXEC CreateNode @Id, @userid, @name

GO
CREATE PROCEDURE ChangeParent @SubjectEmployee hierarchyid , @OldParent hierarchyid, @NewParent hierarchyid 
AS 
BEGIN 
UPDATE HierarchyidTable 
SET hid = @SubjectEmployee.GetReparentedValue(@OldParent, @NewParent)  
WHERE hid= @SubjectEmployee;  
END

GO
DECLARE @SubjectEmployee hierarchyid , @OldParent hierarchyid, @NewParent hierarchyid, @hid hierarchyid   
SELECT @SubjectEmployee = hid FROM HierarchyidTable WHERE userId = 5; 
SELECT @OldParent = hid FROM HierarchyidTable  WHERE userId = 2
SELECT @NewParent = hid FROM HierarchyidTable  WHERE userId = 3
EXEC ChangeParent @SubjectEmployee, @OldParent, @NewParent

