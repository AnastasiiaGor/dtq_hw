CREATE TABLE countryRank AS
	SELECT ranked.rank, c.name AS continent, ranked.region_name, ranked.name, ranked.area, ranked.country_code3, MIN(ranked.nday) AS nday
	FROM continents c JOIN (
    	    SELECT *, RANK() OVER(PARTITION BY rc.region_name ORDER BY rc.area DESC) rank 
    	    FROM (
        	SELECT DISTINCT r.name AS region_name, cn.name, cn.area, cn.country_code3, 
                CASE WHEN cn.national_day IS NULL THEN 'no data' 
                    WHEN cn.national_day > CURRENT_DATE THEN CURRENT_DATE                
                    ELSE cn.national_day END AS nday, r.continent_id 
        	FROM regions r JOIN region_areas ra ON r.name = ra.region_name 
                       	   JOIN countries cn ON cn.region_id = r.region_id 
    	    ORDER BY cn.area DESC) rc) ranked ON c.continent_id = ranked.continent_id 
        GROUP BY ranked.name
	ORDER BY c.name, ranked.region_name, ranked.area DESC;

-- Check duplicates by country name

SELECT cr.name FROM countryRank cr INNER JOIN (
  SELECT cr.name, COUNT(*)
  FROM countryRank cr
  GROUP BY cr.name
  HAVING COUNT(*) >= 2
) AS dupl ON cr.name = dupl.name;

-- Check NULL

SELECT cr.name FROM countryRank cr INNER JOIN (
  SELECT *
  FROM countryRank cr
  WHERE cr.continent IS NULL OR cr.region_name IS NULL OR cr.area IS NULL OR cr.country_code3 IS NULL OR cr.nday IS NULL
) AS n ON cr.name = n.name