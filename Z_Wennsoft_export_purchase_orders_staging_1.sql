SELECT
  LTRIM(RTRIM(PO.PO_Number)) AS PO_Number
  ,Det.Line_Number
  ,Vx.Vendor_Code
  ,PO.PO_Date_List1 AS Document_Date
  ,1 AS PO_Type
  ,CASE
    WHEN Jx.Job_Number <> '' THEN Jx.Job_Number 
    WHEN WOx.WO_Number <> '' THEN WOx.WO_Number
    ELSE ''
  END AS Work_Number
  ,Det.GL_Account
FROM
  dbo.PO_PURCHASE_ORDER_HEADER_MC AS PO WITH (NOLOCK)
  LEFT OUTER JOIN
  (SELECT Company_Code, LTRIM(RTRIM(PO_Number)) AS PO_Number, Line_Number, PO_Quantity_List1 AS Qty, Item_Code, Item_Description, Item_Discount_Percent, Item_Price, Unit_Of_Measure, Tax_Percent, 
    Tax_Amount_List1, Line_Extension_List1, Delivery_Date, GL_Account, LTRIM(RTRIM(Job_Number)) AS Job_Number, LTRIM(RTRIM(WO_Number)) AS WO_Number, Taxable_Flag
  FROM dbo.PO_PURCHASE_ORDER_DETAIL_MC WITH (NOLOCK)
  WHERE (Company_Code = 'NA2')) AS Det
    ON LTRIM(RTRIM(PO.PO_Number)) = Det.PO_Number 
  LEFT OUTER JOIN
  (SELECT LTRIM(RTRIM(PO_Number)) AS PO_Number, LTRIM(RTRIM(Vendor_Code)) AS Vendor_Code
  FROM dbo.PO_VENDOR_XREF_MC WITH (NOLOCK)
  WHERE (Company_Code = 'NA2')) AS Vx
    ON LTRIM(RTRIM(PO.PO_Number)) = Vx.PO_Number 
  LEFT OUTER JOIN
  (SELECT LTRIM(RTRIM(PO_Number)) AS PO_Number, LTRIM(RTRIM(Line_Number)) AS Line_Number, LTRIM(RTRIM(WO_Number)) AS WO_Number
  FROM dbo.PO_WORK_ORDER_XREF_MC WITH (NOLOCK)
  WHERE (Company_Code = 'NA2')) AS WOx
    ON LTRIM(RTRIM(PO.PO_Number)) = WOx.PO_Number AND Det.Line_Number = WOx.Line_Number 
  LEFT OUTER JOIN
  (SELECT LTRIM(RTRIM(PO_Number)) AS PO_Number, Line_Number, LTRIM(RTRIM(Job_Number)) AS Job_Number, Phase_Code, Cost_Type
  FROM dbo.PO_JOB_PHASE_XREF_MC WITH (NOLOCK)
  WHERE (Company_Code = 'NA2')) AS Jx
    ON LTRIM(RTRIM(PO.PO_Number)) = Jx.PO_Number AND Det.Line_Number = Jx.Line_Number
WHERE
  (PO.Company_Code = 'NA2') AND (PO.Status_Flag = 'OPEN')
ORDER BY PO_Number DESC
