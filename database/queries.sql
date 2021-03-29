
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
