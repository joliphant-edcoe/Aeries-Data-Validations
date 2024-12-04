-- for testing purposes
SELECT 
    [STU].[ID] AS StudentID, 
    [STU].[TR] AS [STU.TR], 
    [ENR].[TR] AS [ENR.TR], 
    [ATT].[TR] AS [ATT.TR],
	TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[TR]) = '' THEN 'Track is missing on STU table; ' ELSE '' END,
			CASE WHEN TRIM([ENR].[TR]) = '' THEN 'Track is missing on ENR table; ' ELSE '' END,
			CASE WHEN TRIM([ATT].[TR]) = '' THEN 'Track is missing on ATT table; ' ELSE '' END,
			CASE WHEN STU.TR != ENR.TR THEN 'Track does not match between STU and ENR tables; ' ELSE '' END,
			CASE WHEN ENR.TR != ATT.TR THEN 'Track does not match between ENR and ATT tables; ' ELSE '' END,
			CASE WHEN ATT.TR != STU.TR THEN 'Track does not match between ATT and STU tables; ' ELSE '' END
		)
	) AS [Description],
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
    AND STU.SC IN (68,69,70,72,73)  -- not relevant to school 61! charter does not use track
	AND (TRIM(STU.[TR]) = '' 
		OR TRIM([ENR].[TR]) = '' 
		OR TRIM([ATT].[TR]) = '' 
		OR STU.TR != ENR.TR 
		OR ENR.TR != ATT.TR 
		OR ATT.TR != STU.TR)
ORDER BY 
    STU.SC,STU.ID

/*

-- used in Aeries
SELECT 
    STU.ID AS StudentID, 
    TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[TR]) = '' THEN 'Track is missing on STU table; ' ELSE '' END,
			CASE WHEN TRIM([ENR].[TR]) = '' THEN 'Track is missing on ENR table; ' ELSE '' END,
			CASE WHEN TRIM([ATT].[TR]) = '' THEN 'Track is missing on ATT table; ' ELSE '' END,
			CASE WHEN STU.TR != ENR.TR THEN 'Track does not match between STU and ENR tables; ' ELSE '' END,
			CASE WHEN ENR.TR != ATT.TR THEN 'Track does not match between ENR and ATT tables; ' ELSE '' END,
			CASE WHEN ATT.TR != STU.TR THEN 'Track does not match between ATT and STU tables; ' ELSE '' END
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
	AND STU.ID in (@StudentID)
	AND (TRIM(STU.[TR]) = '' 
		OR TRIM([ENR].[TR]) = '' 
		OR TRIM([ATT].[TR]) = '' 
		OR STU.TR != ENR.TR 
		OR ENR.TR != ATT.TR 
		OR ATT.TR != STU.TR)

*/