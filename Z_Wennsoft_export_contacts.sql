SELECT
	CONCAT(Locs.Location_Code,CAST(Xref.Contact_ID AS varchar)) AS CompKey
	,Locs.Location_Code
	,Xref.Contact_ID
	,Contacts.Concat_Name
	,Contacts.Last_Name
	,Contacts.First_Name
	,Phs.Phone_Number
	,Phs.Phone_Ext
	,Contacts.Email1
	,Contacts.Email2
	,Addrs.Addr_1
	,Addrs.Addr_2
	,Addrs.Addr_City
	,Addrs.Addr_state
	,Addrs.Addr_zip
	,Addrs.Addr_Display
	
FROM
	Z_Wennsoft_export_locations_union AS Locs
	LEFT OUTER JOIN
	(SELECT LTRIM(RTRIM(Site_ID)) AS Location_Code,Contact_ID
	FROM WO_SITE_CONTACTS_MC
	WHERE Company_Code = 'NA2') AS Xref
		ON Locs.Location_Code = Xref.Location_Code
	INNER JOIN
	PA_CONTACTS_MASTER AS Contacts
		ON Xref.Contact_ID = Contacts.Contact_ID
	LEFT OUTER JOIN
	PA_ADDRESS_MASTER AS Addrs
		ON LTRIM(RTRIM(Contacts.Addr_ID)) = LTRIM(RTRIM(Addrs.Addr_ID))
	LEFT OUTER JOIN
	PA_PHONE_MASTER AS Phs
		ON LTRIM(RTRIM(Contacts.Phone_ID)) = LTRIM(RTRIM(Phs.Phone_ID))
WHERE 
	Contacts.Email1 <> ''
	AND Contacts.Status = 'A'
ORDER BY 
	Location_Code
	,Contacts.Last_Name
