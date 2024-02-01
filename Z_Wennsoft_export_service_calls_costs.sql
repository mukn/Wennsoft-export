/** This is used to import work order costs into Wennsoft. */

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
		WHEN Costs.Sp_Cost_Code = 'O' THEN '5'
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
	,'' AS Unit_Cost				-- Calculated in Excel
	,'' AS Extended_Cost			-- Calculated in Excel
	,Costs.Transaction_Amount AS Billing_Amount
	,Costs.Pay_Type AS Pay_Record
	,Costs.Tran_Source AS TRX_Source
	--,'' AS Blank
	--,Costs.*
	--,Calls.*


FROM
	Z_Wennsoft_export_service_calls AS Calls
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(WO_Number)) AS WO_Number,Tran_Type AS Sp_Cost_Code,Tran_Source,Reference,GL_Date,Transaction_Amount,Item_Code,Item_Desc,Unit_Price,Quantity,Unit_Of_Measure,Hours,Pay_Type,Remarks
	,LTRIM(RTRIM(AP_Vendor_Code)) AS Vendor_Code
	FROM WO_COST_HISTORY_MC) AS Costs
		ON Calls.WO_Number = Costs.WO_Number
