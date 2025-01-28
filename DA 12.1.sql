-- all single track schools
-- 68 and 69 are the only multi track schools, really
SELECT 
	ATT.*,
	[DAY].*
FROM 
	(SELECT * FROM ATT WHERE DEL = 0) [ATT]
LEFT JOIN
	(SELECT * FROM [DAY] WHERE DEL = 0) [DAY]
	ON ATT.SC = [DAY].SC
	AND ATT.DY = [DAY].DY
WHERE 
	TRIM(AL) != ''
	AND [DAY].HO NOT IN ('','%')
	AND ATT.SC IN (
		51,  --CHSA
		70,  --SPED HIGH, track school but all the same?
		72,  --UMHS, only one track
		73  --ADULT    (shouldn't have any "A"s?)
	)
