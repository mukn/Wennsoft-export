/** start delta select between what is in WS and what is in Spectrum. 
	This *should* grab any POs that are missing from WS.
	*/
SELECT
	p1.PO_Number
	--,wp.WS_PO_Number										-- Preserving the row to simplify QA testing at the end.
	,CAST(p1.Line_Number AS int) AS Line_Number
	,CAST(p1.Document_Date AS date) AS Document_Date
	,CASE
		WHEN p1.Line_Number IS NULL THEN 'HEADER'
		ELSE 'LINE'
	END AS Line_Type
	,0 AS SignatureLinkOnly
	,1 AS UpdateIfExists
	,LTRIM(RTRIM(p1.Vendor_Code)) AS Vendor_Code
	,1 AS PO_Type
	,p1.Work_Number
	,p1.GL_Account
	,gl.GL_Wennsoft
	,gl.CostCodes_Wennsoft
	,CASE
		WHEN LEN(P1.Work_Number) < 10
			AND gl.CostCodes_Wennsoft LIKE '%EQ.%'
			THEN 1
		WHEN LEN(p1.Work_Number) < 10
			AND gl.CostCodes_Wennsoft LIKE '%MATL%'
			THEN 2
		WHEN LEN(p1.Work_Number) < 10
			AND gl.CostCodes_Wennsoft LIKE '%SUBC%'
			THEN 4
		WHEN LEN(p1.Work_Number) < 10
			AND gl.CostCodes_Wennsoft <> ''
			THEN 5
		ELSE 0
	END AS Cost_Type
	,CASE
		WHEN LEN(p1.Work_Number) > 9
			AND p1.Work_Number != 'NOYESSHOP'
			THEN 2
		WHEN LEN(p1.Work_Number) > 4
			AND p1.Work_Number != 'NOYESSHOP'
			THEN 1
		ELSE 0
	END AS Product_Indicator
	,2 AS PO_Line_Status
	,2 AS PO_Status
	,Det.Qty_comtd
	,0 AS Qty_invcd
	,0 AS Qty_cance
	,0 AS Qty_rej
	,0 AS Qty_actual
	,Det.Unit_Cost
	,0 AS Retention_Pct
	,0 AS Retention_Amt_TTD
	,0 AS Tax_Amt
	,0 AS Frt_Amt
	,Det.Cost_Act_Total AS Cost_act_total
	,0 AS Ret_unit_cost
	,0 AS Ret_total_cost
	,'WAREHOUSE' AS Location_Code
	,Det.Item_Number AS Vendor_item_number
	,Det.Item_Number AS Item_Number
	,Det.Qty_Ordered AS Quantity
	,1 AS Noninventory
	,Det.Item_Description AS Item_Description
	,Det.UOFM AS UOFM
	,Det.Item_Taxable AS Item_Taxable
	,'MD' AS Tax_Schedule
	,'DELIVERY' AS Ship_Method
	,1 AS HDR_UsingHeaderTaxes
	,3 AS HDR_PurchaseFreight
	,3 AS HDR_PurchaseTaxable

FROM
	Z_Wennsoft_purchase_orders_240507 AS wp					-- These are all the purchase orders imported to Wennsoft as of 7 May 2024.
	RIGHT OUTER JOIN
	Z_Wennsoft_export_purchase_orders_staging_1 AS p1		-- This selects all POs that are flagged as 'open' and belong to NA2.
		ON wp.WS_PO_Number = p1.PO_Number
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(WO_Number)) AS WO_Number, Bill_State FROM WO_HEADER_MC WHERE Company_Code = 'NA2') AS wo
		ON p1.Work_Number = wo.WO_Number
	LEFT OUTER JOIN
	Z_Wennsoft_GL_map AS GL
		ON p1.GL_Account = GL.GL_Current_Numeric
			AND wo.Bill_State = GL.State
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(PO_Number)) AS PO_Number, CAST(Line_Number AS int) AS Line_Number, Item_Code AS Item_Number, Item_Description, PO_Quantity_List1 AS Qty_Ordered, PO_Quantity_List2 AS Qty_comtd, Item_Price AS Unit_Cost, CASE WHEN PO_Quantity_List1 > 0 THEN PO_Quantity_List1 * Item_Price ELSE 0 END AS Cost_Act_Total, Unit_Of_Measure AS UOFM, Item_Discount_Percent AS Item_Discount_Pct, WO_Item_Price, CASE WHEN Taxable_Flag = 'Y' THEN 1 WHEN Taxable_Flag = 'N' THEN 2 ELSE 3 END AS Item_Taxable
	FROM PO_PURCHASE_ORDER_DETAIL_MC WITH (NOLOCK) WHERE Company_Code = 'NA2') AS Det
		ON p1.PO_Number = LTRIM(RTRIM(Det.PO_Number)) AND p1.Line_Number = CAST(Det.Line_Number as int)
	
WHERE WS_PO_Number IS NULL									-- Remove any POs that have already been imported to Wennsoft. This is probably because of additional line items in Spectrum.
	AND (p1.GL_Account NOT LIKE '04%')						-- Remove any POs that belong to Service division
	AND (p1.GL_Account NOT LIKE '06%')						-- Remove any POs that belong to Special Projects divison
ORDER BY 
	p1.PO_Number, CAST(p1.Line_Number AS int)				-- Sort by PO number then line number
	-- p1.GL_Account										-- Sort by GL code
