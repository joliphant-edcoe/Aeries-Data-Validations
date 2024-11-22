WITH cteLFCodes AS
(
	SELECT CD, CD1 FROM XRF WHERE DEL = 0 AND SC = 0 AND TC = 'CLPD' AND TC1 = 'STU' AND FC1 = 'LF'
)
SELECT 
	stu.sc [SchoolCode], 
	stu.id [Student ID],
	'LangFlu: ' + stu.lf + 
	case when lac.l1 NOT IN ('', '00', '37') then ', First: ' + lac.l1 else '' end + 
	case when lac.l2 NOT IN ('', '00', '37') then ', Primary: ' + lac.l2 else '' end + 
	case when lac.l3 NOT IN ('', '00', '37') then ', At Home: ' + lac.l3 else '' end
		[Description]
FROM
	stu 
	JOIN lac 
		ON stu.id = lac.id 
	LEFT JOIN cteLFCodes xrfLF
		ON stu.lf = xrfLF.CD1
	WHERE stu.del = 0
		AND lac.del = 0
		AND NOT STU.TG > ' '
		--AND stu.sc = @SchoolCode
		--AND stu.id in (@StudentID)
		AND xrfLF.CD = 'EO'
		AND (lac.l1 NOT IN ('', '00', '37')
			OR lac.l2 NOT IN ('', '00', '37')
			OR lac.l3 NOT IN ('', '00', '37')
			)




--Aeries
/*
; WITH cteLFCodes AS
		(
			SELECT CD, CD1 FROM XRF WHERE DEL = 0 AND SC = 0 AND TC = 'CLPD' AND TC1 = 'STU' AND FC1 = 'LF'
		)
		SELECT 
			stu.sc [SchoolCode], 
			stu.id [Student ID],
			'LangFlu: ' + stu.lf + 
			case when lac.l1 NOT IN ('', '00', '37') then ', First: ' + lac.l1 else '' end + 
			case when lac.l2 NOT IN ('', '00', '37') then ', Primary: ' + lac.l2 else '' end + 
			case when lac.l3 NOT IN ('', '00', '37') then ', At Home: ' + lac.l3 else '' end
			 [Description]
		FROM
			stu 
			JOIN lac 
				ON stu.id = lac.id 
			LEFT JOIN cteLFCodes xrfLF
				ON stu.lf = xrfLF.CD1
			WHERE stu.del = 0
				AND lac.del = 0
				AND stu.sc = @SchoolCode
				AND stu.id in (@StudentID)
				AND xrfLF.CD = 'EO'
				AND (lac.l1 NOT IN ('', '00', '37')
					OR lac.l2 NOT IN ('', '00', '37')
					OR lac.l3 NOT IN ('', '00', '37')
					)
*/