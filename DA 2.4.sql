/*
select sc, it, sp, count(*) 
from stu 
where del = 0 
and not tg > '' 
group by sc, sp, it 
order by sc, sp, it
*/
WITH data AS (
	SELECT 
		CASE
			WHEN SC IN (51,100,101,150) THEN
				CASE 
					WHEN IT != 5 AND SP = 'C' THEN 'Charter students in Program C should have a Transfer code of 6' 
					WHEN IT != 6 AND SP IN ('A','B') THEN 'Charter students in Program A/B should have a Transfer code of 5'
					WHEN TRIM(IT) = '' THEN 'Transfer code must be populated for all students'
					ELSE ''
				END
			WHEN SC in (60,61,68,69,70,72,73) THEN
				CASE 
					WHEN IT != 6 THEN 'For SPED regional programs, Transfer code should always be 6'
					ELSE ''
				END
			ELSE ''
		END [Description],
		SC [School],
		IT [Transfer code],
		SP [Program],
		SC,LN,FN,SX,GR
	FROM 
		(SELECT * FROM STU WHERE DEL = 0) [STU]
	WHERE 
		1=1
		AND NOT TG > ''
) 
SELECT * FROM data WHERE Description != ''

/*

-- for Aeries
WITH data AS (
	SELECT 
		STU.ID [StudentID],
		STU.SC [SchoolCode],
		CASE
			WHEN SC IN (51,100,101,150) THEN
				CASE 
					WHEN IT != 5 AND SP = 'C' THEN 'Charter students in Program C should have a Transfer code of 6' 
					WHEN IT != 6 AND SP IN ('A','B') THEN 'Charter students in Program A/B should have a Transfer code of 5'
					WHEN TRIM(IT) = '' THEN 'Transfer code must be populated for all students'
					ELSE ''
				END
			WHEN SC in (60,61,68,69,70,72,73) THEN
				CASE 
					WHEN IT != 6 THEN 'For SPED regional programs, Transfer code should always be 6'
					ELSE ''
				END
			ELSE ''
		END [Description],
		*
	FROM 
		(SELECT * FROM STU WHERE DEL = 0) [STU]
	WHERE 
		1=1
		AND NOT TG > ''
) 
SELECT ID [StudentID], Description 
FROM data 
WHERE 
	Description != '' 
	AND ID IN (@StudentID) 
	AND SC = @SchoolCode

*/