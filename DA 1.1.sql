-- for testing purposes
SELECT 
	STU.ID as StudentID, 
	STU.ITD [STU.ITD], 
	--CSE.DR [CSE.DR], 
	CSE.DR + '0000000' [CSE.DR],
	[ENR].[ITD] [ENR.ITD],
	[ATT].[ITD] [ATT.ITD],
	ENR.RowNum [ENR Row],
	ATT.RowNum1 [ATT row],	
	TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[ITD]) = '' THEN 'DOR on the Demographics page is missing; ' ELSE '' END,
			CASE WHEN CSE.DR is null THEN 'DOR on Special Ed page is missing; ' ELSE '' END,
			CASE WHEN ENR.ITD is null THEN 'DOR on the Enrollment History page is missing; ' ELSE '' END,
			CASE WHEN ATT.ITD is null THEN 'DOR on the Attendance Enrollment page is missing; ' ELSE '' END,
			CASE WHEN STU.ITD != CSE.DR + '0000000' THEN 'DOR does not match between Demographics and Special Ed; ' ELSE '' END,
			CASE WHEN CSE.DR + '0000000' != ENR.ITD THEN 'DOR does not match between Special Ed and Enrollment History; ' ELSE '' END,
			CASE WHEN ENR.ITD != ATT.ITD THEN 'DOR does not match between Enrollment History and Attendance Enrollment; ' ELSE '' END,
			CASE WHEN ATT.ITD != STU.ITD THEN 'DOR does not match between Attendance Enrollment and Demographics; ' ELSE '' END
		)
	) AS [Description],
	STU.*, 
	CSE.*
FROM 
	(
		SELECT [STU].* 
		FROM STU 
		WHERE DEL = 0
	) STU 
LEFT JOIN
	(
		SELECT [CSE].* 
		FROM CSE 
		WHERE DEL = 0
	) CSE 
	ON STU.ID = CSE.ID
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
	AND (ENR.RowNum = 1 OR ENR.RowNum is null)
	AND (ATT.RowNum1 = 1 OR ATT.RowNum1 is null)
	AND STU.SC IN (60,61,68,69,70,72,73)
	AND (CSE.DR is null 
		OR TRIM([STU].[ITD]) = ''
		OR ENR.ITD is null
		OR ATT.ITD is null
		OR STU.ITD != CSE.DR + '0000000'
		OR CSE.DR + '0000000' != ENR.ITD
		OR ENR.ITD != ATT.ITD
		OR ATT.ITD != STU.ITD)
ORDER BY
	STU.SC, STU.ID


/*

select count(distinct ID) AS count_id from cse group by sc
select * from cse
where SC IN (60,61,68,69,70,72,73)

*/


/*

-- used in Aeries
SELECT 
	STU.ID as StudentID, 
	TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[ITD]) = '' THEN 'DOR on the Demographics page is missing; ' ELSE '' END,
			CASE WHEN CSE.DR is null THEN 'DOR on Special Ed page is missing; ' ELSE '' END,
			CASE WHEN ENR.ITD is null THEN 'DOR on the Enrollment History page is missing; ' ELSE '' END,
			CASE WHEN ATT.ITD is null THEN 'DOR on the Attendance Enrollment page is missing; ' ELSE '' END,
			CASE WHEN STU.ITD != CSE.DR + '0000000' THEN 'DOR does not match between Demographics and Special Ed; ' ELSE '' END,
			CASE WHEN CSE.DR + '0000000' != ENR.ITD THEN 'DOR does not match between Special Ed and Enrollment History; ' ELSE '' END,
			CASE WHEN ENR.ITD != ATT.ITD THEN 'DOR does not match between Enrollment History and Attendance Enrollment; ' ELSE '' END,
			CASE WHEN ATT.ITD != STU.ITD THEN 'DOR does not match between Attendance Enrollment and Demographics; ' ELSE '' END
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
		SELECT [CSE].* 
		FROM CSE 
		WHERE DEL = 0
	) CSE 
	ON STU.ID = CSE.ID
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
	AND (ENR.RowNum = 1 OR ENR.RowNum is null)
	AND (ATT.RowNum1 = 1 OR ATT.RowNum1 is null)
	AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)
	AND (CSE.DR is null 
		OR TRIM([STU].[ITD]) = ''
		OR ENR.ITD is null
		OR ATT.ITD is null
		OR STU.ITD != CSE.DR + '0000000'
		OR CSE.DR + '0000000' != ENR.ITD
		OR ENR.ITD != ATT.ITD
		OR ATT.ITD != STU.ITD)
*/