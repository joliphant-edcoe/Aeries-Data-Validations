-- for testing purposes
SELECT 
    STU.ID AS StudentID, 
    [STU].[AP1] AS [STU.AP1], 
    [ENR].[AP1] AS [ENR.AP1], 
    [ATT].[AP1] AS [ATT.AP1],
	CASE 
		WHEN TRIM([STU].[AP1]) = '' THEN 'AttPrgm1 code empty in the STU table'
		WHEN TRIM([ENR].[AP1]) = '' THEN 'AttPrgm1 code empty in the ENR table'
		WHEN TRIM([ATT].[AP1]) = '' THEN 'AttPrgm1 code empty in the ATT table'
		WHEN STU.AP1 != ENR.AP1 THEN 'AttPrgm1 code does not match between STU and ENR tables'
		WHEN ENR.AP1 != ATT.AP1 THEN 'AttPrgm1 code does not match between ENR and ATT tables'
		WHEN ATT.AP1 != STU.AP1 THEN 'AttPrgm1 code does not match between ATT and STU tables'
		ELSE ''
    END AS [Description], 
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
    NOT STU.TG > ' ' 
	AND (ATT.RowNum1 = 1 OR ATT.RowNum1 is null)
    AND (ENR.RowNum = 1 OR ENR.RowNum is null)
    AND STU.SC IN (68,69,70,72,73,51,100,101,150)  -- not relevant to school 61!
	AND (TRIM([STU].[AP1]) = '' 
	OR TRIM([ENR].[AP1]) = '' 
	OR TRIM([ATT].[AP1]) = '' 
	OR STU.AP1 != ENR.AP1 
	OR ENR.AP1 != ATT.AP1 
	OR ATT.AP1 != STU.AP1)
ORDER BY 
    STU.SC, STU.ID


/*
select * from ATT
where SN = 1043 --1046
and CD = 'E'


select * from STU
where (NOT STU.TG > ' ') and GR = -2
*/

/*
select * from STU
where sc = 61

select * from ENR
where id = 6100547
order by ed desc

select * from ATT
where SN = 655
and CD = 'E'

*/

/*
-- used in Aeries
SELECT 
    STU.ID AS StudentID, 
    CASE 
		WHEN TRIM([STU].[AP1]) = '' THEN 'AttPrgm1 code empty in the STU table'
		WHEN TRIM([ENR].[AP1]) = '' THEN 'AttPrgm1 code empty in the ENR table'
		WHEN TRIM([ATT].[AP1]) = '' THEN 'AttPrgm1 code empty in the ATT table'
		WHEN STU.AP1 != ENR.AP1 THEN 'AttPrgm1 code does not match between STU and ENR tables'
		WHEN ENR.AP1 != ATT.AP1 THEN 'AttPrgm1 code does not match between ENR and ATT tables'
		WHEN ATT.AP1 != STU.AP1 THEN 'AttPrgm1 code does not match between ATT and STU tables'
		ELSE ''
    END AS [Description]
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
    NOT STU.TG > ' ' 
	AND ATT.RowNum1 = 1
    AND ENR.RowNum = 1 
    AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)
	AND (TRIM(STU.[AP1]) = '' 
		OR TRIM([ENR].[AP1]) = '' 
		OR TRIM([ATT].[AP1]) = '' 
		OR STU.AP1 != ENR.AP1 
		OR ENR.AP1 != ATT.AP1 
		OR ATT.AP1 != STU.AP1)

*/