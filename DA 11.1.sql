SELECT 
	STU.ID [StudentID],
	STU.LN + ', ' + STU.FN + ' has a invalid absence code: ' + ATT.AL +' on ' + CONVERT(VARCHAR,ATT.DT,101) [Description],
	STU.SC,
	ATT.AL
FROM 
	(SELECT * FROM ATT WHERE DEL = 0) [ATT] 
LEFT JOIN 
	(SELECT * FROM STU WHERE DEL = 0) [STU]
	ON ATT.SC = STU.SC
	AND ATT.SN = STU.SN
WHERE 
    (
        (TRIM(AL) != '' AND ATT.SC IN (53, 57, 60, 61, 100, 150))  -- shouldn't have any absences
        OR 
        (TRIM(AL) NOT IN ('R', 'I', 'L', '') AND ATT.SC = 111)    -- should only have R,I,or L at Blue ridge
        OR 
        (TRIM(AL) NOT IN ('G', '') AND ATT.SC = 101)    --should only have G at MSA
    )
ORDER BY
	STU.SC,STU.ID