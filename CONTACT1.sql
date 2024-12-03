SELECT 
	ELV [EdLevel], 
	SQ [Sequence], 
	[OR] [contact order], 
	FN [firstname], 
	LN [lastname], 
	LW [lives with], 
	RL [relationship], 
	PC [primary contact], 
	ERH [ed rights holder], 
	CD [record type], 
	AP [portal access], 
	NP [notification preference],  -- 0 means do not contact
	* 
FROM 
	CON 
WHERE 
	PID = 511993 
	AND DEL = 0

SELECT * FROM STU WHERE ID = 511993

/*
SELECT STU.ID [Student ID]
    , CON.LN [Last Name]
    , CON.FN [First Name]
    , 'Contact ' + CON.NM + ' is missing data in FirstName or LastName fields.' [Description]
FROM STU
    INNER JOIN CON ON STU.ID = CON.PID
                    AND CON.NP IN('1', '2')
                    AND CON.DEL = 0
WHERE STU.DEL = 0
    AND STU.TG = ''
    AND (LTRIM(RTRIM(CON.LN)) = ''
        OR LTRIM(RTRIM(CON.FN)) = '')
    AND
	(
		(
			SELECT CD
			FROM DPT
			WHERE NM = 'Loop'
					AND DEL = 0
		) = 'True'
		OR
		(
			SELECT COUNT(*)
			FROM SSP
			WHERE NM = 'ParentSquare'
					AND DEL = 0
					AND DS = 0
		) > 0
	)
    AND STU.SC = @SchoolCode
    AND STU.ID IN(@StudentID)
	*/