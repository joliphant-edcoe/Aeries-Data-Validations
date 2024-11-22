-- testing
WITH cteLFCodes AS
(
	SELECT CD, CD1 FROM XRF WHERE DEL = 0 AND SC = 0 AND TC = 'CLPD' AND TC1 = 'STU' AND FC1 = 'LF'
)
SELECT 
	stu.sc [SchoolCode], 
	stu.id [Student ID],
	stu.hl,
	xrfLF.CD,
	stu.lf,
	case    
		when stu.hl = '' then 'Reporting language blank' 
		when xrfLF.CD = 'EO' and stu.hl not in ('00', '37') then 'Language Fluency=' + stu.lf + ', ' + 'Reporting Language=' + stu.hl
		when stu.lf = '' and stu.hl in ('00', '37') then 'Language Fluency blank, ' + 'Reporting Language=' + stu.hl
		when (xrfLF.CD is null or xrfLF.CD <> 'EO') and stu.hl in ('00', '37') then 'Language Fluency=' + stu.lf + ', ' + 'Reporting Language=' + stu.hl  
		else ''   
	end AS [Description],
	xrfLF.*,
	stu.*
FROM stu
	LEFT JOIN cteLFCodes [xrfLF] on stu.lf = xrfLF.CD1
	WHERE 
		stu.del = 0 
		and NOT stu.tg > ' '
		--AND stu.sc = @SchoolCode
		--AND stu.id in (@StudentID)
		AND (
			(xrfLF.CD = 'EO' and stu.hl not in ('00', '37'))
			OR ((xrfLF.CD is null or xrfLF.CD <> 'EO') and stu.hl in ('00', '37'))
			OR stu.hl = ''
			)

--select * from XRF


-- AERIES
--; WITH cteLFCodes AS
--		(
--			SELECT CD, CD1 FROM XRF WHERE DEL = 0 AND SC = 0 AND TC = 'CLPD' AND TC1 = 'STU' AND FC1 = 'LF'
--		)
--		SELECT 
--			stu.sc [SchoolCode], 
--			stu.id [Student ID],
--			case    
--				when stu.hl = '' then 'Reporting language blank' 
--				when xrfLF.CD = 'EO' and stu.hl not in ('00', '37') then 'Language Fluency=' + stu.lf + ', ' + 'Reporting Language=' + stu.hl
--				when stu.lf = '' and stu.hl in ('00', '37') then 'Language Fluency blank, ' + 'Reporting Language=' + stu.hl
--				when (xrfLF.CD is null or xrfLF.CD <> 'EO') and stu.hl in ('00', '37') then 'Language Fluency=' + stu.lf + ', ' + 'Reporting Language=' + stu.hl  
--				else ''   
--			end AS [Description]
--		FROM stu
--			LEFT JOIN cteLFCodes [xrfLF] on stu.lf = xrfLF.CD1
--			WHERE stu.del = 0 
--				AND stu.sc = @SchoolCode
--				AND stu.id in (@StudentID)
--				AND (
--					(xrfLF.CD = 'EO' and stu.hl not in ('00', '37'))
--					OR ((xrfLF.CD is null or xrfLF.CD <> 'EO') and stu.hl in ('00', '37'))
--					OR stu.hl = ''
--					)