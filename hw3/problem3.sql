-- Initialized by bash: duckdb database.duckdb

-- List the scientific names of bird species in descending order of their maximum average egg volumes. That is, compute the average volume of the eggs in each nest, and then for the nests of each species compute the maximum of those average volumes, and list by species in descending order of maximum volume

-- create table for average egg volumn for each Nest_ID in Bird_eggs table
CREATE TEMP TABLE Averages AS
    SELECT Nest_ID, AVG((3.14 / 6) * Width^2 * Length) AS Avg_volume
        FROM Bird_eggs
        GROUP BY Nest_ID;

-- join to Bird_nests table for species info, create new temp table
CREATE TEMP TABLE Species_max_avgvol AS
    SELECT Species, MAX(Avg_volume) AS Avg_volume
        FROM Bird_nests JOIN Averages USING (Nest_ID)
        GROUP BY Species;

-- join to Species table & query to sort order
SELECT Scientific_name, Avg_volume
    FROM Species_max_avgvol JOIN Species ON Species = code
    ORDER BY Avg_volume DESC;