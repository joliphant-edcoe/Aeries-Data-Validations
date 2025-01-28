SELECT
	ID [StudentID],
	CASE
		WHEN TRIM(CID) = '' THEN 'Student is missing a SSID number'
		ELSE ''
	END AS [Description],
	*
FROM 
	(SELECT STU.* 
	FROM STU 
	WHERE DEL = 0) STU
WHERE 
	1=1
	--AND SC IN (51,60,61,68,70,72,73,100,101,150)
	AND NOT TG > '' 
	AND TRIM(CID) = '' 


/*
SELECT
	ID [StudentID],
	CASE
		WHEN TRIM(CID) = '' THEN 'Student is missing a SSID number'
		ELSE ''
	END AS [Description],
	*
FROM 
	(SELECT STU.* 
	FROM STU 
	WHERE DEL = 0) STU
WHERE 1=1
	AND SC = @SchoolCode
	AND ID IN (@StudentID)
	AND NOT TG > '' 
	AND TRIM(CID) = ''
	
*/