-- ================================================
-- Online Retail ETL - Business Questions
-- Author: Kevin Probetsado
-- ================================================

-- Q1: Top 5 Countries by Revenue and Percentage Contribution
WITH total_rev AS (
    SELECT ROUND(SUM(total_price::NUMERIC), 2) AS overall_revenue
    FROM retail_data
)
SELECT 
    country,
    ROUND(SUM(total_price::NUMERIC), 2) AS total_revenue,
    ROUND(CAST(SUM(total_price) / overall_revenue * 100 AS NUMERIC), 2) || '%' AS revenue_percentage
FROM retail_data, total_rev
GROUP BY country, overall_revenue
ORDER BY total_revenue DESC
LIMIT 5;

-- Q2: Monthly Revenue Trend
SELECT 
    TO_CHAR(DATE_TRUNC('month', invoice_date), 'Month YYYY') AS month,
    ROUND(SUM(total_price::NUMERIC), 2) AS total_revenue,
    RANK() OVER(ORDER BY SUM(total_price) DESC) AS revenue_rank
FROM retail_data
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY DATE_TRUNC('month', invoice_date);

-- Q3: Top 10 Customers by Revenue with Segmentation
WITH total_rev AS (
    SELECT ROUND(SUM(total_price::NUMERIC), 2) AS overall_revenue
    FROM retail_data
),
customer_rev AS (
    SELECT 
        customer_id,
        ROUND(SUM(total_price::NUMERIC), 2) AS customer_revenue
    FROM retail_data
    GROUP BY customer_id
)
SELECT 
    customer_id,
    customer_revenue,
    ROUND(CAST(customer_revenue / overall_revenue * 100 AS NUMERIC), 2) || '%' AS revenue_percentage,
    CASE WHEN (customer_revenue / overall_revenue * 100) > 1 THEN 'High Value'
         ELSE 'Regular'
    END AS customer_segment
FROM customer_rev, total_rev
ORDER BY customer_revenue DESC
LIMIT 10;

-- Q4: AOV per Country vs Overall AOV
WITH overall_aov AS (
    SELECT ROUND(SUM(total_price::NUMERIC), 2) / COUNT(DISTINCT invoice_no) AS total_aov
    FROM retail_data
),
country_aov AS (
    SELECT 
        country,
        ROUND(SUM(total_price::NUMERIC), 2) / COUNT(DISTINCT invoice_no) AS aov_per_country
    FROM retail_data
    GROUP BY country
)
SELECT 
    country,
    ROUND(aov_per_country::NUMERIC, 2) AS aov_per_country,
    ROUND(total_aov::NUMERIC, 2) AS overall_aov,
    CASE WHEN aov_per_country > total_aov THEN 'Above Average'
         ELSE 'Below Average'
    END AS aov_label
FROM country_aov, overall_aov
ORDER BY aov_per_country DESC;
