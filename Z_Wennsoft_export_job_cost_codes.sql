SELECT
  j1.Job_Number
  ,j2.Cost_Type
  ,j2.Original_Est_Cost
  ,j2.Original_Est_Hours
  ,j2.Original_Est_Quantity
  ,CASE
    WHEN Original_Est_Hours > 0 THEN Original_Est_Hours
    WHEN Original_Est_Cost = 0 THEN 0
    ELSE 1
  END AS Update_Qty
  ,CASE
    WHEN j2.Cost_Type = 'C' THEN 'Contingency'
    WHEN j2.Cost_Type = 'L' THEN 'Journeyman'
    WHEN j2.Cost_Type = 'M' THEN 'Materials'
    WHEN j2.Cost_Type = 'E' THEN 'Equipment Purchased'
    WHEN j2.Cost_Type = 'S' THEN 'Subcontract'
    WHEN j2.Cost_Type = 'RE' THEN 'Equipment Rent'
    WHEN j2.Cost_Type = 'B' THEN 'Other (XDC) Burden'
  END AS Cost_Description
  ,CASE
    WHEN j2.Cost_Type = 'C' THEN '8'
    WHEN j2.Cost_Type = 'L' THEN '1'
    WHEN j2.Cost_Type = 'M' THEN '2'
    WHEN j2.Cost_Type = 'E' THEN '3'
    WHEN j2.Cost_Type = 'S' THEN '6'
    WHEN j2.Cost_Type = 'RE' THEN '3'
    WHEN j2.Cost_Type = 'B' THEN '7'
  END AS Cost_Element
  ,CASE
    WHEN j2.Cost_Type = 'C' THEN '08000'
    WHEN j2.Cost_Type = 'L' THEN '01200'
    WHEN j2.Cost_Type = 'M' THEN '02100'
    WHEN j2.Cost_Type = 'E' THEN '03000'
    WHEN j2.Cost_Type = 'S' THEN '06000'
    WHEN j2.Cost_Type = 'RE' THEN '03100'
    WHEN j2.Cost_Type = 'B' THEN '07100'
  END AS CC1
  ,CASE
    WHEN j2.Cost_Type = 'C' THEN '0CNTG'
    WHEN j2.Cost_Type = 'L' THEN 'FIELD'
    WHEN j2.Cost_Type = 'M' THEN '0MATL'
    WHEN j2.Cost_Type = 'E' THEN '000EQ'
    WHEN j2.Cost_Type = 'S' THEN '0SUBC'
    WHEN j2.Cost_Type = 'RE' THEN '000EQ'
    WHEN j2.Cost_Type = 'B' THEN '0BRDN'
  END AS CC2
  ,CASE
    WHEN j2.Cost_Type = 'C' THEN '00000'
    WHEN j2.Cost_Type = 'L' THEN '0JRMN'
    WHEN j2.Cost_Type = 'M' THEN '00000'
    WHEN j2.Cost_Type = 'E' THEN '00PUR'
    WHEN j2.Cost_Type = 'S' THEN '00000'
    WHEN j2.Cost_Type = 'RE' THEN '00RNT'
    WHEN j2.Cost_Type = 'B' THEN '00XDC'
  END AS CC3
  ,'00000' AS CC4
FROM
  Z_Wennsoft_export_jobs AS j1 
  LEFT OUTER JOIN
  (SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number, Cost_Type, SUM(Original_Est_Cost) AS Original_Est_Cost, SUM(Original_Est_Hours) AS Original_Est_Hours, SUM(Original_Est_Quantity) AS Original_Est_Quantity
  FROM dbo.JC_PHASE_MASTER_MC
  GROUP BY Job_Number, Cost_Type) AS j2 
    ON j1.Job_Number = j2.Job_Number
