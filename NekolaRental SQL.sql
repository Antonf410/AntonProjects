USE master
go

CREATE DATABASE NekolaRental
go

USE NekolaRental
go

CREATE TABLE Employees
(
	EmployeeID INT IDENTITY NOT NULL PRIMARY KEY,
	LastName NVARCHAR(20) NOT NULL,
	FirstName NVARCHAR(20) NOT NULL,
	IDNumbers NVARCHAR(10) NOT NULL,
	BirthDate DATE NOT NULL,
	HireDate DATE NOT NULL,
	Address NVARCHAR(80) NULL,
	City NVARCHAR(30) NULL,
	Phone NVARCHAR(15) NULL,
	Salary MONEY NOT NULL,
	CONSTRAINT CH_Salary CHECK (Salary>0),
)
go
CREATE TABLE Customers
(
	CustomerID NCHAR(5) NOT NULL PRIMARY KEY,
	CompanyName NVARCHAR(30) NULL,
	ContactName NVARCHAR(30) NULL,
	ContactTitle NVARCHAR(30) NULL,
	Address NVARCHAR(80) NULL,
	City NVARCHAR(30) NOT NULL,
	Phone NVARCHAR(15) NULL
)
go
CREATE TABLE Rents
(
	RentID INT IDENTITY NOT NULL PRIMARY KEY,
	CustomerID NCHAR(5) NOT NULL,
	EmployeeID INT NOT NULL,
	RentalDate DATE NOT NULL,
	ReturnDate DATE NOT NULL,
	OrderDate DATETIME NULL,
	DelivaryDate DATETIME NULL,
	DelivaryDescription NVARCHAR(100) NULL,
	DelivaryVia INT NULL,
	DelivaryCity NVARCHAR(20) NULL,
	CONSTRAINT FK_Rent_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
	CONSTRAINT FK_Rent_Employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
	CONSTRAINT FK_Rent_Delivary_Emp FOREIGN KEY (DelivaryVia) REFERENCES Employees(EmployeeID)
)
go
CREATE TABLE Importers
(
	ImporterID INT IDENTITY NOT NULL PRIMARY KEY,
	CompanyName NVARCHAR(30) NULL,
	ImporterName NVARCHAR(30) NULL,
	Address NVARCHAR(40) NULL,
	City NVARCHAR(20) NULL,
	Phone NVARCHAR(15) NULL,
	Website NVARCHAR(100) NULL,
	Email NVARCHAR(100) NULL
)
go
CREATE TABLE Equipments
(
	EquipmentID INT IDENTITY NOT NULL PRIMARY KEY,
	EquipmentName NVARCHAR(30) NOT NULL,
	ModelName NVARCHAR(30) NOT NULL,
	Description NVARCHAR(200) NULL,
	CountyOfManufactory NVARCHAR(20) NOT NULL,
	QuantityPerUnit SMALLINT NOT NULL,
	UnitPrice MONEY NOT NULL,
	ImporterID INT NOT NULL,
	CONSTRAINT FK_Equipment_Importer FOREIGN KEY (ImporterID) REFERENCES Importers(ImporterID),
	CONSTRAINT CH_Equipment_UnitPrice CHECK (UnitPrice>0)
)
go
CREATE TABLE [Rental Details]
(
	RentID INT NOT NULL,
	EquipmentID INT NOT NULL,
	Quantity SMALLINT NOT NULL,
	Discount REAL NOT NULL,
	CONSTRAINT PK_Rental_Details_Rent_Equipment PRIMARY KEY (RentID,EquipmentID),
	CONSTRAINT CH_Rent_Detail_Disc CHECK (Discount>=0 AND Discount<=1),
	CONSTRAINT FK_Rental_Details_Rent FOREIGN KEY (RentID) REFERENCES Rents(RentID),
	CONSTRAINT FK_Rental_Details_Equipment FOREIGN KEY (EquipmentID) REFERENCES Equipments(EquipmentID)
)
go
INSERT INTO Employees
VALUES('Farhoud','Anton',312230980,'1994-10-04','2017-07-19','Tawfik Ziyad','ShefarAm',0543902500,6000),
	('Farhoud','Nekola',312330987,'1992-06-26','2017-07-08','Tawfik Ziyad','ShefarAm',0542568423,12000),
	('Farhoud','Hanna',059382145,'1965-10-18','2019-10-28','Tawfik Ziyad','ShefarAm',0542612112,5500),
	('Doukhy','Elias',312568490,'1996-09-03','2019-10-28','Harsheet','Maalot-Tarshiha',0548679988,4800),
	('Haddad','Andro',316547925,'2001-11-04','2020-01-05','Hamerkaz','Maalot-Tarshiha',0548963216,4800),
	('Shaloufe','Christiano',312654980,'1998-09-14','2021-12-02','Poulos HaSheshe','Nazareth',0546921588,5000)
