📦 Olist E-Commerce Analytics Project

Technologies: PostgreSQL • SQL • Power BI • DAX • Data Modeling
Dataset: Brazilian Olist E-commerce Dataset (100k+ orders)

📘 Project Overview

This project is a complete end-to-end analytics pipeline, covering:

Data Exploration & Cleaning (SQL)

Operational & Delivery Analytics

Product & Customer Segmentation

Seller Performance & Fraud Detection

Customer Value & Retention Analysis

Power BI Dashboard Development

The goal is to derive business insights related to:

sales & revenue

customer behavior

product performance

delivery speed

seller quality

customer reviews and responsiveness

🛠️ 1. SQL Data Pipeline
✔ Phase 1 — Data Quality + Basic Analysis

Customer repeat purchase check

Delivery date inconsistencies

Top products by review score

Payment behavior patterns

Customer classification (Gold/Silver/Bronze)

✔ Phase 2 — Logistics & Delivery

Avg delivery duration

% late deliveries

Sellers causing maximum delay

Delivery time vs review score (correlation)

State-wise delivery delays

✔ Phase 3 — Product & Customer Segmentation

Ranking products inside categories

Region–category preference map

High sales but low review score flag

Category revenue by region

Trend-setter customer identification

Full RFM segmentation

✔ Phase 4 — Seller & Review Intelligence

Seller reliability scoring

Freight efficiency analysis

Monthly sales trends

Fraud/Anomaly detection across regions

Seller anomaly detection

Review response segmentation

Interaction score modeling

Correlation study between reply time & review score

✔ Phase 5 — CLV & Seasonality

Customer Lifetime Value

Churn prediction (active vs inactive)

Seasonality trends

Combined insights summary

📊 2. Power BI Dashboard Development
✔ Data Modeling

Central Fact Table: order_items

Dimension tables: Orders, Customers, Sellers, Products, Reviews, Payments

Relationships: 1-to-many using primary keys

Clean star-schema for efficient DAX & reporting

✔ DAX Measures

Total Revenue

Delivery Days

Average Review Score

CLV

Freight-to-Price Ratio

Monthly Revenue

✔ Dashboard Pages
Dashboard 1: Executive Overview

Total revenue

Total orders

Review score average

Delivery time distribution

Monthly revenue trend

Customer state distribution

Key influencer on price

Dashboard 2: Product & Review Performance

Revenue by product category

Review score distribution

Delivery time vs review score scatter

Category-level ranking table

Dashboard 3: Customer & CLV Analytics

CLV distribution

Average delivery days

Delivery day distribution

State & city filters

Customer retention segmentation

Dashboard 4: Seller Performance Dashboard

Freight vs revenue scatter

Seller revenue table

Freight ratio bar chart

Review score vs seller behavior

📍 3. Business Insights Summary
🔹 Key Conclusions

Customer retention is extremely low — most customers order only once.

Delivery delays strongly reduce review scores.

Sellers with high delivery lag can be flagged and managed.

A few product categories contribute majority of revenue.

Some regions show chronically high delays, requiring logistics improvement.

High CLV customers do not give better reviews → service improvements must be uniform.

Review response time segmentation shows fast replies dominate, but there is scope to improve long-tail cases.
