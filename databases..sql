--Q1  Number of Stores Per Country

SELECT
country,
COUNT(store_id) AS total_stores
FROM stores
GROUP BY country
ORDER BY total_stores DESC;  


---Q2  Total Units Sold BY Each Store

SELECT
st.store_name,
SUM(s.quantity) AS total_units_sold
FROM sales s
INNER JOIN stores st
ON s.store_id = st.store_id
GROUP BY st.store_name
ORDER BY total_units_sold DESC;



---Q3 Total Transactions in December 2023

SELECT
COUNT(sale_id) As total_sales 
from sales 
WHERE sale_date BETWEEN '2023-12-01' AND '2023-12-31';


--Q4 Stores That Never Received a Warranty Claim

SELECT
COUNT(*) AS stores_with_no_claims
FROM stores
WHERE store_id NOT IN (
SELECT DISTINCT s.store_id
FROM warranty w
INNER JOIN sales s
ON w.sale_id = s.sale_id
WHERE s.store_id IS NOT NULL
);


--Q5 Percentage of Claims Marked as Warranty Void

SELECT
ROUND(
COUNT(CASE WHEN repair_status = 'Warranty Void'
THEN 1 END) * 100.0
/ COUNT(*),
2
) AS void_percentage
FROM warranty;

--Q6 Store With Highest Sales in the Last Year

SELECT 
    st.store_name,
    SUM(s.quantity) AS total_units
FROM sales s
INNER JOIN stores st 
    ON s.store_id = st.store_id
WHERE s.sale_date >= (SELECT MAX(sale_date) FROM sales) - INTERVAL '1 year'
GROUP BY st.store_name
ORDER BY total_units DESC
LIMIT 1;


--Q7 Count of Unique Products Sold in the Last Year

SELECT 
    COUNT(DISTINCT product_id) AS unique_skus_sold
FROM sales
WHERE sale_date >= (SELECT MAX(sale_date) FROM sales) - INTERVAL '1 year';



---Q8 Average Product Price Per Category

SELECT 
    c.category_name,
    ROUND(AVG(p.price)::numeric, 2) AS avg_retail_price
FROM products p
INNER JOIN category c 
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY avg_retail_price DESC;




---Q9 Total Warranty Claims Filed in 2020

SELECT
COUNT(claim_id) AS total_claims_2020
FROM warranty
WHERE EXTRACT(YEAR FROM claim_date) = 2020;



--Q10 Best-Selling Weekday Per Store


WITH daily_sales AS (
SELECT
s.store_id,
st.store_name,
TRIM(TO_CHAR(s.sale_date, 'Day')) AS weekday,
SUM(s.quantity) AS total_units,
RANK() OVER (
PARTITION BY s.store_id
ORDER BY SUM(s.quantity) DESC
) AS sales_rank
FROM sales s
INNER JOIN stores st
ON s.store_id = st.store_id
GROUP BY
s.store_id,
st.store_name,
TRIM(TO_CHAR(s.sale_date, 'Day'))
)
SELECT
store_name,
weekday AS best_selling_day,
total_units
FROM daily_sales
WHERE sales_rank = 1
ORDER BY store_name;
