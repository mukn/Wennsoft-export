SELECT
	LTRIM(RTRIM(j1.Job_Number)) AS Job_Number
	,LTRIM(RTRIM(j1.WO_Site)) AS Location_ID_Site
	,Locs.Location_BillTo AS Location_ID_Customer
	,LTRIM(RTRIM(j1.Project_Manager)) AS Project_Manager
	,j1.Job_Description
	,LTRIM(RTRIM(j1.Division)) AS Division
	,j1.Original_Contract
	,j1.Sales_Tax_Code
	,LTRIM(RTRIM(j1.Customer_Code)) AS Customer_Code
	,j1.State
	,CASE
		WHEN Division = '06' THEN CONCAT(j1.State, '_SP_PROJ') 
		ELSE CONCAT(j1.State, '_HVAC_PROJ') 
	END AS Div_Code
	,LTRIM(RTRIM(j1.Estimator)) AS Sales_Rep
FROM
	JC_JOB_MASTER_MC AS j1 
	LEFT OUTER JOIN
	(SELECT Customer_Code, Contract_Number, Location_BillTo
		FROM Z_Wennsoft_export_locations_union
		GROUP BY Contract_Number, Customer_Code, Location_BillTo) AS Locs 
			ON j1.Customer_Code = Locs.Customer_Code AND j1.Job_Number = Locs.Contract_Number
WHERE
	(j1.Company_Code = 'NA2') 
	AND (j1.Status_Code = 'A')
ORDER BY Job_Number
