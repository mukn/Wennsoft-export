SELECT
	C.Customer_Code
	,'' AS Location_Code
	,'C' AS Note_Type
	,CNotes.Notes_Topic AS Notes_Service_Index
	,udf_StripHtml(CNotes.Notes_Text) AS Notes_Text
FROM 
	Z_K2A_EXPORT_CUSTOMERS AS C
	LEFT OUTER JOIN
	CR_CUSTOMER_NOTES_MASTER_MC AS CNotes
		ON C.Customer_Code = LTRIM(RTRIM(CNotes.Customer_Code))
WHERE CNotes.Notes_Text <> ''
