-- for testing purposes
SELECT 
    STU.ID AS StudentID, 
    [STU].[AP1] AS [STU.AP1], 
    [ENR].[AP1] AS [ENR.AP1], 
    [ATT].[AP1] AS [ATT.AP1],
	TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[AP1]) = '' THEN 'AttPrgm1 code empty in the STU table; ' ELSE '' END,
			CASE WHEN TRIM([ENR].[AP1]) = '' THEN 'AttPrgm1 code empty in the ENR table; ' ELSE '' END,
			CASE WHEN TRIM([ATT].[AP1]) = '' THEN 'AttPrgm1 code empty in the ATT table; ' ELSE '' END,
			CASE WHEN STU.AP1 != ENR.AP1 THEN 'AttPrgm1 code does not match between STU and ENR tables; ' ELSE '' END,
			CASE WHEN ENR.AP1 != ATT.AP1 THEN 'AttPrgm1 code does not match between ENR and ATT tables; ' ELSE '' END,
			CASE WHEN ATT.AP1 != STU.AP1 THEN 'AttPrgm1 code does not match between ATT and STU tables; ' ELSE '' END,
			CASE WHEN STU.AP1 LIKE '[A-Za-z]%' OR ENR.AP1 LIKE '[A-Za-z]%' OR ATT.AP1 LIKE '[A-Za-z]%' 
				THEN 'AttPrgm1 code should not be a letter; use the numeric version instead; ' ELSE '' END
		)
	) AS [Description],
    STU.SC,
    STU.LN,
    STU.FN,
    STU.SX,
    STU.GR,
	ATT.RowNum1
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
					) AS RowNum1
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
					PARTITION BY ENR.ID ORDER BY ENR.ED DESC
					) AS RowNum 
        FROM ENR 
        WHERE DEL = 0
    ) ENR 
    ON [STU].[ID] = [ENR].[ID]
	AND [STU].[SC] = [ENR].[SC]
WHERE 
	1=1
    --NOT STU.TG > ' ' 
	AND (ATT.RowNum1 = 1 OR (ATT.RowNum1 IS NULL AND NOT STU.TG > '') OR (ATT.RowNum1 IS NOT NULL AND STU.TG > ''))
    AND (ENR.RowNum = 1 OR ENR.RowNum is null)
    AND STU.SC IN (68,69,70,72,73,51,100,101,150)  -- not relevant to school 61!
	AND (TRIM([STU].[AP1]) = '' 
	OR TRIM([ENR].[AP1]) = '' 
	OR TRIM([ATT].[AP1]) = '' 
	OR STU.AP1 != ENR.AP1 
	OR ENR.AP1 != ATT.AP1 
	OR ATT.AP1 != STU.AP1
	OR STU.AP1 LIKE '[A-Za-z]%'
	OR ENR.AP1 LIKE '[A-Za-z]%'
	OR ATT.AP1 LIKE '[A-Za-z]%'
	)
ORDER BY 
    STU.SC, STU.ID

/*
-- used in Aeries
SELECT 
    STU.ID AS StudentID, 
    TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[AP1]) = '' THEN 'AttPrgm1 code empty in the STU table; ' ELSE '' END,
			CASE WHEN TRIM([ENR].[AP1]) = '' THEN 'AttPrgm1 code empty in the ENR table; ' ELSE '' END,
			CASE WHEN TRIM([ATT].[AP1]) = '' THEN 'AttPrgm1 code empty in the ATT table; ' ELSE '' END,
			CASE WHEN STU.AP1 != ENR.AP1 THEN 'AttPrgm1 code does not match between STU and ENR tables; ' ELSE '' END,
			CASE WHEN ENR.AP1 != ATT.AP1 THEN 'AttPrgm1 code does not match between ENR and ATT tables; ' ELSE '' END,
			CASE WHEN ATT.AP1 != STU.AP1 THEN 'AttPrgm1 code does not match between ATT and STU tables; ' ELSE '' END,
			CASE WHEN STU.AP1 LIKE '[A-Za-z]%' OR ENR.AP1 LIKE '[A-Za-z]%' OR ATT.AP1 LIKE '[A-Za-z]%' 
				THEN 'AttPrgm1 code should not be a letter; use the numeric version instead; ' ELSE '' END
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
			ROW_NUMBER() OVER (PARTITION BY ATT.SC, ATT.SN ORDER BY ATT.DT DESC) AS RowNum1
        FROM ATT 
        WHERE DEL = 0 AND CD = 'E'
    ) ATT 
    ON [STU].[SC] = [ATT].[SC] 
    AND [STU].[SN] = [ATT].[SN]
LEFT JOIN 
    (
        SELECT 
            ENR.*, 
            ROW_NUMBER() OVER (PARTITION BY ENR.ID ORDER BY ENR.ED DESC) AS RowNum 
        FROM ENR 
        WHERE DEL = 0
    ) ENR 
    ON [STU].[ID] = [ENR].[ID]
	AND [STU].[SC] = [ENR].[SC]
WHERE 
    1=1
    --NOT STU.TG > ' ' 
	AND (ATT.RowNum1 = 1 OR (ATT.RowNum1 IS NULL AND NOT STU.TG > '') OR (ATT.RowNum1 IS NOT NULL AND STU.TG > ''))
	AND (ATT.RowNum1 = 1 OR ATT.RowNum1 is null)
    AND (ENR.RowNum = 1 OR ENR.RowNum is null)
    AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)
	AND (TRIM(STU.[AP1]) = '' 
		OR TRIM([ENR].[AP1]) = '' 
		OR TRIM([ATT].[AP1]) = '' 
		OR STU.AP1 != ENR.AP1 
		OR ENR.AP1 != ATT.AP1 
		OR ATT.AP1 != STU.AP1	
		OR STU.AP1 LIKE '[A-Za-z]%'
		OR ENR.AP1 LIKE '[A-Za-z]%'
		OR ATT.AP1 LIKE '[A-Za-z]%'
		)

*/