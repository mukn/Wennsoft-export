SELECT
	
	LTRIM(RTRIM(PO.PO_Number)) AS PO_Number					-- PO number
	,LTRIM(RTRIM(Det.Line_Number)) AS Line_Number			-- PO line number
	,LTRIM(RTRIM(PO.Vendor_Code)) AS Vendor_Code			-- Vendor ID
	,PO.PO_Date_List1 AS Document_Date						-- Document date
	,1 AS PO_Type											-- PO type (always 1)
	,CASE
		WHEN PO.Job_Number <> '' THEN 2
		WHEN PO.WO_Number <> '' THEN 3
		ELSE 1
	END AS Product_indicator								--,Product indicator (1=None, 2=Job cost, 3=Service)
	,CASE
		WHEN PO.Job_Number <> '' THEN LTRIM(RTRIM(PO.Job_Number))
		WHEN PO.WO_Number <> '' THEN LTRIM(RTRIM(PO.WO_Number))
		ELSE ''
	END AS Work_Number										-- Job number
	,CASE
		WHEN PO.Job_Number <> '' THEN 'n/a'
		ELSE 'Service cost code needed'
	END AS Cost_type										--,Cost type			Needs definition
	,CASE
		WHEN PO.WO_Number <> '' THEN 'n/a'
		ELSE 'Job cost code needed'
	END AS Cost_type										--,Cost code			Needs definition
	,'1 or 2' AS PO_line_status								--,PO line status		Needs definition
	,'1 or 2' AS PO_status									--,PO status			Needs definition
	,Det.PO_Quantity_List1 AS Qty_Ordered					--,Qty order
	,'qty if po status & line status = 2' AS Qty_comtd		--,Qty com td			Needs definition
	,'0' AS Qty_inv_cd										--,Qty inv cd
	,'0' AS Qty_cance										--,Qty cance
	,'0' AS Qty_rej											--,Qty rej
	,'0' AS Qty_actual										--,Qty actual
	,Det.Item_Price											--,Unit cost
	--,Retention pct
	--,Retention amount TTD
	--,Tax amnt
	--,Frt amnt
	--,Committed cost
	,CASE
		WHEN Det.PO_Quantity_List1 > 0 THEN Det.PO_Quantity_List1 * Det.Item_Price
		ELSE 0
	END AS Cost_Act_Total									--,Actual total cost
	,'0' AS Cost_ret_unit --,Ret unit cost
	,'0' AS Cost_rej_total --,Ret total cost
	,'WAREHOUSE' AS Location_Code--,Location code
	,Det.Item_Code AS Item_Number							--,Item number
	,Det.Unit_Of_Measure AS UOFM							-- Unit of measure
	,'1, 2, or 3' AS Item_Taxable							--,Purchase IV item taxable				Needs definition
	
	
	
	
	,PO.PO_Date_List2 AS Date_Delivery					-- Delivery date
	,PO.PO_Date_List3 AS Date_Last_Received				-- Last received
	
	
	,Det.Item_Description
	,Det.Item_Discount_Percent AS Item_Discount_Pct
	
	,Det.WO_Item_Price
	
	
	
	--,PO.Batch_Code
	,''
	
	,Det.PO_Quantity_List2 AS Qty_Received
	,Det.PO_Quantity_List3
	,Det.PO_Quantity_List4
	,Det.PO_Quantity_List5
	

	--,PO.*
FROM
	PO_INQUIRY_V_MC AS PO WITH (NOLOCK)
	LEFT JOIN
	PO_PURCHASE_ORDER_DETAIL_MC AS Det WITH (NOLOCK)
		ON LTRIM(RTRIM(PO.PO_Number)) = LTRIM(RTRIM(Det.PO_Number))
WHERE
	PO.Company_Code = 'NA2'
	--AND PO.Status = 'Open'
ORDER BY LTRIM(RTRIM(PO.PO_Number)) DESC, LTRIM(RTRIM(Det.Line_Number))
