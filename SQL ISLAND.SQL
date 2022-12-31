/* https://sql-island.informatik.uni-kl.de/#

It seems there are a few people living in these villages. 
How can I see a list of all inhabitants? */

SELECT * 
FROM inhabitant;

/* Okay, let's see who is friendly on this island... */
SELECT * 
FROM inhabitant
WHERE state = "friendly";

/* There is no way around getting a sword for myself. 
I will now try to find a friendly weaponsmith to forge me one. */
SELECT * 
FROM inhabitant
WHERE state = "friendly" AND job = "weaponsmith";

/* Oh, that does not look good. 
Maybe other friendly smiths can help you out, e.g. a blacksmith. */
SELECT * 
FROM inhabitant
WHERE state = "friendly" AND job LIKE "%smith";

/* No need to call me stranger! What's my personid? */
SELECT personid 
FROM inhabitant
WHERE name = "Stranger";

/* I can offer to make you a sword for 150 gold. 
That's the cheapest you will find! How much gold do you have? */
SELECT gold
FROM inhabitant
WHERE personid = 20;

/* Maybe I could collect ownerless items and sell them! 
Can I make a list of all items that don't belong to anyone? */
SELECT *
FROM item
WHERE owner IS NULL;

/* Do you know a trick how to collect all the ownerless items? */
UPDATE item
SET owner = 20 
WHERE owner IS NULL;

/* Now list all of the items I have! */
SELECT *
FROM item
WHERE owner = 20

/* Find a friendly inhabitant who is either a dealer or a merchant. 
Maybe they want to buy some of my items. */
SELECT *
FROM inhabitant
WHERE state = "friendly" AND job = "dealer" OR job = "merchant";

/* I'd like to get the ring and the teapot. */
UPDATE item
SET owner = 15
WHERE item = "ring" OR item = "teapot"; 

/* Maybe it's not a bad idea to change my name from Stranger 
to my real name before I will apply for a job. */
UPDATE inhabitant
SET name = "Colleen O'Leary"
WHERE personid = 20;

/* (Look for Bakers to work for)*/
SELECT *
FROM inhabitant
WHERE job = "baker"
ORDER BY gold DESC;

/* Is there a pilot on this island by any chance? 
He could fly me home. */
SELECT *
FROM inhabitant
WHERE job = "pilot"; 

/* Thanks for the hint! 
I can use the join to find out the chief's name of the village 
Onionville. */
SELECT inhabitant.name
FROM village
JOIN inhabitant
WHERE village.villageid = inhabitant.villageid
AND village.name = "Onionville"
AND inhabitant.personid = village.chief;

/* Shall I tell you how many women there are in Onionville? */
SELECT COUNT(*)
FROM inhabitant
JOIN village
WHERE village.villageid = inhabitant.villageid
AND village.name = "Onionville"
AND gender = "f";

/* Oh, only one woman. What's her name? */
SELECT inhabitant.name
FROM inhabitant
JOIN village
WHERE village.villageid = inhabitant.villageid
AND village.name = "Onionville"
AND gender = "f";

/* I could earn more gold than the worth of gold inventories of 
all bakers, dealers and merchants together. 
How much gold is that? */
SELECT SUM(inhabitant.gold)
FROM inhabitant
WHERE job = "baker" OR job = "dealer" OR job = "merchant"; 

/* How much gold do different inhabitants have on average, 
depending on their state (friendly, ...)? */
SELECT state, AVG(inhabitant.gold) 
FROM inhabitant 
GROUP BY state 
ORDER BY AVG(inhabitant.gold);

/* What will you do next, Real Name? */
DELETE FROM inhabitant
WHERE name = "Dirty Diane";

/* Yeah! Now I release the pilot! */
UPDATE inhabitant 
SET state = "friendly" 
WHERE state = "kidnapped"; 