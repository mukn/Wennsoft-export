/** This pulls service call information and recategorizes everything according to the Wennsoft divisions. 
    This is saved as a view.
*/

SELECT
    LTRIM(RTRIM(WO.WO_Number)) AS WO_Number
    , WO.WO_Date_List1 AS Create_Date
    , WO.WO_Date_List2
    , WO.WO_Date_List3 AS Completed_Date
    ,WO.WO_Date_List4 AS Assigned_Date
    , LTRIM(RTRIM(WO.Workman_List1)) AS Primary_Tech
    , LTRIM(RTRIM(WO.WO_Job_Division)) AS Division
    ,CASE
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'COMD-DC' THEN 'DC_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'COMM-MD' THEN 'MD_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'COMM-VA' THEN 'VA_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'CTDC-DC' THEN 'DC_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'CTDC-MD' THEN 'MD_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'CTMD-DC' THEN 'DC_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'CTMD-MD' THEN 'MD_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'CTVA-DC' THEN 'DC_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'CTVA-MD' THEN 'MD_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'CTVA-VA' THEN 'VA_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PM-MD-MD' THEN 'MD_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PM-VA-DC' THEN 'DC_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMCDC-DC' THEN 'DC_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMCDC-MD' THEN 'MD_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMCDC-VA' THEN 'VA_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMCMD-MD' THEN 'MD_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMCMD-VA' THEN 'VA_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMCVA-VA' THEN 'VA_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSDC-' THEN 'DC_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSDC-DC' THEN 'DC_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSDC-MD' THEN 'MD_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSDC-VA' THEN 'VA_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSMD-' THEN 'MD_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSMD-DC' THEN 'DC_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSMD-MD' THEN 'MD_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSMD-VA' THEN 'VA_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSPA-PA' THEN 'PA_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSVA-DC' THEN 'DC_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSVA-MD' THEN 'MD_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSVA-VA' THEN 'VA_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMSWV-WV' THEN 'WV_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMVA_HVAC_WATER' THEN 'VA_HVAC_WATER'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMWT-DC' THEN 'DC_HVAC_WATER'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'PMWT-MD' THEN 'MD_HVAC_WATER'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SC-DC-DC' THEN 'DC_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SC-DC-VA' THEN 'VA_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SC-MD-' THEN 'MD_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SC-MD-DC' THEN 'DC_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SC-MD-MD' THEN 'MD_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SC-VA-DC' THEN 'DC_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SC-VA-MD' THEN 'MD_HVAC_PM'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SC-VA-VA' THEN 'VA_HVAC_PM' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPDC-' THEN 'DC_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPDC-DC' THEN 'DC_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPDC-MD' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPMD-' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPMD-DC' THEN 'DC_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPMD-MD' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPMD-PA' THEN 'PA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPMD-VA' THEN 'VA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPVA-' THEN 'VA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPVA-DC' THEN 'DC_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPVA-MD' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SPVA-VA' THEN 'VA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVDC-' THEN 'DC_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVDC-DC' THEN 'DC_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVDC-MD' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVDC-VA' THEN 'VA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVDE-DE' THEN 'DE_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVDE-MD' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVDM-' THEN 'MD_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVMD-' THEN 'MD_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVMD-DC' THEN 'DC_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVMD-MD' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVMD-PA' THEN 'PA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVMD-VA' THEN 'VA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVPA-PA' THEN 'PA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVVA-DC' THEN 'DC_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVVA-MD' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVVA-VA' THEN 'VA_HVAC_EMERG' 
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVVA-WV' THEN 'WV_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVWV-VA' THEN 'VA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'SVWV-WV' THEN 'WV_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'TNCDC-DC' THEN 'DC_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'TNCDC-VA' THEN 'VA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'TNCMD-DC' THEN 'DC_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'TNCMD-MD' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'TNCVA-VA' THEN 'VA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'WO06D-DC' THEN 'DC_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'WO06D-MD' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'WO06D-VA' THEN 'VA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'WO06M-MD' THEN 'MD_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'WO06V-VA' THEN 'VA_HVAC_EMERG'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'WT-DC' THEN 'DC_HVAC_WATER'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'WT-MD' THEN 'MD_HVAC_WATER'
        WHEN CONCAT(LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) = 'WT-VA' THEN 'VA_HVAC_WATER'
        ELSE CONCAT('**** ', LTRIM(RTRIM(WO.WO_Job_Division)), '-', WO.WO_State) 
    END AS Service_Type_Code
    , WO.Complete_Date AS Finished_Date
    ,CASE 
        WHEN WO.Posted_From_SC_Flag = 'S' THEN 'MC'
        WHEN WO.Posted_From_SC_Flag = '' THEN 'T&M' 
        ELSE WO.Posted_From_SC_Flag 
    END AS Service_Type
    ,CASE 
        WHEN WO.Posted_From_SC_Flag = 'S' THEN 1 
        WHEN WO.Posted_From_SC_Flag = '' THEN 0 
        ELSE '' 
    END AS Contract_number_sequence
    ,WO.Scheduled_Start_Date AS Scheduled_Date
    , WO.Dispatch_Status_Code
    , LTRIM(RTRIM(LEFT(WO.Summary_Description, 30))) AS Description
    , Dispatch.Status_Description
    ,CASE 
        WHEN Dispatch.WO_Hold_Status = 'H' THEN 'O' 
        WHEN Dispatch.WO_Hold_Status = 'S' THEN 'O' 
        WHEN Dispatch.WO_Hold_Status = 'R' THEN 'O' 
        ELSE Dispatch.WO_Hold_Status 
    END AS WO_Hold_Status
    , WO.WO_State
    , LTRIM(RTRIM(WO.Bill_Customer_Code)) AS Customer_Code
    , LTRIM(RTRIM(WOA.Ship_To_ID)) AS Location_Code
    ,LTRIM(RTRIM(WO.Contract_Number)) AS Contract_Number
    ,CASE 
        WHEN WO.WO_Date_List3 > WO.WO_Date_List1 THEN 'Closed' 
        WHEN WO.Complete_Date > WO.WO_Date_List1 THEN 'Complete' 
        ELSE 'Open' 
    END AS Status
