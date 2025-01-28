WITH FilteredContacts AS (
    -- Select contacts that meet the criteria
    SELECT 
		PID [studentid],
		ELV [EdLevel], 
		SQ [Sequence], 
		FN [firstname], 
		LN [lastname], 
		LW [lives with], 
		RL [relationship], 
		PC [primary contact], 
		ERH [ed rights holder], 
		CD [record type], 
		AP [portal access], 
		CD [contact type],
		NP [notification preference],  -- 0 means do not contact
        ROW_NUMBER() OVER (PARTITION BY CON.PID ORDER BY CON.[OR]) AS ContactRank
    FROM 
        CON
    WHERE 
		DEL = 0
		AND TRIM(FN) != ''
		AND (TRIM(LW) = 'Y'
			OR TRIM(ERH) = 'Y'
			OR TRIM(AP) = 'Y'
			OR TRIM(PC) = 'Y'
			OR CD IN ('P1','P2')) -- students 512761 and 512762 have their grandma listed with portal access, but she should not be included because the first PG is listed as P1
),
TopContacts AS (
    -- Retrieve the first two contacts for each student
    SELECT 
        studentid,
        firstname + ' ' + lastname ContactName,
		EdLevel,
        ContactRank
    FROM 
        FilteredContacts
    WHERE 
        ContactRank <= 2
),
FinalResult AS (
    -- Aggregate the results to indicate missing if no contacts are found
    SELECT 
        STU.ID AS StudentID,
		STU.SC AS School,
		STU.SP AS [Program],
		STU.LN + ', ' + STU.FN AS STUName,
        COALESCE(MAX(CASE WHEN ContactRank = 1 THEN ContactName END), 'Missing') AS FirstContact,
        COALESCE(MAX(CASE WHEN ContactRank = 2 THEN ContactName END), 'Missing') AS SecondContact,
		COALESCE(MAX(CASE WHEN ContactRank = 1 THEN EdLevel END), 'no ed level') AS FirstEdLevel,
		COALESCE(MAX(CASE WHEN ContactRank = 2 THEN EdLevel END), 'no ed level') AS SecondEdLevel
    FROM 
        (SELECT * FROM STU WHERE DEL = 0 AND NOT TG > '') STU
    LEFT JOIN 
        TopContacts
    ON 
        STU.ID = TopContacts.studentid
    GROUP BY 
        STU.ID, STU.SC, STU.SP, STU.LN, STU.FN
)
-- Display the final result
SELECT 
    StudentID,
	School,
	STUName,
	[Program],
    FirstContact,
	FirstEdLevel,
    SecondContact,
	SecondEdLevel,
	CASE 
		WHEN FirstContact = 'Missing' THEN 'Student is missing a contact that meets the requirements to be extracted to CalPADS' 
		ELSE 
			CASE 
				WHEN FirstEdLevel IN ('no ed level','') THEN 'Student contact: '+ [FirstContact] + ' does not have an Ed Level listed. ' 
				WHEN SecondEdLevel IN ('no ed level','') THEN 'Student contact: '+ [SecondContact] + ' does not have an Ed Level listed. ' 
				ELSE '' 
			END 
	END AS [Description] 
FROM 
    FinalResult
WHERE
	1=1
	AND Program != 'M' -- this is the only program that translates to enrollment status 50
	AND School IN (51,60,61,68,69,70,72,73,100,101,150)
	AND (FirstContact = 'Missing'
		OR (FirstContact != 'Missing' AND FirstEdLevel in ('no ed level',''))
		--OR (SecondContact != 'Missing' AND SecondEdLevel in ('no ed level',''))
		)
ORDER BY 
    School,StudentID;


/*
-- For Aeries
WITH FilteredContacts AS (
    -- Select contacts that meet the criteria
    SELECT 
		PID [studentid],
		ELV [EdLevel], 
		SQ [Sequence], 
		FN [firstname], 
		LN [lastname], 
		LW [lives with], 
		RL [relationship], 
		PC [primary contact], 
		ERH [ed rights holder], 
		CD [record type], 
		AP [portal access], 
		CD [contact type],
		NP [notification preference],  -- 0 means do not contact
        ROW_NUMBER() OVER (PARTITION BY CON.PID ORDER BY CON.[OR]) AS ContactRank
    FROM 
        CON
    WHERE 
		DEL = 0
		AND TRIM(FN) != ''
		AND (TRIM(LW) = 'Y'
			OR TRIM(ERH) = 'Y'
			OR TRIM(AP) = 'Y'
			OR TRIM(PC) = 'Y'
			OR CD IN ('P1','P2'))
),
TopContacts AS (
    -- Retrieve the first two contacts for each student
    SELECT 
        studentid,
        firstname + ' ' + lastname ContactName,
		EdLevel,
        ContactRank
    FROM 
        FilteredContacts
    WHERE 
        ContactRank <= 2
),
FinalResult AS (
    -- Aggregate the results to indicate missing if no contacts are found
    SELECT 
        STU.ID AS StudentID,
		STU.SC AS School,
		STU.SP AS [Program],
		STU.LN + ', ' + STU.FN AS STUName,
        COALESCE(MAX(CASE WHEN ContactRank = 1 THEN ContactName END), 'Missing') AS FirstContact,
        COALESCE(MAX(CASE WHEN ContactRank = 2 THEN ContactName END), 'Missing') AS SecondContact,
		COALESCE(MAX(CASE WHEN ContactRank = 1 THEN EdLevel END), 'no ed level') AS FirstEdLevel,
		COALESCE(MAX(CASE WHEN ContactRank = 2 THEN EdLevel END), 'no ed level') AS SecondEdLevel
    FROM 
        (SELECT * FROM STU WHERE DEL = 0 AND NOT TG > '') STU
    LEFT JOIN 
        TopContacts
    ON 
        STU.ID = TopContacts.studentid
    GROUP BY 
        STU.ID, STU.SC, STU.SP, STU.LN, STU.FN
)
-- Display the final result
SELECT 
    StudentID,
	CASE 
		WHEN FirstContact = 'Missing' THEN 'Student is missing a contact that meets the requirements to be extracted to CalPADS' 
		ELSE 
			CASE 
				WHEN FirstEdLevel IN ('no ed level','') THEN 'Student contact: '+ [FirstContact] + ' does not have an Ed Level listed. ' 
				WHEN SecondEdLevel IN ('no ed level','') THEN 'Student contact: '+ [SecondContact] + ' does not have an Ed Level listed. ' 
				ELSE '' 
			END 
	END AS [Description] 
FROM 
    FinalResult
WHERE
	1=1
	AND Program != 'M' -- this is the only program that translates to enrollment status 50
	AND School = @SchoolCode
	AND StudentID IN (@StudentID)
	AND (FirstContact = 'Missing'
		OR (FirstContact != 'Missing' AND FirstEdLevel in ('no ed level',''))
		--OR (SecondContact != 'Missing' AND SecondEdLevel in ('no ed level',''))
		)

*/