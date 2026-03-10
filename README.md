# Instacart Customer Order Analysis

**Tools:** SQL · Databricks SQL Editor  
**Dataset:** Instacart Market Basket Analysis 32M+ order items, 200K users  
**Tables:** orders · order_products · products · aisles · departments

---

## Overview

SQL analysis of 32M+ Instacart grocery order items across 200K users and 49K products. Uncovered product popularity patterns, department-level reorder behavior, peak ordering times, and customer loyalty segmentation all using multi-table joins, window functions, and conditional aggregation in SQL.

---

## Dataset Schema

| Table | Rows | Description |
|---|---|---|
| `orders` | 3.4M | One row per order — user, timing, days since prior |
| `order_products__prior` | 32.4M | All historical order items |
| `order_products__train` | 1.4M | Most recent order per user |
| `products` | 49,688 | Product names, aisle, department |
| `aisles` | 134 | Aisle names |
| `departments` | 21 | Department names |

---

## Analysis & Findings

### 1. Top 10 Most Ordered Products
> **Business Q:** Which products drive the most volume?

| Product | Department | Aisle | Times Ordered | Reorder Rate |
|---------|-----------|-------|---------------|--------------|
| Banana | Produce | Fresh Fruits | 472,565 | 84.4% |
| Bag of Organic Bananas | Produce | Fresh Fruits | 379,450 | 83.3% |
| Organic Strawberries | Produce | Fresh Fruits | 264,683 | 77.8% |
| Organic Baby Spinach | Produce | Packaged Veg | 241,921 | 77.3% |
| Organic Hass Avocado | Produce | Fresh Fruits | 213,584 | 79.7% |
| Organic Avocado | Produce | Fresh Fruits | 176,815 | 75.8% |
| Large Lemon | Produce | Fresh Fruits | 152,657 | 69.6% |
| Strawberries | Produce | Fresh Fruits | 142,951 | 69.8% |
| Limes | Produce | Fresh Fruits | 140,627 | 68.1% |

**Insight:** All top 9 products are fresh produce. Bananas alone account for 472k orders with an 84.4% reorder rate the most habitual purchase on the platform.

---

### 2. Department Breakdown
> **Business Q:** Which departments drive volume and loyalty?

| Department | Total Orders | Share | Reorder Rate |
|-----------|-------------|-------|--------------|
| Produce | 9,479,291 | 29.2% | 65.0% |
| Dairy Eggs | 5,414,016 | 16.7% | 67.0% |
| Snacks | 2,887,550 | 8.9% | 57.4% |
| Beverages | 2,690,129 | 8.3% | 65.3% |
| Frozen | 2,236,432 | 6.9% | 54.2% |
| Pantry | 1,875,577 | 5.8% | 34.7% |
| Bakery | 1,176,787 | 3.6% | 62.8% |
| Canned Goods | 1,068,058 | 3.3% | 45.7% |
| Deli | 1,051,249 | 3.2% | 60.8% |

**Insight:** Produce is the highest volume department (29.2%) but Dairy Eggs has the highest reorder rate (67%) — people are more habitual about dairy than fresh produce.

---

### 3. Peak Ordering Times
> **Business Q:** When are customers most active?

| Day | Hour | Orders |
|-----|------|--------|
| Sunday | 10 AM | 55,671 |
| Saturday | 2 PM | 54,552 |
| Saturday | 3 PM | 53,954 |
| Saturday | 1 PM | 53,849 |
| Sunday | 9 AM | 51,908 |
| Sunday | 11 AM | 51,584 |
| Saturday | 12 PM | 51,443 |
| Saturday | 11 AM | 51,035 |
| Saturday | 4 PM | 49,463 |

**Insight:** Sunday 10 AM is the single busiest ordering slot. The entire top 9 is weekend-only — Saturday afternoons and Sunday mornings dominate. Weekday ordering is significantly lower across all hours.

---

### 4. Customer Loyalty Segmentation
> **Business Q:** What does our customer base look like?

| Segment | Users | Avg Orders | Avg Days Between Orders |
|---------|-------|------------|------------------------|
| Power User (20+ orders) | 53,931 | 38.4 | 9.2 days |
| Loyal (10-19 orders) | 56,797 | 13.6 | 15.3 days |
| Regular (5-9 orders) | 71,495 | 6.7 | 18.7 days |
| Returning (2-4 orders) | 23,986 | 4.0 | 20.3 days |

**Insight:** Power users order every 9.2 days essentially weekly grocery shopping. No one-time buyers exist in this dataset, meaning every user came back at least twice. The 53k power users placing 38 orders each represent the core revenue base of the platform.

---

## Technical Highlights

- Joined **5 tables** across 32M+ rows using multi-table SQL joins
- Used **window functions** (`SUM() OVER()`) for department share calculation
- Built **customer segmentation** using nested subquery + CASE WHEN bucketing
- Applied **conditional aggregation** for reorder rate calculation (`AVG(reordered)`)
- Ran all queries on **Databricks SQL Editor** against raw CSV-loaded tables

---

## How to Reproduce

1. Download dataset from [Kaggle](https://www.kaggle.com/datasets/psparks/instacart-market-basket-analysis)
2. Upload all 6 CSV files to Databricks via **Data → Add or upload data**
3. Run queries from `instacart_queries.sql` in **Databricks SQL Editor**
