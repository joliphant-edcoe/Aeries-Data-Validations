SELECT 
	STU.ID [StudentID],
	A1+A2+A3+A4+A5+A6 AS [Periods], 
	AL [All day], 
	'On '+ CONVERT(VARCHAR,DT,101) + ', the Period attendance is marked: ' + A1+A2+A3+A4+A5+A6 + ', but the All day code is '+ CASE WHEN AL = '' THEN 'blank' ELSE AL END AS [Description],
	* 
FROM 
	(SELECT * FROM ATT WHERE DEL = 0 ) [ATT] 
LEFT JOIN
	(SELECT * FROM STU WHERE DEL = 0 ) [STU]
	ON ATT.SC = STU.SC
	AND ATT.SN = STU.SN
WHERE 
	1=1
	AND ATT.SC = 69
	AND (AL = '' OR AL != A1) 
	AND LEN(A1+A2+A3+A4+A5+A6) = 6
	AND A1 IN ('S','U','X','A')
	AND A2 IN ('S','U','X','A')
	AND A3 IN ('S','U','X','A')
	AND A4 IN ('S','U','X','A')
	AND A5 IN ('S','U','X','A')
	AND A6 IN ('S','U','X','A')


--LIST ATT AL A1 A2 A3 A4 A5 A6 SN DT IF AL = ' '


/*
-- for use in Aeries
SELECT 
	STU.ID [StudentID],
	'On '+ CONVERT(VARCHAR,DT,101) + ', the Period attendance is marked: ' + A1+A2+A3+A4+A5+A6 + ', but the All day code is '+ CASE WHEN AL = '' THEN 'blank' ELSE AL END AS [Description]
FROM 
	(SELECT * FROM ATT WHERE DEL = 0 ) [ATT] 
LEFT JOIN
	(SELECT * FROM STU WHERE DEL = 0 ) [STU]
	ON ATT.SC = STU.SC
	AND ATT.SN = STU.SN
WHERE 
	1=1
	AND ATT.SC = @SchoolCode
	AND STU.ID IN (@StudentID)
	AND (AL = '' OR AL != A1) 
	AND LEN(A1+A2+A3+A4+A5+A6) = 6
	AND A1 IN ('S','U','X','A')
	AND A2 IN ('S','U','X','A')
	AND A3 IN ('S','U','X','A')
	AND A4 IN ('S','U','X','A')
	AND A5 IN ('S','U','X','A')
	AND A6 IN ('S','U','X','A')

*/