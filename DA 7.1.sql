WITH data AS (
	SELECT 
		STU.ID [StudentID],
		STU.LN + ', ' + STU.FN [StudentName],
		STU.SC [School],
		CSE.ED [SpedEnter],
		CSE.XD [SpedExit],
		FOF.SD [504Enter],
		FOF.ED [504Exit],
		CASE 
			WHEN CSE.ID IS NOT NULL AND CSE.ED <= GETDATE() AND (CSE.XD >= GETDATE() OR CSE.XD IS NULL) THEN 'Y' 
			ELSE 'N' 
		END [ActiveIEP],
		CASE
			WHEN FOF.ID IS NOT NULL AND FOF.SD <= GETDATE() AND (FOF.ED >= GETDATE() OR FOF.ED IS NULL) THEN 'Y' 
			ELSE 'N' 
		END [Active504],
		STU.U3 [Sped]
	FROM
		(SELECT * FROM STU WHERE DEL = 0) [STU]
	LEFT JOIN
		(SELECT * FROM CSE WHERE DEL = 0) [CSE]
		ON STU.ID = CSE.ID
	LEFT JOIN
		(
			SELECT 
				*, 
				ROW_NUMBER() OVER (
					PARTITION BY FOF.ID ORDER BY FOF.SQ DESC
					) AS RowNum 
			FROM FOF 
			WHERE DEL = 0
		) [FOF]
		ON STU.ID = FOF.ID
	WHERE 
		NOT STU.TG > ''
		AND (FOF.RowNum = 1 OR FOF.RowNum is null)
	)
SELECT 
	*,
	StudentID,
	CASE
		WHEN ActiveIEP = 'Y' AND Active504 = 'Y' AND Sped = '5' THEN 'Student has both IEP and 504 plans, should be marked "S"'
		WHEN ActiveIEP = 'Y' AND TRIM(Sped) = '' THEN 'Sped field should be marked with a "S" for special education' 
		WHEN Active504 = 'Y' AND TRIM(Sped) = '' THEN 'Sped field should be marked with a "5" for 504 plan' 
		WHEN ActiveIEP = 'N' AND Active504 = 'N' AND TRIM(Sped) IN ('S','5') THEN 'Student has neither IEP nor 504 plans, but is marked "' + Sped + '"'
		WHEN Sped NOT IN ('','S','5') THEN 'Sped Field should only be marked with "S" or "5", this student is marked "' + Sped + '"'
		ELSE ''
	END [Description]
	
FROM data
WHERE 
	1=1
	AND School NOT IN (60,61,68,69,70,72,73)
	AND (
	(ActiveIEP = 'Y' AND Active504 = 'Y' AND Sped = '5') OR
	(ActiveIEP = 'Y' AND TRIM(Sped) = '') OR
	(Active504 = 'Y' AND TRIM(Sped) = '') OR
	(ActiveIEP = 'N' AND Active504 = 'N' AND TRIM(Sped) IN ('S','5')) OR
	Sped NOT IN ('','S','5')
	)
ORDER BY
	School,
	StudentName




/*

WITH data AS (
	SELECT 
		STU.ID [StudentID],
		STU.LN + ', ' + STU.FN [StudentName],
		STU.SC [School],
		CSE.ED [SpedEnter],
		CSE.XD [SpedExit],
		FOF.SD [504Enter],
		FOF.ED [504Exit],
		CASE 
			WHEN CSE.ID IS NOT NULL AND CSE.ED <= GETDATE() AND (CSE.XD >= GETDATE() OR CSE.XD IS NULL) THEN 'Y' 
			ELSE 'N' 
		END [ActiveIEP],
		CASE
			WHEN FOF.ID IS NOT NULL AND FOF.SD <= GETDATE() AND (FOF.ED >= GETDATE() OR FOF.ED IS NULL) THEN 'Y' 
			ELSE 'N' 
		END [Active504],
		STU.U3 [Sped]
	FROM
		(SELECT * FROM STU WHERE DEL = 0) [STU]
	LEFT JOIN
		(SELECT * FROM CSE WHERE DEL = 0) [CSE]
		ON STU.ID = CSE.ID
	LEFT JOIN
		(
			SELECT 
				*, 
				ROW_NUMBER() OVER (
					PARTITION BY FOF.ID ORDER BY FOF.SQ DESC
					) AS RowNum 
			FROM FOF 
			WHERE DEL = 0
		) [FOF]
		ON STU.ID = FOF.ID
	WHERE 
		NOT STU.TG > ''
		AND (FOF.RowNum = 1 OR FOF.RowNum is null)
	)
SELECT 
	*,
	StudentID,
	CASE
		WHEN ActiveIEP = 'Y' AND Active504 = 'Y' AND Sped = '5' THEN 'Student has both IEP and 504 plans, should be marked "S"'
		WHEN ActiveIEP = 'Y' AND TRIM(Sped) = '' THEN 'Sped field should be marked with a "S" for special education' 
		WHEN Active504 = 'Y' AND TRIM(Sped) = '' THEN 'Sped field should be marked with a "5" for 504 plan' 
		WHEN ActiveIEP = 'N' AND Active504 = 'N' AND TRIM(Sped) IN ('S','5') THEN 'Student has neither IEP nor 504 plans, but is marked "' + Sped + '"'
		WHEN Sped NOT IN ('','S','5') THEN 'Sped Field should only be marked with "S" or "5", this student is marked "' + Sped + '"'
		ELSE ''
	END [Description]
	
FROM data
WHERE 
	1=1
	AND School = @SchoolCode
	AND StudentID IN (@StudentID)
	AND (
	(ActiveIEP = 'Y' AND Active504 = 'Y' AND Sped = '5') OR
	(ActiveIEP = 'Y' AND TRIM(Sped) = '') OR
	(Active504 = 'Y' AND TRIM(Sped) = '') OR
	(ActiveIEP = 'N' AND Active504 = 'N' AND TRIM(Sped) IN ('S','5')) OR
	Sped NOT IN ('','S','5')
	)


*/