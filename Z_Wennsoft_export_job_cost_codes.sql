SELECT
	j1.Job_Number
	,j1.CC_Number
	,j1.CC_Description
	,j1.CC_ElementNumber
	,j1.CC_ElementCode
	,2 AS Profit_Type
	,CASE
		WHEN j1.CC_Number IN('01200-FIELD-0JRMN-00000' -- Labor
			,'02100-0MATL-00000-00000' -- Material
			,'03000-000EQ-00PUR-00000' -- Purchased equipment
			,'03100-000EQ-00RNT-00000' -- Rental equipment
			,'06000-0SUBC-00000-00000' -- Subcontractors
			,'07100-0BRDB-00XDC-00000' -- Burden
			,'08000-0CNTG-00000-00000' -- Contingency
			)
			THEN j2.Original_Est_Cost
		ELSE 0
	END AS Original_Est_Cost
	,CASE
		WHEN j1.CC_Number IN('01200-FIELD-0JRMN-00000' -- Labor
			,'02100-0MATL-00000-00000' -- Material
			,'03000-000EQ-00PUR-00000' -- Purchased equipment
			,'03100-000EQ-00RNT-00000' -- Rental equipment
			,'06000-0SUBC-00000-00000' -- Subcontractors
			,'07100-0BRDB-00XDC-00000' -- Burden
			,'08000-0CNTG-00000-00000' -- Contingency
			)
			AND (j2.Original_Est_Hours > 0)
			THEN j2.Original_Est_Hours
		WHEN j1.CC_Number IN('01200-FIELD-0JRMN-00000' -- Labor
			,'02100-0MATL-00000-00000' -- Material
			,'03000-000EQ-00PUR-00000' -- Purchased equipment
			,'03100-000EQ-00RNT-00000' -- Rental equipment
			,'06000-0SUBC-00000-00000' -- Subcontractors
			,'07100-0BRDB-00XDC-00000' -- Burden
			,'08000-0CNTG-00000-00000' -- Contingency
			)
			AND (j2.Original_Est_Cost = 0 )
			THEN 0
		ELSE 1
	END AS Original_Est_Hours
	,CASE
		WHEN j1.CC_Number IN('01200-FIELD-0JRMN-00000' -- Labor
			,'02100-0MATL-00000-00000' -- Material
			,'03000-000EQ-00PUR-00000' -- Purchased equipment
			,'03100-000EQ-00RNT-00000' -- Rental equipment
			,'06000-0SUBC-00000-00000' -- Subcontractors
			,'07100-0BRDB-00XDC-00000' -- Burden
			,'08000-0CNTG-00000-00000' -- Contingency
			)
			AND j2.Original_Est_Hours > 0 THEN j2.Original_Est_Hours
		WHEN j1.CC_Number IN('01200-FIELD-0JRMN-00000' -- Labor
			,'02100-0MATL-00000-00000' -- Material
			,'03000-000EQ-00PUR-00000' -- Purchased equipment
			,'03100-000EQ-00RNT-00000' -- Rental equipment
			,'06000-0SUBC-00000-00000' -- Subcontractors
			,'07100-0BRDB-00XDC-00000' -- Burden
			,'08000-0CNTG-00000-00000' -- Contingency
			)
			AND j2.Original_Est_Cost = 0 THEN 0
		ELSE 1
	END AS Update_Qty
	,CASE
		WHEN j1.CC_Number LIKE '01200-%' THEN '01200'
		WHEN j1.CC_Number LIKE '02100-%' THEN '02100'
		WHEN j1.CC_Number LIKE '03000-%' THEN '03000'
		WHEN j1.CC_Number LIKE '03100-%' THEN '03100'
		WHEN j1.CC_Number LIKE '06000-%' THEN '06000'
		WHEN j1.CC_Number LIKE '07100-%' THEN '07100'
		WHEN j1.CC_Number LIKE '08000-%' THEN '08000'
	END AS CC1
	,CASE
		WHEN j1.CC_Number LIKE '01200-%' THEN 'FIELD'
		WHEN j1.CC_Number LIKE '02100-%' THEN '0MATL'
		WHEN j1.CC_Number LIKE '03000-%' THEN '000EQ'
		WHEN j1.CC_Number LIKE '03100-%' THEN '000EQ'
		WHEN j1.CC_Number LIKE '06000-%' THEN '0SUBC'
		WHEN j1.CC_Number LIKE '07100-%' THEN '0BRDB'
		WHEN j1.CC_Number LIKE '08000-%' THEN '0CNTG'
	END AS CC2
	,CASE
		WHEN j1.CC_Number LIKE '01200-%' THEN '0JRMN'
		WHEN j1.CC_Number LIKE '02100-%' THEN '00000'
		WHEN j1.CC_Number LIKE '03000-%' THEN '00PUR'
		WHEN j1.CC_Number LIKE '03100-%' THEN '00RNT'
		WHEN j1.CC_Number LIKE '06000-%' THEN '00000'
		WHEN j1.CC_Number LIKE '07100-%' THEN '00SDC'
		WHEN j1.CC_Number LIKE '08000-%' THEN '00000'
	END AS CC3
	,CASE
		WHEN j1.CC_Number LIKE '01200-%' THEN '00000'
		WHEN j1.CC_Number LIKE '02100-%' THEN '00000'
		WHEN j1.CC_Number LIKE '03000-%' THEN '00000'
		WHEN j1.CC_Number LIKE '03100-%' THEN '00000'
		WHEN j1.CC_Number LIKE '06000-%' THEN '00000'
		WHEN j1.CC_Number LIKE '07100-%' THEN '00000'
		WHEN j1.CC_Number LIKE '08000-%' THEN '00000'
	END AS CC4
FROM
	Z_Wennsoft_jobs_with_all_cost_codes AS j1
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number, Cost_Type, SUM(Original_Est_Cost) AS Original_Est_Cost, SUM(Original_Est_Hours) AS Original_Est_Hours, SUM(Original_Est_Quantity) AS Original_Est_Quantity
	  FROM dbo.JC_PHASE_MASTER_MC
	  GROUP BY Job_Number, Cost_Type) AS j2
	  ON j1.Job_Number = j2.Job_Number
		AND j1.CC_ElementCode = j2.Cost_Type


--WHERE j1.CC_Number IN('01200-FIELD-0JRMN-00000' -- Labor
--			,'02100-0MATL-00000-00000' -- Material
--			,'03000-000EQ-00PUR-00000' -- Purchased equipment
--			,'03100-000EQ-00RNT-00000' -- Rental equipment
--			,'06000-0SUBC-00000-00000' -- Subcontractors
--			,'07100-0BRDB-00XDC-00000' -- Burden
--			,'08000-0CNTG-00000-00000' -- Contingency
--			)
ORDER BY Job_Number