FROM
    dbo.WO_HEADER2_V_MC AS WO WITH (nolock) 
    LEFT OUTER JOIN
    dbo.WO_ADDRESS_MC AS WOA WITH (nolock) 
        ON WOA.Ship_To_Name = WO.Name 
        AND WOA.Company_Code = WO.Company_Code 
        AND WOA.Ship_To_Address1 = WO.WO_Address_1 
        AND WOA.Ship_To_Address2 = WO.WO_Address_2 
        AND WOA.Ship_To_City = WO.WO_City 
        AND WOA.Ship_To_State = WO.WO_State 
        AND WOA.Ship_To_Zip_Code = WO.WO_Zip_Code 
    LEFT OUTER JOIN
    dbo.WO_DISPATCH_STATUS_MC AS Dispatch WITH (nolock) 
        ON WO.Company_Code = Dispatch.Company_Code 
        AND WO.Dispatch_Status_Code = Dispatch.Status_Code
WHERE     
    (WO.Company_Code = 'NA2') 
    AND (WO.WO_Date_List1 > CONVERT(DATE, '2018-12-31', 102)) 
    AND (WOA.Status = 'A') 
    AND (LTRIM(RTRIM(WO.WO_Job_Division)) <> 'TKSKC') 
    AND (LTRIM(RTRIM(WO.WO_Job_Division)) <> 'TKSKP') 
    AND (LTRIM(RTRIM(WO.WO_Job_Division)) <> 'TKSKS') 
    AND (LTRIM(RTRIM(WO.WO_Job_Division)) <> 'TOOLC') 
    AND (LTRIM(RTRIM(WO.WO_Job_Division)) <> 'TOOLP') 
    AND (LTRIM(RTRIM(WO.WO_Job_Division)) <> 'TOOLS') 
    AND (WO.Dispatch_Status_Code <> 'M')
ORDER BY WO_Number
