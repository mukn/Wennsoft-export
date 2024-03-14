SELECT
	
	LTRIM(RTRIM(PO.PO_Number)) AS PO_Number					-- PO number
	,LTRIM(RTRIM(Det.Line_Number)) AS Line_Number			-- PO line number
	,LTRIM(RTRIM(PO.Vendor_Code)) AS Vendor_Code			-- Vendor ID
	,PO.PO_Date_List1 AS Document_Date						-- Document date
	--,Line number
	,1 AS PO_Type											-- PO type (always 1)
	--,Product indicator (1=None, 2=Job cost, 3=Service)
	,CASE
		WHEN PO.Job_Number <> '' THEN LTRIM(RTRIM(PO.Job_Number))
		WHEN PO.WO_Number <> '' THEN LTRIM(RTRIM(PO.WO_Number))
		ELSE ''
	END AS Work_Number										-- Job number
	--,Cost type
	--,Cost code
	--,PO line status
	--,PO status
	--,Qty order
	--,Qty com td
	--,Qty inv cd
	--,Qty cance
	--,Qty rej
	--,Qty actual
	--,Unit cost
	--,Retention pct
	--,Retention amount TTD
	--,Tax amnt
	--,Frt amnt
	--,Committed cost
	--,Actual total cost
	--,Ret unit cost
	--,Ret total cost
	--,Location code
	--,VNDITNUM -- Vendor item number ?
	--,Item number
	--,Quantity
	--,Non-inventory
	,Det.Unit_Of_Measure AS UOFM							-- Unit of measure
	--,Purchase IV item taxable
	
	
	
	
	,PO.PO_Date_List2 AS Date_Delivery					-- Delivery date
	,PO.PO_Date_List3 AS Date_Last_Received				-- Last received
	
	,Det.Item_Code
	,Det.Item_Description
	,Det.Item_Discount_Percent
	,Det.Item_Price
	,Det.WO_Item_Price
	
	
	,PO.Batch_Code
	,''

	--,PO.*
FROM
	PO_INQUIRY_V_MC AS PO WITH (NOLOCK)
	LEFT JOIN
	PO_PURCHASE_ORDER_DETAIL_MC AS Det WITH (NOLOCK)
		ON PO.PO_Number = LTRIM(RTRIM(Det.PO_Number))
WHERE
	PO.Company_Code = 'NA2'
	AND PO.Status = 'Open'
ORDER BY LTRIM(RTRIM(PO.PO_Number)) DESC
