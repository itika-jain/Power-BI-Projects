📌 Project Title

Live Sales Data Simulation & Power BI Analytics Dashboard

📖 Project Overview

This project showcases a comprehensive Business Intelligence solution, where live sales data is consistently produced through PostgreSQL simulations and displayed in an interactive Power BI dashboard. The system replicates a real e-commerce setting with automated order generation, product purchases, customer expansion, and payment transactions — facilitating dynamic, time-sensitive analytics.

⚙️ Tech Stack

Database: PostgreSQL

Data Simulation: PL/pgSQL Functions

Data Modeling: SQL Views (Fact & Dimension structure)

Visualization: Microsoft Power BI

🔄 Live Data Simulation

Custom PostgreSQL functions simulate real-time business activity:

Simulation	Description

🛒 Orders	: Random number of new orders generated per cycle

📦 Order Items	: Random products & quantities per order

💳 Payments	: Success, failure, pending & refunded scenarios

👤 Customers :	New customers added over time

A loop script runs these functions repeatedly, creating a continuously growing dataset to power live dashboards.

🗂 Database Structure

Fact Tables :

orders

order_items

payments

Dimension Tables :

customers

products

categories

regions

Reporting Layer (SQL Views) :

Optimized reporting views were created to follow a star-schema style model for Power BI

vw_orders

vw_order_items

vw_customers

vw_products

vw_categories

vw_regions

vw_payments

📊 Power BI Dashboard Features

🔹 Sales Overview

Total Revenue

Total Orders

Average Order Value

Revenue Trend Over Time

Order Status Distribution

🔹 Product Insights

Top 10 Products by Revenue

Revenue by Category

🔹 Customer Insights

Average Spend per Customer

Customer Distribution by Region

Customer Payment Preferences

🔹 Payment Analytics

Successful vs Failed Payments

Payment Method Distribution

Payment Status Distribution

📈 Advanced Analytics

Dynamic KPI calculations using DAX

Measures organized in a dedicated Measures Table

Clean star schema model for optimal performance

🎯 Key Learning Outcomes

✔ Designing a relational database for analytics

✔ Writing PL/pgSQL functions for live data simulation

✔ Building reporting-optimized SQL views

✔ Creating a star schema data model

✔ Writing advanced DAX measures

✔ Building a professional multi-page Power BI dashboard

🚀 How to Run This Project

Restore database schema in PostgreSQL

Run simulation functions to generate live data

Connect Power BI to PostgreSQL database

Refresh report to see updated data

👩‍💻 Author

Itika Jain

Aspiring Data Analyst | BI Developer

Passionate about turning raw data into meaningful insights
