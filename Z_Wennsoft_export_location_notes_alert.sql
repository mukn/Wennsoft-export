SELECT
	L.Customer_Code
	,L.Location_Code
	,'L' AS Note_Type
	,'ALERT' AS Notes_Service_Index
	,udf_StripHtml(WNotes.Special_Instructions) AS Notes_Text
FROM 
	Z_Wennsoft_export_locations_union AS L
	LEFT OUTER JOIN
	WO_ADDRESS_MC AS WNotes
		ON L.Location_Code = LTRIM(RTRIM(WNotes.Ship_To_ID))
WHERE WNotes.Special_Instructions <> ''
GROUP BY L.Customer_Code,L.Location_Code,WNotes.Special_Instructions
