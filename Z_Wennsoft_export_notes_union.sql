SELECT Customer_Code,Location_Code,Note_Type,Notes_Service_Index,Notes_Text
FROM Z_Wennsoft_export_customer_notes
UNION
SELECT Customer_Code,Location_Code,Note_Type,Notes_Service_Index,Notes_Text
FROM Z_Wennsoft_export_location_notes
UNION
SELECT Customer_Code,Location_Code,Note_Type,Notes_Service_Index,Notes_Text
FROM Z_Wennsoft_export_location_notes_alert
