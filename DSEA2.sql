-- for testing purposes
SELECT 
	STU.ID as StudentID, 
	STU.GR [STU.GR], 
	ATT.GR [ATT.GR], 
	CASE
		WHEN STU.GR != ATT.GR THEN 'Grade does not match between STU and ATT tables'
		WHEN STU.GR = -2 THEN 'STU.GR is -2 (PS) which is no longer valid'
		WHEN ATT.GR = -2 THEN 'ATT.GR is -2 (PS) which is no longer valid'
		WHEN STU.GR is null THEN 'Grade in the STU table is missing'
		WHEN ATT.GR is null THEN 'Grade in the ATT table is missing'
		ELSE ''
	END AS [Description], 
	STU.*, 
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
					) AS RowNum
        FROM ATT 
        WHERE DEL = 0 AND CD = 'E'
    ) ATT 
    ON [STU].[SC] = [ATT].[SC] 
    AND [STU].[SN] = [ATT].[SN]
WHERE 
	NOT STU.TG > ' '
	--AND COALESCE(ATT.RowNum,1) = 1
	AND (ATT.RowNum = 1 OR ATT.RowNum is null)
	AND STU.SC IN (60,61,68,69,70,72,73,51,100,101,150)
	AND (STU.GR != ATT.GR 
		OR STU.GR = -2 
		OR ATT.GR = -2 
		OR ATT.GR is null 
		OR STU.GR is null)
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
-- used in Aeries
SELECT 
	STU.ID as StudentID, 
	CASE
		WHEN STU.GR != ATT.GR THEN 'Grade does not match between STU and ATT tables'
		WHEN STU.GR = -2 THEN 'STU.GR is -2 (PS) which is no longer valid'
		WHEN ATT.GR = -2 THEN 'ATT.GR is -2 (PS) which is no longer valid'
		WHEN STU.GR is null THEN 'Grade in the STU table is missing'
		WHEN ATT.GR is null THEN 'Grade in the ATT table is missing'
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
					) AS RowNum
        FROM ATT 
        WHERE DEL = 0 AND CD = 'E'
    ) ATT 
    ON [STU].[SC] = [ATT].[SC] 
    AND [STU].[SN] = [ATT].[SN]
WHERE 
	NOT STU.TG > ' '
	AND ATT.RowNum = 1
	AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)
	AND (STU.GR != ATT.GR 
		OR STU.GR = -2 
		OR ATT.GR = -2 
		OR ATT.GR is null 
		OR STU.GR is null)


*/