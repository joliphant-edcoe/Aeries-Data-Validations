-- for testing purposes
SELECT 
    [STU].[ID] AS StudentID, 
    [STU].[TR] AS [STU.TR], 
    [ENR].[TR] AS [ENR.TR], 
    [ATT].[TR] AS [ATT.TR],
	CONVERT(varchar,ATT.SC) + ATT.TR [schoolTrack],
	TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[TR]) = '' THEN 'Track is missing on STU table; ' ELSE '' END,
			CASE WHEN TRIM([ENR].[TR]) = '' THEN 'Track is missing on ENR table; ' ELSE '' END,
			CASE WHEN TRIM([ATT].[TR]) = '' THEN 'Track is missing on ATT table; ' ELSE '' END,
			CASE WHEN STU.TR != ENR.TR THEN 'Track does not match between STU and ENR tables; ' ELSE '' END,
			CASE WHEN ENR.TR != ATT.TR THEN 'Track does not match between ENR and ATT tables; ' ELSE '' END,
			CASE WHEN ATT.TR != STU.TR THEN 'Track does not match between ATT and STU tables; ' ELSE '' END,
			CASE WHEN (CONVERT(varchar,ATT.SC) + ATT.TR) NOT IN ('68A','68B','68C','68D','68E','68F','68G','68H','68I',
				'69A','69B','69C','69D','70A','70B','70C','70D','72A','73A') 
				THEN 'School-Track combination ' + CONVERT(varchar,ATT.SC) + ATT.TR + ' not valid.' ELSE '' END
		)
	) AS [Description],
	STU.TG,
	STU.SC,
    ATT.*
FROM 
    (
        SELECT [STU].* 
        FROM STU 
        WHERE DEL = 0
    ) STU
INNER JOIN   -- inner join with ATT, because we only care about students who have an ATT 'E'nter record 
    (
        SELECT 
			[ATT].*
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
    1=1
    AND (ENR.RowNum = 1 OR ENR.RowNum is null)  -- most recent ENR record is fine because it is not used for attendance accounting
    AND STU.SC IN (68,69,70,72,73)  -- not relevant to school 61! charter does not use track
	AND (TRIM(STU.[TR]) = '' 
		OR TRIM([ENR].[TR]) = '' 
		OR TRIM([ATT].[TR]) = '' 
		OR STU.TR != ENR.TR 
		OR ENR.TR != ATT.TR 
		OR ATT.TR != STU.TR
		OR (CONVERT(varchar,ATT.SC) + ATT.TR) NOT IN ('68A','68B','68C','68D','68E','68F','68G','68H','68I',
				'69A','69B','69C','69D','70A','70B','70C','70D','72A','73A')
		)
ORDER BY 
    STU.SC,STU.ID


/*

SELECT 
    [STU].[SC] AS [School], 
    [STU].[TR] AS [Track], 
	COUNT(*) AS [Enrolled]
FROM 
    (
        SELECT [STU].* 
        FROM STU 
        WHERE DEL = 0
    ) STU
WHERE 
	1=1
    --NOT STU.TG > ' ' 
    AND STU.SC IN (68,69,70,72,73)  -- not relevant to school 61! charter does not use track
GROUP BY
	STU.SC,STU.TR
ORDER BY 
    STU.SC,STU.TR


SELECT TR,* FROM STU WHERE SC = 68 and TR = ''

*/
/*

-- used in Aeries
SELECT 
    [STU].[ID] AS StudentID, 
	TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[TR]) = '' THEN 'Track is missing on STU table; ' ELSE '' END,
			CASE WHEN TRIM([ENR].[TR]) = '' THEN 'Track is missing on ENR table; ' ELSE '' END,
			CASE WHEN TRIM([ATT].[TR]) = '' THEN 'Track is missing on ATT table; ' ELSE '' END,
			CASE WHEN STU.TR != ENR.TR THEN 'Track does not match between STU and ENR tables; ' ELSE '' END,
			CASE WHEN ENR.TR != ATT.TR THEN 'Track does not match between ENR and ATT tables; ' ELSE '' END,
			CASE WHEN ATT.TR != STU.TR THEN 'Track does not match between ATT and STU tables; ' ELSE '' END,
			CASE WHEN (CONVERT(varchar,ATT.SC) + ATT.TR) NOT IN ('68A','68B','68C','68D','68E','68F','68G','68H','68I',
				'69A','69B','69C','69D','70A','70B','70C','70D','72A','73A') 
				THEN 'School-Track combination ' + CONVERT(varchar,ATT.SC) + ATT.TR + ' not valid.' ELSE '' END
		)
	) AS [Description]
FROM 
    (
        SELECT [STU].* 
        FROM STU 
        WHERE DEL = 0
    ) STU
INNER JOIN   -- inner join with ATT, because we only care about students who have an ATT 'E'nter record 
    (
        SELECT 
			[ATT].*
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
    1=1
    AND (ENR.RowNum = 1 OR ENR.RowNum is null)  -- most recent ENR record is fine because it is not used for attendance accounting
    AND STU.SC = @SchoolCode
	AND STU.ID in (@StudentID)
	AND (TRIM(STU.[TR]) = '' 
		OR TRIM([ENR].[TR]) = '' 
		OR TRIM([ATT].[TR]) = '' 
		OR STU.TR != ENR.TR 
		OR ENR.TR != ATT.TR 
		OR ATT.TR != STU.TR
		OR (CONVERT(varchar,ATT.SC) + ATT.TR) NOT IN ('68A','68B','68C','68D','68E','68F','68G','68H','68I',
				'69A','69B','69C','69D','70A','70B','70C','70D','72A','73A')
		)

*/