#EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoffs_staging2; 

#TOTAL AND %AGE LAID OFF
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

#COMPANIES THAT LAID OFF EVERYONE
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC; 

#COMPANIES WITH THE MOST LAID OFF
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; 

#DATE RANGE OF LAYOFFS
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2; 

#INDUSTRIES WITH MOST LAID OFF
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC; 

#COUNTRIES WITH MOST LAID OFF
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC; 

#TOTAL LAYOFFS EACH YEAR
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC; 

#STAGE OF COMPANY AT TIME OF LAYOFFS
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; 

#ROLLING SUM OF LAYOFFS
WITH rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) as `ROLLING TOTAL`
FROM rolling_total; 

#COMPANY LAYOFFS PER YEAR
SELECT company, SUBSTRING(`date`, 1, 4) AS `YEAR`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `YEAR`
ORDER BY 1,2; 

#COMPANIES WITH MOST LAID OFF IN A YEAR
SELECT company, SUBSTRING(`date`, 1, 4) AS `YEAR`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `YEAR`
ORDER BY 3 DESC;  

#COMPANIES THAT LAID OFF THE MOST PEOPLE EACH YEAR
WITH company_year (company, years, total_laid_off) AS
(
SELECT company, SUBSTRING(`date`, 1, 4) AS `YEAR`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `YEAR`
), company_year_rank AS
(
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5
ORDER BY years ASC, ranking ASC;