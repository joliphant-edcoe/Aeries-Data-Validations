WITH data AS (
SELECT 
    CAT.SCL,
    CAT.ID,
    CAT.DT,
    (
        SELECT COUNT(SE) 
        FROM CAR 
        WHERE CAR.DEL = 0 
          AND CAT.DT BETWEEN CAR.DS AND CAR.DE 
          AND CAT.SCL = CAR.SC 
          AND CAR.SN IN (
              SELECT STU.SN 
              FROM STU 
              WHERE STU.SC = CAT.SCL 
                AND STU.ID = CAT.ID
          )
    ) AS "Nbr Of Periods",
    (
        SELECT COALESCE(STRING_AGG(AL, ','), '') 
        FROM ATT 
        WHERE ATT.DEL = 0 
          AND ATT.DT = CAT.DT 
          AND ATT.SC = CAT.SCL 
          AND ATT.SN IN (
              SELECT STU.SN 
              FROM STU 
              WHERE STU.SC = CAT.SCL 
                AND ID = CAT.ID
          )
    ) AS AllDayCode,
    COALESCE(STRING_AGG(CAT.AC, ','), '') AS "Period Absences",
    COUNT(CAT.AC) AS "Number of Absences"
FROM CAT
WHERE
    CAT.DEL = 0
    AND CAT.SCL IN (70, 72)
    AND CAT.ID IN (
        SELECT ENR.ID 
        FROM ENR 
        WHERE ENR.SC = CAT.SCL 
          AND ENR.YR = 2024
    )
    AND (
        SELECT COALESCE(STRING_AGG(AL, ','), '') 
        FROM ATT 
        WHERE ATT.DEL = 0 
          AND ATT.DT = CAT.DT 
          AND ATT.SC = CAT.SCL 
          AND ATT.SN IN (
              SELECT STU.SN 
              FROM STU 
              WHERE STU.SC = CAT.SCL 
                AND ID = CAT.ID
          )
    ) IN ('','A')
	AND CAT.DT >= DATEADD(WEEK, -4, GETDATE())
GROUP BY 
    CAT.ID, 
    CAT.DT, 
    CAT.SCL
HAVING 
    COUNT(CAT.AC) >= (
        SELECT COUNT(SE) 
        FROM CAR 
        WHERE CAR.DEL = 0 
          AND CAT.DT BETWEEN CAR.DS AND CAR.DE 
          AND CAT.SCL = CAR.SC 
          AND CAR.SN IN (
              SELECT STU.SN 
              FROM STU 
              WHERE STU.SC = CAT.SCL 
                AND STU.ID = CAT.ID
          ) 
    ) - 1
)
SELECT 
	ID [StudentID], 
	('On ' + convert(varchar,DT,101) + ', Student had ' + cast([Nbr Of Periods] as varchar) + ' class periods, and was absent for ' 
	+ CAST([Number of Absences] AS VARCHAR) + ' of them (' + [Period Absences] + '). The all day code is ' + 
	CASE WHEN AllDayCode = '' THEN 'blank.' ELSE '' END + [AllDayCode]) [Description], 
	* 
FROM data
ORDER BY 
    SCL, 
    ID;


/*
--for Aeries
WITH data AS (
SELECT 
    CAT.SCL,
    CAT.ID,
    CAT.DT,
    (
        SELECT COUNT(SE) 
        FROM CAR 
        WHERE CAR.DEL = 0 
          AND CAT.DT BETWEEN CAR.DS AND CAR.DE 
          AND CAT.SCL = CAR.SC 
          AND CAR.SN IN (
              SELECT STU.SN 
              FROM STU 
              WHERE STU.SC = CAT.SCL 
                AND STU.ID = CAT.ID
          )
    ) AS "Nbr Of Periods",
    (
        SELECT COALESCE(STRING_AGG(AL, ','), '') 
        FROM ATT 
        WHERE ATT.DEL = 0 
          AND ATT.DT = CAT.DT 
          AND ATT.SC = CAT.SCL 
          AND ATT.SN IN (
              SELECT STU.SN 
              FROM STU 
              WHERE STU.SC = CAT.SCL 
                AND ID = CAT.ID
          )
    ) AS AllDayCode,
    COALESCE(STRING_AGG(CAT.AC, ','), '') AS "Period Absences",
    COUNT(CAT.AC) AS "Number of Absences"
FROM CAT
WHERE
    CAT.DEL = 0
    AND CAT.SCL = @SchoolCode
    AND CAT.ID IN (
        SELECT ENR.ID 
        FROM ENR 
        WHERE ENR.SC = CAT.SCL 
          AND ENR.YR = 2024
    )
    AND (
        SELECT COALESCE(STRING_AGG(AL, ','), '') 
        FROM ATT 
        WHERE ATT.DEL = 0 
          AND ATT.DT = CAT.DT 
          AND ATT.SC = CAT.SCL 
          AND ATT.SN IN (
              SELECT STU.SN 
              FROM STU 
              WHERE STU.SC = CAT.SCL 
                AND ID = CAT.ID
          )
    ) IN ('','A')
	AND CAT.DT >= DATEADD(WEEK, -4, GETDATE())
GROUP BY 
    CAT.ID, 
    CAT.DT, 
    CAT.SCL
HAVING 
    COUNT(CAT.AC) >= (
        SELECT COUNT(SE) 
        FROM CAR 
        WHERE CAR.DEL = 0 
          AND CAT.DT BETWEEN CAR.DS AND CAR.DE 
          AND CAT.SCL = CAR.SC 
          AND CAR.SN IN (
              SELECT STU.SN 
              FROM STU 
              WHERE STU.SC = CAT.SCL 
                AND STU.ID = CAT.ID
          ) 
    ) - 1
)
SELECT 
	ID [StudentID], 
	('On ' + convert(varchar,DT,101) + ', Student had ' + cast([Nbr Of Periods] as varchar) + ' class periods, and was absent for ' 
	+ CAST([Number of Absences] AS VARCHAR) + ' of them (' + [Period Absences] + '). The all day code is ' + 
	CASE WHEN AllDayCode = '' THEN 'blank.' ELSE '' END + [AllDayCode]) [Description]
FROM data
WHERE ID in (@StudentID)



*/