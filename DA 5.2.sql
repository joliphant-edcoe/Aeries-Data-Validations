-- for testing purposes
SELECT 
    STU.ID AS StudentID, 
    [STU].[SP] AS [STU.SP], 
    [ENR].[PR] AS [ENR.PR], 
    [ATT].[PR] AS [ATT.PR],
	TRIM(
		CONCAT(
			CASE WHEN TRIM(STU.[SP]) = '' THEN 'Program is empty on STU table; ' ELSE '' END,
			CASE WHEN TRIM(ENR.[PR]) = '' THEN 'Program is empty on ENR table; ' ELSE '' END,
			CASE WHEN TRIM(ATT.[PR]) = '' THEN 'Program is empty on ATT table; ' ELSE '' END,
			CASE WHEN STU.SP != ENR.PR THEN 'Program does not match between STU and ENR; ' ELSE '' END,
			CASE WHEN ENR.PR != ATT.PR THEN 'Program does not match between ENR and ATT; ' ELSE '' END,
			CASE WHEN ATT.PR != STU.SP THEN 'Program does not match between ATT and STU; ' ELSE '' END,
			CASE WHEN ((STU.SP NOT IN ('B','C') OR ENR.PR NOT IN ('B','C') OR ATT.PR NOT IN ('B','C')) 
				AND STU.SC != 100) THEN 'Program is not "B" or "C"; ' ELSE '' END,
			CASE WHEN ((STU.SP != 'A' OR ENR.PR != 'A' OR ATT.PR != 'A') 
				AND STU.SC = 100) THEN 'School=100, Program is not "A"; ' ELSE '' END,
			CASE WHEN DATEDIFF(DAY, STU.BD,GETDATE())/365.25 >= 12 AND STU.SP = 'B' 
				THEN CAST(DATEDIFF(DAY, STU.BD,GETDATE())/365.25 AS VARCHAR) + ' yrs old, yet in program B; ' ELSE '' END,
			CASE WHEN DATEDIFF(DAY, STU.BD,GETDATE())/365.25 < 12 AND STU.SP = 'C' 
				THEN CAST(DATEDIFF(DAY, STU.BD,GETDATE())/365.25 AS VARCHAR) + ' yrs old, yet in program C; ' ELSE '' END
		)
	) AS [Description],
	STU.BD AS [Birthday],
	DATEDIFF(DAY, STU.BD,GETDATE())/365.25 AS [Age],
    STU.*, 
    ENR.*, 
    ATT.*
FROM 
    (
        SELECT [STU].* 
        FROM STU 
        WHERE DEL = 0
    ) STU
LEFT JOIN 
    (
        SELECT 
			[ATT].*,
			ROW_NUMBER() OVER (
					PARTITION BY ATT.SC, ATT.SN ORDER BY ATT.DT DESC
					) AS RowNum1  -- most recent
        FROM ATT 
        WHERE DEL = 0 AND CD = 'E'
    ) ATT 
    ON [STU].[SC] = [ATT].[SC] 
    AND [STU].[SN] = [ATT].[SN]
LEFT JOIN 
    (
        SELECT 
            ENR.*, 
            ROW_NUMBER() OVER (
					PARTITION BY ENR.SC, ENR.ID ORDER BY ENR.ED DESC
					) AS RowNum    -- most recent
        FROM ENR 
        WHERE DEL = 0
    ) ENR 
    ON [STU].[ID] = [ENR].[ID]
	AND STU.SC = ENR.SC
WHERE 
    NOT STU.TG > ' ' 
	AND (ATT.RowNum1 = 1 OR ATT.RowNum1 is null)
    AND (ENR.RowNum = 1 OR ENR.RowNum is null)
    AND STU.SC IN (51,100,101,150)
	AND (TRIM(STU.[SP]) = '' 
		OR TRIM([ENR].[PR]) = '' 
		OR TRIM([ATT].[PR]) = '' 
		OR STU.SP != ENR.PR 
	    OR ENR.PR != ATT.PR 
		OR ATT.PR != STU.SP 
		OR (STU.SP NOT IN ('B','C') AND STU.SC != 100)
		OR (ENR.PR NOT IN ('B','C') AND STU.SC != 100) 
		OR (ATT.PR NOT IN ('B','C') AND STU.SC != 100)
		OR (STU.SP != 'A' AND STU.SC = 100)
		OR (ENR.PR != 'A' AND STU.SC = 100)
		OR (ATT.PR != 'A' AND STU.SC = 100)
	    OR (DATEDIFF(DAY, STU.BD,GETDATE())/365.25 >= 12 
			AND STU.SP = 'B' )
		OR (DATEDIFF(DAY, STU.BD,GETDATE())/365.25 < 12 
			AND STU.SP = 'C' ))
