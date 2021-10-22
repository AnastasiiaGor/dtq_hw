CREATE TABLE countryRank AS
	SELECT ranked.rank, c.name AS continent, ranked.region_name, ranked.name, ranked.area, ranked.country_code3, ranked.nday 
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
	ORDER BY c.name, ranked.region_name, ranked.area DESC;