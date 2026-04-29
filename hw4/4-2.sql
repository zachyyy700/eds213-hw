--- The Camp_assignment table lists where each person worked and when. Your goal is to answer, Who worked with whom? That is, you are to find all pairs of people who worked at the same site, and whose date ranges overlap while at that site. This can be solved using a self-join.

duckdb database.duckdb

SELECT * FROM Camp_assignment;

-- start with self-join, using conditions to find overlapping workers
SELECT A.Site AS Site, A.Observer AS Observer_1, B.Observer AS Observer_2
    FROM Camp_assignment A, Camp_assignment B
        WHERE A.Site = B.Site
        -- AND A.Site = 'lkri'
        AND (A.Start <= B.End AND A.End >= B.Start)
        AND A.Observer < B.Observer;

-- Bonus
SELECT * FROM Personnel;

WITH friends AS 
    (SELECT A.Site AS Site, A.Observer AS Observer_1, B.Observer AS Observer_2
        FROM Camp_assignment A, Camp_assignment B
            WHERE A.Site = B.Site
            AND A.Site = 'lkri'
            AND (A.Start <= B.End AND A.End >= B.Start)
            AND A.Observer < B.Observer)
SELECT Site, p1.Name AS Name_1, p2.Name AS Name_2
    FROM friends
    LEFT JOIN Personnel AS p1 ON friends.Observer_1 = p1.Abbreviation
    LEFT JOIN Personnel AS p2 ON friends.Observer_2 = p2.Abbreviation;