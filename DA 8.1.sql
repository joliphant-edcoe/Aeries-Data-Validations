SELECT 
    STU.SC,
    STU.CU,
    STU.TR,
    (CONVERT(VARCHAR, STU.SC) + STU.TR + '-' + CONVERT(VARCHAR, STU.CU)) AS [CounsTrack],
	TRIM(
		CONCAT(
			'Student is assigned to teacher / counselor: ', TCH.TE, '; ',
			CASE 
				WHEN TCH.TR = '' THEN TCH.TE + ' is not assigned to a Track; ' 
				WHEN STU.TR != TCH.TR THEN 'Student Track: ' + STU.TR + ', does not align with the Teacher Track: ' + TCH.TR + '; ' 
				ELSE '' 
			END,
			''
		)
	) AS [Description],
    STU.TG,
    ATT.SN,
    STU.LN,
    STU.FN,
    STU.ID,
	TCH.TE,
	TCH.TR [Teacher Track]
FROM 
    (SELECT * FROM STU WHERE DEL = 0) STU
INNER JOIN 
    (SELECT * FROM ATT WHERE DEL = 0 AND CD = 'E') ATT
    ON STU.SC = ATT.SC 
    AND STU.SN = ATT.SN
LEFT JOIN
	(SELECT * FROM TCH WHERE DEL = 0) TCH
	ON STU.SC = TCH.SC
	AND STU.CU = TCH.TN
WHERE
    STU.SC IN (69, 70, 72) 
	AND (TCH.TR = '' OR STU.TR != TCH.TR)
ORDER BY 
    STU.SC, STU.CU, STU.TR;

--SELECT SC,TN,TE,TF,TLN,TR,RM FROM TCH where SC IN (69,70,72)



/*
-- for use in Aeries
SELECT 
	STU.ID [StudentID],
	TRIM(
		CONCAT(
			'Student is assigned to teacher / counselor: ', TCH.TE, '; ',
			CASE 
				WHEN TCH.TR = '' THEN TCH.TE + ' is not assigned to a Track; ' 
				WHEN STU.TR != TCH.TR THEN 'Student Track: ' + STU.TR + ', does not align with the Teacher Track: ' + TCH.TR + '; ' 
				ELSE '' 
			END,
			''
		)
	) AS [Description]
FROM 
    (SELECT * FROM STU WHERE DEL = 0) STU
INNER JOIN 
    (SELECT * FROM ATT WHERE DEL = 0 AND CD = 'E') ATT
    ON STU.SC = ATT.SC 
    AND STU.SN = ATT.SN
LEFT JOIN
	(SELECT * FROM TCH WHERE DEL = 0) TCH
	ON STU.SC = TCH.SC
	AND STU.CU = TCH.TN
WHERE
	1=1
	AND (TCH.TR = '' OR STU.TR != TCH.TR)
    AND STU.SC = @SchoolCode
	AND STU.ID IN (@StudentID)

*/
