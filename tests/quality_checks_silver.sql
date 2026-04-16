/*
=========================================================================================
Quality Checks
=========================================================================================
Script Purpose:
    This script performs various quaity checks for data consistency, accuracy, and
    standardization across the 'silver' schema. It includes checcks for;
    - Null or duplicate primary keys
    - Unwanted spaces in string fields
    - Data standardization and consistency
    - Invalid date ranges and orders
    - Data consistency between related fields

Usage Notes:
    - Run this checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
=========================================================================================
*/

-- =========================================================================
-- Data quality checks on crm_cust_info
-- =========================================================================
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result

SELECT 
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- check for unwanted spaces
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- check for consistency and standardization
-- normalization or standardization: mapping abbrev to full words
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

-- Data quality verification after inserting into silver table
SELECT *
FROM silver.crm_cust_info
  
-- =========================================================================
-- Data quality checks on crm_prod_info
-- =========================================================================

-- Check for Nulls or Duplicates in Primary Key
SELECT 
	prd_id,
	COUNT (*)
FROM bronze.crm_prod_info
GROUP BY prd_id
HAVING COUNT (*) >1 

-- Handling nulls
SELECT 
	prd_cost
FROM bronze.crm_prod_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- check for consistency and standardization
SELECT 
	DISTINCT prd_line
FROM bronze.crm_prod_info

-- check for invalid date
SELECT *
FROM bronze.crm_prod_info
WHERE prd_end_dt < prd_start_dt

-- Data quality verification after inserting into silver table
SELECT *
FROM silver.crm_prod_info
  
-- =========================================================================
-- Data quality checks on crm_sales_details
-- =========================================================================
-- Check for Nulls or Duplicates in Primary Key
SELECT
	sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prod_info)

-- check invalid date
SELECT
	NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8

-- check invalid date
SELECT
*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- checking if the columns follow the business rule
SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price,
	/* 
	CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
		 ELSE sls_sales
	END AS sls_sales1,
	CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / ABS(sls_quantity)
		 ELSE sls_price
	END AS sls_price1
	*/
FROM bronze.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity 
OR sls_sales <= 0 OR sls_price <= 0 OR sls_quantity <= 0
OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL
ORDER BY sls_sales, sls_quantity,sls_price

-- Data quality verification after inserting into silver table
SELECT *
FROM silver.crm_sales_details
  
-- =========================================================================
-- Data quality checks on erp_cust_az12
-- =========================================================================
-- checking our pk column
SELECT *
FROM bronze.erp_cust_az12
WHERE cid LIKE '%AW00011000'

SELECT * FROM silver.crm_cust_info;

-- Identify invalid or out-of-range date
SELECT DISTINCT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1926-01-01' OR bdate > GETDATE()

-- check for consistency and standardization
SELECT DISTINCT gen
FROM bronze.erp_cust_az12

-- Data quality verification after inserting into silver table
SELECT *
FROM silver.erp_cust_az12
  
-- =========================================================================
-- Data quality checks on erp_loc_a101
-- =========================================================================
-- checking our pk column
SELECT cid
FROM bronze.erp_loc_a101

-- check for consistency and standardization
SELECT DISTINCT 
	cntry
FROM bronze.erp_loc_a101
ORDER BY cntry

-- Data quality verification after inserting into silver table
SELECT *
FROM silver.erp_loc_a101
  
-- =========================================================================
-- Data quality checks on erp_px_cat_g1v2
-- =========================================================================
-- checking our pk column
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (
SELECT cat_id FROM silver.crm_prod_info);

-- Check for null in pk column
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE LEN(id) != 5

-- checking cat, subcat, maintenance column for nulls
SELECT cat, subcat, maintenance
FROM bronze.erp_px_cat_g1v2
WHERE cat IS NULL OR subcat IS NULL OR maintenance IS NULL

-- checking cat, subcat, maintenance column for list of values
SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2
ORDER BY maintenance

-- Data quality verification after inserting into silver table
SELECT *
FROM silver.erp_px_cat_g1v2
