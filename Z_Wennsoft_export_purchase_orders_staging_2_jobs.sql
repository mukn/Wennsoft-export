SELECT
  P1.PO_Number
  ,P1.Line_Number
  ,P1.Vendor_Code
  ,P1.Document_Date
  ,P1.PO_Type
  ,P1.Work_Number
  ,P1.GL_Account
  ,J1.State
  ,GL.GL_Wennsoft
  ,GL.GL_Wennsoft_Description
  ,GL.CostCodes_Wennsoft
  ,GL.State AS GL_State
  ,GL.GL_Current
  ,GL.GL_Current_Numeric
  
FROM
  dbo.Z_Wennsoft_export_purchase_orders_staging_1 AS P1 
  INNER JOIN
  (SELECT LTRIM(RTRIM(Job_Number)) AS jn, State
  FROM dbo.JC_JOB_MASTER_MC WITH (NOLOCK)) AS J1
    ON P1.Work_Number = J1.jn
  LEFT OUTER JOIN
  dbo.Z_Wennsoft_GL_map AS GL
    ON P1.GL_Account = GL.GL_Current_Numeric AND J1.State = GL.State
WHERE
  (P1.GL_Account LIKE '06%') OR (P1.GL_Account LIKE '04%')
ORDER BY P1.PO_Number, P1.Line_Number
