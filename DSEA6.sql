-- for testing purposes
WITH AttCodes AS (
	SELECT 
		CD, 
		DE 
	FROM 
		COD 
	WHERE 
		DEL = 0
		AND TC = 'STU' 
		AND FC = 'AP1'
),
DistCodes AS (
	SELECT 
		DISTINCT ITD AS DITD,
		CASE 
			WHEN ITD = '09619290000000' THEN 'Mother Lode'
			WHEN ITD = '09618380000000' THEN 'Buckeye'
			WHEN ITD = '09737830000000' THEN 'Black Oak Mine'
			WHEN ITD = '09619520000000' THEN 'Placerville'
			WHEN ITD = '09618460000000' THEN 'Camino'
			WHEN ITD = '09619780000000' THEN 'Rescue'
			WHEN ITD = '09618790000000' THEN 'Gold Oak'
			WHEN ITD = '09619600000000' THEN 'Pollock Pines'
			WHEN ITD = '09619450000000' THEN 'Pioneer'
			WHEN ITD = '09619110000000' THEN 'Latrobe'
			WHEN ITD = '09618870000000' THEN 'Gold Trail'
			WHEN ITD = '09618530000000' THEN 'EDUHSD'
			WHEN ITD = '09619030000000' THEN 'Lake Tahoe'
			WHEN ITD = '09619860000000' THEN 'Silver Fork'
			WHEN ITD = '09618950000000' THEN 'Indian Diggings'

			WHEN ITD = '34673140000000' THEN 'Elk Grove'
			WHEN ITD = '03739810000000' THEN 'Amador'
			WHEN ITD = '34674470000000' THEN 'San Juan'
			WHEN ITD = '34673300000000' THEN 'Folsom/Cordova'
			WHEN ITD = '31669280000000' THEN 'Roseville Joint Union'
			WHEN ITD = '31668940000000' THEN 'Placer County'
			WHEN ITD = '34674390000000' THEN 'SAC'
			WHEN ITD = '03739810000000' THEN 'Amador'
			WHEN ITD = '41104130000000' THEN 'San Mateo COE'
			WHEN ITD = '14766870000000' THEN 'Bishop'

			WHEN ITD = '53765135337456' THEN 'Trinity High'
			WHEN ITD = '09618386096614' THEN 'Camerado Springs School'
			WHEN ITD = '09619030930040' THEN 'Mt. Tallac High'
			WHEN ITD = '09618530930081' THEN 'Oak Ridge High'
			WHEN ITD = '09619030937805' THEN 'South Tahoe High'
			WHEN ITD = '50711755034905' THEN 'Modesto High'
			WHEN ITD = '09618530932756' THEN 'El Dorado High'
			WHEN ITD = '09618530930164' THEN 'Union Mine High'
			WHEN ITD = '26102642630028' THEN 'Jan Work Community High'
			WHEN ITD = '09618530936302' THEN 'Ponderosa High'
			WHEN ITD = '09737830930073' THEN 'Black Oak Mine School Code'

			WHEN TRIM(ITD) = '' THEN 'ResDist is missing'
			ELSE 'Code not recognized in Data Validation'
		END AS DEE
	FROM 
		(
		SELECT [STU].* 
		FROM STU 
		WHERE DEL = 0
		) STU 
)
SELECT 
	STU.ID [StudentID],
	CASE
		WHEN TRIM(AttCodes.DE) = '' AND DistCodes.DEE = 'ResDist is missing' THEN 'AttPrgm1 and ResDist codes are missing'
		WHEN TRIM(AttCodes.DE) = '' THEN 'AttPrgm1 code is missing, ResDist code is '+DistCodes.DEE
		WHEN TRIM (DistCodes.DEE) = '' THEN 'ResDist code is missing, AttPrgm1 code is '+AttCodes.DE
		WHEN AttCodes.DE != DistCodes.DEE THEN 'AttPrgm1 code is ' + AttCodes.DE + ' and ResDist code is ' + DistCodes.DEE
		WHEN (GR >= 9 AND GR <= 14 AND AttCodes.DE NOT IN ('EDUHSD','Black Oak Mine','Lake Tahoe','Roseville Joint Union',
		'Folsom/Cordova','SAC','Placer County','Elk Grove','Amador','San Juan','San Mateo COE','Bishop')) THEN 'High school aged student that is in ' + AttCodes.DE + ' district'
		WHEN (GR <= 8 AND AttCodes.DE = 'EDUHSD') THEN 'Elementary student in the High school district'
		ELSE ''
	END AS Description,
	STU.AP1,
	AttCodes.CD,
	AttCodes.DE,
	STU.ITD,
	DistCodes.DITD,
	DistCodes.DEE,
	CASE 
		WHEN AttCodes.DE = DistCodes.DEE THEN 'True'
		ELSE 'False'
	END AS Checked,
	STU.*
FROM
	(
		SELECT [STU].* 
		FROM STU 
		WHERE DEL = 0 
	) STU 
LEFT JOIN
	AttCodes
	ON STU.AP1 = AttCodes.CD
LEFT JOIN
	DistCodes
	ON STU.ITD = DistCodes.DITD
WHERE 
	1=1
	AND NOT STU.TG > ' '
	AND STU.SC IN (68,69,70,72,73,51,100,101,150)
	AND (AttCodes.DE != DistCodes.DEE
		OR (GR >= 9 AND GR <= 14 AND AttCodes.DE NOT IN ('EDUHSD','Black Oak Mine','Lake Tahoe','Roseville Joint Union',
		'Folsom/Cordova','SAC','Placer County','Elk Grove','Amador','San Juan','San Mateo COE','Bishop'))
		OR (GR <= 8 AND AttCodes.DE = 'EDUHSD'))

