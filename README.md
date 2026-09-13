# Supply Chain Performance Intelligence

A SQL and Power BI business intelligence project focused on analyzing supply chain performance, delivery delays, shipping efficiency, regional performance, product performance, sales, and profitability.

---

## 📌 Project Overview

A manufacturing company has experienced increasing delivery delays and logistics challenges. Management needs a single intelligence layer to understand supply chain performance and identify the areas contributing to delivery problems.

This project uses **MySQL and Power BI** to transform raw supply chain data into actionable business insights.

The analysis focuses on:

- Delivery performance
- Actual vs scheduled shipping time
- Shipping-mode performance
- Regional performance
- Product performance
- Sales and profitability
- Late-delivery risk
- Business recommendations

---

## 🎯 Objective


To analyze supply chain performance using SQL and Power BI and identify products, shipping modes, and regions contributing to delivery delays and operational performance issues.

---

## ❓ Business Questions

The project aims to answer the following business questions:

1. Which delivery statuses occur most frequently?
2. Which shipping modes handle the highest business volume?
3. Which regions experience the highest delivery delays?
4. Which products have the highest order volume?
5. Which products generate the highest profit?

---

## 📊 Dataset

**Dataset:** DataCo Smart Supply Chain Dataset

**Source:** Kaggle — DataCo Smart Supply Chain for Big Data Analysis

The dataset contains supply chain order-level information including order dates, shipping information, products, regions, sales, profit, delivery status, and shipping performance indicators.

### Dataset Source

https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis

---

## 🛠️ Technologies Used

- **MySQL** — Data loading, cleaning, transformation, analysis and SQL queries
- **Power BI** — Interactive dashboard and data visualization
- **Power Query** — Data preparation
- **DAX** — KPI calculations and analytical measures
- **GitHub** — Project documentation and version control

---

# 🔄 Project Workflow

```text
Raw Dataset
     ↓
Data Validation
     ↓
Data Cleaning & Transformation
     ↓
MySQL Analysis
     ↓
Power BI Data Model
     ↓
DAX Measures
     ↓
Interactive Dashboard
     ↓
Business Insights
     ↓
Recommendations

## DAX Measures

The following DAX measures were created in Power BI to calculate key supply chain performance metrics:

| DAX Measure                | Purpose                                                 |
| -------------------------- | ------------------------------------------------------- |
| **Total Orders**           | Counts the total number of orders.                      |
| **Total Sales**            | Calculates the total sales generated.                   |
| **Total Profit**           | Calculates the total profit generated.                  |
| **Average Order Value**    | Calculates the average value per order.                 |
| **Average Delivery Delay** | Calculates the average delay in delivery.               |
| **On-Time Delivery %**     | Calculates the percentage of orders delivered on time.  |
| **Late Delivery %**        | Calculates the percentage of deliveries that were late. |
| **Late Order Rate %**      | Calculates the percentage of orders classified as late. |

These measures are used in the Power BI dashboard to monitor overall sales, profitability, order performance, and delivery performance.
