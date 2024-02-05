SELECT
  j1.Job_Number
  ,j2.Cost_Type
  ,j2.Original_Est_Cost
  ,j2.Original_Est_Hours
  ,j2.Original_Est_Quantity
  ,(CASE
      WHEN j2.Cost_Type = 'L' THEN '1'
      WHEN j2.Cost_Type = 'M' THEN '2'
      WHEN j2.Cost_Type = 'E' THEN '3'
      WHEN j2.Cost_Type = 'S' THEN '6'
      WHEN j2.Cost_Type = 'RE' THEN '3'
      WHEN j2.Cost_Type = 'B' THEN '7'
  END) AS Cost_Element
  ,CASE
      WHEN Trx.Tran_Type_Code = 'OH' THEN 'GJ'
      ELSE Trx.Tran_Type_Code
  END AS Doc_Source
  ,Trx.Tran_Date_Text AS Transaction_Date_1
  ,LTRIM(RTRIM(Trx.Invoice_Number)) AS Invoice_Number
  ,Trx.Invoice_Date AS Transaction_Date_2
  ,Trx.Tran_Amount AS Document_Amount
  ,CASE
      WHEN j2.Cost_Type = 'L' THEN 'Journeyman'
      WHEN j2.Cost_Type = 'M' THEN 'Materials'
      WHEN j2.Cost_Type = 'E' THEN 'Equipment Purchased'
      WHEN j2.Cost_Type = 'S' THEN 'Subcontract'
      WHEN j2.Cost_Type = 'RE' THEN 'Equipment Rent'
      WHEN j2.Cost_Type = 'B' THEN 'Other (XDC) Burden'
  END AS Cost_Description
  ,CASE
      WHEN j2.Cost_Type = 'L' THEN '01200'
      WHEN j2.Cost_Type = 'M' THEN '02100'
      WHEN j2.Cost_Type = 'E' THEN '03000'
      WHEN j2.Cost_Type = 'S' THEN '06000'
      WHEN j2.Cost_Type = 'RE' THEN '03100'
      WHEN j2.Cost_Type = 'B' THEN '07100' 
  END AS CC1
  ,CASE
      WHEN j2.Cost_Type = 'L' THEN 'FIELD'
      WHEN j2.Cost_Type = 'M' THEN '0MATL'
      WHEN j2.Cost_Type = 'E' THEN '000EQ'
      WHEN j2.Cost_Type = 'S' THEN '0SUBC'
      WHEN j2.Cost_Type = 'RE' THEN '000EQ'
      WHEN j2.Cost_Type = 'B' THEN '0BRDN'
  END AS CC2
  ,CASE
      WHEN j2.Cost_Type = 'L' THEN '0JRMN'
      WHEN j2.Cost_Type = 'M' THEN '00000'
      WHEN j2.Cost_Type = 'E' THEN '00PUR'
      WHEN j2.Cost_Type = 'S' THEN '00000'
      WHEN j2.Cost_Type = 'RE' THEN '00RNT'
      WHEN j2.Cost_Type = 'B' THEN '00XDC'
    END AS CC3
  ,'00000' AS CC4
  ,CASE
      WHEN j2.Cost_Type = 'L' THEN '1'
      WHEN j2.Cost_Type <> 'L' THEN '0'
  END AS WS_Cost
  ,CASE
      WHEN (j2.Cost_Type = 'L') AND (Trx.PR_Pay_Amount1 > 0) THEN 'REG'
      WHEN (j2.Cost_Type = 'L') AND (Trx.PR_Pay_Amount2 > 0) THEN 'OT'
      WHEN (j2.Cost_Type = 'L') AND (Trx.PR_Pay_Amount3 > 0) THEN 'DT'
  END AS UPRTRX_Code
  ,Trx.PR_Hours1 AS Labor_Regular
  ,Trx.PR_Hours2 AS Labor_Over
  ,Trx.PR_Hours3 AS Labor_Double
  ,Trx.PR_Pay_Amount1 AS Paid_Regular
  ,Trx.PR_Pay_Amount2 AS Paid_Over
  ,Trx.PR_Pay_Amount3 AS Paid_Double
  ,Trx.Qty
  ,Trx.Amt
FROM
  dbo.Z_Wennsoft_export_jobs AS j1 
  LEFT OUTER JOIN
  (SELECT Job_Number, Cost_Type, Original_Est_Cost, Original_Est_Hours, Original_Est_Quantity
  FROM dbo.JC_PHASE_MASTER_MC
  WHERE (Phase_Code = '0001')) AS j2 
    ON j1.Job_Number = j2.Job_Number 
  LEFT OUTER JOIN
  (SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number, Cost_Type, Tran_Type_Code, Tran_Date_Text, Invoice_Number, Invoice_Date, Tran_Amount, PR_Hours1, PR_Hours2, 
    PR_Hours3, PR_Pay_Amount1, PR_Pay_Amount2, PR_Pay_Amount3, Quantity AS Qty, Tran_Amount AS Amt
  FROM dbo.JC_TRANSACTION_HISTORY_MC
  WHERE (Company_Code = 'NA2')) AS Trx ON j1.Job_Number = Trx.Job_Number AND j2.Cost_Type = Trx.Cost_Type
WHERE
  (Trx.Tran_Type_Code <> '')
ORDER BY j1.Job_Number
