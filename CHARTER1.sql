-- for testing purposes
SELECT 
	STU.ID as StudentID, 
	STU.ITD [STU.ITD], 
	[ENR].[ITD] [ENR.ITD],
	[ATT].[ITD] [ATT.ITD],
	CSE.DR [CSE.DR],
	ENR.RowNum [ENR Row],
	ATT.RowNum1 [ATT row],	
	CASE	
		WHEN TRIM([STU].[ITD]) = '' THEN 'District of Residence on the Demographics page is missing'
		WHEN ENR.ITD is null THEN 'District of Residence on the Enrollment History page is missing'
		WHEN ATT.ITD is null THEN 'District of Residence on the Attendance Enrollment page is missing'
		WHEN ENR.ITD != ATT.ITD THEN 'District of Residence does not match between ENR and ATT tables'
		WHEN ATT.ITD != STU.ITD THEN 'District of Residence does not match between ATT and STU tables'
		WHEN TRIM(CSE.DR) = '' THEN 'Student has CSE record, but no DSEA recorded'
		WHEN CSE.DR != '0910090' THEN 'All Charter students should have DSEA = 0910090'
		ELSE ''
	END AS [Description], 
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
	AND STU.SC IN (51,101,150)
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
SELECT CSE.DR, STU.ITD, * 
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
WHERE 
	NOT STU.TG > ' '
	AND STU.SC IN (51,100,101,150)
	AND CSE.DR IS NOT NULL
	--AND (TRIM(CSE.DR) = '' OR CSE.DR + '0000000' != STU.ITD)
ORDER BY
	Ln, Fn


*/

/*

select count(distinct ID) AS count_id from cse group by sc
select * from cse
where SC IN (60,61,68,69,70,72,73)

*/


/*

-- used in Aeries
SELECT 
	STU.ID as StudentID, 
	CASE	
		WHEN TRIM([STU].[ITD]) = '' THEN 'District of Residence on the Demographics page is missing'
		WHEN CSE.DR is null THEN 'District of Residence on Special Ed page is missing'
		WHEN ENR.ITD is null THEN 'District of Residence on the Enrollment History page is missing'
		WHEN ATT.ITD is null THEN 'District of Residence on the Attendance Enrollment page is missing'
		WHEN STU.ITD != CSE.DR + '0000000' THEN 'District of Residence does not match between STU and CSE tables'
		WHEN CSE.DR + '0000000' != ENR.ITD THEN 'District of Residence does not match between CSE and ENR tables'
		WHEN ENR.ITD != ATT.ITD THEN 'District of Residence does not match between ENR and ATT tables'
		WHEN ATT.ITD != STU.ITD THEN 'District of Residence does not match between ATT and STU tables'
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