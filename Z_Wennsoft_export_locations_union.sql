/* Z_Wennsoft_export_locations_union */ 
SELECT Customer_Code, Contract_Number, Location_Code, Location_Name, Location_Addr1, Location_Addr2, Location_Addr3, Location_City, Location_State, 
                         Location_Zip, Location_Latitude, Location_Longitude, Location_Phone1, Location_Phone2, Location_Contact, Service_Zone, [Contract/Non-contract], Vertical_Market, Sales_Tax_Code, { fn CONCAT(Customer_Code, { fn CONCAT('-', Location_Code) }) } AS Second_Comparison_Key, Comparison_Key, Location_BillTo, Customer_Email
FROM         Z_Wennsoft_export_locations_contracts_billto
UNION
SELECT   Customer_Code, Contract_Number, Location_Code, Location_Name, Location_Addr1, Location_Addr2, Location_Addr3, Location_City, Location_State, Location_Zip, Location_Latitude, Location_Longitude, Location_Phone1, Location_Phone2, 
                         Location_Contact, Service_Zone, [Contract/Non-contract], Vertical_Market, Sales_Tax_Code, { fn CONCAT(Customer_Code, { fn CONCAT('-', Location_Code) }) } AS Second_Comparison_Key, Comparison_Key, Location_BillTo, Customer_Email
FROM         Z_Wennsoft_export_locations_contracts_work_locations
UNION
SELECT   Customer_Code, Job_Number, Location_Code, Location_Name, Location_Addr1, Location_Addr2, Location_Addr3, Location_City, Location_State, Location_Zip, Location_Latitude, Location_Longitude, Location_Phone1, Location_Phone2, 
                         Location_Contact, Service_Zone, [Contract/Non-contract], Vertical_Market, Sales_Tax_Code, { fn CONCAT(Customer_Code, { fn CONCAT('-', Location_Code) }) } AS Second_Comparison_Key, Comparison_Key, Location_BillTo, Customer_Email
FROM         Z_Wennsoft_export_locations_jobs_work_locations
UNION
SELECT   Customer_Code, Job_Number, Location_Code, Location_Name, Location_Addr1, Location_Addr2, Location_Addr3, Location_City, Location_State, Location_Zip, Location_Latitude, Location_Longitude, Location_Phone1, Location_Phone2, 
                         Location_Contact, Service_Zone, [Contract/Non-contract], Vertical_Market, Sales_Tax_Code, { fn CONCAT(Customer_Code, { fn CONCAT('-', Location_Code) }) } AS Second_Comparison_Key, Comparison_Key, Location_BillTo, Customer_Email
FROM         Z_Wennsoft_export_locations_jobs_billto