ORDER BY 
	SC,ID

/*
-- used in Aeries
WITH AttCodes AS (
	SELECT 
		CD, 
		DE 
	FROM 
		COD 
	WHERE 
		DEL = 0
		AND TC = 'STU' 
		AND FC = 'AP1'
),
DistCodes AS (
	SELECT 
		DISTINCT ITD AS DITD,
		CASE 
			WHEN ITD = '09619290000000' THEN 'Mother Lode'
			WHEN ITD = '09618380000000' THEN 'Buckeye'
			WHEN ITD = '09737830000000' THEN 'Black Oak Mine'
			WHEN ITD = '09619520000000' THEN 'Placerville'
			WHEN ITD = '09618460000000' THEN 'Camino'
			WHEN ITD = '09619780000000' THEN 'Rescue'
			WHEN ITD = '09618790000000' THEN 'Gold Oak'
			WHEN ITD = '09619600000000' THEN 'Pollock Pines'
			WHEN ITD = '09619450000000' THEN 'Pioneer'
			WHEN ITD = '09619110000000' THEN 'Latrobe'
			WHEN ITD = '09618870000000' THEN 'Gold Trail'
			WHEN ITD = '09618530000000' THEN 'EDUHSD'
			WHEN ITD = '09619030000000' THEN 'Lake Tahoe'
			WHEN ITD = '09619860000000' THEN 'Silver Fork'
			WHEN ITD = '09618950000000' THEN 'Indian Diggings'

			WHEN ITD = '34673140000000' THEN 'Elk Grove'
			WHEN ITD = '03739810000000' THEN 'Amador'
			WHEN ITD = '34674470000000' THEN 'San Juan'
			WHEN ITD = '34673300000000' THEN 'Folsom/Cordova'
			WHEN ITD = '31669280000000' THEN 'Roseville Joint Union'
			WHEN ITD = '31668940000000' THEN 'Placer County'
			WHEN ITD = '34674390000000' THEN 'SAC'
			WHEN ITD = '03739810000000' THEN 'Amador'
			WHEN ITD = '41104130000000' THEN 'San Mateo COE'
			WHEN ITD = '14766870000000' THEN 'Bishop'

			WHEN ITD = '53765135337456' THEN 'Trinity High'
			WHEN ITD = '09618386096614' THEN 'Camerado Springs School'
			WHEN ITD = '09619030930040' THEN 'Mt. Tallac High'
			WHEN ITD = '09618530930081' THEN 'Oak Ridge High'
			WHEN ITD = '09619030937805' THEN 'South Tahoe High'
			WHEN ITD = '50711755034905' THEN 'Modesto High'
			WHEN ITD = '09618530932756' THEN 'El Dorado High'
			WHEN ITD = '09618530930164' THEN 'Union Mine High'
			WHEN ITD = '26102642630028' THEN 'Jan Work Community High'
			WHEN ITD = '09618530936302' THEN 'Ponderosa High'
			WHEN ITD = '09737830930073' THEN 'Black Oak Mine School Code'
			WHEN TRIM(ITD) = '' THEN 'ResDist is missing'
			ELSE 'Code not recognized in Data Validation'
		END AS DEE
	FROM 
		(
		SELECT [STU].* 
		FROM STU 
		WHERE DEL = 0
		) STU 
)
SELECT 
	STU.ID [StudentID],
	CASE
		WHEN TRIM(AttCodes.DE) = '' AND DistCodes.DEE = 'ResDist is missing' THEN 'AttPrgm1 and ResDist codes are missing'
		WHEN TRIM(AttCodes.DE) = '' THEN 'AttPrgm1 code is missing, ResDist code is '+DistCodes.DEE
		WHEN TRIM (DistCodes.DEE) = '' THEN 'ResDist code is missing, AttPrgm1 code is '+AttCodes.DE
		WHEN AttCodes.DE != DistCodes.DEE THEN 'AttPrgm1 code is ' + AttCodes.DE + ' and ResDist code is ' + DistCodes.DEE
		WHEN (GR >= 9 AND GR <= 14 AND AttCodes.DE NOT IN ('EDUHSD','Black Oak Mine','Lake Tahoe','Roseville Joint Union',
		'Folsom/Cordova','SAC','Placer County','Elk Grove','Amador','San Juan','San Mateo COE','Bishop')) THEN 'High school aged student that is in ' + AttCodes.DE + ' district'
		WHEN (GR <= 8 AND AttCodes.DE = 'EDUHSD') THEN 'Elementary student in the High school district'
		ELSE ''
	END AS Description
FROM
	(
		SELECT [STU].* 
		FROM STU 
		WHERE DEL = 0 
	) STU 
LEFT JOIN
	AttCodes
	ON STU.AP1 = AttCodes.CD
LEFT JOIN
	DistCodes
	ON STU.ITD = DistCodes.DITD
WHERE 
	1=1
	AND NOT STU.TG > ' '
	AND (AttCodes.DE != DistCodes.DEE
		OR (GR >= 9 AND GR <= 14 AND AttCodes.DE NOT IN ('EDUHSD','Black Oak Mine','Lake Tahoe','Roseville Joint Union',
		'Folsom/Cordova','SAC','Placer County','Elk Grove','Amador','San Juan','San Mateo COE','Bishop'))
		OR (GR <= 8 AND AttCodes.DE = 'EDUHSD'))
	AND STU.ID IN (@StudentID)
	AND STU.SC = @SchoolCode



*/