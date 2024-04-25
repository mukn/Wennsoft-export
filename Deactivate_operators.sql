/** The operator table before */
SELECT * FROM PA_Operator_master
WHERE 
	Operator_ID <> '123'
	AND Operator_ID <> 'JER'
	AND Operator_ID <> 'CPK'
	AND Operator_ID <> 'IK'
	AND Operator_ID <> 'KSA'
	AND Operator_ID <> 'JCW'
	AND Operator_ID <> 'LEE'
	AND Operator_ID <> 'TCA'
	AND Operator_ID <> 'SS1'


/** The UPDATE command to script */
UPDATE PA_Operator_master
SET Status = 'I'
WHERE 
	Operator_ID <> '123'
	AND Operator_ID <> 'JER'
	AND Operator_ID <> 'CPK'
	AND Operator_ID <> 'IK'
	AND Operator_ID <> 'KSA'
	AND Operator_ID <> 'JCW'
	AND Operator_ID <> 'LEE'
	AND Operator_ID <> 'TCA'
	AND Operator_ID <> 'SS1'


/** The operator table after */
SELECT * FROM PA_Operator_master
WHERE 
	Operator_ID = '123'
	OR Operator_ID = 'JER'
	OR Operator_ID = 'CPK'
	OR Operator_ID = 'IK'
	OR Operator_ID = 'KSA'
	OR Operator_ID = 'JCW'
	OR Operator_ID = 'LEE'
	OR Operator_ID = 'TCA'
	OR Operator_ID = 'SS1'
