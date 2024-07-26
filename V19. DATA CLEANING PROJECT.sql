#DATA CLEANING

SELECT *
FROM layoffs; 

# 1 - REMOVE DUPES
# 2 - STANDARDIZE DATA
# 3 - NULL OR BLANK VALUES
# 4 - REMOVE ANY COLUMNS/ROWS THAT ARE UNNECESSARY

#CREATE STAGING TABLE TO KEEP RAW DATA INTACT
CREATE TABLE layoffs_staging
LIKE layoffs; 

SELECT *
FROM layoffs_staging; 

#INSERT DATA INTO STAGING TABLE
INSERT layoffs_staging
SELECT * 
FROM layoffs; 



# 1 - REMOVING DUPES
#CREATE STAGING TABLE TO KEEP RAW DATA INTACT
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging; 

#CREATE CTE TO HELP ID DUPES
WITH dupe_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM dupe_cte
WHERE row_num > 1; 

#CREATE ANOTHER STAGING TABLE TO ACTUALLY REMOVE DUPES
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2; 

#INSERT DATA INTO NEW STAGING TABLE
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging; 

SELECT *
FROM layoffs_staging2; 

#DELETE DUPES FROM NEW STAGING TABLE
DELETE
FROM layoffs_staging2
WHERE row_num > 1; 

SELECT *
FROM layoffs_staging2; 



#2 - STANDARDIZING DATA
UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2; 

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1; 

#FIX VARIATIONS OF 'CRYPTO'
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'; 

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'; 

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

#FIX VARIATIONS OF U.S. 
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%'; 

SELECT *
FROM layoffs_staging2; 

#CHANGE DATE FROM TEXT TO TIME SERIES
##DATE FORMAT
SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2; 

UPDATE layoffs_staging2
SET date = STR_TO_DATE(`date`, '%m/%d/%Y');

##DATE DATA TYPE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; 

SELECT *
FROM layoffs_staging2; 



#3 - NULL AND BLANK VALUES
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

#MAKE BLANK ENTRIES 'NULL'
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''; 

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'; 

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL; 

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL; 

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'; 

SELECT *
FROM layoffs_staging2; 



#4 - REMOVE COLUMNS/ROWS THAT ARE UNNECESSARY
###DELETE ROWS WHERE BOTH TOTAL AND %AGE LAID OF IS NULL
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

#DROP row_num COLUMN THAT'S NOT NEEDED ANYMORE
ALTER TABLE layoffs_staging2
DROP COLUMN row_num; 

SELECT *
FROM layoffs_staging2; 