-- for testing purposes
SELECT 
	STU.ID as StudentID, 
	STU.GR [STU.GR], 
	ATT.GR [ATT.GR], 
	STU.BD [STU.BD],
	DATEDIFF(DAY, STU.BD,GETDATE())/365.25 [Age],
	DATEDIFF(DAY, STU.BD,GETDATE())/365.25 - stu.gr [Age minus grade],
	TRIM(
		CONCAT(
			CASE WHEN STU.GR != ATT.GR THEN 'Grade does not match between STU and ATT tables; ' ELSE '' END,
			CASE WHEN STU.GR = -2 THEN 'STU.GR is -2 (PS) which is no longer valid; ' ELSE '' END,
			CASE WHEN ATT.GR = -2 THEN 'ATT.GR is -2 (PS) which is no longer valid; ' ELSE '' END,
			CASE WHEN STU.GR is null THEN 'Grade in the STU table is missing; ' ELSE '' END,
			CASE WHEN ATT.GR is null THEN 'Grade in the ATT table is missing; ' ELSE '' END,
			CASE WHEN STU.BD is null THEN 'Birthday is missing, Age cannot be calculated; ' ELSE '' END,
			CASE 
				WHEN STU.GR < 14 THEN 
					CASE 
						WHEN DATEDIFF(DAY, STU.BD,GETDATE())/365.25 - STU.GR < 4.0 THEN 'Age seems a little low for grade ' + CAST(STU.GR AS VARCHAR) + '; '
						WHEN DATEDIFF(DAY, STU.BD,GETDATE())/365.25 - STU.GR > 8.5 THEN 'Age seems a little high for grade ' + CAST(STU.GR AS VARCHAR) + '; '
						ELSE ''
					END 
				WHEN STU.GR > 14 THEN
					CASE 
						WHEN DATEDIFF(DAY, STU.BD,GETDATE())/365.25 < 0 THEN 'Age seems a little low for preschool/infants; '
						WHEN DATEDIFF(DAY, STU.BD,GETDATE())/365.25 > 6 THEN 'Age seems a little high for preschool/infants '
						ELSE ''
					END
				WHEN STU.GR = 14 THEN
					CASE 
						WHEN DATEDIFF(DAY, STU.BD,GETDATE())/365.25 < 18 THEN 'Age seems a little low for adult ed; '
						ELSE ''
					END
				END
		)
	) AS [Description],
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
	AND (ATT.RowNum = 1 OR ATT.RowNum is null)
	AND STU.SC IN (60,61,68,69,70,72,73,51,100,101,150)
	AND (STU.GR != ATT.GR 
		OR STU.GR = -2 
		OR ATT.GR = -2 
		OR ATT.GR is null 
		OR STU.GR is null
		OR (STU.GR < 14 AND DATEDIFF(DAY, STU.BD,GETDATE())/365.25 - STU.GR < 4.0)
		OR (STU.GR < 14 AND DATEDIFF(DAY, STU.BD,GETDATE())/365.25 - STU.GR > 8.5)
		OR (STU.GR = 14 AND DATEDIFF(DAY, STU.BD,GETDATE())/365.25 < 18)
		OR (STU.GR > 14 AND DATEDIFF(DAY, STU.BD,GETDATE())/365.25 < 0)
		OR (STU.GR > 14 AND DATEDIFF(DAY, STU.BD,GETDATE())/365.25 > 6)
		)
ORDER BY
	DATEDIFF(DAY, STU.BD,GETDATE())/365.25, STU.SC, STU.ID

/*
-- used in Aeries
SELECT 
	STU.ID as StudentID, 
	TRIM(
		CONCAT(
			CASE WHEN STU.GR != ATT.GR THEN 'Grade does not match between STU and ATT tables; ' ELSE '' END,
			CASE WHEN STU.GR = -2 THEN 'STU.GR is -2 (PS) which is no longer valid; ' ELSE '' END,
			CASE WHEN ATT.GR = -2 THEN 'ATT.GR is -2 (PS) which is no longer valid; ' ELSE '' END,
			CASE WHEN STU.GR is null THEN 'Grade in the STU table is missing; ' ELSE '' END,
			CASE WHEN ATT.GR is null THEN 'Grade in the ATT table is missing; ' ELSE '' END
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
					) AS RowNum
        FROM ATT 
        WHERE DEL = 0 AND CD = 'E'
    ) ATT 
    ON [STU].[SC] = [ATT].[SC] 
    AND [STU].[SN] = [ATT].[SN]
WHERE 
	NOT STU.TG > ' '
	AND (ATT.RowNum = 1 OR ATT.RowNum is null)
	AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)
	AND (STU.GR != ATT.GR 
		OR STU.GR = -2 
		OR ATT.GR = -2 
		OR ATT.GR is null 
		OR STU.GR is null)


*/