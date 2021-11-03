
--create database Zoo_db
--use Zoo_db


create table Employee
(
	employeeID char(9) check(employeeID like replicate('[0-9]',9)) primary key,
	firstName nvarchar(20) check(len(firstName) >= 2) not null,
	lastName nvarchar(20) check(len(lastName) >= 2) not null,
	birthDate date check(birthDate <= getdate() and datediff(year, birthDate, getdate()) > 16) not null,
	phoneNumber char(10) check(phoneNumber like '05'+replicate('[0-9]',8)) not null,
	gender char(1) check(gender in ('M', 'F')) not null,
	salary real not null 
)

create table Food 
(
	foodID tinyint identity (1,1) primary key,
	foodName nvarchar(20) unique not null check(len(foodName) > 2),
	foodMatterState nvarchar(6) check(foodMatterState in ('liquid', 'solid')) not null
)


create table AnimalType 
(
	animalTypeID smallint identity (1,1) primary key,
	animalTypeName nvarchar(50) check(len(animalTypeName) > 2) not null,
	animalCategory nvarchar(13) check(animalCategory in ('Mammal', 'Bird', 'Reptile', 'Amphibian', 'Fish', 'Invertebrate', 'Bug'))	
)


create table Cage
(
	cageID smallint identity (100, 10) primary key,
	cageForDangerousAnimal BIT null,
	cageVolume decimal(4,1) check(cageVolume > 4.0) not null,
	cageMaterial nvarchar(5) check(cageMaterial like 'Wood' 
								or cageMaterial like 'Metal' 
								or cageMaterial like 'Stone') not null
)


create table Animal
(
	animalID smallint identity (1, 1) not null primary key,
	animalName nvarchar(20) check(len(animalName) >= 2) not null,
	animalBirthDate date check(animalBirthDate < getdate()) not null,
	animalWeight decimal(5,1) check(animalWeight > 0) not null,
	animalHeight decimal(3,2) check(animalHeight > 0 and animalHeight < 7.0) not null,
	animalGender char(1) check(animalGender  in ('M', 'F')) not null,
	animalIsDangerous BIT null,
	animalDescription nvarchar(255) null,
	animalTypeID smallint references AnimalType(animalTypeID) ON UPDATE CASCADE ON DELETE SET NULL, -- SET NULL because we would like to still have the data
	--animalType nvarchar(50) references AnimalType(animalTypeName) ON UPDATE CASCADE ON DELETE SET NULL, -- SET NULL because we would like to still have the data
	--animalFoodID tinyint references Food(foodID), -- pivot table
	--animalCageID smallint references Cage(cageID) -- pivot table
)


create table AnimalInCage
(
	animalID smallint references Animal(animalID) ON UPDATE CASCADE ON DELETE CASCADE,
	cageID smallint references Cage(cageID) ON UPDATE CASCADE ON DELETE CASCADE,

	primary key(animalID , cageID)
)

create table AnimalEatsFood
(
	animalID smallint references Animal(animalID) ON UPDATE CASCADE ON DELETE CASCADE,
	foodID tinyint references Food(foodID) ON UPDATE CASCADE ON DELETE CASCADE,

	primary key(animalID , foodID)
)


create table EmployeeCleanCage
(
	employeeID char(9) references Employee(employeeID) ON UPDATE CASCADE ON DELETE CASCADE,
	cageID smallint references Cage(cageID) ON UPDATE CASCADE ON DELETE CASCADE,
	
	startCleaningTime smalldatetime not null,
	endCleaningTime smalldatetime null,
	dryCleaning BIT null,

	primary key (employeeID, cageID, startCleaningTime)
)

--ALTER TABLE EmployeeCleanCage 
--DROP CONSTRAINT CK__EmployeeC__endCl__35BCFE0A;

--ALTER TABLE Employees ALTER COLUMN LastName NVARCHAR(25) NULL;

--alter table EmployeeCleanCage alter column endCleaningTime smalldatetime null;


create table Visitor
(
	visitorID int identity(1000,1) primary key,
	visitorFirstName varchar(40) not null,
	visitorLastName varchar(40) not null,
	visitorBirthDate date check(datediff(year, visitorBirthDate, getdate()) between 3 and 103) not null,
	visitorGender char(1) check(visitorGender in ('M','F')) not null,
)


create table VisitorMeetAnimal
(
	visitorID int references Visitor(visitorID),
	animalID smallint references Animal(animalID),
	visitDate date not null,
	primary key (visitorID, animalID, visitDate)
)
