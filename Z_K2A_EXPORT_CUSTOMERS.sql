SELECT
  Cust.Customer_Code
  ,Cust.Name AS Customer_Name
  ,Cont.Concat_Name AS Customer_PrimaryContact
  ,Terms.Terms_Description AS Payment_Terms
  ,Cust.Address_1 AS Customer_Address1
  ,Cust.Address_2 AS Customer_Address2
  ,Cust.City AS Customer_City
  ,Cust.State AS Customer_State
  ,Cust.Zip_Code AS Customer_Zip
  ,Cust.Phone AS Customer_PrimaryContactPhone1
  ,Cust.Fax_Phone AS Customer_PrimaryContactFax
  ,Cont.Email1 AS Customer_PrimaryContactEmail
  ,Cust.Salesperson AS Employee_Initials
  ,'ALL' AS Price_Matrix
  ,Cust.Markup_Code AS Price_Matrix_SP
  ,CASE
    WHEN (SxC.Customer_Code <> '') 
    THEN 'Contract' 
  END AS Contract
  ,LTRIM(RTRIM(Cust.Customer_Email)) AS Customer_Email
FROM
  dbo.CR_CUSTOMER_MASTER_MC AS Cust WITH (NOLOCK) 
  LEFT OUTER JOIN
  dbo.PA_CONTACTS_MASTER AS Cont WITH (NOLOCK)
    ON Cust.Primary_Contact = Cont.Contact_ID 
  LEFT OUTER JOIN
  dbo.CR_TERMS_MASTER_MC AS Terms
    ON Cust.Terms_Code = Terms.Terms_Code 
  LEFT OUTER JOIN
  (SELECT RTRIM(LTRIM(Bill_Customer_Code)) AS Customer_Code
    FROM dbo.WO_HEADER2_V_MC
    WHERE (Company_Code = 'na2')
    GROUP BY Bill_Customer_Code) AS SxC 
    ON Cust.Customer_Code = SxC.Customer_Code
WHERE
  (Cust.Company_Code = 'NA2')
  AND (Cust.Status = 'A')
  AND (Terms.Company_Code = 'NA2')
ORDER BY Cust.Customer_Code
