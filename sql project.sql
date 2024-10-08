/*1. the difference between average claim_cost and payer_coverage balances grouped by encounter_class    */

SELECT * FROM mghdata.encounters;
SELECT ENCOUNTER_CLASS,ROUND(avg(BASE_ENCOUNTER_COST),2)   AVG_BASE_COST,round(AVG(TOTAL_CLAIM_COST),2)   AVG_CLAIM_COST,round(AVG(PAYER_COVERAGE),2)   AVG_PAYER_COVERAGE,  (round(AVG(TOTAL_CLAIM_COST),2)) - (round(AVG(PAYER_COVERAGE),2)) BALACE
FROM mghdata.encounters
group by ENCOUNTER_CLASS;

/*2.Count of patients categorized by encounter_class */
SELECT ENCOUNTER_CLASS, count(CODE)   No_of_patients
FROM mghdata.encounters
group by ENCOUNTER_CLASS
order by No_of_patients DESC;

/*3.Top 10 revenue generating healthcare organizations*/
SELECT * FROM mghdata.organization;
SELECT NAME,ROUND(REVENUE,2)   Revenue
FROM mghdata.organization
order by REVENUE DESC;

/*4.Healthcare organizations based on utilization */
SELECT NAME,UTILIZATION
FROM mghdata.organization
order by UTILIZATION DESC;


/*5. Count of gender based on race */
SELECT * FROM mghdata.patients;
SELECT GENDER,count(GENDER)   cOUNT_OF_GENDER
FROM mghdata.patients
GROUP BY GENDER;

/*6.healthcare_expenses and coverage based on patients*/
SELECT FULL_NAME,HEALTHCARE_EXPENSES,HEALTHCARE_COVERAGE
FROM mghdata.patients;

/*7.Count of ethicity*/
SELECT ETHNICITY,COUNT(ETHNICITY)   Count_of_Ethnicity
FROM mghdata.patients
group by ETHNICITY;


/*8.Count of gender based on race*/
SELECT * FROM mghdata.patients;
SELECT RACE,GENDER,COUNT(GENDER)   COUNT_OF_GENDER
FROM mghdata.patients
group by RACE,GENDER
ORDER BY RACE DESC,GENDER ASC;

/*9.Payers based on revenue*/
SELECT * FROM mghdata.payer;
SELECT NAME,REVENUE
FROM mghdata.payer
ORDER BY REVENUE DESC;


/* 10.Count of ownership */
SELECT * FROM mghdata.payer_transactions;
SELECT OWNERSHIP,count(OWNERSHIP)   COUNT_OF_OWNERSHIP
FROM mghdata.payer_transactions
group by OWNERSHIP;

/*11.PROVIDERS WHERE UTILIZATION IS GREATER THAN 1000*/
SELECT * FROM mghdata.providers;
SELECT NAME,UTILIZATION
FROM mghdata.providers
WHERE UTILIZATION > 1000
order by UTILIZATION DESC;

/*12.providers aggregated by gender*/
SELECT * FROM mghdata.providers;
SELECT GENDER,count(GENDER)   COUNT_OF_GENDER
FROM mghdata.providers
group by GENDER;

/*13. Number of specialists aggregated by their specialties in massachussets*/
SELECT * FROM mghdata.providers;
SELECT SPECIALITY,count(SPECIALITY)   No_of_Specialists
FROM mghdata.providers
group by SPECIALITY
order by No_of_Specialists DESC;

/*14. joins  */
SELECT pd.NAME   PROVIDER,pd.SPECIALITY,od.NAME   ORGANIZATION,od.UTILIZATION,REVENUE
FROM mghdata.providers pd
JOIN
mghdata.organization od ON od.Id=pd.organization;

/*Organizations with more than the average revenue */
SELECT * 
FROM mghdata.organization
WHERE REVENUE > (SELECT round(Avg(REVENUE),2)   Avg_revenue
FROM mghdata.organization);

/* 15.STORE PROCEDURE  */
SELECT DISTINCT pd.Id,pd.SSN,pd. BIRTH_DATE,pd.DEATH_DATE,pd.PASSPORT,pd.FULL_NAME,pd.GENDER,pd.ADDRESS,pd.CITY,pd.COUNTY,pd.ZIP,ed.ENCOUNTER_CLASS,pd.HEALTHCARE_EXPENSES,pd.HEALTHCARE_COVERAGE,ed.`START`,ed.`STOP`
FROM mghdata.patients pd
JOIN 
mghdata.encounters ed ON pd.Id = ed.PATIENT;

delimiter $$
create procedure mghdata.patients(IN FULL_NAME VARCHAR(100))
begin
SELECT DISTINCT pd.SSN,pd.FULL_NAME,pd. BIRTH_DATE,pd.DEATH_DATE,pd.GENDER,ed.`DESCRIPTION`,ed.ENCOUNTER_CLASS,ed.`START`,ed.`STOP`,
pd.ADDRESS,pd.CITY,pd.COUNTY,pd.HEALTHCARE_EXPENSES,pd.HEALTHCARE_COVERAGE
FROM mghdata.patients pd
JOIN 
mghdata.encounters ed ON pd.Id = ed.PATIENT
where pd.FULL_NAME = FULL_NAME;
end $$
delimiter ;

call mghdata.patients();
drop procedure mghdata.patients;


/*join on providers and organizations*/
SELECT dp.NAME,od.NAME,dp.GENDER,dp.SPECIALITY,dp.UTILIZATION,dp.ADDRESS,dp.CITY,dp.STATE,dp.ZIP
FROM mghdata.providers dp
JOIN
mghdata.organization od ON dp.ORGANIZATION = od.Id;

/* store procedure on providers*/
delimiter $$
create procedure mghdata.provider(IN Provider_Name VARCHAR(100))
begin
SELECT dp.NAME   PROVIDER_NAME,od.NAME   ORGANIZATION,dp.GENDER,dp.SPECIALITY,dp.UTILIZATION,dp.ADDRESS,dp.CITY,dp.STATE,dp.ZIP
FROM mghdata.providers dp
JOIN
mghdata.organization od ON dp.ORGANIZATION = od.Id
where dp.NAME = Provider_Name;
end $$
delimiter ;

call mghdata.provider();
drop procedure mghdata.provider;

SELECT * FROM mghdata.organization;
SELECT * FROM mghdata.providers;

SELECT mo.CITY,count(mp.SPECIALITY)   Count_of_speciality
FROM mghdata.organization mo
JOIN
mghdata.providers mp ON mo.Id = mp.ORGANIZATION
GROUP BY CITY
ORDER BY Count_of_speciality DESC;

/* Patients who spent more than one hour at the hospitals */
SELECT pa.FULL_NAME,timediff(ec.`STOP`,ec.`START`)   TIME
FROM mghdata.patients pa
JOIN
mghdata.encounters ec ON pa.Id = ec.PATIENT
WHERE timediff(ec.`STOP`,ec.`START`) > '01:00:00';


