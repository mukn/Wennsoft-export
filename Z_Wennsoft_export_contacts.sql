SELECT
	Cust.Customer_Code
	,Xref.Contact_ID
	,Contacts.Concat_Name
	,Contacts.Last_Name
	,Contacts.First_Name
	,Contacts.Email1
	,Contacts.Email2
FROM 
	Z_K2A_EXPORT_CUSTOMERS AS Cust
	INNER JOIN
	PA_Contact_All_Addr_Types_V AS Xref
		ON Cust.Customer_Code = LTRIM(RTRIM(Xref.Code1))
	LEFT OUTER JOIN
	PA_CONTACTS_MASTER AS Contacts
		ON Xref.Contact_ID = Contacts.Contact_ID
WHERE 
	Contacts.Email1 <> ''
	AND Contacts.Status = 'A'
ORDER BY 
	Customer_Code
	,Contacts.Last_Name
