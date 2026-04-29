-- You receive an urgent phone call from a colleague who says they just discovered that an observer, who worked at the “nome” site between 1998 and 2008 inclusive, had been floating eggs in salt water and not freshwater. The density of salt water being different, those measurements are incorrect and need to be adjusted. The colleague says that this incorrect technique was used on exactly 36 nests, but before you can ask who the observer was, the phone is disconnected. Who made this error?

duckdb database.duckdb

-- join Bird_nests to Personnel & get counts
SELECT Name, COUNT(Observer) as Count FROM Bird_nests
    JOIN Personnel ON Bird_nests.Observer = Personnel.Abbreviation -- Filter with WHERE after JOIN
    GROUP BY Name; -- can use HAVING after GROUPBY to get exact nest count 

SELECT Name, COUNT(Observer) as Num_floated_nests FROM Bird_nests
    JOIN Personnel ON Bird_nests.Observer = Personnel.Abbreviation
    WHERE (Year >= 1998 AND Year <= 2008)
    AND Site = 'nome' AND ageMethod = 'float'
    GROUP BY Name HAVING Num_floated_nests = 36;

-- Culprit: Emilie D'Astrous, 36 Num_floated nests