CREATE TABLE countryRank AS 
  SELECT DISTINCT cont.name AS continent, r.name AS region, cn.area, cn.name AS name, cn.country_code3, 
                 CASE WHEN cn.national_day IS NULL THEN 'no data' 
                      WHEN cn.national_day > CURRENT_DATE THEN CURRENT_DATE 
                      ELSE cn.national_day END AS nday 
  FROM regions r JOIN region_areas ra ON r.name = ra.region_name 
                 JOIN countries cn ON r.region_id = cn.region_id 
                 JOIN (
    SELECT c.*, ca.cont_area from continents c JOIN (
      SELECT r.continent_id, SUM(ra.region_area) AS cont_area 
      FROM regions r JOIN region_areas ra ON r.name = ra.region_name 
      GROUP BY r.continent_id) ca 
    ON c.continent_id = ca.continent_id) cont 
  ON r.continent_id = cont.continent_id 
  ORDER BY cont.cont_area DESC, ra.region_area DESC, cn.area DESC;
ALTER TABLE countryRank ADD COLUMN rank INT AUTO_INCREMENT UNIQUE FIRST;