--SELECT * FROM STR

WITH STUADDR AS (
	SELECT 
		STU.ID,
		STU.FN,
		STU.LN,
		STU.AD, 
		STU.CY, 
		STU.ST, 
		STU.ZC, 
		STU.RAD, 
		STU.RCY, 
		STU.RST, 
		STU.RZC, 
		STU.ITD, 
		STU.TG,
		--tempSTR.ZC, 
		--LTRIM(SUBSTRING(STU.RAD, CHARINDEX(' ', STU.RAD) + 1, LEN(STU.RAD))) AS street_name,
		SUBSTRING(STU.RAD, 0, CHARINDEX(' ', STU.RAD) + 1) AS street_num,
		LTRIM(RTRIM(
			CASE 
				WHEN CHARINDEX('#', STU.RAD) > 0 THEN 
					SUBSTRING(STU.RAD, CHARINDEX(' ', STU.RAD) + 1, CHARINDEX('#', STU.RAD) - CHARINDEX(' ', STU.RAD) - 1)
				WHEN CHARINDEX('APT', UPPER(STU.RAD)) > 0 THEN 
					SUBSTRING(STU.RAD, CHARINDEX(' ', STU.RAD) + 1, CHARINDEX('APT', UPPER(STU.RAD)) - CHARINDEX(' ', STU.RAD) - 1)
				ELSE 
					SUBSTRING(STU.RAD, CHARINDEX(' ', STU.RAD) + 1, LEN(STU.RAD))
			END
		)) AS street_name3
	FROM STU
	WHERE 
		1=1
		AND NOT STU.TG > ' '
		AND STU.SC = 51
)
SELECT
	STUADDR.*, 
	tempSTR.*, 
	CASE 
		WHEN STUADDR.street_num > HI THEN 'TOO HIGH'
		WHEN STUADDR.street_num < LO THEN 'TOO LOW'
		WHEN STUADDR.RCY != tempSTR.CY THEN 'City doesnt match'
		WHEN STUADDR.RZC != tempSTR.ZC THEN 'Zip code does not match'
		WHEN tempSTR.ST IS NULL THEN 'Cannot identify the street'
		ELSE ''
	END AS [Description]
FROM STUADDR 
LEFT JOIN (
    VALUES 
        (1, 'Greenwood Ln', 3262, 3401, 'Placerville', '95667', 'MOTHER LODE'),
		(2, 'PONDEROSA RD', 3330, 3340,'Cameron Park','94859', ''),
		(3, 'GREEN VALLEY RD',3330, 3340, 'EL DORADO','94940', ''),
		(4, 'Fricot City Road',23,43, 'San Andreas','95249', ''),
		(5, 'Dollhouse Rd', 4840, 5340, 'Placerville', '95667', 'GOLD OAK'),
		(6, 'Bordeaux Dr', 3397, 3397,'El Dorado Hills', '95762', 'RESCUE'),
		(7, 'Carnelian Cir', 2510, 2704, 'El Dorado Hills','95762', 'RESCUE'),
		(8, 'mandrake ln',23,43, 'San Andreas','95249', ''),
		(9, 'rosecrest cir', 3330, 3340, 'Placerville', '95667', ''),
		(10, 'Hogarth Way', 1038, 1089,'El Dorado Hills','95762', 'RESCUE'),	
		(11, 'Steeple Chase Drive',3330, 3340, 'EL DORADO','94940', ''),
		(12, 'Mount Aukum Rd',23,43, 'San Andreas','95249', ''),
		(13, 'Alameda Road', 4004, 4600, 'Placerville','95667', 'GOLD OAK'),
		(14, 'Burrmac Lane',2230, 2261, 'Placerville','95667', 'GOLD TRAIL'),
		(15, 'Blazing Star Ln', 7300, 7320, 'Somerset','95684', 'PIONEER'),
		(15, 'Amber Lane', 170, 208, 'Placerville','95667', 'MOTHER LODE'),
		(4, 'Akashic Dr.', 1408, 1540, 'Placerville','95667', 'GOLD TRAIL'),
		(5, 'April Lane', 4541, 4541, 'Placerville', '95667', 'MOTHER LODE'),
		(6, 'Aquamarine Cir', 2830, 2849,'Rescue', '95672', 'RESCUE'),
		(7, 'Carnelian Cir', 2510, 2704, 'El Dorado Hills','95762', 'RESCUE'),
		(8, 'mandrake ln',23,43, 'San Andreas','95249', ''),
		(9, 'rosecrest cir', 3330, 3340, 'Placerville', '95667', ''),
		(10, 'Hogarth Way', 1038, 1089,'El Dorado Hills','95762', 'RESCUE'),	
		(11, 'Steeple Chase Drive',3330, 3340, 'EL DORADO','94940', ''),
		(12, 'Mount Aukum Rd',23,43, 'San Andreas','95249', ''),
		(13, 'Alameda Road', 4004, 4600, 'Placerville','95667', 'GOLD OAK'),
		(14, 'Pleasant Valley Rd',130, 6585, 'Placerville','95667', 'GOLD OAK'),
		(15, 'Pleasant Oak Rd', 3020, 3180, 'Placerville','95667', 'GOLD OAK')
	) AS tempSTR(RN, ST, LO, HI, CY, ZC, DR)
	ON UPPER(STUADDR.street_name3) = UPPER(tempSTR.ST)

ORDER BY 
	street_name3, street_num