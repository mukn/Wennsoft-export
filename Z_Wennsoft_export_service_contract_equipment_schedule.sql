SELECT
  Contracts.Customer_Code
  ,Contracts.Contract_number
  ,Contracts.Location_Work
  ,Visit.Visit_Date
  ,VEqp.Equipment
  ,Visit.Budget_Hours
  ,Visit.Description
  ,CASE
  	WHEN Visit.Description LIKE 'Annual%Maint%' THEN 'Annual Maintenance'
  	WHEN Visit.Description LIKE 'Tower Cle%' THEN 'Annual Tower Cleaning'
  	WHEN Visit.Description LIKE '%Change%' THEN 'Changeover'
  	WHEN Visit.Description LIKE 'Engin%' THEN 'Engineering'
  	WHEN Visit.Description LIKE '%Summer%' THEN 'Summer Work'
  	WHEN Visit.Description LIKE 'Water Tre%' THEN 'Water Treatment'
  	WHEN Visit.Description LIKE '%Winter%' THEN 'Winter Work'
  	ELSE 'Inspection'
  END AS Description

FROM
  dbo.Z_Wennsoft_export_service_contracts AS Contracts 
  LEFT OUTER JOIN
  (SELECT LTRIM(RTRIM(Contract_Number)) AS Contract_Number, LTRIM(RTRIM(Work_Summary)) AS Description, Visit_Date, Internal_Key, Budget_Hours
    FROM dbo.SC_CONTRACT_VISIT_MC) AS Visit
    ON Visit.Contract_Number = Contracts.Contract_number 
  LEFT OUTER JOIN
  (SELECT Internal_Key, LTRIM(RTRIM(Equipment)) AS Equipment
    FROM dbo.SC_CONTRACT_VISIT_EQUIP_MC) AS VEqp
    ON Visit.Internal_Key = VEqp.Internal_Key
--WHERE Visit.Description LIKE 'Water Tre%'
ORDER BY Visit.Visit_Date DESC, Visit.Contract_Number, VEqp.Equipment
