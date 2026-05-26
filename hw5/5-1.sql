---- Investigate Egg Variance

-- Step 0: Load original database.duckdb
duckdb data/database.duckdb

--- Step 1: Load big eggs and big nests into table
-- CREATE TABLE Nests_big AS SELECT * FROM 'data/nests_big.csv';
-- SELECT * FROM Nests_big LIMIT 3;

-- CREATE TABLE Eggs_big AS SELECT * FROM 'data/eggs_big.csv';
-- SELECT * FROM Eggs_big LIMIT 3;

--- Step 2: Join big tables to Species table
FROM Eggs_big
    JOIN Nests_big USING (Nest_ID)
    JOIN Species ON Nests_big.Species = Species.Code
    SELECT *
    WHERE Scientific_name = 'Calidris alpina';

--- Step 3: Calculate volume, save to view
CREATE VIEW Site_eggvol AS
    FROM Eggs_big
    JOIN Nests_big USING (Nest_ID)
    JOIN Species ON Nests_big.Species = Species.Code
    SELECT Site, ( (3.14/6) * Width^2 * Length ) AS Volume
    WHERE Scientific_name = 'Calidris alpina';

-- Step 4: Join with Site table for longtitude
FROM Site_eggvol
    JOIN Site ON Site_eggvol.Site = Site.Code
    SELECT Longitude, Volume;
    
FROM Site_eggvol
    JOIN Site ON Site_eggvol.Site = Site.Code
    SELECT MAX(Longitude), MIN(Longitude);


-- Step 5: Fix Longitude
CREATE VIEW Long_vol AS
FROM Site_eggvol
JOIN Site ON Site_eggvol.Site = Site.Code
    SELECT
        CASE WHEN Longitude > 0
        THEN Longitude - 360
        ELSE Longitude
        END AS Longitude, Volume;

FROM Long_vol SELECT MAX(Longitude), MIN(Longitude);

-- Step 6: Run stats
FROM Long_vol 
    SELECT REGR_SLOPE(Volume, Longitude) AS Slope, -- REGR_SLOPE(y,x), note order
    corr(Volume, Longitude) AS PCC;

---- Part 2:
1. Do the tables created automatically by DuckDB guarantee that a nest ID mentioned in the Eggs_big table actually exists in the Nests_big table? If yes, explain how that is guaranteed, if not, explain why not

No, the way we created the tables just copies the data from the eggs_big.csv. There are no foreign key constraints that are defined that would explicitly say that the nest_id in Eggs_big has to reference a nest_id in Nests_big.

2. What queries did you use (or could you use) to find the minimum and maximum longitude values in the Site table?

First, before the longitude fix:
FROM Site_eggvol
    JOIN Site ON Site_eggvol.Site = Site.Code
    SELECT MAX(Longitude), MIN(Longitude);

Second, to confirm the longitude fix:
FROM Long_vol SELECT MAX(Longitude), MIN(Longitude);


3. The interpretation of the Pearson correlation coefficient is: +1 is a perfect positive correlation, -1 is a perfect negative correlation, and 0 is no correlation at all. How would you characterize the correlation between egg volume and longitude for the eggs of Calidris alpina in the Arctic above Canada? 

-0.11, not a very strong correlation but it is negative. Meaning that as Longitude increases egg volume decreases.