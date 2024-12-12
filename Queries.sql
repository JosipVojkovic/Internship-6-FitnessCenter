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
	ELSE 'DOSTUPAN' END
FROM Trainers t

