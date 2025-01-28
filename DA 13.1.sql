-- program 3 if less than 30 days olds
-- program 1 if more than

-- blue ridge program code
SELECT STU.LN, STU.FN, STU.ID, STU.TG, STU.SP, ATT.PR, 
	ATT.RowNum,
	ATT2.RowNum,
	CONVERT(VARCHAR,ATT.DT,101) [EnterDate], 
	CASE WHEN NOT STU.TG > '' THEN 'in future' ELSE CONVERT(VARCHAR,ATT2.DT,101) END AS [LeaveDate], 
	CASE WHEN NOT STU.TG > '' THEN DATEDIFF(day, ATT.DT,GETDATE()) ELSE DATEDIFF(day, ATT.DT,ATT2.DT) END AS [Days], 
	TRIM(
		CONCAT(
			CASE WHEN TRIM([STU].[SP]) != TRIM(ATT.PR) THEN 'Program doesnt match; ' ELSE '' END,
			''
		)
	) AS [Description],
	STU.DE, STU.DP, STU.DA, ATT.*
FROM 
	(SELECT * FROM STU WHERE DEL = 0) [STU]
LEFT JOIN
	(
		SELECT 
			*, 
			ROW_NUMBER() OVER (PARTITION BY ATT.SC, ATT.SN ORDER BY ATT.DT DESC) AS RowNum  
		FROM ATT 
		WHERE 
			DEL = 0 
			AND CD = 'E'
	) [ATT]
	ON STU.SC = ATT.SC
	AND STU.SN = ATT.SN
LEFT JOIN
	(
		SELECT 
			*, 
			ROW_NUMBER() OVER (PARTITION BY ATT.SC, ATT.SN ORDER BY ATT.DT DESC) AS RowNum  
		FROM ATT 
		WHERE 
			DEL = 0 
			AND CD = 'L'
	) [ATT2]
	ON STU.SC = ATT2.SC
	AND STU.SN = ATT2.SN
WHERE 
	STU.SC = 111
	AND ATT.RowNum = 1
	AND COALESCE(ATT2.RowNum,1) = 1 