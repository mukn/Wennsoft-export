SELECT
  LTRIM(RTRIM(v1.Invoice_Number)) AS Document_Number
  ,v1.Invoice_Type_Code AS Document_Type_Code
  ,CASE
    WHEN v1.Invoice_Type_Code = 'I' THEN 1
    WHEN v1.Invoice_Type_Code = 'C' THEN 5
  END AS Document_Type
  ,LEFT(v1.Remarks, 30) AS Description
  ,LTRIM(RTRIM(v1.Vendor_Code)) AS Vendor_Code
  ,v1.Date_List1 AS Date_Invoice
  ,v1.Date_List2
  ,v1.Date_List3
  ,v1.Date_List4 AS Date_Due
  , v1.Date_List5 AS Discount_Date
  ,CASE
	WHEN v1.Invoice_Type_Code = 'I' THEN v1.Invoice_Amount
	WHEN v1.Invoice_Type_Code = 'C' THEN (v1.Invoice_Amount * -1)
  END AS Invoice_Amount
  ,v1.Discount_Eligible_Amount
  ,v2.Terms_Code
  ,v2.Terms_Days
  ,v1.Date_List5
FROM
  dbo.VN_OPEN_ITEMS_MC AS v1 
  LEFT OUTER JOIN
  (SELECT LTRIM(RTRIM(Vendor_Code)) AS Vendor_Code, Terms_Code, Terms_Days
  FROM dbo.VN_VENDOR_MASTER_MC
  WHERE (Company_Code = 'NA2') AND (Status = 'A')) AS v2
    ON LTRIM(RTRIM(v1.Vendor_Code)) = v2.Vendor_Code
WHERE (v1.Company_Code = 'NA2')
ORDER BY Vendor_Code
