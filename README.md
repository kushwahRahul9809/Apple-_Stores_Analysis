#Capstone Project Million-Row Apple_Stores_Analysis

#Overview

In this capstone project, you will work with a real-world retail sales database containing over 1 million transaction records. Your goal is to write progressively complex SQL queries — from simple aggregations to advanced window functions and CTEs — to extract meaningful business intelligence from raw data.

#Objectives

A PostgreSQL-based retail sales analytics project that leverages advanced SQL, window functions, CTEs, and indexing techniques to analyze over 1 million sales transactions and generate business insights.

#Dataset

The project uses a retail sales database called apple_db built in PostgreSQL. It models the operations of a global electronics retailer with stores across multiple countries. The database has 5 tables and contains over 1 million rows of transactional data.

#Schema

-- CREATE TABLE STORES

CREATE TABLE stores ( store_id VARCHAR(10) PRIMARY KEY, store_name VARCHAR(50) , city VARCHAR(25), country VARCHAR(25) );

-- CREATE TABLE category

DROP TABLE IF EXISTS category; CREATE TABLE category ( category_id VARCHAR(10) PRIMARY KEY, category_name VARCHAR(20) );

-- CREATE TABLE products

CREATE TABLE products ( product_id VARCHAR(10) PRIMARY KEY, product_name VARCHAR(35), category_id VARCHAR(10), launch_date DATE, price FLOAT, CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(category_id) );

-- CREATE TABLE sales

CREATE TABLE sales ( sale_id VARCHAR(15) PRIMARY KEY, sale_date DATE, store_id VARCHAR(10), -- this fk product_id VARCHAR(10), -- this fk quantity INT, CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id), CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id) );

-- CREATE TABLE warranty

CREATE TABLE warranty ( claim_id VARCHAR(10) PRIMARY KEY, claim_date DATE, sale_id VARCHAR(15), repair_status VARCHAR(15), CONSTRAINT fk_orders FOREIGN KEY (sale_id) REFERENCES sales(sale_id) );

#Business Problems and Solutions

--Q1 Number of Stores Per Country

SELECT country, COUNT(store_id) AS total_stores FROM stores GROUP BY country ORDER BY total_stores DESC;
** Objective** -Count how many retail store locations exist in each country. The result should be sorted so the country with the most stores appears first

---Q2 Total Units Sold BY Each Store

SELECT st.store_name, SUM(s.quantity) AS total_units_sold FROM sales s INNER JOIN stores st ON s.store_id = st.store_id GROUP BY st.store_name ORDER BY total_units_sold DESC;

** Objective** -Find the total number of product units sold by every store, ranked from highest to lowest. This requires joining the sales fact table with the stores dimension table to get human-readable store names.

---Q3 Total Transactions in December 2023

SELECT COUNT(sale_id) As total_sales from sales WHERE sale_date BETWEEN '2023-12-01' AND '2023-12-31';

** Objective** - Count the total number of sales transactions that occurred exclusively during the month of December 2023. Two approaches are shown — one readable, one index-optimized.

--Q4 Stores That Never Received a Warranty Claim

SELECT COUNT(*) AS stores_with_no_claims FROM stores WHERE store_id NOT IN ( SELECT DISTINCT s.store_id FROM warranty w INNER JOIN sales s ON w.sale_id = s.sale_id WHERE s.store_id IS NOT NULL ); ** Objective** - Find how many stores have never had a customer file a warranty claim. This requires identifying which store IDs appear in warranty records and then excluding them.

--Q5 Percentage of Claims Marked as Warranty Void

SELECT ROUND( COUNT(CASE WHEN repair_status = 'Warranty Void' THEN 1 END) * 100.0 / COUNT(*), 2 ) AS void_percentage FROM warranty;

** Objective** - Calculate what percentage of all warranty claims carry the status "Warranty Void" — meaning the claim was rejected, typically due to tampering or water damage.

--Q6 Store With Highest Sales in the Last Year
SELECT st.store_name, SUM(s.quantity) AS total_units FROM sales s INNER JOIN stores st ON s.store_id = st.store_id WHERE s.sale_date >= (SELECT MAX(sale_date) FROM sales) - INTERVAL '1 year' GROUP BY st.store_name ORDER BY total_units DESC LIMIT 1;

** Objective**- Find the single store that sold the most units over the trailing 12-month period. The time window should be dynamic— it should always be relative to the current date, not a hardcoded range.

--Q7 Count of Unique Products Sold in the Last Year

SELECT COUNT(DISTINCT product_id) AS unique_skus_sold FROM sales WHERE sale_date >= (SELECT MAX(sale_date) FROM sales) - INTERVAL '1 year';

** Objective** - Determine how many distinct product SKUs were sold over the trailing 12 months. This measures catalog diversity— how many different items are actively moving off shelves

---Q8 Average Product Price Per Category

SELECT c.category_name, ROUND(AVG(p.price)::numeric, 2) AS avg_retail_price FROM products p INNER JOIN category c ON p.category_id = c.category_id GROUP BY c.category_name ORDER BY avg_retail_price DESC;

** Objective**- Calculate the average retail price of products in each category, sorted from most expensive to least expensive.This requires joining products to category to get readable category names

---Q9 Total Warranty Claims Filed in 2020

SELECT COUNT(claim_id) AS total_claims_2020 FROM warranty WHERE EXTRACT(YEAR FROM claim_date) = 2020;

** Objective** - Count the number of warranty claims that were submitted specifically during the calendar year 2020. Practice using EXTRACT to pull the year component from a date column.

--Q10 Best-Selling Weekday Per Store

WITH daily_sales AS ( SELECT s.store_id, st.store_name, TRIM(TO_CHAR(s.sale_date, 'Day')) AS weekday, SUM(s.quantity) AS total_units, RANK() OVER ( PARTITION BY s.store_id ORDER BY SUM(s.quantity) DESC ) AS sales_rank FROM sales s INNER JOIN stores st ON s.store_id = st.store_id GROUP BY s.store_id, st.store_name, TRIM(TO_CHAR(s.sale_date, 'Day')) ) SELECT store_name, weekday AS best_selling_day, total_units FROM daily_sales WHERE sales_rank = 1 ORDER BY store_name;

** Objective**- For every individual store, find which day of the week generates the highest total sales volume. This is a classic "Top-N per Group" problem solved using a CTE combined with a window function

#Findings and Conclusion

##Findings

Analyzed over 1 million retail sales records using PostgreSQL. Identified sales trends, top-performing stores, and popular product categories. Evaluated warranty claim patterns and store performance. Improved query efficiency using indexes, CTEs, and window functions.

##Conclusion

This project demonstrates how advanced SQL techniques can be used to extract valuable business insights from large datasets. It highlights practical skills in data analysis, performance optimization, and business intelligence reporting using PostgreSQL.

#Author - Rahul Kushwaha

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

About
Capstone Project Million-Row Apple_stores_Analysis

Resources
 Readme
 Activity
Stars
 0 stars
Watchers
 0 watching
Forks
 0 forks
Report repository
Releases
No releases published
Packages
No packages published
Contributors
1
@Rahul9809
Rahul9809 Rahul Kushwaha
Footer
© 2026 Git
