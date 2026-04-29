--- Which sites have no egg data? Please answer this question using the two techniques demonstrated in class. In doing so, you will need to work with the Bird_eggs table, the Site table, or both. As a reminder, the techniques are:
-- Using a Code NOT IN (subquery) clause.
-- Using an outer join with a WHERE clause that selects the desired rows. Caution: make sure your IS NULL test is performed against a column that is not ordinarily allowed to be NULL. You may want to consult the database schema to remind yourself of column declarations.
duckdb database.duckdb

SELECT Code, Site_name FROM Site;

-- EXCEPT, (find sites that are missing in the bird eggs table)
SELECT DISTINCT Code FROM Site
    WHERE Code NOT IN (SELECT DISTINCT Site FROM Bird_eggs)
    ORDER BY Site;