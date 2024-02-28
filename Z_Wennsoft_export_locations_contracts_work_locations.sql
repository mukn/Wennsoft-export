SELECT
  Contract.Customer_Code
  ,LTRIM(RTRIM(Contract.Contract_Number)) AS Contract_Number
  ,LTRIM(RTRIM(Contract.Site_ID)) AS Location_Code
  ,Contract.BILLTO_CODE
  ,Site.Ship_To_Name AS Location_Name
  ,Site.Ship_To_Address1 AS Location_Addr1
  ,Site.Ship_To_Address2 AS Location_Addr2
  ,Site.Ship_To_City AS Location_City
  ,Site.Ship_To_State AS Location_State
  ,Site.Ship_To_Zip_Code AS Location_Zip
  ,Site.Ship_To_Phone1 AS Location_Phone1
  ,Site.Ship_To_Phone2 AS Location_Phone2
  ,Site.Site_Contact_Person AS Location_Contact
  ,Site.Zone AS Service_Zone
  ,CASE
    WHEN Contract.Site_ID <> '' THEN 'Contract'
    ELSE 'Non-contract'
  END AS [Contract/Non-contract]
  ,WU.Vert_Market AS Vertical_Market
  ,Site.Sales_Tax_Code
  ,{ fn CONCAT(LTRIM(RTRIM(Contract.Customer_Code)), { fn CONCAT('-', { fn CONCAT(LTRIM(RTRIM(Contract.Site_ID)), '-Main') }) }) } AS Comparison_Key
  ,Contract.ALTERNATE_ADDRESS AS AltBillTo_Flag
  ,CASE
    WHEN Contract.Alternate_Address = 'Y' THEN CONCAT(LTRIM(RTRIM(Contract.Site_ID)), '-BillTo') 
    ELSE LTRIM(RTRIM(Contract.Site_ID)) 
  END AS Location_BillTo
  ,Cust.Customer_Email
FROM
  dbo.PA_ADDRESS_MASTER AS PA
  RIGHT OUTER JOIN
  dbo.CR_ALTERNATE_BILLTO_ADDR_MC AS Bill
    ON PA.Addr_ID = Bill.Address_ID
  LEFT OUTER JOIN
  dbo.Z_K2A_EXPORT_CUSTOMERS AS Cust
    ON Bill.Customer_Code = Cust.Customer_Code
  RIGHT OUTER JOIN
  dbo.SC_CONTRACT_MC AS Contract 
    ON Bill.Company_Code = Contract.Company_Code
      AND Bill.Customer_Code = Contract.Customer_Code 
      AND Bill.Billto_Code = Contract.BILLTO_CODE 
  LEFT OUTER JOIN
  dbo.WO_ADDRESS_MC AS Site
    ON Contract.Company_Code = Site.Company_Code
      AND Contract.Site_ID = Site.Ship_To_ID 
  LEFT OUTER JOIN
  dbo.SC_CONTRACT2_V_MC AS Contract2
    ON Contract.Company_Code = Contract2.Company_Code
      AND Contract.Site_ID = Contract2.Site_ID 
      AND Contract.Contract_Number = Contract2.Contract_Number 
  LEFT OUTER JOIN
  (SELECT Site_ID, Alpha_Field AS Vert_Market
  FROM dbo.WO_SITE_USER_FIELDS_DET_MC
  WHERE (Company_Code = 'NA2') AND (User_Def_Sequence = '000023')) AS WU 
    ON LTRIM(RTRIM(Site.Ship_To_ID)) = LTRIM(RTRIM(WU.Site_ID))
WHERE
  (Contract.Company_Code = 'NA2')
GROUP BY Contract.Site_ID, Contract.Description, Contract.Contract_Amount, Contract2.Status, Contract.Contract_Number, Site.Ship_To_Name, Site.Ship_To_Address1, Site.Ship_To_Address2, 
                         Site.Ship_To_City, Site.Ship_To_State, Site.Ship_To_Zip_Code, Site.Ship_To_Phone1, Site.Ship_To_Phone2, Site.Site_Contact_Person, Site.Zone, WU.Vert_Market, Site.Sales_Tax_Code, 
                         Contract.Customer_Code, Contract.BILLTO_CODE, Contract.ALTERNATE_ADDRESS, Bill.AltName, PA.Addr_1, PA.Addr_2, PA.Addr_City, PA.Addr_State, PA.Addr_Zip,Cust.Customer_Email
HAVING (Contract2.Status = 'active')
ORDER BY Contract.Customer_Code
