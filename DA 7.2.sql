WITH data AS (
	SELECT 
		STU.ID [StudentID],
		STU.LN + ', ' + STU.FN [StudentName],
		STU.SC [School],
		STU.U8 [McKFoster],
		CASE
			WHEN PGM.CD = 190 AND PGM.ESD <= GETDATE() AND (PGM.EED >= GETDATE() OR PGM.EED IS NULL) THEN 'Y'
			ELSE 'N'
		END [ActiveFoster],
		CASE
			WHEN PGM.CD = 191 AND PGM.ESD <= GETDATE() AND (PGM.EED >= GETDATE() OR PGM.EED IS NULL) THEN 'Y'
			ELSE 'N'
		END [ActiveHomeless],

		PGM.CD [PrgmCode],
		PGM.ST [Status],
		PGM.ESD [PrgmElgibleStartDate],
		PGM.EED [PrgmElgibleEndDate]
	FROM
		(SELECT * FROM STU WHERE DEL = 0) [STU]
	LEFT JOIN
		(
			SELECT * 
			FROM PGM 
			WHERE 
				DEL = 0 
				AND CD IN (190,191)
				AND PGM.ESD <= GETDATE() 
				AND (PGM.EED >= GETDATE() 
					OR PGM.EED IS NULL)
		) [PGM]
		ON STU.ID = PGM.PID
	WHERE 
		NOT STU.TG > ''
	), 
filtered AS (
	SELECT 
		CASE 
			WHEN TRIM(McKFoster) = 'Y' THEN 
				CASE 
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'Y' THEN 'Student has PROGRAM records indicating Homeless AND Foster, which is unusual. Not sure what the Demographics page should indicate...'
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'N' THEN 'Student is marked as Homeless on the Demographics page (STU.U8) but has a Foster PROGRAM record instead'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'Y' THEN 'good'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'N' THEN 'Student is marked as Homeless on the Demographics page (STU.U8) but does not have a PROGRAM record that is active'
					ELSE '' 
				END
			WHEN TRIM(McKFoster) = 'F' THEN
				CASE
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'Y' THEN 'Student has PROGRAM records indicating Homeless AND Foster, which is unusual. Not sure what the Demographics page should indicate...'
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'N' THEN 'good'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'Y'  THEN 'Student is marked as Foster on the Demographics page (STU.U8) but has a Homeless PROGRAM record instead'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'N' THEN 'Student is marked as Foster on the Demographics page (STU.U8) but does not have a PROGRAM record that is active'
					ELSE '' 
				END
			WHEN TRIM(McKFoster) = '' THEN
				CASE 
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'Y' THEN 'Student has PROGRAM records indicating Homeless AND Foster, which is unusual. Not sure what the Demographics page should indicate...'
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'N' THEN 'Student has a Foster PROGRAM record but is missing the indicator "F" on the Demographics page (STU.U8)'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'Y'  THEN 'Student has a Homeless PROGRAM record but is missing the indicator "Y" on the Demographics page (STU.U8)'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'N' THEN 'good'
					ELSE '' 
				END
			ELSE '' 
		END [Description],
		*
	FROM data
	WHERE 
		1=1
)
SELECT * 
FROM filtered 
WHERE 
	Description != 'good' 
	AND School NOT IN (60,61,68,69,70,72,73)
ORDER BY School, StudentName


--schools 51,101,150 seem to be the only schools who use this field
--select id, fn, ln, u8, sc from stu where u8 != '' and not tg > '' and del = 0



/*
-- for Aeries

WITH data AS (
	SELECT 
		STU.ID [StudentID],
		STU.LN + ', ' + STU.FN [StudentName],
		STU.SC [School],
		STU.U8 [McKFoster],
		CASE
			WHEN PGM.CD = 190 AND PGM.ESD <= GETDATE() AND (PGM.EED >= GETDATE() OR PGM.EED IS NULL) THEN 'Y'
			ELSE 'N'
		END [ActiveFoster],
		CASE
			WHEN PGM.CD = 191 AND PGM.ESD <= GETDATE() AND (PGM.EED >= GETDATE() OR PGM.EED IS NULL) THEN 'Y'
			ELSE 'N'
		END [ActiveHomeless],

		PGM.CD [PrgmCode],
		PGM.ST [Status],
		PGM.ESD [PrgmElgibleStartDate],
		PGM.EED [PrgmElgibleEndDate],
		PGM.*
	FROM
		(SELECT * FROM STU WHERE DEL = 0) [STU]
	LEFT JOIN
		(
			SELECT * 
			FROM PGM 
			WHERE 
				DEL = 0 
				AND CD IN (190,191)
				AND PGM.ESD <= GETDATE() 
				AND (PGM.EED >= GETDATE() 
					OR PGM.EED IS NULL)
		) [PGM]
		ON STU.ID = PGM.PID
	WHERE 
		NOT STU.TG > ''
	), 
filtered AS (
	SELECT 
		CASE 
			WHEN TRIM(McKFoster) = 'Y' THEN 
				CASE 
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'Y' THEN 'Student has PROGRAM records indicating Homeless AND Foster, which is unusual. Not sure what the Demographics page should indicate...'
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'N' THEN 'Student is marked as Homeless on the Demographics page (STU.U8) but has a Foster PROGRAM record instead'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'Y' THEN 'good'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'N' THEN 'Student is marked as Homeless on the Demographics page (STU.U8) but does not have a PROGRAM record that is active'
					ELSE '' 
				END
			WHEN TRIM(McKFoster) = 'F' THEN
				CASE
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'Y' THEN 'Student has PROGRAM records indicating Homeless AND Foster, which is unusual. Not sure what the Demographics page should indicate...'
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'N' THEN 'good'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'Y'  THEN 'Student is marked as Foster on the Demographics page (STU.U8) but has a Homeless PROGRAM record instead'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'N' THEN 'Student is marked as Foster on the Demographics page (STU.U8) but does not have a PROGRAM record that is active'
					ELSE '' 
				END
			WHEN TRIM(McKFoster) = '' THEN
				CASE 
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'Y' THEN 'Student has PROGRAM records indicating Homeless AND Foster, which is unusual. Not sure what the Demographics page should indicate...'
					WHEN ActiveFoster = 'Y' AND ActiveHomeless = 'N' THEN 'Student has a Foster PROGRAM record but is missing the indicator "F" on the Demographics page (STU.U8)'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'Y'  THEN 'Student has a Homeless PROGRAM record but is missing the indicator "Y" on the Demographics page (STU.U8)'
					WHEN ActiveFoster = 'N' AND ActiveHomeless = 'N' THEN 'good'
					ELSE '' 
				END
			ELSE '' 
		END [Description],
		*
	FROM data
	WHERE 
		1=1
)
SELECT StudentID, Description
FROM filtered 
WHERE 
	Description != 'good' 
	AND StudentID IN (@StudentID)
	AND School = @SchoolCode

*/