/*
================================================================================
Quality Checks for Data Consistency and Accuracy
================================================================================
Purpose:
  This script performs quality checks on the 'silver' and 'bronze' schemas to ensure
  data consistency, accuracy, and standardization. Checks include:
  - Null or duplicate primary keys
  - Unwanted spaces in string fields
  - Invalid date ranges and orders
  - Data consistency between related fields (e.g., sales, quantity, price)

Usage Notes:
  - Run after loading data into the Silver Layer
  - Investigate and resolve any discrepancies found
================================================================================
*/

-- 1. Check for Null or Duplicate Primary Keys in 'prd_id'
-- Expectation: No results (indicating no nulls or duplicates)
SELECT 
    prd_id,
    COUNT(*) AS record_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- 2. Check for Unwanted Spaces in Product Names
-- Expectation: No results (indicating no leading/trailing spaces)
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- 3. Check Data Standardization: Distinct Values for 'gen'
-- Lists unique values to verify standardization
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

-- 4. Check for NULL or Negative Product Costs
-- Expectation: No results (indicating no null or negative costs)
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- 5. Check for Invalid Date Orders
-- Ensures order date is not later than ship or due date
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- 6. Check Data Consistency: Sales = Quantity * Price
-- Validates sales calculations and ensures no NULL or non-positive values
SELECT DISTINCT
    sls_sales AS old_sls_sales,
    sls_quantity,
    sls_price AS old_sls_price,
    CASE 
        WHEN sls_sales IS NULL 
             OR sls_sales <= 0 
             OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales 
    END AS sls_sales,
    CASE 
        WHEN sls_price IS NULL 
             OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- 7. Identify Out-of-Range Birth Dates
-- Ensures dates are within a reasonable range (post-1924 and not in the future)
SELECT DISTINCT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();
