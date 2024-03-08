SELECT
	Cust.Customer_Code
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
	
	Z_K2A_EXPORT_CUSTOMERS AS Cust
	INNER JOIN
	PA_Contact_All_Addr_Types_V AS Xref
		ON Cust.Customer_Code = LTRIM(RTRIM(Xref.Code1))
	LEFT OUTER JOIN
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
	Customer_Code
	,Contacts.Last_Name
