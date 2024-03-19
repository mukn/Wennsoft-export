SELECT
	
	LTRIM(RTRIM(PO.PO_Number)) AS PO_Number					-- PO number
	,LTRIM(RTRIM(Det.Line_Number)) AS Line_Number			-- PO line number
	,LTRIM(RTRIM(PO.Vendor_Code)) AS Vendor_Code			-- Vendor ID
	,PO.PO_Date_List1 AS Document_Date						-- Document date
	,1 AS PO_Type											-- PO type (always 1)
	,CASE
		WHEN PO.Job_Number <> '' THEN 2
		WHEN (PO.WO_Number <> '') 
			AND (LEN(LTRIM(RTRIM(PO.WO_Number))) <= 6) 
			AND (LEN(LTRIM(RTRIM(PO.WO_Number))) >= 5) THEN 3
		ELSE 1
	END AS Product_indicator								--,Product indicator (1=None, 2=Job cost, 3=Service)
	,CASE
		WHEN PO.Job_Number <> '' THEN LTRIM(RTRIM(PO.Job_Number))
		WHEN PO.WO_Number <> '' THEN LTRIM(RTRIM(PO.WO_Number))
		ELSE ''
	END AS Work_Number										-- Job number
	,Det.GL_Account
	,CASE
		WHEN PO.Job_Number <> '' THEN 'n/a'
		ELSE GL.CostCodes_Wennsoft
	END AS Cost_type										--,Cost type
	,CASE
		WHEN PO.WO_Number <> '' THEN 'n/a'
		ELSE GL.CostCodes_Wennsoft
	END AS Cost_code										--,Cost Code
	,2 AS PO_line_status									--,PO line status
	,2 AS PO_status											--,PO status
	,Det.PO_Quantity_List1 AS Qty_Ordered					--,Qty order
	,Det.PO_Quantity_List1 AS Qty_comtd						--,Qty com td
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
	
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Job_Number)) AS Job_Number,State--,*
	FROM JC_JOB_MASTER_MC
	WHERE Company_Code = 'NA2') AS Job
		ON PO.Job_Number = Job.Job_Number
	LEFT OUTER JOIN
	Z_Wennsoft_GL_map AS GL
		--ON CAST(Det.GL_Account AS int) = CAST(GL.GL_Current_Numeric AS int)
		ON Det.GL_Account = GL.GL_Current_Numeric
			AND GL.State = Job.State
	--LEFT OUTER JOIN
	--(SELECT LTRIM(RTRIM(Job_Number)) AS jn,LTRIM(RTRIM(Phase_Code)) AS pc,LTRIM(RTRIM(Cost_Type)) AS cc,LTRIM(RTRIM(PO_Number)) AS pn,LTRIM(RTRIM(Line_Number)) AS ln
	--FROM PO_JOB_PHASE_XREF_MC WITH (NOLOCK)
	--WHERE Company_Code = 'NA2') AS xref_jc
	--	ON LTRIM(RTRIM(PO.Job_Number)) = xref_jc.jn
	--		AND LTRIM(RTRIM(Det.Line_Number)) = xref_jc.ln
	--		AND LTRIM(RTRIM(PO.PO_Number)) = xref_jc.pn
WHERE
	PO.Company_Code = 'NA2'
	AND PO.Status = 'Open'



	--AND LTRIM(RTRIM(PO.Job_Number))  = '24020402RO'



ORDER BY LTRIM(RTRIM(PO.PO_Number)) DESC, LTRIM(RTRIM(Det.Line_Number))
