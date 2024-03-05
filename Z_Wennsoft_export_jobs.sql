--
/* -- Z_Wennsoft_export_jobs -- */
SELECT
	LTRIM(RTRIM(j1.Job_Number)) AS Job_Number
	,LTRIM(RTRIM(j1.WO_Site)) AS Location_ID_Site
	,Locs.Location_BillTo AS Location_ID_Customer
	,LTRIM(RTRIM(j1.Project_Manager)) AS Project_Manager
	,j1.Job_Description AS Job_Name
	,jDesc.Alpha_Field AS Job_Description
	,jPrio.Alpha_Field AS Priority
	,CAST(jOT.Amount_Field AS int) AS Estimated_OT_Hours
	,CAST(jLbr.Amount_Field AS int) AS Estimated_Labor_hours
	,jPerm.Alpha_Field AS Permit_Reqd
	,jSch.Alpha_Field AS Scheduling_Status
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
	,jSf.Date_Field AS Salesforce_Date
	,jComp.Date_Field AS Cost_Complete
	,j1.Est_Start_Date AS Date_Scheduled_Start
	--,j1.Start_Date AS Date_Actual_Start
	,j1.Est_Complete_Date AS Date_Scheduled_Complete
	--,j1.Complete_Date AS Date_Actual_Complete
FROM
	JC_JOB_MASTER_MC AS j1 
	LEFT OUTER JOIN
	(SELECT Customer_Code, Contract_Number, Location_BillTo
		FROM Z_Wennsoft_export_locations_union
		GROUP BY Contract_Number, Customer_Code, Location_BillTo) AS Locs 
			ON j1.Customer_Code = Locs.Customer_Code AND j1.Job_Number = Locs.Contract_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number,Alpha_Field FROM JC_JOB_USER_FIELDS_DET_MC WHERE Company_Code = 'NA2' AND User_Def_Sequence = '000006') AS jDesc
		ON j1.Job_Number = jDesc.Job_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number,Alpha_Field FROM JC_JOB_USER_FIELDS_DET_MC WHERE Company_Code = 'NA2' AND User_Def_Sequence = '000002') AS jPrio
		ON j1.Job_Number = jPrio.Job_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number,Date_Field FROM JC_JOB_USER_FIELDS_DET_MC WHERE Company_Code = 'NA2' AND User_Def_Sequence = '000011') AS jSf
		ON j1.Job_Number = jSf.Job_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number,Date_Field FROM JC_JOB_USER_FIELDS_DET_MC WHERE Company_Code = 'NA2' AND User_Def_Sequence = '000015') AS jComp
		ON j1.Job_Number = jComp.Job_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number,Amount_Field FROM JC_JOB_USER_FIELDS_DET_MC WHERE Company_Code = 'NA2' AND User_Def_Sequence = '000016') AS jOT
		ON j1.Job_Number = jOT.Job_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number,Alpha_Field FROM JC_JOB_USER_FIELDS_DET_MC WHERE Company_Code = 'NA2' AND User_Def_Sequence = '000008') AS jPerm
		ON j1.Job_Number = jPerm.Job_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number,Amount_Field FROM JC_JOB_USER_FIELDS_DET_MC WHERE Company_Code = 'NA2' AND User_Def_Sequence = '000019') AS jLbr
		ON j1.Job_Number = jLbr.Job_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number,Alpha_Field FROM JC_JOB_USER_FIELDS_DET_MC WHERE Company_Code = 'NA2' AND User_Def_Sequence = '000009') AS jSch
		ON j1.Job_Number = jSch.Job_Number
WHERE
	(j1.Company_Code = 'NA2') 
	AND (j1.Status_Code = 'A')
ORDER BY Job_Number
