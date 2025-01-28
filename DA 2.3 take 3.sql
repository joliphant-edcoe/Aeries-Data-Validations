WITH RankedContacts AS (
    -- Rank contacts by the initial criteria and order
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
		CON.[OR] [contactOrder],
		NP [notification preference],  -- 0 means do not contact
        ROW_NUMBER() OVER (PARTITION BY CON.PID ORDER BY CON.[OR]) AS ContactRank,
        CASE 
            WHEN DEL = 0 AND TRIM(FN) != '' AND 
                (TRIM(LW) = 'Y' OR TRIM(ERH) = 'Y' OR TRIM(AP) = 'Y' OR TRIM(PC) = 'Y' OR CD IN ('P1', 'P2'))
            THEN 1
            ELSE 0
        END AS IsValidInitial,
        CASE 
            WHEN CD IN ('P1', 'P2') THEN 1
            ELSE 0
        END AS IsValidSubsequent
    FROM 
        CON
		where PID = 2315
),
FilteredContacts AS (
    -- Apply the logic for determining if a contact is valid based on prior valid contacts
    SELECT 
        [studentid],
        [EdLevel], 
		[Sequence], 
		[firstname], 
		[lastname], 
		[lives with], 
		[relationship], 
		[primary contact], 
		[ed rights holder], 
		[record type], 
		[portal access], 
		[contactOrder],
		[IsValidInitial],
		[IsValidSubsequent],
        CASE
            WHEN ContactRank = 1 THEN IsValidInitial
            WHEN EXISTS (
                SELECT 1 
                FROM RankedContacts rc2 
                WHERE rc2.[studentid] = RankedContacts.[studentid] 
                  AND rc2.ContactRank < RankedContacts.ContactRank 
                  AND rc2.IsValidInitial = 1
            ) THEN IsValidSubsequent
            ELSE 0
        END AS IsValid
    FROM 
        RankedContacts
),
ValidContacts AS (
    -- Filter only valid contacts and rank them
    SELECT 
        [studentid],
        firstname + ' ' + lastname ContactName,
		EdLevel,
        ROW_NUMBER() OVER (PARTITION BY StudentID ORDER BY [contactOrder]) AS ContactRank
    FROM 
        FilteredContacts
    WHERE 
        IsValid = 1
),
FinalResult AS (
    -- Aggregate to get the first two valid contacts
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
        ValidContacts
    ON 
        STU.ID = ValidContacts.studentid
    GROUP BY 
        STU.ID, STU.SC, STU.SP, STU.LN, STU.FN
)
-- Display the final result
SELECT 
    StudentID,
	School,
	Program,
	STUName,
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
	--AND Program != 'M' -- this is the only program that translates to enrollment status 50
	--AND School IN (51,60,61,68,69,70,72,73,100,101,150)
	--AND (FirstContact = 'Missing'
	--	OR (FirstContact != 'Missing' AND FirstEdLevel in ('no ed level',''))
	--	OR (SecondContact != 'Missing' AND SecondEdLevel in ('no ed level','')))
ORDER BY 
    School,StudentID;
