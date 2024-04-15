SELECT
	j1.Job_Number
	,j1.CC_Number
	,j1.CC_ElementNumber
	,j1.CC_ElementCode
	,CASE
		WHEN j1.CC_Number IN('01100-FIELD-0FRMN-00000' -- Labor
			,'02100-0MATL-00000-00000' -- Material
			,'03000-000EQ-00PUR-00000' -- Purchased equipment
			,'03100-000EQ-00RNT-00000' -- Rental equipment
			,'06000-0SUBC-00000-00000' -- Subcontractors
			,'07100-0BRDB-00XDC-00000' -- Burden
			,'08000-0CNTG-00000-00000' -- Contingency
			)
			THEN j2.Original_Est_Cost
		ELSE 0
	END AS Original_Est_Cost_Calc
	,CASE
		WHEN j1.CC_Number IN('01100-FIELD-0FRMN-00000' -- Labor
			,'02100-0MATL-00000-00000' -- Material
			,'03000-000EQ-00PUR-00000' -- Purchased equipment
			,'03100-000EQ-00RNT-00000' -- Rental equipment
			,'06000-0SUBC-00000-00000' -- Subcontractors
			,'07100-0BRDB-00XDC-00000' -- Burden
			,'08000-0CNTG-00000-00000' -- Contingency
			)
			AND (j2.Original_Est_Hours > 0)
			THEN j2.Original_Est_Hours
		WHEN j1.CC_Number IN('01100-FIELD-0FRMN-00000' -- Labor
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
	END AS Original_Est_Hours_Calc
	,j2.Original_Est_Cost AS Est_cost
	,j2.Original_Est_Hours
	,j2.Original_Est_Quantity
	,CASE
		WHEN Original_Est_Hours > 0 THEN Original_Est_Hours
		ELSE 0
	END AS Update_Qty
FROM
	Z_Wennsoft_jobs_with_all_cost_codes AS j1
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number, Cost_Type, SUM(Original_Est_Cost) AS Original_Est_Cost, SUM(Original_Est_Hours) AS Original_Est_Hours, SUM(Original_Est_Quantity) AS Original_Est_Quantity
	  FROM dbo.JC_PHASE_MASTER_MC
	  GROUP BY Job_Number, Cost_Type) AS j2
	  ON j1.Job_Number = j2.Job_Number
		AND j1.CC_ElementCode = j2.Cost_Type


--WHERE j1.CC_Number IN('01100-FIELD-0FRMN-00000' -- Labor
--			,'02100-0MATL-00000-00000' -- Material
--			,'03000-000EQ-00PUR-00000' -- Purchased equipment
--			,'03100-000EQ-00RNT-00000' -- Rental equipment
--			,'06000-0SUBC-00000-00000' -- Subcontractors
--			,'07100-0BRDB-00XDC-00000' -- Burden
--			,'08000-0CNTG-00000-00000' -- Contingency
--			)
ORDER BY Job_Number
