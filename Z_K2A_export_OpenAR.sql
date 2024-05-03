SELECT 
  a.CUSTOMER_CODE AS Customer_Number
  ,a.INVOICE_BALANCE AS Document_Amount
  ,a.TRANSACTION_TYPE AS Trans_Type
  ,CASE
    WHEN a.TRANSACTION_TYPE = 'I' THEN '1'
    WHEN a.TRANSACTION_TYPE = 'C' THEN '7'
  END AS Document_Type
  ,a.INVOICE_DATE AS Document_Date
  ,LEFT(Inv.Invoice_Description, 30) AS Document_Description
  ,LTRIM(RTRIM(a.INVOICE_OR_TRANSACTION)) AS Document_Number
FROM
  dbo.CR_AGING_DETAIL_MC AS a 
  LEFT OUTER JOIN
  dbo.CR_OPEN_ITEM_MC AS Inv
    ON LTRIM(RTRIM(a.INVOICE_OR_TRANSACTION)) = RTRIM(LTRIM(Inv.Invoice_Or_Transaction))
WHERE
  (a.Company_Code = 'NA2')
  AND (a.CUSTOMER_CODE <> '4800HAMPDE')
  AND (a.TRANSACTION_TYPE <> 'P')
  AND (a.TRANSACTION_TYPE <> 'A')
  AND (LEFT(Inv.Invoice_Description, 30) <> 'Adjustments')
  AND (LEFT(Inv.Invoice_Description, 30) <> 'Adjustment')
ORDER BY Customer_Number