go
INSERT INTO Customers
VALUES('Ha001','Abu Maher Hall','Maher Attareye','Manager','איזור תעשייה','Nazareth',0544369825),
	('Ha002','Verona Hall','Tarek Khoury','Manager',NULL,'Kfar Yasif',0528987456),
	('Si001',NULL,'Zoher Francis','Singer',NULL,'Haifa',0522981344),
	('Si002',NULL,'Eyal Golan','Singer',NULL,'Rehovot',0536475511),
	('Ha003','Abu Rasheed',NULL,'Office',NULL,'Eibillin',049981344),
	('Si003',NULL,'Habib Simaan','Singer',NULL,'Kfar Yasif',0526478911),
	('Ho001','C-Hotels','Dudu Oz','מנכ"ל','Yafi Nof','Maalot',0498662155),
	('Ch001','Christ The King Church','Hatim Jeryis','Pastor','HaBrush','Tarshiha',0546215789),
	('Ch002','Kehilat HaCarmel Church','EliEl','אחראי',NULL,'Osefia',0528963741),
	('TV001','Doit TV Studio','Moaawiya','Manager',NULL,'Baqa El Gharbeya',049821568),
	('TV002','Al Arz TV Studio',NULL,'Office','El Ein','Nazareth',049875631),
	('Ra001','Al Shams Radio',NULL,NULL,'Office','Nazareth',1800752614),
	('Ra002','Hope Radio','Nizar Elemy','Manager',NULL,'Tiberias',0502583691)
go
INSERT INTO Rents
VALUES('Ha001',2,'2017-07-20','2017-07-21','2017-07-08 09:37:51:00','2017-07-21 17:30:25:00','הובלה ברכב Peugeot Boxer',1,'Nazareth'),
	('Si001',2,'2017-07-31','2017-08-02','2017-07-09 12:30:55:00','2017-08-01 20:13:26:00','הובלה ברכב Peugeot Boxer',2,'Tel Aviv'),
	('Ha002',1,'2017-08-06','2017-08-10','2017-07-20 09:20:34:00','2017-08-06 14:21:25:00','הובלה ברכב Dacia Duster',1,'Kfar Yasif'),
	('Si002',2,'2019-12-04','2019-12-08','2019-08-26 15:14:39:00','2019-12-04 08:03:12:00','הובלה ברכב Peugeot Boxer',3,'Jerusalem'),
	('Si003',2,'2020-01-06','2020-01-07','2019-09-05 21:25:00:00','2020-01-06 07:11:21:00','הובלה ברכב Dacia Duster',4,'Ashdod'),
	('TV001',1,'2021-05-23','2021-05-25','2021-03-13 15:21:15:00','2021-05-23 13:25:36:00','הובלה ברכב Peugeot Boxer',3,'Baqa El Gharbeya'),
	('Si002',1,'2021-05-29','2021-06-01','2021-03-25 21:26:06:00','2021-05-29 09:01:35:00','הובלה ברכב Peugeot Boxer',3,'Maron Golan'),
	('Ra001',1,'2021-06-14','2021-06-16','2021-04-02 19:49:42:00','2021-06-14 15:25:45:00','הובלה ברכב Dacia Duster',2,'Nazareth'),
	('Ch001',2,'2021-06-21','2021-06-23','2021-04-21 10:55:26:00','2021-06-21 12:18:55:00','הובלה ברכב Dacia Duster',1,'Tarshiha'),
	('Ch002',2,'2021-06-28','2021-07-01','2021-05-15 16:53:25:00','2021-06-28 14:16:37:00','הובלה ברכב Peugeot Boxer',1,'Osefia'),
	('Ch001',2,'2021-07-06','2021-07-10','2021-05-19 12:29:27:00','2021-07-06 16:02:22:00','הובלה ברכב Peugeot Boxer',1,'Tarshiha'),
	('Ha003',2,'2021-07-14','2021-07-15','2021-05-23 10:00:22:00','2021-07-14 10:06:01:00','הובלה ברכב Dacia Duster',2,'Eibillin'),
	('Ra001',1,'2021-07-16','2021-07-16','2021-05-30 11:03:10:00','2021-07-16 06:39:41:00','הובלה ברכב Peugeot Boxer',4,'Nazareth'),
	('TV001',1,'2021-07-21','2021-07-25','2021-06-04 14:27:11:00','2021-07-21 17:55:23:00','הובלה ברכב Dacia Duster',5,'Baqa El Gharbeya'),
	('Ra002',3,'2021-07-28','2021-07-28','2021-06-22 17:39:33:00','2021-07-28 07:19:28:00','הובלה ברכב Peugeot Boxer',3,'Tiberias'),
	('Si003',3,'2021-08-01','2021-08-02','2021-07-01 20:58:27:00','2021-08-01 10:06:12:00','הובלה ברכב Peugeot Boxer',3,'Nahariyya'),
	('Ch002',4,'2021-08-04','2021-08-07','2021-07-09 16:20:25:00','2021-08-04 18:06:08:00','הובלה ברכב Dacia Duster',1,'Osefia'),
	('TV002',5,'2021-08-21','2021-08-24','2021-07-15 13:03:36:00','2021-08-21 11:12:38:00','הובלה ברכב Dacia Duster',4,'Nazareth'),
	('Ha003',3,'2021-09-01','2021-09-06','2021-07-28 12:25:33:00','2021-09-01 18:30:31:00','הובלה ברכב Peugeot Boxer',5,'Eibillin'),
	('TV001',1,'2021-10-29','2021-11-01','2021-08-25 13:24:11:00','2021-10-29 14:12:33:00','הובלה ברכב Dacia Duster',2,'Baqa El Gharbeya'),
	('TV002',2,'2021-12-31','2022-01-02','2021-10-19 11:36:02:00','2021-12-31 07:36:22:00','הובלה ברכב Peugeot Boxer',6,'Nazareth'),
	('Ch001',2,'2022-02-02','2022-02-03','2021-11-14 09:33:08:00','2022-02-02 07:46:01:00','הובלה ברכב Peugeot Boxer',6,'Tarshiha'),
	('TV002',2,'2022-02-13','2022-02-15','2021-12-29 13:47:22:00','2022-02-13 07:00:56:00','הובלה ברכב Peugeot Boxer',5,'Nazareth'),
	('Ra002',1,'2022-02-19','2022-02-21','2022-01-16 20:52:10:00','2022-02-19 09:04:32:00','הובלה ברכב Peugeot Boxer',6,'Tiberias'),
	('TV002',2,'2022-02-28','2022-03-01','2022-01-30 13:41:02:00','2022-02-28 15:33:14:00','הובלה ברכב Peugeot Boxer',1,'Nazareth')
