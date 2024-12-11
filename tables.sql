CREATE TABLE FitnessCenters(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	WorkingTime VARCHAR(30)
)

CREATE TABLE Activities(
	Id SERIAL PRIMARY KEY,
	IdFitnessCenter INT REFERENCES FitnessCenters(Id),
	Type VARCHAR(30) NOT NULL CHECK(Type IN ('Snaga', 'Kardio', 'Yoga', 'Ples', 'Rehabilitacija')),
	Price DECIMAL NOT NULL CHECK(Price > 0)
)

CREATE TABLE Terms(
	Id SERIAL PRIMARY KEY,
	IdActivity INT REFERENCES Activities(Id),
	Date DATE NOT NULL DEFAULT CURRENT_DATE,
	MaxParticipants INT NOT NULL CHECK(MaxParticipants > 0)
)

CREATE TABLE Trainers(
	Id SERIAL PRIMARY KEY,
	IdCountry VARCHAR(30) NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL CHECK(BirthDate < CURRENT_DATE),
	Gender VARCHAR(30) NOT NULL CHECK(Gender IN ('Musko', 'Zensko', 'Nepoznato', 'Ostalo'))
)