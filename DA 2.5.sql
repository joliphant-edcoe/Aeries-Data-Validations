-- for testing purposes (look at each table seperataly, then union them later
--STU table
SELECT 
    STU.ID AS StudentID, 
	TRIM(
		CONCAT(
			CASE WHEN STU.HS != STU.SC AND STU.HS != 0 THEN 'On Demographics page (2): Reporting Home School [STU.HS] = ' + CONVERT(VARCHAR,STU.HS) + ' does not match School [STU.SC] = ' + CONVERT(VARCHAR,STU.SC) + '; 'ELSE '' END,
			CASE WHEN STU.TG > '' THEN 'Student is Inactive, but had attendance during the year; ' ELSE '' END,
			''
		)
	) AS [Description]
FROM 
    (
        SELECT [STU].* 
        FROM STU 
        WHERE DEL = 0
    ) STU
INNER JOIN 
    (
        SELECT 
			[ATT].*
        FROM ATT 
        WHERE DEL = 0 AND CD = 'E'
    ) ATT 
    ON [STU].[SC] = [ATT].[SC] 
    AND [STU].[SN] = [ATT].[SN]
WHERE
	STU.HS != STU.SC AND STU.HS != 0


-- ATT table
UNION ALL


SELECT 
    STU.ID AS StudentID,
	TRIM(
		CONCAT(
			CASE WHEN ATT.HS != ATT.SC AND ATT.HS != 0 THEN 'On Attendance Enrollment page: RptgSchl [ATT.HS] = ' + CONVERT(VARCHAR,ATT.HS) + ' does not match School [ATT.SC] = ' + CONVERT(VARCHAR,ATT.SC) + '; 'ELSE '' END,
			CASE WHEN STU.TG > '' THEN 'Student is Inactive, but had attendance during the year; ' ELSE '' END,
			''
		)
	) AS [Description]
FROM 
    (
        SELECT [STU].* 
        FROM STU 
        WHERE DEL = 0
    ) STU
INNER JOIN 
    (
        SELECT 
			[ATT].*
        FROM ATT 
        WHERE DEL = 0 AND CD = 'E'
    ) ATT 
    ON [STU].[SC] = [ATT].[SC] 
    AND [STU].[SN] = [ATT].[SN]
WHERE
	1=1
	AND ATT.HS != ATT.SC AND ATT.HS != 0


--- ENR table
UNION ALL

SELECT 
    STU.ID AS StudentID, 
	TRIM(
		CONCAT(
			CASE WHEN ENR.HS != ENR.SC AND ENR.HS != 0 THEN 'On Enrollment History page: RptgSchl [ENR.HS] = ' + CONVERT(VARCHAR,ENR.HS) + ' does not match School [ENR.SC] = ' + CONVERT(VARCHAR,ENR.SC) + '; ' ELSE '' END,
			CASE WHEN STU.TG > '' THEN 'Student is Inactive, but probably should still be fixed; ' ELSE '' END,
			''
		)
	) AS [Description]
FROM 
    (
        SELECT [STU].* 
        FROM STU 
        WHERE DEL = 0
    ) STU
LEFT JOIN 
    (
        SELECT 
            ENR.*, 
            ROW_NUMBER() OVER (
					PARTITION BY ENR.SC, ENR.ID ORDER BY ENR.ED DESC
					) AS RowNum    -- most recent
        FROM ENR 
        WHERE DEL = 0
		AND YR = 2024
    ) ENR 
    ON [STU].[ID] = [ENR].[ID]
	AND STU.SC = ENR.SC
WHERE 
	1=1
	AND ENR.HS != ENR.SC AND ENR.HS != 0

ORDER BY StudentID

/*

-- used in Aeries
--STU table
SELECT 
    STU.ID AS StudentID, 
	TRIM(
		CONCAT(
			CASE WHEN STU.HS != STU.SC AND STU.HS != 0 THEN 'On Demographics page (2): Reporting Home School [STU.HS] = ' + CONVERT(VARCHAR,STU.HS) + ' does not match School [STU.SC] = ' + CONVERT(VARCHAR,STU.SC) + '; 'ELSE '' END,
			CASE WHEN STU.TG > '' THEN 'Student is Inactive, but had attendance during the year; ' ELSE '' END,
			''
		)
	) AS [Description]
FROM 
    (
        SELECT [STU].* 
        FROM STU 
        WHERE DEL = 0
    ) STU
INNER JOIN 
    (
        SELECT 
			[ATT].*
        FROM ATT 
        WHERE DEL = 0 AND CD = 'E'
    ) ATT 
    ON [STU].[SC] = [ATT].[SC] 
    AND [STU].[SN] = [ATT].[SN]
WHERE
	STU.HS != STU.SC AND STU.HS != 0
	AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)


-- ATT table
UNION ALL


SELECT 
    STU.ID AS StudentID,
	TRIM(
		CONCAT(
			CASE WHEN ATT.HS != ATT.SC AND ATT.HS != 0 THEN 'On Attendance Enrollment page: RptgSchl [ATT.HS] = ' + CONVERT(VARCHAR,ATT.HS) + ' does not match School [ATT.SC] = ' + CONVERT(VARCHAR,ATT.SC) + '; 'ELSE '' END,
			CASE WHEN STU.TG > '' THEN 'Student is Inactive, but had attendance during the year; ' ELSE '' END,
			''
		)
	) AS [Description]
FROM 
    (
        SELECT [STU].* 
        FROM STU 
        WHERE DEL = 0
    ) STU
INNER JOIN 
    (
        SELECT 
			[ATT].*
        FROM ATT 
        WHERE DEL = 0 AND CD = 'E'
    ) ATT 
    ON [STU].[SC] = [ATT].[SC] 
    AND [STU].[SN] = [ATT].[SN]
WHERE
	1=1
	AND ATT.HS != ATT.SC AND ATT.HS != 0
	AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)


--- ENR table
UNION ALL

SELECT 
    STU.ID AS StudentID, 
	TRIM(
		CONCAT(
			CASE WHEN ENR.HS != ENR.SC AND ENR.HS != 0 THEN 'On Enrollment History page: RptgSchl [ENR.HS] = ' + CONVERT(VARCHAR,ENR.HS) + ' does not match School [ENR.SC] = ' + CONVERT(VARCHAR,ENR.SC) + '; ' ELSE '' END,
			CASE WHEN STU.TG > '' THEN 'Student is Inactive, but probably should still be fixed; ' ELSE '' END,
			''
		)
	) AS [Description]
FROM 
    (
        SELECT [STU].* 
        FROM STU 
        WHERE DEL = 0
    ) STU
LEFT JOIN 
    (
        SELECT 
            ENR.*, 
            ROW_NUMBER() OVER (
					PARTITION BY ENR.SC, ENR.ID ORDER BY ENR.ED DESC
					) AS RowNum    -- most recent
        FROM ENR 
        WHERE DEL = 0
		AND YR = 2024
    ) ENR 
    ON [STU].[ID] = [ENR].[ID]
	AND STU.SC = ENR.SC
WHERE 
	1=1
	AND ENR.HS != ENR.SC AND ENR.HS != 0
	AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)


*/