go

INSERT INTO Importers
VALUES(NULL,'Avi','אזור תעשייה','karmiel',0522369159,NULL,NULL),
	('Askol','Assaf',NULL,'Afula',0548963215,'www.askol.co.il','assaf@askol.co.il'),
	(NULL,'Wissam',NULL,'Ebillin',0543655632,NULL,NULL),
	('Halilet',NULL,'Hadar','Haifa',049863256,'www.Halilet.com',NULL)
go
INSERT INTO Equipments
VALUES('HK','Audio PR:O 112XD2','12 INCH Monitor Speaker - Speaker with Amplifier - 1200W','Germany',12,300,1),
	('HK','Audio PR:O 115XD','15 INCH Top Speaker - Speaker with Amplifie - 1200W','Germany',2,400,1),
	('HK','Polar 12','12 INCH - SUB with Column Speakers - 2000w','Germany',2,1000,1),
	('FBT','MUSE 218','NETWORKABLE ACTIVE LINE Dual 18 INCH - 4000W - Line Array Sub','Italy',4,1400,3),
	('FBT','MUSE 210LND','NETWORKABLE ACTIVE LINE Dual 10 INCH - 1200W - Line Array Top','Italy',8,1100,3),
	('FBT','StageMaxX 12Ma','12 INCH Monitor Speaker','Italy',3,300,3),
	('FBT','Mitus 215A','15 INCH - Top Speaker - Like Line Array Top','Italy',4,800,3),
	('Sennheiser','e935','Dynamic Microphone','Germany',4,160,2),
	('Shure','SM58','Dynamic Microphone','Mexico',11,160,4),
	('Shure','SM57A Beta','Dynamic Microphone','Mexico',3,150,4),
	('Shure','ULXD Beta 58','Wireless Dynamic Microphone','Mexico',1,900,4),
	('Behringer','B-5','Condencer Microphone','Germany',4,150,2),
	('Electro Voice','ND468','Dynamic Microphone','Minnesota',4,140,2),
	('Klark Teknik','DI 20P','Stereo','Philippines',5,110,2),
	('Electro Voice','RE20','Dynamic Microphone','Minnesota',1,170,2)
go
INSERT INTO [Rental Details]
VALUES(1,2,2,0.15),
	(1,1,5,0),
	(2,15,1,0),
	(3,11,1,0.10),
	(1,10,2,0.30),
	(4,6,3,0),
	(2,3,2,0),
	(5,4,2,0.05),
	(6,5,4,0),
	(7,7,2,0.05),
	(8,9,9,0.05),
	(5,8,4,0.30),
	(4,12,2,0.25),
	(2,13,3,0.40),
	(9,6,3,0.35),
	(10,14,4,0),
	(11,2,1,0),
	(12,7,4,0),
	(3,8,4,0),
	(13,9,10,0.35),
	(14,4,4,0.25),
	(15,5,4,0.15),
	(8,1,8,0.12),
	(16,3,2,0.13),
	(17,4,4,0),
	(18,2,2,0),
	(19,8,4,0.02),
	(2,5,6,0),
	(20,12,4,0.30),
	(21,15,1,0.20),
	(22,13,2,0.10),
	(23,4,2,0.15),
	(24,14,3,0.13),
	(25,4,4,0.15),
	(25,5,6,0.15)
go