E-Commerce Customer & Order Insights (SQL Analytics Project)
Project Overview

This project performs a comprehensive SQL-based analysis on a Brazilian e-commerce dataset, focusing on customer behavior, sales trends, product profitability, and review patterns.
Each analysis phase gradually increases in complexity, using joins, window functions, CTEs, and segmentation logic to uncover data-driven insights.

The dataset includes:

Customer demographics and IDs

Order and payment information

Product details

Seller data

Review scores and messages

Project Structure
Phase	Title	Key Focus	SQL Concepts Used
Phase 1	Data Exploration	Dataset overview, table joins, customer & order basics	INNER JOIN, GROUP BY, COUNT, AVG
Phase 2	Customer Behavior Analysis	Repeat orders, review response time, active customers	Joins, Subqueries, Date functions
Phase 3	Profitability Insights	Sales and category profitability analysis	Aggregates, CASE WHEN, Ranking
Phase 4	Customer Segmentation & CLV	Segmentation by CLV and correlation with reviews	CTEs, Derived metrics, Correlation logic
Phase 5	Strategic Customer & Product Insights	Inactivity analysis, seasonality, product co-purchase trends	Window functions, Date extraction, Self-joins
 Highlight Queries
1. Customer Lifetime Value (CLV)

Calculates average purchase value × average purchase frequency to derive each customer’s lifetime value and segment them as High or Low Value Customers.

 2. Inactive Customer Detection

Determines customers who haven’t placed an order in over 3000 days to identify potential churn candidates.

 3. Seasonality Trends

Groups orders by month to find seasonal demand peaks (e.g., spikes in May and August, possibly due to holidays or local festivals).

 4. Product Co-Purchase Pairs

Finds the top 10 product category combinations most frequently bought together — a foundation for cross-sell recommendations.

 5. Review & Segment Correlation

Assesses whether customer value segments show different review patterns (result: negligible correlation, implying satisfaction is not value-dependent).

 Tools Used

SQL (PostgreSQL / MySQL compatible)

DB Browser / pgAdmin / BigQuery (optional visualization tools)

Google Colab / Python (optional) for exploratory translation & plotting

 Key Insights

Orders are heavily concentrated in specific seasonal periods.

High-value and low-value customers give similar review scores, implying stable service quality.

Co-purchased product categories indicate potential for bundle promotions.

Most customers show short-term engagement, suggesting need for retention strategies.

 Repository Layout
 e-commerce-sql-analysis
 ┣ 📄 phase1_exploration.sql
 ┣ 📄 phase2_customer_behavior.sql
 ┣ 📄 phase3_profitability_analysis.sql
 ┣ 📄 phase4_customer_segmentation.sql
 ┣ 📄 phase5_strategic_insights.sql
 ┣ 📄 README.md   ← (this file)

 Author Note

This project was built step-by-step to bridge theoretical SQL concepts with practical business analytics, culminating in advanced segmentation and trend analysis.