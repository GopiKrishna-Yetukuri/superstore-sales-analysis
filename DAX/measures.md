# DAX Measures – Superstore Sales Analysis

This file documents the key **DAX measures** created for the Power BI dashboard.

---

## 🔹 Sales & Profit
- **Total Sales**
```DAX
Total Sales = SUM(OrderDetails[Sales])
```
- **Total Profit**
```DAX
Total Profit = SUM(OrderDetails[Profit])
```
- **Profit Margin**
```DAX
Profit Margin = DIVIDE([Total Profit], [Total Sales], 0)
```

## 🔹 Time Intelligence
- **Sales YTD**
```DAX
Sales YTD = TOTALYTD([Total Sales], 'Orders'[Order Date])
```

- **Sales LYTD**
```DAX
Sales LYTD = CALCULATE([Sales YTD], SAMEPERIODLASTYEAR('Orders'[Order Date]))
```

- **Sales Growth %**
```DAX
Sales Growth % = DIVIDE([Sales YTD] - [Sales LYTD], [Sales LYTD], 0)
```

## 🔹 Top / Bottom Analysis

- **Most Profitable Sub-Category**
```DAX
Most Profitable Sub-Category =
TOPN(
    1,
    SUMMARIZE('Products', Products[Sub-Category], "Profit", [Total Profit]),
    [Total Profit], DESC
)
```

- **Least Profitable Sub-Category**
```DAX
Least Profitable Sub-Category =
TOPN(
    1,
    SUMMARIZE('Products', Products[Sub-Category], "Profit", [Total Profit]),
    [Total Profit], ASC
)
```
## 🔹 Customer Metrics
- **Customer Count**
```DAX
Customer Count = DISTINCTCOUNT(Customers[CustomerID])
```

- **Avg Sales per Customer**
```DAX
Avg Sales per Customer = DIVIDE([Total Sales], [Customer Count], 0)
```
