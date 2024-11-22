WITH LangCompare AS (
	SELECT 
		STU.LF, 
		LAC.EAC, 
		CASE
			WHEN STU.LF = '1' THEN 'EO'
			WHEN STU.LF = '2' THEN 'IFEP'
			WHEN STU.LF = '3' THEN 'EL'
			WHEN STU.LF = '4' THEN 'RFEP'
			WHEN STU.LF = '5' THEN 'TBD'
			WHEN STU.LF = 'E' THEN 'EO'
			WHEN STU.LF = 'R' THEN 'RFEP'
			WHEN STU.LF = '' THEN 'MISSING'
			ELSE ''
		END AS LFMAPPED,
		STU.ID,
		STU.GR,
		STU.SC
		--STU.*,
		--LAC.* 
	FROM
		(
			SELECT [STU].* 
			FROM STU 
			WHERE DEL = 0
		) STU 
	LEFT JOIN
		(
			SELECT [LAC].* 
			FROM LAC 
			WHERE DEL = 0
		) LAC 
		ON STU.ID = LAC.ID
	WHERE 
		NOT STU.TG > ' '
)
SELECT 
	*,
	ID [StudentID],
	CASE 
		WHEN LFMAPPED = 'MISSING' THEN 'STU.LF missing'
		WHEN LFMAPPED != EAC AND NOT EAC = '' THEN 'STU.LF and LAC.EAC do not match'
		WHEN LFMAPPED = 'EL' AND EAC = '' THEN 'English Learner but no LAC.EAC'
		WHEN LF = 'E' THEN 'STU.LF is E, but should be 1'
		WHEN LF = 'R' THEN 'STU.LF is R, but should be 4'
		ELSE ''
	END [Description]
FROM LangCompare 
WHERE 
	1=1
	AND (LF = 'E'
		OR LF = 'R'
		OR (LFMAPPED = 'EL' AND EAC = '')
		OR (LFMAPPED != EAC AND NOT EAC = '')
		OR LFMAPPED = 'MISSING'
		)
ORDER BY SC,GR

