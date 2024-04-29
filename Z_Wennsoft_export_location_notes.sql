SELECT
	L.Customer_Code
	,L.Location_Code
	,'L' AS Note_Type
	,LNotes.Notes_Topic AS Notes_Service_Index
	,dbo.udf_StripHTML(LNotes.Notes_Text) AS Notes_Text
FROM
	Z_Wennsoft_export_locations_union AS L
	LEFT OUTER JOIN
	WO_SITE_NOTES_MASTER_MC AS LNotes
		ON L.Location_Code = LTRIM(RTRIM(LNotes.Notes_Key))
WHERE LNotes.Notes_Text <> ''
