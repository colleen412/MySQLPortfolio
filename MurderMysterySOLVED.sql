/*https://mystery.knightlab.com/

CRIME SCENE REPORT */
SELECT *
FROM crime_scene_report
WHERE date = 20180115 AND type = "murder" AND city = "SQL City";

/* FIRST WITNESS INFO */
SELECT *
FROM person
WHERE address_street_name = "Northwestern Dr"
ORDER BY address_number DESC
LIMIT 1; 

/* SECOND WITNESS INFO */
SELECT *
FROM person
WHERE name LIKE "Annabel%" AND address_street_name = "Franklin Ave"; 

/* FIRST WITNESS STATEMENT */
SELECT *
FROM interview
WHERE person_id = 14887;

/* SECOND WITNESS STATEMENT */
SELECT *
FROM interview
WHERE person_id = 16371;

/* FIRST WITNESS STATEMENT RESULTS - PART 1 */
SELECT *
FROM get_fit_now_member
WHERE id LIKE "48Z%" AND membership_status = "gold";

/* FIRST WITNESS STATEMENT RESULTS - PART 2 */
SELECT *
FROM drivers_license
WHERE plate_number LIKE "%H42W%"; 

/* SECOND WITNESS STATEMENT RESULTS */
SELECT *
FROM get_fit_now_check_in
WHERE check_in_date = 20180109 AND membership_id LIKE "48Z%";

/* CROSS REFERENCE RESULTS FROM THE 2 STMTS */
SELECT *
FROM person
WHERE license_id = 423327 OR license_id = 664760; 

/* "CHECK YOUR SOLUTION" */
INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
        SELECT value FROM solution;

/*Congrats, you found the murderer! 
But wait, there's more... 
If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. 
If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. 
Use this same INSERT statement with your new suspect to check your answer.*/

/*SUSPECT'S STMT*/
SELECT *
FROM interview
WHERE person_id = 67318; 

/*2 QUERIES BASED ON SUSPECT'S STMT*/
SELECT *
FROM drivers_license
WHERE gender  = "female" AND hair_color = "red" AND car_make = "Tesla";

SELECT person.name, income.annual_income, drivers_license.height, drivers_license.hair_color, drivers_license.car_make, drivers_license.car_model, facebook_event_checkin.event_name, facebook_event_checkin.date
FROM person
JOIN drivers_license
ON person.license_id = drivers_license.id
JOIN facebook_event_checkin
ON facebook_event_checkin.person_id = person.id
JOIN income
ON person.ssn = income.ssn
WHERE drivers_license.id = 202298 OR drivers_license.id = 291182 OR drivers_license.id = 918773;

/*Congrats, you found the brains behind the murder! 
Everyone in SQL City hails you as the greatest SQL detective of all time. 
Time to break out the champagne!*/
