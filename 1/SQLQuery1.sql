USE [SoftLicenseManagement]
GO


CREATE TABLE [dbo].[Software] (
    [Id]          INT      IDENTITY (1, 1) NOT NULL,
    [Name]			NVARCHAR(75)    NOT NULL,
	[Version]      NVARCHAR(75)    NOT NULL,
	[Price]			MONEY          NOT NULL,
    [OwnerId]       INT      NOT NULL,
    [DateCreated] DATETIME NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Owners] (
    [Id]          INT             IDENTITY (1, 1) NOT NULL,
	[ContactId]		INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Licenses] (
    [Id]				INT            IDENTITY (1, 1) NOT NULL,
    [Title]				NVARCHAR (75)  NOT NULL,
    [PaymentDate]		DATETIME       NOT NULL DEFAULT(GETDATE()),
    [ExpiryDate]		DATETIME		NOT NULL,
    [SoftwareId]		INT            NOT NULL,
    [CustomerId]		INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[LicensesHistory] (
    [Id]				INT            IDENTITY (1, 1) NOT NULL,
	[LicenseId]			INT            NOT NULL,
    [Title]				NVARCHAR (75)  NOT NULL,
    [PaymentDate]		DATETIME       NOT NULL DEFAULT(GETDATE()),
    [ExpiryDate]		DATETIME       NOT NULL,
    [SoftwareId]		INT            NOT NULL,
    [CustomerId]		INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Customers] (
    [Id]          INT             IDENTITY (1, 1) NOT NULL,
	[ContactId]	  INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[Contacts] (
    [Id]          INT             IDENTITY (1, 1) NOT NULL,
	[Name]		  NVARCHAR (75)   NOT NULL,
    [Email]       NVARCHAR (75)   NOT NULL,
	[Address]     NVARCHAR (75)   NULL,
    [Phone]       NVARCHAR (75)   NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

------------------------------------------

CREATE NONCLUSTERED INDEX [IX_Software_OwnerId]
    ON [dbo].[Software]([OwnerId] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_Owners_ContactId]
    ON [dbo].[Owners]([ContactId] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_Customers_ContactId]
    ON [dbo].[Customers]([ContactId] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_Licenses_SoftwareId]
    ON [dbo].[Licenses]([SoftwareId] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_Licenses_CustomerId]
    ON [dbo].[Licenses]([CustomerId] ASC);

------------------------------------------

ALTER TABLE [dbo].[Software]
    ADD CONSTRAINT [FK_Software_Owners] FOREIGN KEY ([OwnerId]) REFERENCES [dbo].[Owners] ([Id]);
GO
ALTER TABLE [dbo].[Licenses]
    ADD CONSTRAINT [FK_Licenses_Software] FOREIGN KEY ([SoftwareId]) REFERENCES [dbo].[Software] ([Id]);
GO
ALTER TABLE [dbo].[Licenses]
    ADD CONSTRAINT [FK_Licenses_Customers] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customers] ([Id]);
GO
ALTER TABLE [dbo].[Owners]
    ADD CONSTRAINT [FK_Owners_Contacts] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[Contacts] ([Id]);
GO
ALTER TABLE [dbo].[Customers]
    ADD CONSTRAINT [FK_Customers_Contacts] FOREIGN KEY ([ContactId]) REFERENCES [dbo].[Contacts] ([Id]);
GO

------------------------------------------
CREATE PROCEDURE usp_AddSoftware
    @name NVARCHAR(75),
	@version NVARCHAR(75),
	@price MONEY,
    @ownerId INT,
	@date DATETIME,
    @softwareId INT OUTPUT
AS
BEGIN
    INSERT INTO [dbo].[Software]
    (
        Name,
		Version,
		Price,
		OwnerId,
		DateCreated
    )
    VALUES (@name, @version, @price, @ownerId, @date)

    SET @softwareId = SCOPE_IDENTITY()
END
GO

CREATE PROCEDURE usp_AddLicense
    @title NVARCHAR(75),
	@expirydate DATETIME,
	@softwareId INT,
	@customerId INT,
    @licenseId INT OUTPUT
AS
BEGIN
    INSERT INTO [dbo].[Licenses]
    (
        Title,
		ExpiryDate,
		SoftwareId,
		CustomerId
    )
    VALUES (@title, @expirydate, @softwareId, @customerId)

    SET @licenseId = SCOPE_IDENTITY()
END
GO

CREATE PROCEDURE usp_AddOwner
    @name NVARCHAR(75),
	@email NVARCHAR(75),
	@address NVARCHAR(75),
	@phone NVARCHAR(75),
    @ownerId INT OUTPUT
AS
BEGIN
	DECLARE @contactId INT

    INSERT INTO [dbo].[Contacts]
    (
        Name,
		Email,
		Address,
		Phone
    )
    VALUES (@name, @email, @address, @phone)

    SET @contactId = SCOPE_IDENTITY()

	INSERT INTO [dbo].[Owners]
    (
        ContactId
    )
    VALUES (@contactId)

	 SET @ownerId = SCOPE_IDENTITY()
END
GO

CREATE PROCEDURE usp_AddCustomer
    @name NVARCHAR(75),
	@email NVARCHAR(75),
	@address NVARCHAR(75) = NULL,
	@phone NVARCHAR(75),
    @ownerId INT OUTPUT
AS
BEGIN
	DECLARE @contactId INT

    INSERT INTO [dbo].[Contacts]
    (
        Name,
		Email,
		Address,
		Phone
    )
    VALUES (@name, @email, @address, @phone)

    SET @contactId = SCOPE_IDENTITY()

	INSERT INTO [dbo].[Customers]
    (
        ContactId
    )
    VALUES (@contactId)

	 SET @ownerId = SCOPE_IDENTITY()
END
GO

CREATE PROCEDURE usp_EditCustomer
    @id INT,
	@name NVARCHAR(75),
    @email NVARCHAR(75),
    @phone NVARCHAR(75)
AS
BEGIN

    UPDATE c
    SET c.Email = @email,
        c.Name = @name,
        c.Phone = @phone
    FROM [dbo].[Contacts] c
    INNER JOIN 
	[dbo].[Customers] u ON c.Id = u.ContactId
    WHERE u.Id = @id

END
GO

CREATE PROCEDURE usp_EditOwner
    @id INT,
	@name NVARCHAR(75),
    @email NVARCHAR(75),
	@address NVARCHAR(75),
    @phone NVARCHAR(75)
AS
BEGIN

    UPDATE c
    SET c.Email = @email,
        c.Name = @name,
        c.Phone = @phone
    FROM [dbo].[Contacts] c 
	INNER JOIN 
	[dbo].[Owners] o ON c.Id = o.ContactId
    WHERE o.Id = @id

END
GO

CREATE PROCEDURE usp_EditSoftware
	@id INT,
    @name NVARCHAR(75),
	@version NVARCHAR(75),
	@price MONEY,
    @ownerId INT
AS
BEGIN

    UPDATE s
    SET s.Name = @name,
		s.Version = @version,
		s.Price = @price,
        s.OwnerId = @ownerId
    FROM [dbo].[Software] s
    WHERE s.Id = @id

END
GO

CREATE PROCEDURE usp_EditLicense
	@id INT,
	@title NVARCHAR(75),
	@expirydate DATETIME,
	@softwareId INT,
	@customerId INT
AS
BEGIN

    UPDATE s
    SET s.Title = @title,
		s.ExpiryDate = @expirydate,
		s.SoftwareId = @softwareId,
        s.CustomerId = @customerId
    FROM [dbo].[Licenses] s
    WHERE s.Id = @id

END
GO

CREATE PROCEDURE [dbo].[usp_DeleteLicense]
    @id INT
AS
BEGIN
    DELETE [dbo].[Licenses]
    WHERE Id = @id
END
GO

CREATE PROCEDURE [dbo].[usp_DeleteSoftware]
    @id INT
AS
BEGIN
    DELETE [dbo].[Software]
    WHERE Id = @id
END
GO

CREATE PROCEDURE [dbo].[usp_DeleteOwner]
    @id INT
AS
BEGIN

	DELETE l FROM [dbo].[Licenses] l
	INNER JOIN [dbo].[Software] s 
	ON l.SoftwareId = s.Id
    WHERE s.OwnerId = @id

    DELETE [dbo].[Software]
    WHERE OwnerId = @id

	DELETE [dbo].[Owners]
    WHERE Id = @id
END
GO

CREATE PROCEDURE [dbo].[usp_DeleteCustomer]
    @id INT
AS
BEGIN

    DELETE [dbo].[Licenses]
    WHERE CustomerId = @id

	DELETE [dbo].[Customers]
    WHERE Id = @id
END
GO

CREATE PROCEDURE usp_GetLicenses
AS
BEGIN
    SELECT l.Id
          ,l.Title
          ,l.PaymentDate
          ,l.ExpiryDate
          ,l.SoftwareId
		  ,l.CustomerId
    FROM [dbo].[Licenses] l
END
GO

CREATE PROCEDURE usp_GetLicensesHistory
AS
BEGIN
    SELECT l.Id
          ,l.LicenseId
		  ,l.Title
          ,l.PaymentDate
          ,l.ExpiryDate
          ,l.SoftwareId
		  ,l.CustomerId
    FROM [dbo].[LicensesHistory] l
END
GO

CREATE PROCEDURE usp_GetOwners
AS
BEGIN
    SELECT o.Id
          ,c.Name
          ,c.Email
          ,c.Address
          ,c.Phone
    FROM [dbo].[Owners] o
	INNER JOIN [dbo].[Contacts] c
	ON o.ContactId = c.Id
END
GO

CREATE PROCEDURE usp_GetCustomers
AS
BEGIN
    SELECT o.Id
          ,c.Name
          ,c.Email
          ,c.Address
          ,c.Phone
    FROM [dbo].[Customers] o
	INNER JOIN [dbo].[Contacts] c
	ON o.ContactId = c.Id
END
GO

CREATE PROCEDURE usp_GetSoftwares
AS
BEGIN
    SELECT s.Id
          ,s.Name
		  ,s.Version
          ,s.OwnerId
		  ,s.Price
          ,s.DateCreated
    FROM [dbo].[Software] s
END
GO

CREATE PROCEDURE usp_GetLicensesExpireNextMonth
AS
BEGIN
     SELECT l.Id
          ,l.Title
          ,l.PaymentDate
          ,l.ExpiryDate
          ,l.SoftwareId
		  ,l.CustomerId
    FROM [dbo].[Licenses] l
	WHERE DATEDIFF(month, getdate(), l.ExpiryDate) = 1
END
GO

------------------------------------------

CREATE VIEW [dbo].[vw_InactiveLicenses]
AS

SELECT l.[Id]
      ,l.[Title]
      ,l.[PaymentDate]
      ,l.[ExpiryDate]
      ,l.[SoftwareId]
      ,l.[CustomerId]
FROM [dbo].[Licenses] l
WHERE l.[ExpiryDate] < GETDATE();
GO

CREATE VIEW [dbo].[vw_ActiveLicenses]
AS

SELECT l.[Id]
      ,l.[Title]
      ,l.[PaymentDate]
      ,l.[ExpiryDate]
      ,l.[SoftwareId]
      ,l.[CustomerId]
FROM [dbo].[Licenses] l
WHERE l.[ExpiryDate] > GETDATE();
GO

--------------------------------------------

CREATE FUNCTION [dbo].[udf_TotalCostOfPurchasedLicenses]() returns INT 
AS
BEGIN  
     DECLARE @sum INT = 
	 (SELECT sum(s.Price) 
	 FROM [dbo].[vw_ActiveLicenses] l 
	 INNER JOIN 
	 [dbo].[Software] s on l.SoftwareId = s.Id);    
     RETURN @sum;
END;  

GO

------------------------------------------
CREATE TRIGGER [Licenses_INSERT]
ON [dbo].[Licenses]
	AFTER INSERT
	AS
	INSERT INTO [dbo].[LicensesHistory] 
	(
	LicenseId,
	Title,
	PaymentDate,
	ExpiryDate,
	SoftwareId,
	CustomerId
	) 
	SELECT	i.Id, 
			i.Title,
			i.PaymentDate,
			i.ExpiryDate,
			i.SoftwareId,
			i.CustomerId
	FROM INSERTED i
	RETURN;
GO
------------------------------------------