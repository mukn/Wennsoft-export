SELECT
  c1.Customer_Code
  ,c1.Location_Work
  ,c1.Contract_number
  ,equip.Equipment_Code
  ,notes.Equip_Description
  ,notes.Equip_Type
  ,notes.Make
  ,notes.Model
  ,notes.Serial
  ,notes.Location AS Equip_Location
  ,equip.Equipment_Comment
  
FROM
  (SELECT Customer_Code, Contract_number, Location_Work
  FROM Z_Wennsoft_export_service_contracts) AS c1 
  LEFT OUTER JOIN
  SC_CONTRACT_EQUIPMENT_MC AS equip
    ON c1.Contract_number = equip.Contract_Number 
  LEFT OUTER JOIN
  WO_EQUIPMENT_MC AS notes
    ON c1.Location_Work = LTRIM(RTRIM(notes.Site_ID)) AND equip.Equipment_Code = notes.Equip_ID
ORDER BY c1.Customer_Code, c1.Contract_number
