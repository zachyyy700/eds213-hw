duckdb walkability.duckdb

-- INSTALL spatial;
LOAD spatial;
-- INSTALL httpfs;
LOAD httpfs;

-- initialize empty database
-- ATTACH 'walkability.duckdb';
-- USE walkability;

-- create fips table
CREATE TABLE Fips AS
    SELECT * FROM read_csv('https://apps.bren.ucsb.edu/eds213-data/walkability/fips_state_county.csv');

SELECT * FROM Fips WHERE State_name = 'HAWAII';

-- create walkability table for hawaii
CREATE TABLE Walkability_hi AS
    SELECT GEOID10, STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, CBSA, CBSA_Name, TotPop, NatWalkInd, geom_wgs84 
    FROM read_parquet('https://apps.bren.ucsb.edu/eds213-data/walkability/walkability_wgs84.parquet') 
    WHERE STATEFP = '15';

-- create view with joined data
CREATE VIEW Walkind_hi AS
    SELECT w.*, f.State_name, f.County_name FROM Walkability_hi w
    JOIN Fips f USING (STATEFP, COUNTYFP);

-- 1. one location: point in ala moana area has a walkability index of 17.5, pretty good, pretty accurate
SELECT NatWalkInd FROM Walkind_hi
    WHERE ST_WITHIN(st_point(-157.84706115855602, 21.29279375395358), geom_wgs84);

-- 2. one tract: tract that contains our point contains 7 block groups has avg walk index of 16.33
SELECT TRACTCE, COUNT(*) AS block_count, ROUND(AVG(NatWalkInd), 2) AS avg_walk_index
    FROM Walkind_hi
    WHERE TRACTCE = (
        SELECT TRACTCE FROM Walkind_hi
        WHERE ST_WITHIN(st_point(-157.84516919260497, 21.291637847455366), geom_wgs84)
    )
    GROUP BY TRACTCE;

-- 3. one county: Honolulu county has avg walk index of 12.0
SELECT COUNTYFP, County_name, COUNT(*) AS block_count, ROUND(AVG(NatWalkInd), 2) AS avg_walk_index
    FROM Walkind_hi
    WHERE County_name = (
        SELECT County_name FROM Walkind_hi
        WHERE ST_WITHIN(st_point(-157.84516919260497, 21.291637847455366), geom_wgs84)
    ) GROUP BY COUNTYFP, County_name;

-- My point location had the highest walkability when comparing it at the tract and county level. I picked one of my favorite places to hangout in and would say the area is pretty walkable. When aggregating to the tract level, the walkability didn't change much going from 17.5 to 16.33. However, when comparing to the whole county, walkability changed from 17.5 to 12.0, this was rather expected as I picked a very walkable location and do think that some places in the county would score rather bad in walkability, pulling the average down.

-- export table
-- original observations for tract of interest
SELECT *
    FROM Walkind_hi
    WHERE TRACTCE = (
        SELECT TRACTCE FROM Walkind_hi
        WHERE ST_WITHIN(st_point(-157.84516919260497, 21.291637847455366), geom_wgs84)
    );

-- create aggregated variable for tract
CREATE TEMP TABLE tract_agg AS
SELECT TRACTCE, ROUND(AVG(NatWalkInd), 2) AS avg_tract_index
    FROM Walkind_hi
    WHERE TRACTCE = (
        SELECT TRACTCE FROM Walkind_hi
        WHERE ST_WITHIN(st_point(-157.84516919260497, 21.291637847455366), geom_wgs84)
    ) GROUP BY TRACTCE;

-- create aggregated variable for county
CREATE TEMP TABLE county_agg AS
SELECT County_name, ROUND(AVG(NatWalkInd), 2) AS avg_county_index
    FROM Walkind_hi
    WHERE County_name = (
        SELECT County_name FROM Walkind_hi
        WHERE ST_WITHIN(st_point(-157.84516919260497, 21.291637847455366), geom_wgs84)
    ) GROUP BY County_name;

-- join temp tables to original observations
CREATE TABLE export_table AS
SELECT *
    FROM Walkind_hi
    JOIN tract_agg USING (TRACTCE)
    JOIN county_agg USING (County_name)
    WHERE TRACTCE = (
        SELECT TRACTCE FROM Walkind_hi
        WHERE ST_WITHIN(st_point(-157.84516919260497, 21.291637847455366), geom_wgs84)
    );

-- export table to csv
COPY export_table TO 'walk_export.csv';

-- After inspecting the csv, the geometry column was saved but as a varchar, I'm guessing the file is not a 'geo' file. Another file format like parquet, GeoJSON would have enabled to keep the geospatial encoding.