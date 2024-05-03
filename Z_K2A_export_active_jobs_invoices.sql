SELECT
	JobInv.Customer_Code
	,JobInv.Job_Number
	,LTRIM(RTRIM(JobInv.Invoice_Or_Transaction)) AS Invoice_Number
	,JobInv.Transaction_Type AS [Invoice/Credit]
	,JobInv.Invoice_Date
	,JobInv.Terms_Code
	,JobInv.Sales_Tax_Code
	,JobInv.Invoice_Extension AS Gross_Billed
	,JobInv.Retention_Percent AS Retention_Perc
	,JobInv.Retention_Amount AS Retention_Billed
	,JobInv.Batch_Code
	,LTRIM(RTRIM(Job.WO_Site)) AS WO_Site
	,CASE 
		WHEN Terms_Code = '1' THEN 'Net 30' 
		WHEN Terms_Code = '2' THEN 'COD' 
		WHEN Terms_Code = '3' THEN 'Net 45' 
		WHEN Terms_Code = '4' THEN 'Net 60' 
		WHEN Terms_Code = '5' THEN 'Net 35' 
		WHEN Terms_Code = '6' THEN 'Net 75' 
		WHEN Terms_Code = '9' THEN 'Net 90' 
	END AS Terms_Description
	,j.Location_ID_Customer
FROM
	dbo.JC_JOB_MASTER_MC AS Job 
	LEFT OUTER JOIN
    dbo.Z_K2A_EXPORT_ACTIVE_JOBS AS j 
		ON Job.Job_Number = j.Job_Number 
	LEFT OUTER JOIN
    dbo.CR_INVOICE_HEADER_MC AS JobInv 
		ON Job.Job_Number = JobInv.Job_Number
WHERE
	(JobInv.Company_Code = 'NA2') 
	AND (JobInv.Job_Number <> '') 
	AND (Job.Status_Code <> 'C')
ORDER BY Job.Job_Number
