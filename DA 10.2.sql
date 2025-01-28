--12.15
--•	To be an English learner, the Primary Language Code must be a language other than English or American Sign Language.
--•	This element should be established once and should not change throughout the course of the student’s academic career. This is true even when the English language acquisition status of an English learner is changed to Reclassified Fluent English Proficient (RFEP).
--This element is required for students in grades kindergarten through 12. It is NOT required and should not be submitted for pre-kindergarten students

--SELA0322
--Primary Language must equal English (00, eng) or American Sign Language (ase) when English Language Acquisition Status Code equals EO
SELECT	
	STU.LF,
	ELAS.DE,
	STU.HL,
	LANG.DE,
	STU.TG,
	TRIM(CONCAT(
		CASE
			WHEN STU.LF = 1 AND STU.HL NOT IN ('00', '37', '') 
				THEN 'English only students are required to have a reporting language of English / American Sign Language; Language Fluency: ' 
			
			WHEN STU.LF NOT IN (1,'') AND STU.HL IN ('00', '37') 
				THEN 'Students who are or have been EL should have a reporting language other than English / American Sign Language; Language Fluency: ' 
			ELSE ''
		END,
		ELAS.DE + ', ' + 'Reporting Language: ' + LANG.DE)) [Description],
	STU.*
FROM 
	(SELECT * FROM STU WHERE DEL = 0) [STU]
LEFT JOIN
	(SELECT * FROM COD WHERE TC = 'STU' AND FC = 'HL') [LANG]
	ON STU.HL = LANG.CD
LEFT JOIN
	(SELECT * FROM COD WHERE TC = 'STU' AND FC = 'LF') [ELAS]
	ON STU.LF = ELAS.CD
INNER JOIN
	(SELECT * FROM ATT WHERE DEL = 0 AND CD = 'E') [ATT]
	ON STU.SC = ATT.SC
	AND STU.SN = ATT.SN
WHERE 
	1=1
	AND ((STU.LF = 1 AND STU.HL NOT IN ('00', '37', ''))
		OR (STU.LF NOT IN (1,'') AND STU.HL IN ('00', '37')))
	AND STU.SC != 999
ORDER BY 
	STU.SC



/*

SELECT	
	STU.ID [StudentID],
	TRIM(CONCAT(
		CASE
			WHEN STU.LF = 1 AND STU.HL NOT IN ('00', '37', '') 
				THEN 'English only students are required to have a reporting language of English / American Sign Language; Language Fluency: ' 
			
			WHEN STU.LF NOT IN (1,'') AND STU.HL IN ('00', '37') 
				THEN 'Students who are or have been EL should have a reporting language other than English / American Sign Language; Language Fluency: ' 
			ELSE ''
		END,
		ELAS.DE + ', ' + 'Reporting Language: ' + LANG.DE)) [Description]
FROM 
	(SELECT * FROM STU WHERE DEL = 0) [STU]
LEFT JOIN
	(SELECT * FROM COD WHERE TC = 'STU' AND FC = 'HL') [LANG]
	ON STU.HL = LANG.CD
LEFT JOIN
	(SELECT * FROM COD WHERE TC = 'STU' AND FC = 'LF') [ELAS]
	ON STU.LF = ELAS.CD
INNER JOIN
	(SELECT * FROM ATT WHERE DEL = 0 AND CD = 'E') [ATT]
	ON STU.SC = ATT.SC
	AND STU.SN = ATT.SN
WHERE 
	1=1
	AND ((STU.LF = 1 AND STU.HL NOT IN ('00', '37', ''))
		OR (STU.LF NOT IN (1,'') AND STU.HL IN ('00', '37')))
	AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)

*/