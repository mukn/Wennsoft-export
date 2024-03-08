SELECT
  LTRIM(RTRIM(j1.Customer_Code)) AS Customer_Code
  ,j1.Job_Number
  ,{ fn CONCAT(LTRIM(RTRIM(j1.WO_Site)), '-BillTo') } AS Location_Code
  ,c1.BillTo_Code
  ,Bill.AltName AS Location_Name
  ,p.Addr_1 AS Location_Addr1
  ,p.Addr_2 AS Location_Addr2
  ,Bill.AltName AS Location_Addr3
  ,p.Addr_City AS Location_City
  ,p.Addr_State AS Location_State
  ,p.Addr_Zip AS Location_Zip
  ,'' AS Location_Phone1
  ,'' AS Location_Phone2
  ,'' AS Location_Contact
  ,'' AS Service_Zone
  ,'Non-contract' AS [Contract/Non-contract]
  ,'' AS Vertical_Market
  ,'' AS Sales_Tax_Code
  ,CASE
    WHEN c1.BillTo_Flag = 'Y' THEN CONCAT(j1.WO_Site, '-BillTo') 
    ELSE j1.WO_Site
  END AS Location_BillTo
  ,{ fn CONCAT(j1.Customer_Code, { fn CONCAT('-', { fn CONCAT(j1.WO_Site, '-Main') }) }) } AS Comparison_Key
  ,Cust.Customer_Email
  ,j1.Latitude
  ,j1.Longitude
FROM
  dbo.JC_JOB_MASTER_MC AS j1
  LEFT OUTER JOIN
  (SELECT LTRIM(RTRIM(Customer_Code)) AS Customer_Code, Job_Number, Alternate_Address AS BillTo_Flag, Billto_Code AS BillTo_Code
  FROM dbo.CR_CONTRACT_MASTER_MC) AS c1
    ON j1.Job_Number = c1.Job_Number
  LEFT OUTER JOIN
  dbo.CR_CONTRACT_MASTER_MC AS c2 
    ON j1.Job_Number = c2.Job_Number
  LEFT OUTER JOIN
  dbo.CR_ALTERNATE_BILLTO_ADDR_MC AS Bill
    ON j1.Customer_Code = Bill.Customer_Code
      AND c2.Billto_Code = Bill.Billto_Code 
  LEFT OUTER JOIN
  dbo.Z_K2A_EXPORT_CUSTOMERS AS Cust
    ON Bill.Customer_Code = Cust.Customer_Code
  LEFT OUTER JOIN
  dbo.PA_ADDRESS_MASTER AS p
    ON Bill.Address_ID = p.Addr_ID
WHERE 
  (j1.Company_Code = 'NA2')
  AND (c1.BillTo_Flag = 'Y')
  AND (j1.Status_Code = 'A')
ORDER BY j1.Customer_Code
