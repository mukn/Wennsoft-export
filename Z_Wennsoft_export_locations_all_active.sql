SELECT
	LTRIM(RTRIM(Ship_To_Customer_Code)) AS Customer_Code
	,LTRIM(RTRIM(Contract.Contract_Number)) AS Contract_Number
	,LTRIM(RTRIM(Ship_to_id)) AS Location_Code
	,LTRIM(RTRIM(Site.Billto_Code)) AS Location_BillTo
	,LTRIM(RTRIM(Ship_To_Name)) AS Location_Name
	
	,LTRIM(RTRIM(Ship_To_Address1)) AS Location_Addr1
	,LTRIM(RTRIM(Ship_To_Address2)) AS Location_Addr2
	,'' AS Location_Addr3
	,LTRIM(RTRIM(Ship_To_City)) AS Location_City
	,LTRIM(RTRIM(Ship_To_State)) AS Location_State
	,LTRIM(RTRIM(Ship_To_Zip_Code)) AS Location_Zip
	,LTRIM(RTRIM(Ship_To_Phone1)) AS Location_Phone1
	,LTRIM(RTRIM(Ship_To_Phone2)) AS Location_Phone2
	,LTRIM(RTRIM(Site_Contact_Person)) AS Location_Contact
	,LTRIM(RTRIM(Zone)) AS Service_Zone
	,CASE
		WHEN Contract.Site_ID <> '' THEN 'Contract'
		ELSE 'Non-contract'
	END AS [Contract/Non-contract]
	,WU.Vert_Market AS Vertical_Market
	,'NT' AS Sales_Tax_Code
	,Site.Sales_Tax_Code AS Sales_Tax_Code_SP
	,{ fn CONCAT(LTRIM(RTRIM(Ship_To_Customer_Code)), { fn CONCAT('-', { fn CONCAT(LTRIM(RTRIM(Ship_To_ID)), '-Main') }) }) } AS Comparison_Key
	,'' AS AltBillTo_Flag
	,CASE
		WHEN Contract.Alternate_Address = 'Y' THEN CONCAT(LTRIM(RTRIM(Contract.Site_ID)), '-BillTo') 
		ELSE LTRIM(RTRIM(Contract.Site_ID)) 
	END AS Location_BillTo
	,Work_Site_Email AS Customer_Email
	,Latitude AS Location_Latitude
	,Longitude AS Location_Longitude
	--,''
	--,*
FROM
	WO_ADDRESS_MC AS Site WITH (NOLOCK)
	LEFT OUTER JOIN
	SC_CONTRACT_MC AS Contract WITH (NOLOCK)
		ON Site.Company_Code = Contract.Company_Code
			AND LTRIM(RTRIM(Site.Ship_To_Customer_Code)) = LTRIM(RTRIM(Contract.Company_Code))
			AND LTRIM(RTRIM(Site.Ship_To_ID)) = LTRIM(RTRIM(Contract.Site_ID))
	LEFT OUTER JOIN
	(SELECT Site_ID, Alpha_Field AS Vert_Market
	  FROM dbo.WO_SITE_USER_FIELDS_DET_MC
	  WHERE (Company_Code = 'NA2') AND (User_Def_Sequence = '000023')) AS WU 
		ON LTRIM(RTRIM(Site.Ship_To_ID)) = LTRIM(RTRIM(WU.Site_ID))
			--AND LTRIM(RTRIM(Contract.Site_ID)) = LTRIM(RTRIM(WU.Site_ID))
WHERE
	Site.Company_Code = 'NA2'
	AND Status = 'A'
