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