SELECT
	STU.SC [SchoolCode],
	STU.ID [StudentID],
	CASE 
		WHEN STU.BCU = '' THEN 'Birth Country is blank' 
		ELSE 'Birth County ' + STU.BCU + ' is not valid.'
	END AS [Description]
FROM 
	(
		SELECT [STU].* 
		FROM STU 
		WHERE DEL = 0
	) STU 
WHERE 
	1=1
	--AND not STU.TG > ' '  -- even inactive STUdents are included in calpads if they were enrolled on cbeds day
	AND STU.SC in (51,100,101,150)
	--AND STU.id in (@StudentID)
	AND (STU.BCU NOT IN (
					SELECt CD 
					FROM usysgcod 
					WHERE 
						DEL = 0 
						and TC = 'STU' 
						and FC = 'BCU') 
		OR STU.BCU = '')



/*
select 
	STU.sc [SchoolCode],
	STU.id [STUdent ID],
	STU.BCU [Description]
from STU  
where STU.del = 0 
	and STU.sc = @SchoolCode
	and STU.id in (@STUdentID)
	and STU.BCU not in (select cd from usysgcod where del = 0 and tc = 'STU' and fc = 'BCU')
*/