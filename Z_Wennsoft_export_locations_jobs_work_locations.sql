SELECT
  LTRIM(RTRIM(j1.Customer_Code)) AS Customer_Code
  ,j1.Job_Number
  ,j1.WO_Site AS Location_Code
  ,'Main' AS BillTo_Code
  ,j1.Job_Description AS Location_Name
  ,j1.Address_1 AS Location_Addr1
  ,j1.Address_2 AS Location_Addr2
  ,'' AS Location_Addr3
  ,j1.City AS Location_City
  ,j1.State AS Location_State
  ,j1.Zip_Code AS Location_Zip
  ,j1.Phone AS Location_Phone1
  ,w.Ship_To_Phone2 AS Location_Phone2
  ,w.Site_Contact_Person AS Location_Contact
  ,w.Zone AS Service_Zone
  ,CASE
    WHEN c.Site_ID <> '' THEN 'Contract'
    ELSE 'Non-contract'
  END AS [Contract/Non-contract]
  ,WU.Vert_Market AS Vertical_Market
  ,'NT' AS Sales_Tax_Code
  ,j1.Sales_Tax_Code_SP
  ,CASE
    WHEN c1.BillTo_Flag = 'Y' THEN CONCAT(j1.WO_Site, '-BillTo') 
    ELSE j1.WO_Site
  END AS Location_BillTo
  ,{ fn CONCAT(j1.Customer_Code, { fn CONCAT('-', { fn CONCAT(j1.WO_Site, '-Main') }) }) } AS Comparison_Key
  ,Cust.Customer_Email
  ,j1.Longitude AS Location_Longitude
  ,j1.Latitude AS Location_Latitude
FROM         
  (SELECT LTRIM(RTRIM(Customer_Code)) AS Customer_Code, LTRIM(RTRIM(Job_Number)) AS Job_Number, LTRIM(RTRIM(Job_Description)) AS Job_Description, LTRIM(RTRIM(Address_1)) AS Address_1, LTRIM(RTRIM(Address_2)) AS Address_2, LTRIM(RTRIM(City)) AS City, LTRIM(RTRIM(State)) AS State, LTRIM(RTRIM(Zip_Code)) 
                                                    AS Zip_Code, LTRIM(RTRIM(Phone)) AS Phone, LTRIM(RTRIM(Sales_Tax_Code)) AS Sales_Tax_Code, LTRIM(RTRIM(WO_Site)) AS WO_Site, Latitude, Longitude
  FROM dbo.JC_JOB_MASTER_MC
  WHERE (Company_Code = 'NA2') AND (Status_Code = 'A')
  GROUP BY Customer_Code, Job_Number, Job_Description, Address_1, Address_2, City, State, Zip_Code, Phone, Sales_Tax_Code, WO_Site, Latitude, Longitude) AS j1
  LEFT OUTER JOIN
  dbo.Z_K2A_EXPORT_CUSTOMERS as Cust
    ON j1.Customer_Code = Cust.Customer_Code
  LEFT OUTER JOIN
  dbo.WO_ADDRESS_MC AS w
    ON LTRIM(RTRIM(j1.WO_Site)) = LTRIM(RTRIM(w.Ship_To_ID)) 
  LEFT OUTER JOIN
  (SELECT   RTRIM(LTRIM(Site_ID)) AS Site_ID
    FROM         dbo.SC_CONTRACT2_V_MC
    WHERE     (Status = 'Active')
    GROUP BY Site_ID) AS c ON LTRIM(RTRIM(w.Ship_To_ID)) = LTRIM(RTRIM(c.Site_ID)) 
  LEFT OUTER JOIN
  (SELECT   Site_ID, Alpha_Field AS Vert_Market
    FROM         dbo.WO_SITE_USER_FIELDS_DET_MC
    WHERE     (Company_Code = 'NA2') AND (User_Def_Sequence = '000023')) AS WU 
    ON LTRIM(RTRIM(w.Ship_To_ID)) = LTRIM(RTRIM(WU.Site_ID)) 
  LEFT OUTER JOIN
  (SELECT   LTRIM(RTRIM(Customer_Code)) AS Customer_Code, Job_Number, Alternate_Address AS BillTo_Flag, Billto_Code AS BillTo_Code
    FROM         dbo.CR_CONTRACT_MASTER_MC) AS c1 
  ON j1.Job_Number = c1.Job_Number
ORDER BY j1.Customer_Code
