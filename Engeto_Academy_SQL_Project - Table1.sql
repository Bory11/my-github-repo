/* Pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky.
 * Tedy průměrné mzdy a ceny potravin v jednotlivých letech 2006 až 2018
 */

CREATE OR REPLACE TABLE t_marek_borč_project_SQL_primary_final
SELECT
	cpc.name AS product,
	cp.value AS price,
	cpc.price_value AS price_value,
	cpc.price_unit AS price_unit,
	DATE_FORMAT(cp.date_from, '%Y-%m-%d') AS price_measured_from,
    DATE_FORMAT(cp.date_to, '%Y-%m-%d') AS price_measured_to,
	cpib.name AS industry,
	cpay.value AS payroll,
	cpay.payroll_year
FROM czechia_price AS cp 
JOIN czechia_payroll AS cpay 
	ON cpay.payroll_year = YEAR(cp.date_from)
	AND cpay.payroll_year BETWEEN 2006 AND 2018
	AND cpay.value_type_code = 5958
JOIN czechia_price_category AS cpc 
	ON cpc.code = cp.category_code
LEFT JOIN czechia_payroll_industry_branch AS cpib 
	ON cpib.code = cpay.industry_branch_code
;

/*
 * CREATE TABLE trvá deset minut bez ohledu sekvenci. Zřejmě normální při množství dat?
*/

-- Pomocné dotazy --

SELECT * FROM czechia_payroll AS cp 
WHERE value_type_code = 5958 AND value IS NULL;

CREATE OR REPLACE TABLE t_marek_borč_project_SQL_primary_final_2
SELECT
	cpc.name AS product,
	avg(cp.value) AS price,
	cpc.price_value AS price_value,
	cpc.price_unit AS price_unit,
	DATE_FORMAT(cp.date_from, '%Y-%m-%d') AS price_measured_from,
    DATE_FORMAT(cp.date_to, '%Y-%m-%d') AS price_measured_to,
	cpib.name AS industry,
	cpay.value AS payroll,
	cpay.payroll_year
FROM czechia_price AS cp 
JOIN czechia_payroll AS cpay 
	ON cpay.payroll_year = YEAR(cp.date_from)
	AND cpay.payroll_year BETWEEN 2006 AND 2018
	AND cpay.value_type_code = 5958
JOIN czechia_price_category AS cpc 
	ON cpc.code = cp.category_code
LEFT JOIN czechia_payroll_industry_branch AS cpib 
	ON cpib.code = cpay.industry_branch_code
GROUP BY cpay.payroll_year, cpc.name, cpib.name;