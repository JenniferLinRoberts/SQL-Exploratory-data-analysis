# Exploratoty data analysis project.
# Using the cleaned data from a previous project to continue the data analysis process. 
# This is an open ended task with no clear beginning objectives.

SELECT * 
FROM layoffs_staging2
;

#Beginning by investigating the total_laid_off column 
SELECT MAX(total_laid_off) , MAX(percentage_laid_off)
FROM layoffs_staging2
;
#RETURNS 12000, 1 
# The highest persentage of laid off staff is 100% meaning an entire company was laid off. 
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC 
;
# returs the companies that lost all their employees. 

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;
#RETURNS the total ammount of employees each company laid off


SELECT MIN(`date`), MAX(`DATE`) 
FROM layoffs_staging2
;
#RETURNS the time period the data represens 2020-03-11 to 2023-03-06 which is from the beginning of the covid pandemic (for the US) till 3 years after. 

SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
;
#RETURNS consumer and retail were the hardest hit industrys where Fin-tec and manufacturing were the least impacted. 


SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;
#RERTURNS the US was the most impacted 

SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC
;


SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC
;












#rolling total layoffs 

SELECT SUBSTRING(`DATE`, 1,7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2 
WHERE SUBSTRING(`DATE`, 1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 asc
;


WITH Rolling_total AS 
(
SELECT SUBSTRING(`DATE`, 1,7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2 
WHERE SUBSTRING(`DATE`, 1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 asc
)
SELECT `month` , total_off
, SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_total
;





SELECT company, YEAR(`date`) ,SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company,YEAR( `date`)
ORDER BY 3 DESC
;


# The top 5 companies that laid off the most ammount of people per year
WITH company_year (Company, Years, Total_laid_off) AS
(
SELECT company, YEAR(`date`) ,SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company,YEAR( `date`)
ORDER BY 3 DESC
), Company_Year_Rank AS
(SELECT * , dense_rank() OVER (partition by years ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE Years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5
;


