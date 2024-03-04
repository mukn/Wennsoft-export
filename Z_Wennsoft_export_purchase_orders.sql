SELECT
	LTRIM(RTRIM(PO_Number)) AS PO_Number
	,LTRIM(RTRIM(PO.Vendor_Code)) AS Vendor_Code
	,PO.PO_Date_List1 AS Document_Date
	,PO.PO_Date_List2
	,PO.PO_Date_List3
	,'' AS Product_Indicator		-- Job cost or service
	,CASE
		WHEN PO.Job_Number <> '' THEN LTRIM(RTRIM(PO.Job_Number))
		WHEN PO.WO_Number <> '' THEN LTRIM(RTRIM(PO.WO_Number))
		ELSE ''
	END AS Work_Number
	,PO.Batch_Code
	--,PO.*
FROM
	PO_INQUIRY_V_MC AS PO
WHERE
	PO.Company_Code = 'NA2'
	AND PO.Status = 'Open'
