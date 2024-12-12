-- 1. Ime, prezime, spol (ispisati ‘MUŠKI’, ‘ŽENSKI’, ‘NEPOZNATO’, ‘OSTALO’),
--    ime države i prosječna plaća u toj državi za svakog trenera.
SELECT t.FirstName, t.LastName, t.Gender, c.Name, c.AverageSalary FROM Trainers t
JOIN Countries c ON t.IdCountry = c.Id

-- 2. Naziv i termin održavanja svake sportske igre zajedno s imenima glavnih trenera
--    (u formatu Prezime, I.; npr. Horvat, M.; Petrović, T.).
SELECT a.Name, t.Date, STRING_AGG(CONCAT(tr.Lastname, ', ', LEFT(tr.FirstName, 1)), '; ') AS HeadCoach 
FROM Terms t
JOIN Activities a ON a.Id = t.IdActivity
JOIN TermTrainers tt ON tt.IdTerm = t.Id
JOIN Trainers tr ON tt.IdTrainer = tr.Id
WHERE tt.Role = 'Glavni'
GROUP BY a.Name, t.Date

-- 3. Top 3 fitness centra s najvećim brojem aktivnosti u rasporedu
SELECT fc.Id, fc.Name, COUNT(a.Id) AS NumberOfActivities FROM FitnessCenters fc
JOIN Activities a ON a.IdFitnessCenter = fc.Id
GROUP BY fc.Id
ORDER BY NumberOfActivities DESC
LIMIT 3

-- 4. Po svakom terneru koliko trenutno aktivnosti vodi; ako nema aktivnosti,
--    ispiši “DOSTUPAN”, ako ima do 3 ispiši “AKTIVAN”, a ako je na više ispiši “POTPUNO ZAUZET”.

SELECT t.Id, t.FirstName, t.LastName, 
CASE
	WHEN(SELECT COUNT(*) FROM TermTrainers tt WHERE t.Id = tt.IdTrainer) > 3 THEN 'POTPUNO ZAUZET'
	WHEN(SELECT COUNT(*) FROM TermTrainers tt WHERE t.Id = tt.IdTrainer) > 0 THEN 'AKTIVAN'
	ELSE 'DOSTUPAN' END AS Status
FROM Trainers t

-- 5. Imena svih članova koji trenutno sudjeluju na nekoj aktivnosti.
SELECT DISTINCT u.Id, u.FirstName, u.LastName FROM Users u
JOIN TermUsers tu ON u.Id = tu.IdUser

-- 6. Sve trenere koji su vodili barem jednu aktivnost između 2019. i 2022.
SELECT DISTINCT tr.Id, tr.FirstName, tr.LastName FROM Trainers tr
JOIN TermTrainers tt ON tt.IdTrainer = tr.Id
JOIN Terms te ON te.Id = tt.IdTerm
WHERE te.Date BETWEEN '2022-01-01' AND '2024-01-01'
-- Nisam generirao termine sa datumom prije 2022 godine tako da sam ovaj upit napisao da gleda termine od 2022 do 2024

-- 7. Prosječan broj sudjelovanja po tipu aktivnosti po svakoj državi.
SELECT c.Name AS Country, a.Type AS TypeOfActivity, ROUND(AVG(NumOfParticipants), 2) AS AverageParticipation
FROM Countries c
JOIN Trainers tr ON tr.IdCountry = c.Id
JOIN TermTrainers tt ON tt.IdTrainer = tr.Id
JOIN Terms t ON t.Id = tt.IdTerm
JOIN Activities a ON a.Id = t.IdActivity
JOIN (
    SELECT IdTerm, COUNT(IdUser) AS NumOfParticipants
    FROM TermUsers
    GROUP BY IdTerm
) AS participants ON participants.IdTerm = t.Id
GROUP BY c.Name, a.Type

-- 8. Top 10 država s najvećim brojem sudjelovanja u injury rehabilitation tipu aktivnosti
SELECT c.Name, COUNT(u.Id) AS NumberOfParticipants FROM Countries c
JOIN Users u ON u.IdCountry = c.Id
JOIN TermUsers tu ON tu.IdUser = u.Id
JOIN Terms te ON te.Id = tu.IdTerm
JOIN Activities a ON a.Id = te.IdActivity
WHERE a.Type = 'Rehabilitacija'
GROUP BY c.Name
ORDER BY NumberOfParticipants DESC
LIMIT 10

-- 9. Ako aktivnost nije popunjena, ispiši uz nju “IMA MJESTA”, a ako je popunjena ispiši “POPUNJENO”
SELECT a.Name, a.Type,
CASE 
	WHEN COUNT(tu.IdUser) < te.MaxParticipants THEN 'IMA MJESTA'
	ELSE 'POPUNJENO' END AS Status
FROM Terms te
JOIN TermUsers tu ON tu.IdTerm = te.Id
LEFT JOIN Activities a ON a.Id = te.IdActivity
GROUP BY te.Id, a.Name, a.Type

-- 10. 10 najplaćenijih trenera, ako po svakoj aktivnosti dobije prihod kao brojSudionika * cijenaPoTerminu
SELECT tr.FirstName, tr.LastName, SUM(a.Price * Sub.NumOfParticipants) AS TotalRevenue
FROM Trainers tr
JOIN TermTrainers tt ON tt.IdTrainer = tr.Id
JOIN Terms te ON te.Id = tt.IdTerm
JOIN TermUsers tu ON tu.IdTerm = te.Id
JOIN Activities a ON a.Id = te.IdActivity
JOIN (
    SELECT tu.IdTerm, COUNT(tu.IdUser) AS NumOfParticipants
    FROM TermUsers tu
    GROUP BY tu.IdTerm
) Sub ON Sub.IdTerm = te.Id
GROUP BY tr.Id, a.Price
ORDER BY TotalRevenue DESC
LIMIT 10;