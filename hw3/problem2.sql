---- Load in tables from .duckdb file
-- 1. From terminal
duckdb database.duckdb

-- OR

-- 2. Initilize duckdb in terminal then run:
ATTACH 'database.duckdb' AS db;
USE db;

---- part 1
-- What is wrong with the query: SELECT Site_name, MAX(Area) FROM Site;

SELECT Site_name, MAX(Area) FROM Site; -- "Binder Error: column "Site_name" must appear in the GROUP BY clause or must be part of an aggregate function."

-- aggregate functions like max, produces one value, one output row per group. However, Site_name has many values and SQL doesn't know which Site_name to show for that one result.

SELECT Site_name, MAX(Area) FROM Site GROUP BY Site_name; -- correct query to find the maximum area per site

---- part 2
-- Find the site name & area that has the largest area
SELECT Site_name, MAX(Area) AS Area FROM Site GROUP BY Site_name ORDER BY Area DESC LIMIT 1;

---- part 3
-- Complete the same task as part 2 but use a nested query
SELECT Site_name, Area FROM Site WHERE Area = (SELECT MAX(Area) FROM Site);