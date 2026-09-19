# Retail Sales & Customer Performance Analytics

An end-to-end data analytics project using **MySQL and Power BI** to analyze retail sales performance across customers, products, categories, cities and monthly trends.

## Project Objective

The objective of this project is to transform raw retail transaction data into meaningful business insights by:

* Analyzing overall sales performance
* Identifying high-performing customers and products
* Comparing category and city-level performance
* Tracking monthly revenue trends and growth
* Building an interactive Power BI dashboard for business analysis

## Tools & Technologies

* **MySQL** — Data validation, SQL analysis and business queries
* **Power BI** — Interactive dashboard and data visualization
* **DAX** — Measures, rankings, contribution analysis and time-based calculations

## Dataset

The project contains three main tables:

* **Customers** — customer demographics, city and customer segment
* **Products** — product, category, subcategory and pricing information
* **Sales** — orders, dates, quantities and discounts

### Data Model

```text
Customers  1 ─────── * Sales * ─────── 1 Products
                         │
                         │
                         *
                    DateTable
```

## Key KPIs

| KPI                 |   Value |
| ------------------- | ------: |
| Total Revenue       |  ₹1.13M |
| Total Orders        |      60 |
| Total Quantity      |     209 |
| Total Customers     |      20 |
| Average Order Value | ₹18.88K |

## Power BI Dashboard

The dashboard contains five analytical pages:

### 1. Executive Overview

Provides an overall view of retail business performance through:

* Revenue
* Orders
* Quantity
* Customers
* Average Order Value
* Monthly revenue trend
* Revenue by category
* Revenue by city
* Interactive filters

### 2. Customer Analysis

Focuses on customer-level performance including:

* Top 5 customers by revenue
* Customer revenue contribution
* Customer ranking
* Customer AOV
* Customer segment performance
* Customer performance details

### 3. Product Analysis

Analyzes product and category performance through:

* Top 5 products by revenue
* Revenue by category
* Quantity by category
* Product performance details
* Category and subcategory filters

### 4. City Analysis

Analyzes regional sales performance using:

* Revenue by city
* Orders by city
* Average revenue per customer
* City performance details
* City filter

### 5. Trend Analysis

Focuses on sales trends and time-based performance:

* Monthly revenue trend
* Month-over-month revenue growth
* Cumulative revenue
* Monthly performance details
* Date-range filtering

## Dashboard Preview

Executive Overview




Customer Analysis




Product Analysis




City Analysis




Trend Analysis



## SQL Analysis

SQL was used to perform business-focused analysis including:

* Overall revenue and order analysis
* Customer revenue and order performance
* Top and bottom customers
* Customer AOV
* Customer revenue contribution
* Customer segmentation analysis
* City-level performance
* Category and product analysis
* Top products by category
* Repeat customer analysis
* High-value customer analysis
* Monthly revenue analysis
* Month-over-month growth
* Running total revenue
* Revenue concentration
* Discount analysis

## Key Business Observations

Initial dashboard analysis identified:

* **Mumbai** generated the highest revenue among the cities.
* **Electronics** was the highest-revenue category.
* **May** recorded the highest monthly revenue during the analyzed period.

Further customer, product and city-level analysis was performed in the dashboard to understand the factors behind these patterns.

## Data Validation

Before analysis, the dataset was checked for:

* Duplicate customer IDs
* Duplicate order IDs
* Missing values
* Invalid customer/product relationships
* Invalid quantities
* Invalid discounts
* Invalid product prices
* Invalid customer ages

The validation checks returned no issues in the tested fields.

## Project Structure

```text
Retail_Sales_Customer_Performance_Analytics/
│
├── Retail_Sales_Customer_Performance_Analytics.pbix
├── Retail_Sales_Analytics.sql
└── README.md
```

## Skills Demonstrated

**SQL**

* Joins
* Aggregations
* GROUP BY / HAVING
* CTEs
* Subqueries
* Window functions
* RANK
* Running totals
* MoM growth
* Business analysis

**Power BI**

* Data modeling
* Relationships
* Power Query
* DAX measures
* RANKX
* TOPN
* CALCULATE
* FILTER
* ALL
* Time intelligence
* Interactive slicers
* Dashboard design

## Project Outcome

This project demonstrates an end-to-end analytics workflow:

**Raw Data → Data Validation → SQL Analysis → Data Modeling → DAX → Power BI Dashboard → Business Insights**
