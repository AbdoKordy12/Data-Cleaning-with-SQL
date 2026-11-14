-- Data Cleaning
SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
(SELECT * FROM layoffs);
SELECT * FROM layoffs_staging;

-- 1.REMOVE DUPLICATES
-- 2.STANDARDIZE THE DATA
-- 3.NULL VALUES OR BLANK VALUES
-- 4.REMOVE ANY CLOUMNS

SELECT *, ROW_NUMBER() OVER(PARTITION BY company,industry,total_laid_off,percentage_laid_off,'date',country,stage) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(SELECT *, ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,country,stage,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * FROM duplicate_cte WHERE row_num>1;
CREATE TEMPORARY TABLE layoffs_with_row_num
(SELECT *, ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,country,stage,funds_raised_millions) AS row_num
FROM layoffs_staging
);
SELECT * FROM layoffs_with_row_num;
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
SELECT * FROM layoffs_staging2;
INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,country,stage,funds_raised_millions) AS row_num
FROM layoffs_staging;
SELECT * FROM layoffs_staging2;
DELETE
FROM layoffs_staging2
WHERE row_num>1;
SELECT * FROM layoffs_staging2;
SELECT * FROM layoffs_staging2
WHERE row_num=1;

-- Standardizing Data
SELECT * FROM layoffs_staging2;
UPDATE layoffs_staging2
SET company=TRIM(company);
SELECT company FROM layoffs_staging2;
UPDATE layoffs_staging2
SET industry='Crypto'
WHERE industry LIKE 'Crypto%';
SELECT * FROM layoffs_staging2;
SELECT location
FROM layoffs_staging2
ORDER BY location;
UPDATE layoffs_staging2
SET country='United States'
WHERE country='%United States.%';
SELECT country FROM layoffs_staging2;
UPDATE layoffs_staging2
SET country=TRIM(TRAILING '.' FROM country);
SELECT country FROM layoffs_staging2;
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;
UPDATE layoffs_staging2
SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y');
SELECT `date` FROM layoffs_staging2;
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; 

-- NULL VALUES OR BLANK VALUES
SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
OR total_laid_off ='';

SELECT * 
FROM layoffs_staging2
WHERE industry='' OR industry IS NULL;
SELECT * FROM layoffs_staging2
WHERE company="Airbnb";

SELECT * FROM layoffs_staging2 st1
JOIN layoffs_staging2 st2
    ON st1.company=st2.company AND st1.location=st2.location
WHERE (st1.industry IS NULL OR st1.industry='') AND (st2.industry IS NOT NULL AND st2.industry!='');
UPDATE layoffs_staging2 st1
JOIN layoffs_staging2 st2
    ON st1.company=st2.company AND st1.location=st2.location
SET st1.industry=st2.industry    
WHERE (st1.industry IS NULL OR st1.industry='') AND (st2.industry IS NOT NULL AND st2.industry!='');
-- REMOVE ANY COLUMNS
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
SELECT * FROM layoffs_staging2;

