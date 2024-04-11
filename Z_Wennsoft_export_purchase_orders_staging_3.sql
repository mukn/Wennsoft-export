SELECT
	'LINE' AS Line_Type
	,0 AS SigLinkOnly
	,1 AS UpdateIfExists
	,P1.PO_Number
	,CAST(P1.Line_Number AS int) AS Line_Number
	,P1.Vendor_Code
	,P1.Document_Date
	,P1.PO_Type
	,P1.Product_Indicator
	--,CASE
	--	WHEN LEN(P1.Work_Number) = 10 THEN 2
	--	WHEN LEN(P1.Work_Number) < 10 THEN 3
	--	ELSE 1
	--END AS Product_Indicator
	--,CASE
	--	WHEN P1.GL_Account LIKE '04%' THEN 3
	--	WHEN P1.GL_Account LIKE '06%' THEN 2
	--	ELSE 1
	--END AS Product_Indicator						-- Updated logic to this
	,P1.Work_Number
	,P1.GL_Account
	,CASE
		WHEN LEN(P1.Work_Number) < 10
			AND P1.CostCodes_Wennsoft LIKE '%EQ.%'
			THEN '1'
		WHEN LEN(P1.Work_Number) < 10
			AND P1.CostCodes_Wennsoft LIKE '%MATL%'
			THEN '2'
		WHEN LEN(P1.Work_Number) < 10
			AND P1.CostCodes_Wennsoft LIKE '%SUBC%'
			THEN '4'
		WHEN LEN(P1.Work_Number) < 10
			AND P1.CostCodes_Wennsoft <> ''
			THEN '5'
		ELSE '0'
	END AS Cost_Type
	--,CASE
	--	WHEN P1.GL_Account LIKE '04%' 
	--		AND P1.CostCodes_Wennsoft LIKE '%EQ.%'
	--		THEN '1'
	--	WHEN P1.GL_Account LIKE '04%' 
	--		AND P1.CostCodes_Wennsoft LIKE '%MATL%'
	--		THEN '2'
	--	WHEN P1.GL_Account LIKE '04%' 
	--		AND P1.CostCodes_Wennsoft LIKE '%SUBC%'
	--		THEN '4'
	--	WHEN P1.GL_Account LIKE '04%' 
	--		AND P1.CostCodes_Wennsoft <> ''
	--		THEN '5'
	--	ELSE ''
	--END AS Cost_Type
	,CASE
		WHEN LEN(P1.Work_Number) = 10 
			AND P1.CostCodes_Wennsoft LIKE '%0MATL%'
			THEN CONCAT(REPLACE(P1.CostCodes_Wennsoft, '.', '-'), '-2')
		WHEN LEN(P1.Work_Number) = 10 
			AND P1.CostCodes_Wennsoft LIKE '%EQ%'
			THEN CONCAT(REPLACE(P1.CostCodes_Wennsoft, '.', '-'), '-3')
		WHEN LEN(P1.Work_Number) = 10 
			AND P1.CostCodes_Wennsoft LIKE '%SUBC%'
			THEN CONCAT(REPLACE(P1.CostCodes_Wennsoft, '.', '-'), '-6')
		ELSE ''
	END AS CostCodes_Wennsoft
	,2 AS PO_line_status
	,2 AS PO_status
	,Det.PO_Quantity_List1 AS Qty_Ordered					--,Qty order
	,Det.PO_Quantity_List1 AS Qty_comtd						--,Qty com td
	,'0' AS Qty_inv_cd										--,Qty inv cd
	,'0' AS Qty_cance										--,Qty cance
	,'0' AS Qty_rej											--,Qty rej
	,'0' AS Qty_actual										--,Qty actual
	,Det.Item_Price	AS Unit_cost							--,Unit cost
	,CASE
		WHEN Det.PO_Quantity_List1 > 0 THEN Det.PO_Quantity_List1 * Det.Item_Price
		ELSE 0
	END AS Cost_Act_Total									--,Actual total cost
	,'0' AS Cost_ret_unit									--,Ret unit cost
	,'0' AS Cost_rej_total									--,Ret total cost
	,'WAREHOUSE' AS Location_Code							--,Location code
	,Det.Item_Code AS Item_Number							--,Item number
	,Det.Unit_Of_Measure AS UOFM							-- Unit of measure
	,Det.Item_Description
	,Det.Item_Discount_Percent AS Item_Discount_Pct
	,Det.WO_Item_Price
	,Det.PO_Quantity_List2 AS Qty_Received
	,1 AS Noninventory
	,CASE
		WHEN Det.Taxable_Flag = 'Y' THEN 1
		WHEN Det.Taxable_Flag = 'N' THEN 2
		ELSE 3
	END AS Item_Taxable
	,0 as Tax_Amount
	--,Det.Tax_Amount_List1 AS Tax_Amount
	,0 AS Freight_Amount
	,0 AS Ret_unit_cost
	,0 AS Ret_total_cost
	,0 AS Ret_Pct
	,0 AS Ret_amt_ttd
	,0 AS Ret_unit_cost
	,0 AS Ret_total_cost
	,1 AS HDR_UsingHeaderTaxes
	,3 AS HDR_PurchaseFreight
	,3 AS HDR_PurchaseTaxable
	,'MD' AS Tax_Schedule
	,'DELIVERY' AS ShipMethod



FROM
	(SELECT PO_Number,Line_Number,Vendor_Code,Document_Date,PO_Type,Product_Indicator,Work_Number,GL_Account,State,GL_Wennsoft,GL_Wennsoft_Description,CostCodes_Wennsoft,GL_State,GL_Current,GL_Current_Numeric
	FROM Z_Wennsoft_export_purchase_orders_staging_2_jobs
	UNION
	SELECT PO_Number,Line_Number,Vendor_Code,Document_Date,PO_Type,Product_Indicator,Work_Number,GL_Account,State,GL_Wennsoft,GL_Wennsoft_Description,CostCodes_Wennsoft,GL_State,GL_Current,GL_Current_Numeric
	FROM Z_Wennsoft_export_purchase_orders_staging_2_workorders) AS P1
	LEFT OUTER JOIN
	PO_PURCHASE_ORDER_DETAIL_MC AS Det WITH (NOLOCK)
		ON P1.PO_Number = LTRIM(RTRIM(Det.PO_Number)) AND P1.Line_Number = Det.Line_Number
ORDER BY P1.PO_Number, P1.Line_Number


--SELECT * FROM PO_PURCHASE_ORDER_DETAIL_MC WHERE Company_Code = 'NA2' AND Taxable_Flag <> ''
