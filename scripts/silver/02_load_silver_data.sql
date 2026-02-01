insert into silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)

SELECT 
	cst_id,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	case when upper(trim(cst_marital_status)) = 'M' then 'Married'
		 when upper(trim(cst_marital_status)) = 'S' then 'Single'
		 else 'n/a'
	end as cst_marital_status,
	case when upper(trim(cst_gndr)) = 'M' then 'Male'
		 when upper(trim(cst_gndr)) = 'F' then 'Female'
		 else 'n/a'
	end as cst_gndr,
	cst_create_date
FROM(
SELECT 
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS latest_entry
FROM bronze.crm_cust_info
)t WHERE latest_entry = 1 

---------------------------------------------------
truncate table silver.crm_prd_info
INSERT INTO silver.crm_prd_info (
	prd_id, 
	cat_id, 
	prd_key, 
	prd_nm, 
	prd_cost, 
	prd_line, 
	prd_start_dt, 
	prd_end_dt
)
select 
	prd_id,
	REPLACE(substring(prd_key,1,5), '-', '_') as cat_id,
	REPLACE(substring(prd_key,7,len(prd_key)), '-', '_') as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line,
	cast(prd_start_dt as date),
	cast(LEAD(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt_test
from bronze.crm_prd_info


--------------------------------------------

select 
	sls_ord_num, 
	sls_prd_key, 
	sls_cust_id, 

	case when sls_order_dt = 0 or LEN(sls_order_dt) ! = 8 then null
		 else cast(cast(sls_order_dt as varchar) as date)
	end as sls_order_dt,

	case when sls_ship_dt = 0 or LEN(sls_ship_dt) ! = 8 then null
		 else cast(cast(sls_ship_dt as varchar) as date)
	end as sls_ship_dt,

	case when sls_due_dt = 0 or LEN(sls_due_dt) ! = 8 then null
		 else cast(cast(sls_due_dt as varchar) as date)
	end as sls_due_dt,

	sls_sales, 
	sls_quantity, 
	sls_price
from bronze.crm_sales_details