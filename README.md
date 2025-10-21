
# 🛒 E-Commerce SQL Analytics Project

> A complete **SQL-based analytical study** of an e-commerce dataset, uncovering patterns in **customer behavior, revenue trends, and product performance** through structured query analysis.

---

## 📁 Project Overview

This project focuses on **deriving business insights** from e-commerce transactional data using **pure SQL**.
Each phase explores a key aspect of customer and business analytics — from understanding order patterns to evaluating profitability and customer lifetime value (CLV).

The dataset includes tables such as:

* `customers`
* `orders`
* `order_items`
* `order_payments`
* `order_reviews`
* `products`

---

## ⚙️ Tools & Environment

* **Database:** PostgreSQL / MySQL
* **Query Language:** SQL
* **Environment:** DBeaver / MySQL Workbench / pgAdmin
* **Data Visualization (optional):** Excel / Python (matplotlib / seaborn)

---

## 📊 Project Phases

### **🧩 Phase 1 — Basic Insights**

* Explored total customers, orders, and unique products.
* Identified most frequently ordered products and payment methods.
* Examined distribution of review scores.

> 📝 *These exploratory queries provide a baseline understanding of customer and order characteristics.*

---

### **📦 Phase 2 — Product & Revenue Analysis**

* Linked product categories with revenue contribution.
* Calculated **top 10 profitable categories**.
* Compared **average payment values per category**.

> 💡 *Helped identify high-value categories driving majority of revenue.*

---

### **💰 Phase 3 — Customer Segmentation & CLV**

* Computed **Customer Lifetime Value (CLV)** based on purchase frequency and average payment.
* Segmented customers into **High-Value** and **Low-Value** groups.
* Compared **average review scores** across segments.

> 📈 *Revealed that customer satisfaction scores were stable across all segments — indicating consistent service quality.*

---

### **🕒 Phase 4 — Seasonality & Behavioral Analysis**

* Identified **monthly order trends** to detect seasonal peaks.
* Analyzed **co-purchased product pairs** using self-joins.
* Calculated **active vs inactive customers** based on recent orders.

> 🌤️ *Orders peaked during May and August — aligning with Brazilian summer and festival periods.*
> 🔗 *Common product combinations (e.g., Electronics + Accessories) suggest cross-selling potential.*

---

### **📈 Phase 5 — Advanced Analytical Extensions**

1. **Correlation Analysis**

   * Checked statistical relationship between **review scores and CLV segmentation** (result: weak correlation).

2. **Customer Retention Patterns**

   * Used `last_order` date to classify active/inactive customers.

3. **Seasonality and Growth**

   * Monthly and quarterly order counts highlight operational trends.

> ⚙️ *These advanced queries connect customer engagement, seasonality, and satisfaction into actionable intelligence.*

---

## 📋 Key Insights

| Analysis               | Finding                                       | Business Impact                             |
| ---------------------- | --------------------------------------------- | ------------------------------------------- |
| **CLV Segmentation**   | ~30% customers are high-value                 | Focus retention efforts on these customers  |
| **Seasonality**        | Orders peak in May & August                   | Align marketing campaigns with these months |
| **Review Correlation** | No strong relationship between review and CLV | Service quality consistent                  |
| **Co-Purchase Pairs**  | Electronics + Accessories frequent            | Targeted bundle offers                      |

---

## 📊 Sample Visuals

| Visualization                                 | Description                                   |
| --------------------------------------------- | --------------------------------------------- |
| ![Monthly Orders](visuals/monthly_orders.png) | Orders by month show seasonal peaks           |
| ![Top Categories](visuals/top_categories.png) | Highest revenue-generating product categories |
| ![Co-purchase Pairs](visuals/co_purchase.png) | Frequent co-bought category combinations      |

> *(You can generate these using Excel or matplotlib and place them inside a `/visuals` folder.)*

---

## 🧭 Business Takeaways

* Consistent customer experience regardless of purchase value.
* Seasonal spikes suggest optimal times for promotions.
* CLV segmentation helps tailor loyalty and retention campaigns.
* Product pair analysis reveals cross-selling opportunities.

---

## 🚀 How to Run

1. Open any SQL editor (DBeaver, MySQL Workbench, or pgAdmin).
2. Import the dataset tables.
3. Run the SQL scripts in the following order:

   ```
   1_Phase1_Basics.sql  
   2_Phase2_Products.sql  
   3_Phase3_Customer_Segmentation.sql  
   4_Phase4_Seasonality.sql  
   5_Phase5_Advanced_Analysis.sql
   ```
4. (Optional) Use exported query results to create charts or dashboards.

---

## 🏷️ Tags

`sql` • `data-analysis` • `business-intelligence` • `customer-segmentation` • `ecommerce` • `analytics`

---

Would you like me to make a **GitHub-ready version** (with image links and collapsible query sections like “click to view SQL”)? It’ll make your README look like a published analytics report.
