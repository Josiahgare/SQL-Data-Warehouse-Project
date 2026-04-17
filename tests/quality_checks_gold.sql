/*
==============================================================================================
Quality Checks GOLD LAYER
==============================================================================================
Script Purpose:
    This Scripts performa quality checks to validate the integrity, consistency, and accuracy
    of the Gold layer. These checks ensure;
    - Uniqueness of surrogate keys in dimension tables
    - Referential integrity between fact and dimension tables
    - Validation of relationships in the data model for analytical purpose

Usage Notes:
    - Run the scripts after data liading silver layer
    - Investigate and resolve anydiscrepancies found during the checks
==============================================================================================
*/

-- ===============================================================================
-- Data Integration: Handling similar columns with unmatching data after the joins
-- ===============================================================================

SELECT 
	ci.cst_gndr,
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen, 'n/a')
	END gender
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON		ci.cst_key = la.cid;

SELECT DISTINCT gender FROM gold.dim_customers;

-- ==================================================================
-- checking: 'gold.dim_customers'
-- ==================================================================
-- checking the uniqueness of customer_key in gold.dim_customers
-- Expectation: No result

  SELECT 
      customer_key,
      COUNT(*) AS duplicate_count
  FROM gold.dim_customers
  GROUP BY customer_key
  HAVING COUNT(*) > 1;

-- ==================================================================
-- checking: 'gold.dim_products'
-- ==================================================================
-- checking the uniqueness of product_key in gold.dim_products
-- Expectation: No result
  
  SELECT 
      product_key,
      COUNT(*) AS duplicate_count
  FROM gold.dim_products
  GROUP BY product_key
  HAVING COUNT(*) > 1;

-- ==================================================================
-- Fact Check: Foreign Key integrity
-- ==================================================================
-- check the data model connectivity between the fact and dimension
  
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL;	-- customer dimension key

SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL;		-- product dimension key
