/** This is used to import work order costs into Wennsoft. */

WITH Summed AS (
    SELECT Control_Code, SUM(Transaction_Amount) AS Sum_Amount
    FROM dbo.WO_COST_HISTORY_MC
    WHERE Pay_Type IN ('R', 'BASIC LIFE', 'LTD ER')
    GROUP BY Control_Code
)
SELECT 
	Calls.WO_Number
	,Calls.Status
	,'0' AS Sequence_Number
	,Calls.Customer_Code
	,Calls.Location_Code
	,Costs.Sp_Cost_Code
	,CASE 
		WHEN Costs.Sp_Cost_Code = 'E' THEN '1' 
		WHEN Costs.Sp_Cost_Code = 'M' THEN '2' 
		WHEN Costs.Sp_Cost_Code = 'S' THEN '4' 
		WHEN Costs.Sp_Cost_Code = 'O' THEN '4' 
		WHEN Costs.Sp_Cost_Code = 'L' THEN '6' 
		ELSE Costs.Sp_Cost_Code 
	END AS WS_Cost_Code
	,Costs.GL_Date AS Document_Date
	,Costs.Item_Desc AS Transaction_Description
	,CASE 
		WHEN Costs.Sp_Cost_Code = 'L' THEN Costs.Hours * 100 
		ELSE 0 
	END AS TRX_Hours_Units
	,CASE 
		WHEN Costs.Sp_Cost_Code <> 'L' THEN CAST(Costs.Quantity AS int) 
		ELSE '0' 
	END AS TRX_Qty
	,'' AS Unit_Cost
	
	,CASE 
		WHEN Costs.Pay_Type = 'R' AND Costs.Control_Code IN (SELECT Control_Code FROM Summed) THEN S.Sum_Amount 
		ELSE Costs.Transaction_Amount 
	END AS Extended_Cost
	,'Get from Inv.Billed' AS Billing_Amount
	,CASE
		WHEN Costs.Pay_Type = 'R' THEN 'REG'
		WHEN Costs.Pay_Type = 'O' THEN 'OT'
		WHEN Costs.Pay_Type = 'D' THEN 'DT'
		ELSE ''
	END AS Pay_Record
	,Costs.Tran_Source AS TRX_Source
	,xref.Invoice_Number
FROM 
	Z_Wennsoft_export_service_calls AS Calls 
	LEFT OUTER JOIN
    (SELECT LTRIM(RTRIM(WO_Number)) AS WO_Number, Tran_Type AS Sp_Cost_Code, Tran_Source, Reference, GL_Date, Transaction_Amount, Item_Code, Item_Desc, Unit_Price, 
        Quantity, Unit_Of_Measure, Hours, Pay_Type, Remarks, LTRIM(RTRIM(AP_Vendor_Code)) AS Vendor_Code, Control_Code
    FROM WO_COST_HISTORY_MC) AS Costs 
		ON Calls.WO_Number = Costs.WO_Number
	LEFT JOIN 
	Summed AS S 
		ON Costs.Control_Code = S.Control_Code
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Work_Order)) AS WO_Number,LTRIM(RTRIM(Invoice_Or_Transaction)) AS Invoice_Number
	FROM CR_OPEN_ITEM_INVOICE_MC
	WHERE (Company_Code = 'NA2') AND (Work_Order <> '')) AS xref
		ON Calls.WO_Number = xref.WO_Number
WHERE 
	(Calls.Status = 'Open') 
	AND (Costs.Sp_Cost_Code <> '')
	AND Costs.Pay_Type NOT IN ('BASIC LIFE', 'LTD ER')
ORDER BY Calls.WO_Number, Location_Code, Document_Date
