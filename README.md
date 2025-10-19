E-Commerce Customer & Order Insights (SQL Analytics Project)
This project provides a comprehensive SQL-based analysis of a Brazilian e-commerce dataset. The focus is on key areas of customer behavior, sales performance, product trends, and review patterns. The analysis is structured into five progressive phases, each building on the last to reveal data-driven business insights. 
Table of Contents
Project Overview
Dataset
Project Structure
Key Insights
Highlight Queries
Tools Used
Repository Layout
Project Overview
The project uses SQL to analyze an e-commerce dataset, moving from basic data exploration to complex strategic insights. The analysis involves:
Phase 1: Data Exploration - Understanding the dataset's scope and performing basic joins.
Phase 2: Customer Behavior Analysis - Examining repeat orders, review patterns, and identifying active customers.
Phase 3: Profitability Insights - Analyzing sales and category profitability.
Phase 4: Customer Segmentation & CLV - Creating customer segments based on derived metrics like Customer Lifetime Value (CLV).
Phase 5: Strategic Customer & Product Insights - Studying customer inactivity, seasonality, and product co-purchase trends. 
Dataset
The analysis uses a Brazilian e-commerce dataset containing the following information:
Customer demographics and unique IDs
Order and payment details
Product information
Seller data
Review scores and messages
Project Structure
The project is organized into five phases, with increasing complexity at each stage. 
Phase	Title	Key Focus	SQL Concepts Used
Phase 1	Data Exploration	Dataset overview, table joins, customer & order basics	INNER JOIN, GROUP BY, COUNT, AVG
Phase 2	Customer Behavior Analysis	Repeat orders, review response time, active customers	Joins, Subqueries, Date functions
Phase 3	Profitability Insights	Sales and category profitability analysis	Aggregates, CASE WHEN, Ranking
Phase 4	Customer Segmentation & CLV	Segmentation by CLV and correlation with reviews	CTEs, Derived metrics, Correlation logic
Phase 5	Strategic Customer & Product Insights	Inactivity analysis, seasonality, product co-purchase trends	Window functions, Date extraction, Self-joins
Key Insights
Based on the analysis, several key insights were uncovered:
Seasonal Trends: Orders exhibit a strong concentration in specific periods, such as May and August, indicating potential seasonal demand peaks influenced by holidays or local festivals.
Customer Satisfaction vs. Value: High-value and low-value customers provide similar review scores. This suggests a consistent service quality that is not dependent on the customer's spending level.
Cross-Sell Opportunities: Identification of frequently co-purchased product categories points to clear opportunities for bundle promotions.
Customer Retention Needs: The short-term engagement patterns observed in most customers indicate a need for focused retention strategies to increase long-term loyalty. 
Highlight Queries
A few of the project's most insightful queries include:
Customer Lifetime Value (CLV): A query was developed to calculate each customer's lifetime value by using their average purchase value and frequency. It then segments customers into High or Low Value.
Inactive Customer Detection: A query identifies customers who have not placed an order in over 3,000 days, flagging potential churn candidates for re-engagement campaigns.
Seasonality Trends: A query groups orders by month to find seasonal demand peaks and troughs.
Product Co-Purchase Pairs: A query finds the top 10 most frequently co-purchased product category combinations, providing a basis for cross-selling recommendations.
Review & Segment Correlation: A query assesses whether customer value segments (e.g., High vs. Low) show different review patterns. The analysis found negligible correlation. 
Tools Used
SQL: Compatible with PostgreSQL and MySQL.
Database Tools: DB Browser, pgAdmin, or BigQuery can be used for running queries and visualizing data.
Optional Tools: Google Colab or Python can be used for exploratory data translation and plotting.
Repository Layout
e-commerce-sql-analysis
┣ 📄 phase1_exploration.sql
┣ 📄 phase2_customer_behavior.sql
┣ 📄 phase3_profitability_analysis.sql
┣ 📄 phase4_customer_segmentation.sql
┣ 📄 phase5_strategic_insights.sql
┣ 📄 README.md
Author Note
This project was developed step-by-step to connect theoretical SQL concepts with practical business analytics. It culminates in advanced segmentation and trend analysis, demonstrating a comprehensive approach to data-driven decision-making. 
AI can make mistakes, so double-check responses