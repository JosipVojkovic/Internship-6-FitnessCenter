CREATE TABLE FitnessCenters(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	WorkingTime VARCHAR(30)
)

CREATE TABLE Activities(
	Id SERIAL PRIMARY KEY,
	IdFitnessCenter INT REFERENCES FitnessCenters(Id),
	Name VARCHAR(50) NOT NULL,
	Type VARCHAR(30) NOT NULL CHECK(Type IN ('Snaga', 'Kardio', 'Yoga', 'Ples', 'Rehabilitacija')),
	Price DECIMAL NOT NULL CHECK(Price > 0)
)

CREATE TABLE Terms(
	Id SERIAL PRIMARY KEY,
	IdActivity INT REFERENCES Activities(Id),
	Date DATE NOT NULL DEFAULT CURRENT_DATE,
	MaxParticipants INT NOT NULL CHECK(MaxParticipants > 0)
)

CREATE TABLE Countries(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) UNIQUE NOT NULL,
	Population INT NOT NULL CHECK(Population > 0),
	AverageSalary DECIMAL NOT NULL CHECK(AverageSalary > 0)
)

CREATE TABLE Trainers(
	Id SERIAL PRIMARY KEY,
	IdCountry INT REFERENCES Countries(Id),
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL CHECK(BirthDate < CURRENT_DATE),
	Gender VARCHAR(30) NOT NULL CHECK(Gender IN ('Musko', 'Zensko', 'Nepoznato', 'Ostalo'))
)

CREATE TABLE TermTrainers(
	Id SERIAL PRIMARY KEY,
	IdTerm INT REFERENCES Terms(Id),
	IdTrainer INT REFERENCES Trainers(Id),
	Role VARCHAR(30) NOT NULL CHECK(Role IN ('Glavni', 'Pomocni'))
)

CREATE TABLE Users(
	Id SERIAL PRIMARY KEY,
	IdCountry INT REFERENCES Countries(Id),
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL CHECK(BirthDate < CURRENT_DATE)
)

CREATE TABLE TermUsers(
	Id SERIAL PRIMARY KEY,
	IdTerm INT REFERENCES Terms(Id),
	IdUser INT REFERENCES Users(Id),
	SignupDate DATE CHECK(SignupDate < CURRENT_DATE)
)