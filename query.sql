-- Case information
SELECT DISTINCT *
FROM crime_scene_report
WHERE date = 20180115 
AND city LIKE 'Insight City'
AND type LIKE 'murder';

-- Witness 1: Morty Schapiro (id: 14887)
SELECT TOP 1 *
FROM person
WHERE address_street_name LIKE 'Northwestern Dr'
ORDER BY address_number DESC

-- Witness 2: Annabel Miller (id: 16371)
SELECT *
FROM person
WHERE name LIKE '%Annabel%'
AND address_street_name LIKE 'Franklin Ave'

-- The testimony of 2 witnesses:
SELECT DISTINCT p.name, i.transcript
FROM interview i
JOIN person p ON i.person_id = p.id
WHERE p.id IN (14887,16371);

-- Find a gym member with a code starting with "48z", a golden member and go for the gym on January 9, 2018
SELECT DISTINCT m.id, m.person_id, m.name, c.check_in_date, c.check_in_time, c.check_out_time
FROM get_fit_now_member m
JOIN get_fit_now_check_in c ON m.id = c.membership_id
WHERE m.id LIKE '48Z%'
AND m.membership_status LIKE 'gold'
AND c.check_in_date = 20180109;

-- Find a car owner with a license plate containing "H42W"
SELECT p.*, d.plate_number
FROM person p
JOIN drivers_license d ON p.license_id = d.id
WHERE d.plate_number LIKE '%H42W%';

-- Find the perpetrator information
SELECT DISTINCT p.id, p.name, p.license_id, d.plate_number, m.id as member_id, m.membership_status
FROM person p
JOIN drivers_license d ON p.license_id = d.id
JOIN get_fit_now_member m ON p.id = m.person_id
JOIN get_fit_now_check_in c ON m.id = c.membership_id
WHERE m.id LIKE '48Z%'
AND m.membership_status LIKE 'gold'
AND d.plate_number LIKE '%H42W%'
AND c.check_in_date = 20180109;
-- We found the perpetrator name 'Jeremy Bowers'

-- Look up the testimony of the perpetrator Jeremy Bowers to find out the mastermind
SELECT DISTINCT i.transcript
FROM interview i
JOIN person p ON i.person_id = p.id
JOIN drivers_license d ON p.license_id = d.id
JOIN get_fit_now_member m ON p.id = m.person_id
JOIN get_fit_now_check_in c ON m.id = c.membership_id
WHERE m.id LIKE '48Z%'
AND m.membership_status LIKE 'gold'
AND d.plate_number LIKE '%H42W%'
AND c.check_in_date = 20180109;

/* 
Find the mastermind with the testimony that found above:
"I was hired by a woman with a lot of money. 
I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
She has red hair and she drives a Tesla Model S. 
I know that she attended the SQL Symphony Concert 3 times in December 2017."  
*/

-- The mastermind has red hair and she drives a Tesla Model S and body information around 5'5" (65") or 5'7" (67")
SELECT *
FROM person
WHERE license_id IN (
    SELECT id
    FROM drivers_license
    WHERE height BETWEEN 65 AND 67
    AND hair_color = 'red'
    AND car_make = 'Tesla'
    AND car_model = 'Model S'
    AND gender = 'female'
)

-- The mastermind is a woman with a lot of money.
SELECT DISTINCT p.*, i.annual_income
FROM person p, income i
WHERE p.ssn = i.ssn
AND p.license_id IN (
    SELECT id
    FROM drivers_license
    WHERE height BETWEEN 65 AND 67
    AND hair_color = 'red'
    AND car_make = 'Tesla'
    AND car_model = 'Model S'
    AND gender = 'female'
)
ORDER BY i.annual_income DESC

-- The mastermind attended the SQL Symphony Concert 3 times in December 2017.
SELECT person_id, COUNT(*) AS event_count
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
AND date BETWEEN 20171201 AND 20171231
GROUP BY person_id
HAVING COUNT(*) = 3

-- After querying, the mastermind is Miranda Priestly with id = 99716