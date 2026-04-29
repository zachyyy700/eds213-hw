-- Suppose you’re not sure what the AVG function returns if there are NULL values in the column being averaged. Suppose you either didn’t have access to any documentation, or didn’t trust it. What experiment could you run to find out what happens?

---- part 1
-- Construct an SQL experiment to determine the answer to the question above. Does SQL abort with some kind of error? Does it ignore NULL values? Do the NULL values somehow factor into the calculation, and if so, how?

-- create table with one column of REAL
CREATE TABLE numbers (
    col1 REAL
);

INSERT INTO numbers (col1)
VALUES (5), (5), (5), (5), (5);

INSERT INTO numbers (col1)
VALUES (NULL), (NULL);

SELECT * FROM numbers;

-- Run AVG function
SELECT AVG(col1) FROM numbers; -- returns 5: (25 / 5 = 5). AVG ignored NULLs in calculation.

-- if AVG factored NULLs in, perhaps instead of 25 / 5, it could've counted all the rows like this: 25 / 7, which is about 3.57.

---- part 2
-- If SQL didn’t have an AVG function, you could compute the average value of a column by doing something like this on your table:
-- SELECT SUM(mycolumn)/COUNT(*) FROM mytable;
-- SELECT SUM(mycolumn)/COUNT(mycolumn) FROM mytable;
-- Which query above is correct? Please explain why.

-- use numbers table to explore query options
SELECT SUM(col1)/COUNT(*) FROM numbers; -- returns 3.57, incorrect average of col1.

SELECT SUM(col1)/COUNT(col1) FROM numbers; -- returns 5.0, correct average col1.

-- the second query is correct, the difference in queries is the use of the * operator vs. naming the column in the COUNT function. After looking at documentation, COUNT(*) counts the total number of rows including NULL, leading to incorrect average. COUNT(col1) counts all non-NULL values in col1, this would be the correct query to calculate the average of a column.