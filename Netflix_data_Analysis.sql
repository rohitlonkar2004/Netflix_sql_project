CREATE TABLE netflix (
show_id varchar(6),
type   varchar(10),
title  varchar(150),
director  varchar(208),
casts   varchar(1000),
country varchar(150),
date_added varchar(50),
release_year INT,
rating  varchar(10),
duration varchar(15),
listed_in varchar(100),
description varchar(250)
);

select * from  netflix;

--  15 business problem 

-- 1. Count number of Tvshow vs Movies 

SELECT 
     type,
     COUNT(*) as total_content
FROM netflix
GROUP BY type;

-- 2. Find the most common rating For movies and tv show 

SELECT 
    type,
	rating
FROM
(

SELECT
    type,
	 rating,
	 COUNT(*),
	 -- MAX(rating)
	 RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1,2
ORDER BY 1, 3 DESC

 ) as t1


 -- 3. List all movies released in  a specific year ( e.g 2000) 

 -- filter 2020
 -- movies

 SELECT * FROM netflix
 WHERE type = 'Movie'
 AND
  release_year = 2020

-- 4. Find the top 5 countries with the most content on  Netflix

SELECT 
   country,
   COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
 
SELECT
  UNNEST( STRING_TO_ARRAY(country , ',')) as new_country
FROM netflix


SELECT 
   UNNEST ( STRING_TO_ARRAY( country,',')) as new_country,
   COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
 


-- 5. Identify the longest movie ?

SELECT * FROM netflix
WHERE 
    type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix)


-- 6. Find content added in the last  5 year 

SELECT *
FROM netflix
WHERE
   TO_DATE(date_added , 'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 years'
SELECT CURRENT_DATE - INTERVAL '5 years'


 -- 7. Find all the movies/Tv shows by director 'rajiv chilaka'

 select* from netflix
 WHERE director = 'Binayak Das'

 -- better other   director name show 

 SELECT* FROM netflix
 WHERE title  = 'Stranger Things'

 SELECT * FROM  netflix
 WHERE director LIKE '%Rajiv Chilaka%'



 -- 8. list all Tv show with more than 5 sessions 
 
SELECT * FROM netflix
-- SPLIT_PART(duration , ' ', 1 ) as sessions
WHERE 
    type = 'TV Show'
	AND
	SPLIT_PART(duration ,' ', 1):: numeric  > 5


-- 9. Count the number of content item in each genre 

SELECT 
UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
    COUNT(show_id) as total_content
FROM  netflix 
GROUP BY 1

 -- 10. FIND each year and the avg number of content release by India on netflix.
  -- return top5 year wit highest avg content release 

 SELECT *FROM netflix
 WHERE country =  'India'
 


SELECT 
   EXTRACT(YEAR From TO_DATE(date_added, 'Month DD , YYYY')) as  year,
  COUNT(*)
  FROM netflix
   WHERE country = 'India'
   GROUP BY 1
 
-- avg 

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


--  11. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

-- 12  12. Find All Content Without a Director
SELECT * 
FROM netflix
WHERE director IS NULL;

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India


SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
  
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;



