
/* 4 -- List out people with health insurance that has COVID coverage */
SELECT DISTINCT P.name
FROM People P NATURAL JOIN Health_Insurance HI
WHERE HI.covid_coverage = 'T' OR HI.covid_coverage = 't';

/* 5 -- List out health insurance number of people eligible for a distribution phase which has three or more comorbidities associated with it */
SELECT DISTINCT HI.Insurance_Number
FROM Health_Insurance HI, ((SELECT DISTINCT P.phase_number FROM People P)
INTERSECT
(SELECT DISTINCT DP.phase_number
FROM Distribution_Phase DP NATURAL JOIN associated_with AW
GROUP BY DP.phase_number
HAVING count(AW.Disease_ID) >= 3));

/* 6 -- List out all vaccine types supplied by a vaccine company which is located at a given address (denoted with x currently) */
SELECT DISTINCT VT.Vaccine_ID, VT.Vaccine_Name
FROM Vaccine_Type VT, (SELECT * FROM Address A NATURAL JOIN Located L)
WHERE A.address_id = x; 


/*----- SANIKA: QUERIES------------- */

/* 3-- List out people eligible for a distribution phase which has three or more comorbidities associated with it. */
SELECT P.SSN, P.name
FROM People P
WHERE P.SSN IN(
SELECT A.Phase_number
FROM associated_with A
GROUP BY A.Phase_number
HAVING COUNT(DISTINCT A.Disease_ID) >= 3);

/* 7-- List out names and SSN of all healthcare people administering vaccine types supplied by a given vaccine company. */
SELECT P.SSN, P.name
FROM People P
WHERE P.SSN IN(
SELECT Admin.SSN
FROM Administers Admin
WHERE Admin.Vaccine_ID IN(
SELECT S.Vaccine_ID
FROM Supplies S
WHERE S.Company_ID IN((SELECT C.Company_ID FROM Vaccine_Companies C WHERE C.Company_Name = 'ModernaTX'))));

/*9-- List out all the appointments having vaccine types supplied by a given vaccine company. */
SELECT AP.Appt_ID
FROM Appointments AP
WHERE AP.Vaccine_ID IN(
SELECT S.Vaccine_ID
FROM Supplies S
WHERE S.Company_ID IN(
(SELECT C.Company_ID FROM Vaccine_Companies C WHERE C.Company_Name = 'ModernaTX')))

/*8.-- List out all people scheduling an appointment for a distribution phase with 3 months of duration. -S */
/*SELECT P.SSN, P.name
FROM People P
WHERE P.SSN IN(

SELECT A.SSN
FROM Appointments A
WHERE A.is_part_of IN( 
SELECT DP.Phase_number FROM Distribution_Phase DP WHERE (SELECT DATEDIFF(month, DP.Start_Date, DP.End_Date) > 3 )
)

)*/
