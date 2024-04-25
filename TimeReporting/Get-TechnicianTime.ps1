<## Get-TechnicianTime

This script retrieves a given technician's time for the given date and sums it.

#>

# Set parameters.
param(
  [Parameter(Mandatory=$True)]
  [string]$EmpID,
  [Parameter(Mandatory=$True)]
  [string]$Date
  )



# Query the database
$sqlSrv = "k2a.nacgroup.com"
$sqlDb = "NAC"
$qry = @"
  SELECT Technician_Long_Name,SUM(TRX_Total1) AS Total_Time
  FROM csvw_TT_Audit_Union 
  WHERE 
    (EMPLOYID = '$EmpID')
    AND (WS_Transaction_Date = $Date)
  GROUP BY Technician_Long_Name
  "@
