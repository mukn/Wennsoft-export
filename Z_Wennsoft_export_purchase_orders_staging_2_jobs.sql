SELECT
  P1.PO_Number
  ,CAST(P1.Line_Number AS int) AS Line_Number
  ,P1.Vendor_Code
  ,P1.Document_Date
  ,P1.PO_Type
  ,3 AS Product_Indicator
  ,P1.Work_Number
  ,P1.GL_Account
  ,W1.Bill_State AS State
  ,GL.GL_Wennsoft
  ,GL.GL_Wennsoft_Description
  ,GL.CostCodes_Wennsoft
  ,GL.State AS GL_State
  ,GL.GL_Current
  ,GL.GL_Current_Numeric
  
FROM
  dbo.Z_Wennsoft_export_purchase_orders_staging_1 AS P1 
  INNER JOIN
  (SELECT LTRIM(RTRIM(WO_Number)) AS WO_Number, Bill_State
  FROM dbo.WO_HEADER_MC WITH (NOLOCK)
  WHERE  Dispatch_Status_Code <> 'F') AS W1
    ON P1.Work_Number = W1.WO_Number
  LEFT OUTER JOIN
  dbo.Z_Wennsoft_GL_map AS GL
    ON P1.GL_Account = GL.GL_Current_Numeric AND W1.Bill_State = GL.State
WHERE
  (P1.GL_Account LIKE '06%') OR (P1.GL_Account LIKE '04%') AND (p1.Document_Date > DATENAME(YEAR,GETDATE()))
ORDER BY P1.PO_Number, CAST(P1.Line_Number AS int)
