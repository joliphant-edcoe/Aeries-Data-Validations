WITH rawdata AS (
	SELECT 
		STU.ID,
		STU.FN,
		STU.LN,
		STU.MN,
		STU.GR,
		CAT.DT,
		CAT.SCL,
		CAT.AC
	FROM
		(SELECT STU.* FROM STU WHERE DEL = 0) STU
	LEFT JOIN
		(SELECT CAT.* FROM CAT WHERE DEL = 0) CAT
		ON STU.ID = CAT.ID
	LEFT JOIN
		(SELECT MST.* FROM MST WHERE DEL = 0) MST
		ON MST.SC = CAT.SCL
		AND MST.SE = CAT.SE
	WHERE 
		1=1
		AND NOT STU.TG > ' '
		AND CAT.SCL IN (70,72)
), grouped AS
(
	SELECT 
		ID,
		FN,
		LN,
		GR,
		SCL,
		DT,
		COUNT(*) [AbsencesPerDay] 
	FROM 
		rawdata 
	WHERE 
		AC IN ('X','U','S') 
	GROUP BY 
		ID,FN,LN,GR,SCL,DT
), filtered AS 
(
	SELECT * 
	FROM grouped 
	WHERE 
		1=1
		AND (  (AbsencesPerDay >= 6 AND DT < '2024-11-30') 
			OR (SCL = 72 AND AbsencesPerDay >= 4 AND DT > '2024-12-01')
			OR (SCL = 70 AND AbsencesPerDay >= 6 AND DT > '2024-12-01')) 
		--	OR (AbsencesPerDay >= 4 AND DT > '2025-01-01'))
), allday AS 
(
	SELECT 
		STU.ID, 
		STU.LN, 
		STU.FN, 
		ATT.AL, 
		ATT.DT 
	FROM (SELECT STU.* FROM STU WHERE DEL = 0) STU
	LEFT JOIN ATT 
		ON STU.SC = ATT.SC 
		AND STU.SN = ATT.SN 
	WHERE 
		1=1
		--NOT STU.TG > ''
		AND STU.SC IN (70,72)
		AND ATT.AL IN ('U','X','T')
)
SELECT 
	filtered.ID  [StudentID],
	CASE 
		WHEN filtered.ID is not null and allday.id is null THEN 'missing all day code on date ' + convert(varchar,filtered.dt,101)
		ELSE ''
	END [Description],
	*
FROM filtered 
FULL OUTER JOIN allday 
	ON filtered.ID = allday.ID 
	AND filtered.DT = allday.DT 
WHERE filtered.ID is not null and allday.id is null
ORDER BY filtered.ID, filtered.DT





/*
WITH rawdata AS (
	SELECT 
		STU.ID,
		STU.FN,
		STU.LN,
		STU.MN,
		STU.GR,
		CAT.DT,
		CAT.SCL,
		CAT.AC
	FROM
		(SELECT STU.* FROM STU WHERE DEL = 0) STU
	LEFT JOIN
		(SELECT CAT.* FROM CAT WHERE DEL = 0) CAT
		ON STU.ID = CAT.ID
	LEFT JOIN
		(SELECT MST.* FROM MST WHERE DEL = 0) MST
		ON MST.SC = CAT.SCL
		AND MST.SE = CAT.SE
	WHERE 
		1=1
		AND NOT STU.TG > ' '
		AND CAT.SCL IN (70,72)
), grouped AS
(
	SELECT 
		ID,
		FN,
		LN,
		GR,
		SCL,
		DT,
		COUNT(*) [AbsencesPerDay] 
	FROM 
		rawdata 
	WHERE 
		AC IN ('X','U','S') 
	GROUP BY 
		ID,FN,LN,GR,SCL,DT
), filtered AS 
(
	SELECT * 
	FROM grouped 
	WHERE 
		1=1
		AND (  (AbsencesPerDay >= 6 AND DT < '2024-11-30') 
			OR (SCL = 72 AND AbsencesPerDay >= 4 AND DT > '2024-12-01')
			OR (SCL = 70 AND AbsencesPerDay >= 6 AND DT > '2024-12-01')) 
		--	OR (AbsencesPerDay >= 4 AND DT > '2025-01-01'))
), allday AS 
(
	SELECT 
		STU.ID, 
		STU.LN, 
		STU.FN, 
		ATT.AL, 
		ATT.DT 
	FROM (SELECT STU.* FROM STU WHERE DEL = 0) STU
	LEFT JOIN ATT 
		ON STU.SC = ATT.SC 
		AND STU.SN = ATT.SN 
	WHERE 
		1=1
		--NOT STU.TG > ''
		AND STU.SC IN (70,72)
		AND ATT.AL IN ('U','X','T')
)
SELECT 
	filtered.ID [StudentID],
	CASE 
		WHEN filtered.ID is not null and allday.id is null THEN 'missing all day code on date ' + convert(varchar,filtered.dt,101)
		ELSE ''
	END [Description]
FROM filtered 
FULL OUTER JOIN allday 
	ON filtered.ID = allday.ID 
	AND filtered.DT = allday.DT 
WHERE 
	filtered.ID is not null and allday.id is null
	AND filtered.ID IN (@StudentID)
	AND filtered.SCL = @SchoolCode
*/