ORDER BY 
    STU.SC, STU.ID


/*

-- used in Aeries
SELECT 
    STU.ID AS StudentID, 
    TRIM(
		CONCAT(
			CASE WHEN TRIM(STU.[SP]) = '' THEN 'Program is empty on STU table; ' ELSE '' END,
			CASE WHEN TRIM(ENR.[PR]) = '' THEN 'Program is empty on ENR table; ' ELSE '' END,
			CASE WHEN TRIM(ATT.[PR]) = '' THEN 'Program is empty on ATT table; ' ELSE '' END,
			CASE WHEN STU.SP != ENR.PR THEN 'Program does not match between STU and ENR; ' ELSE '' END,
			CASE WHEN ENR.PR != ATT.PR THEN 'Program does not match between ENR and ATT; ' ELSE '' END,
			CASE WHEN ATT.PR != STU.SP THEN 'Program does not match between ATT and STU; ' ELSE '' END,
			CASE WHEN ((STU.SP NOT IN ('B','C') OR ENR.PR NOT IN ('B','C') OR ATT.PR NOT IN ('B','C')) 
				AND STU.SC != 100) THEN 'Program is not "B" or "C"; ' ELSE '' END,
			CASE WHEN ((STU.SP != 'A' OR ENR.PR != 'A' OR ATT.PR != 'A') 
				AND STU.SC = 100) THEN 'School=100, Program is not "A"; ' ELSE '' END,
			CASE WHEN DATEDIFF(DAY, STU.BD,GETDATE())/365.25 >= 12 AND STU.SP = 'B' 
				THEN CAST(DATEDIFF(DAY, STU.BD,GETDATE())/365.25 AS VARCHAR) + ' yrs old, yet in program B; ' ELSE '' END,
			CASE WHEN DATEDIFF(DAY, STU.BD,GETDATE())/365.25 < 12 AND STU.SP = 'C' 
				THEN CAST(DATEDIFF(DAY, STU.BD,GETDATE())/365.25 AS VARCHAR) + ' yrs old, yet in program C; ' ELSE '' END
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
			[ATT].*,
			ROW_NUMBER() OVER (
					PARTITION BY ATT.SC, ATT.SN ORDER BY ATT.DT DESC
					) AS RowNum1  -- most recent
        FROM ATT 
        WHERE DEL = 0 AND CD = 'E'
    ) ATT 
    ON [STU].[SC] = [ATT].[SC] 
    AND [STU].[SN] = [ATT].[SN]
LEFT JOIN 
    (
        SELECT 
            ENR.*, 
            ROW_NUMBER() OVER (
					PARTITION BY ENR.SC, ENR.ID ORDER BY ENR.ED DESC
					) AS RowNum    -- most recent
        FROM ENR 
        WHERE DEL = 0
    ) ENR 
    ON [STU].[ID] = [ENR].[ID]
	AND STU.SC = ENR.SC
WHERE 
    NOT STU.TG > ' ' 
	AND (ATT.RowNum1 = 1 OR ATT.RowNum1 is null)
    AND (ENR.RowNum = 1 OR ENR.RowNum is null)
    AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)
	AND (TRIM(STU.[SP]) = '' 
		OR TRIM([ENR].[PR]) = '' 
		OR TRIM([ATT].[PR]) = '' 
		OR STU.SP != ENR.PR 
	    OR ENR.PR != ATT.PR 
		OR ATT.PR != STU.SP 
		OR (STU.SP NOT IN ('B','C') AND STU.SC != 100)
		OR (ENR.PR NOT IN ('B','C') AND STU.SC != 100) 
		OR (ATT.PR NOT IN ('B','C') AND STU.SC != 100)
		OR (STU.SP != 'A' AND STU.SC = 100)
		OR (ENR.PR != 'A' AND STU.SC = 100)
		OR (ATT.PR != 'A' AND STU.SC = 100)
	    OR (DATEDIFF(DAY, STU.BD,GETDATE())/365.25 >= 12 AND STU.SP = 'B' )
		OR (DATEDIFF(DAY, STU.BD,GETDATE())/365.25 < 12 AND STU.SP = 'C' ))

*/
