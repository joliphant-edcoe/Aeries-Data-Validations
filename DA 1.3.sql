SELECT 
	STU.ID [StudentID],
	CASE 
		WHEN STU.LF IN ('E','F','L','R','T') THEN ' This EL code: '+ CONVERT(VARCHAR,STU.LF) + ' - ' + COD.DE +' is deprecated, please review and convert to the updated codes.'	
		ELSE 'Student in Grade ' + CONVERT(VARCHAR,STU.GR) + ' is marked as ' + CONVERT(VARCHAR,STU.LF) + ' - ' + COD.DE + ' which is invalid.' 
	END [Description], 
	STU.TG, 
	* 
FROM
	(SELECT * FROM STU WHERE DEL = 0) [STU]
LEFT JOIN 
	(SELECT * FROM COD WHERE DEL = 0 AND TC = 'STU' AND FC = 'LF') [COD]
	ON STU.LF = COD.CD
WHERE
	1=1
	AND STU.SC IN (60,61,68,69,70,72,73) 
	AND ((CONVERT(VARCHAR,STU.LF) NOT IN ('1','5','') AND STU.GR IN (16,17))
		OR (CONVERT(VARCHAR,STU.LF) IN ('E','F','L','R','T') AND STU.SC != 999))


/*
SELECT 
	STU.ID [StudentID],
	CASE 
		WHEN STU.LF IN ('E','F','L','R','T') THEN ' This EL code:'+ CONVERT(VARCHAR,STU.LF) + ' - ' + COD.DE +' is deprecated, please review and convert to the updated codes.'	
		ELSE 'Student in Grade ' + CONVERT(VARCHAR,STU.GR) + ' is marked as ' + CONVERT(VARCHAR,STU.LF) + ' - ' + COD.DE + ' which is invalid.' 
	END [Description]
FROM
	(SELECT * FROM STU WHERE DEL = 0) [STU]
LEFT JOIN 
	(SELECT * FROM COD WHERE DEL = 0 AND TC = 'STU' AND FC = 'LF') [COD]
	ON STU.LF = COD.CD
WHERE
	1=1
	AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)
	AND ((CONVERT(VARCHAR,STU.LF) NOT IN ('1','5','') AND STU.GR IN (16,17))
		OR (CONVERT(VARCHAR,STU.LF) IN ('E','F','L','R','T')))
*/

