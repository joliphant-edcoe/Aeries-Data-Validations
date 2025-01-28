SELECT 
	STU.ID [StudentID],
	STU.LN + ', ' + STU.FN + ' has a "A" absence code on ' + CONVERT(VARCHAR,ATT.DT,101) [Description],
	STU.SC,
	ATT.AL
FROM 
	(SELECT * FROM ATT WHERE DEL = 0) [ATT] 
LEFT JOIN 
	(SELECT * FROM STU WHERE DEL = 0) [STU]
	ON ATT.SC = STU.SC
	AND ATT.SN = STU.SN
WHERE 
	1=1
	AND TRIM(AL) = 'A' 
ORDER BY
	STU.SC,STU.ID


/*
-- in Aeries

SELECT 
	STU.ID [StudentID],
	STU.LN + ', ' + STU.FN + ' has a "A" absence code on ' + CONVERT(VARCHAR,ATT.DT,101) [Description]
FROM 
	(SELECT * FROM ATT WHERE DEL = 0) [ATT] 
LEFT JOIN 
	(SELECT * FROM STU WHERE DEL = 0) [STU]
	ON ATT.SC = STU.SC
	AND ATT.SN = STU.SN
WHERE 
	1=1
	AND TRIM(AL) = 'A' 
	AND STU.ID IN (@StudentID)
	AND STU.SC = @SchoolCode

*/