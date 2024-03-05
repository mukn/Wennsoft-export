/* -- Z_Wennsoft_export_service_contracts -- */
SELECT
	c1.Customer_Code
	,RTRIM(LTRIM(c1.Contract_Number)) AS Contract_number
	,Work_Locs.Location_Code AS Location_Work
	,Work_Locs.Location_BillTo
	,c1.Begin_Date
	,c1.End_Date
	,c1.Number_Of_Bill_Periods
	,CASE
		WHEN c1.Number_Of_Bill_Periods % 12 = 0 THEN '1'
		WHEN c1.Number_Of_Bill_Periods % 4 = 0 THEN '2'
		WHEN c1.Number_Of_Bill_Periods % 6 = 0 THEN '4'
		ELSE '5'
	END AS Bill_Freq_Code
	,c1.Contract_Amount AS Contract_Amount_Lifetime
	,CASE
		WHEN (CAST((c1.End_Date - c1.Begin_Date) AS int) > 366) THEN 'True'
		ELSE 'False'
	END AS GreaterThanYear												-- This flags when a contract is greater than one year in duration.
	,CASE
		WHEN (CAST((c1.End_Date - c1.Begin_Date) AS int) > 366) THEN CAST(c1.Contract_Amount / ((CAST((c1.End_Date - c1.Begin_Date) AS decimal)) / 365) AS int)
		ELSE c1.Contract_Amount
	END AS Contract_Amount_Annual										-- This is a calculated column to provide the annual contract amount if the term is greater than one year.
	,c1.Salesman
	,c1.BILLTO_CODE AS Contract_BillTo
	,WA.Billto_Code AS Site_BillTo
	,Work_Locs.Location_Phone1 AS Location_Phone1
	,WA.Ship_To_State AS Tax_Schedule									-- This is the state the site is located in.
	,{ fn CONCAT(WA.Ship_To_State, '_HVAC_PM') } AS Div_Code
	,bh.Amt_Recognized
	,ba.Sched_Amt AS Amt_Billed
	,LTRIM(RTRIM(WA.Requested_Tech)) AS Primary_tech
	,Mat.UDF_Value AS Materials_Covered									-- This is a boolean flag of whether materials are included in the contract.
	,sf.UDF_Value AS Salesforce_Book_Date								-- This is a UDF in Spectrum that is not also populated in Wennsoft.

FROM
	dbo.SC_CONTRACT_MC AS c1 
	LEFT OUTER JOIN
	dbo.WO_ADDRESS_MC AS WA
		ON LTRIM(RTRIM(c1.Site_ID)) = LTRIM(RTRIM(WA.Ship_To_ID)) 
			AND c1.Company_Code = WA.Company_Code 
	LEFT OUTER JOIN
	(SELECT Contract_Number, SUM(Revenue_Amount) AS Amt_Recognized
		FROM dbo.SC_GL_DIST_HIST_MC
		GROUP BY Contract_Number) AS bh
			ON c1.Contract_Number = bh.Contract_Number 
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Contract_Number)) AS Contract_Number, SUM(Scheduled_Amount) AS Sched_Amt
		FROM dbo.SC_CONTRACT_BILLING_MC
		WHERE (Company_Code = 'NA2') AND (Billed = 'Y')
		GROUP BY Contract_Number) AS ba
			ON LTRIM(RTRIM(ba.Contract_Number)) = LTRIM(RTRIM(c1.Contract_Number))
	LEFT OUTER JOIN
	dbo.Z_Wennsoft_export_locations_contracts_work_locations AS Work_Locs 
		ON c1.Customer_Code = Work_Locs.Customer_Code
			AND LTRIM(RTRIM(c1.Contract_Number)) = Work_Locs.Contract_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Site_ID)) AS Location_Code,LTRIM(RTRIM(Contract_Number)) AS Contract_Number,'Salesforce_Booking' AS UDF_Key,Date_Field AS UDF_Value
		FROM SC_CONTRACT_USER_FIELDS_MC
		WHERE User_Def_Sequence = '000001') AS sf
		ON c1.Contract_Number = sf.Contract_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Site_ID)) AS Location_Code,LTRIM(RTRIM(Contract_Number)) AS Contract_Number,'Materials_Covered' AS UDF_Key,Alpha_Field AS UDF_Value
		FROM SC_CONTRACT_USER_FIELDS_MC
		WHERE User_Def_Sequence = '000007') AS Mat
		ON c1.Contract_Number = Mat.Contract_Number
WHERE (c1.Company_Code = 'NA2') AND (c1.End_Date > GETDATE())
ORDER BY c1.Contract_Number
