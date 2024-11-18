-- for testing purposes
SELECT 
    STU.ID AS StudentID, 
    [STU].[SP] AS [STU.SP], 
    [ENR].[PR] AS [ENR.PR], 
    [ATT].[PR] AS [ATT.PR],
    CASE 
		WHEN TRIM(STU.[SP]) = '' THEN 'Program is empty on STU table'
		WHEN TRIM(ENR.[PR]) = '' THEN 'Program is empty on ENR table'
		WHEN TRIM(ATT.[PR]) = '' THEN 'Program is empty on ATT table'
		WHEN STU.SP NOT IN ('N','M','S') THEN 'Program is not "N","M" or "S"'
		WHEN ENR.PR NOT IN ('N','M','S') THEN 'Program is not "N","M" or "S"'
		WHEN ATT.PR NOT IN ('N','M','S') THEN 'Program is not "N","M" or "S"'
		WHEN STU.SP != ENR.PR THEN 'Program does not match between STU and ENR'
		WHEN ENR.PR != ATT.PR THEN 'Program does not match between ENR and ATT'
		WHEN ATT.PR != STU.SP THEN 'Program does not match between ATT and STU'
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
	AND ATT.RowNum1 = 1
    AND ENR.RowNum = 1 
    AND STU.SC IN (60,61,68,69,70,72,73)
	AND (TRIM(STU.[SP]) = '' 
		OR TRIM([ENR].[PR]) = '' 
		OR TRIM([ATT].[PR]) = '' 
		OR STU.SP != ENR.PR 
	    OR ENR.PR != ATT.PR 
		OR ATT.PR != STU.SP 
		OR STU.SP NOT IN ('N','M','S') 
		OR ENR.PR NOT IN ('N','M','S') 
		OR ATT.PR NOT IN ('N','M','S'))
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
where id = 60000298
order by ed desc

select * from ATT
where SN = 655
and CD = 'E'

*/
--select TR, * from STU
--where sc = 61



/*

-- used in Aeries
-- for testing purposes
SELECT 
    STU.ID AS StudentID, 
    CASE 
		WHEN TRIM(STU.[SP]) = '' THEN 'Program is empty on STU table'
		WHEN TRIM(ENR.[PR]) = '' THEN 'Program is empty on ENR table'
		WHEN TRIM(ATT.[PR]) = '' THEN 'Program is empty on ATT table'
		WHEN STU.SP NOT IN ('N','M','S') THEN 'Program is not "N","M" or "S"'
		WHEN ENR.PR NOT IN ('N','M','S') THEN 'Program is not "N","M" or "S"'
		WHEN ATT.PR NOT IN ('N','M','S') THEN 'Program is not "N","M" or "S"'
		WHEN STU.SP != ENR.PR THEN 'Program does not match between STU and ENR'
		WHEN ENR.PR != ATT.PR THEN 'Program does not match between ENR and ATT'
		WHEN ATT.PR != STU.SP THEN 'Program does not match between ATT and STU'
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
	AND ATT.RowNum1 = 1
    AND ENR.RowNum = 1 
    AND STU.SC = @SchoolCode
	AND STU.ID in (@StudentID)
	AND (TRIM(STU.[SP]) = '' 
		OR TRIM([ENR].[PR]) = '' 
		OR TRIM([ATT].[PR]) = '' 
		OR STU.SP != ENR.PR 
	    OR ENR.PR != ATT.PR 
		OR ATT.PR != STU.SP 
		OR STU.SP NOT IN ('N','M','S') 
		OR ENR.PR NOT IN ('N','M','S') 
		OR ATT.PR NOT IN ('N','M','S'))

*/
