-- for testing purposes
SELECT 
	STU.ID as StudentID, 
	STU.ITD [STU.ITD], 
	[ENR].[ITD] [ENR.ITD],
	[ATT].[ITD] [ATT.ITD],
	CSE.DR [CSE.DR],
	ENR.RowNum [ENR Row],
	ATT.RowNum1 [ATT row],	
	TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[ITD]) = '' THEN 'DOR on the Demographics page is missing; ' ELSE '' END,
			CASE WHEN ENR.ITD is null THEN 'DOR on the Enrollment History page is missing; ' ELSE '' END,
			CASE WHEN ATT.ITD is null THEN 'DOR on the Attendance Enrollment page is missing; ' ELSE '' END,
			CASE WHEN ENR.ITD != ATT.ITD THEN 'DOR does not match between ENR and ATT tables; ' ELSE '' END,
			CASE WHEN ATT.ITD != STU.ITD THEN 'DOR does not match between ATT and STU tables; ' ELSE '' END,
			CASE WHEN TRIM(CSE.DR) = '' THEN 'Student has CSE record, but no DSEA recorded; ' ELSE '' END,
			CASE WHEN CSE.DR != '0910090' THEN 'All Charter students should have DSEA = 0910090; ' ELSE '' END
		)
	) AS [Description],
	STU.GR,
	STU.*
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
	AND STU.SC IN (51,100,101,150)
	AND (TRIM([STU].[ITD]) = ''
		OR ENR.ITD is null
		OR ATT.ITD is null
		OR STU.ITD != ENR.ITD
		OR ENR.ITD != ATT.ITD
		OR ATT.ITD != STU.ITD
		OR TRIM(CSE.DR) = '' 
		OR CSE.DR != '0910090'
		)
ORDER BY
	STU.SC, STU.ID


/*
--------------------------------------------------------------------------
--https://www.cde.ca.gov/ds/sp/cl/swdreporting.asp
--scenario 11
--charter kids that are sped may not need a DSEA listed. Either it should be blank for everybody 
--or it should be EDCOE 0910090 for all.
--still being discussed
----------------------------------------------------------------------------
*/
/*

-- used in Aeries
SELECT 
	STU.ID as StudentID, 
	TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[ITD]) = '' THEN 'DOR on the Demographics page is missing; ' ELSE '' END,
			CASE WHEN ENR.ITD is null THEN 'DOR on the Enrollment History page is missing; ' ELSE '' END,
			CASE WHEN ATT.ITD is null THEN 'DOR on the Attendance Enrollment page is missing; ' ELSE '' END,
			CASE WHEN ENR.ITD != ATT.ITD THEN 'DOR does not match between ENR and ATT tables; ' ELSE '' END,
			CASE WHEN ATT.ITD != STU.ITD THEN 'DOR does not match between ATT and STU tables; ' ELSE '' END,
			CASE WHEN TRIM(CSE.DR) = '' THEN 'Student has CSE record, but no DSEA recorded; ' ELSE '' END,
			CASE WHEN CSE.DR != '0910090' THEN 'All Charter students should have DSEA = 0910090; ' ELSE '' END
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
	AND (TRIM([STU].[ITD]) = ''
		OR ENR.ITD is null
		OR ATT.ITD is null
		OR STU.ITD != ENR.ITD
		OR ENR.ITD != ATT.ITD
		OR ATT.ITD != STU.ITD
		OR TRIM(CSE.DR) = '' 
		OR CSE.DR != '0910090'
		)


*/