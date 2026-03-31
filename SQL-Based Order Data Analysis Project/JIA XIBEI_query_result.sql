USE lab3_db;

-- =====================================================
-- SQL-Based Order Data Analysis Project
-- =====================================================

-- =========================
-- Customer Analysis
-- =========================

-- Analysis 1: Identify top customer by total order amount
SELECT 
    c.Cus_number, 
    c.Cus_name, 
    SUM(po.Amount) AS total_order_amount
FROM CUSTOMER c
JOIN PAPER_ORDER po 
    ON c.Cus_number = po.Cus_no
GROUP BY c.Cus_number, c.Cus_name
ORDER BY total_order_amount DESC
LIMIT 1;

-- =========================
-- Employee Analysis
-- =========================

-- Analysis 2: Identify employee with highest total handled order value
SELECT 
    e.Emp_ID, 
    e.Name, 
    SUM(po.Amount) AS total_handled_amount
FROM EMPLOYEE e
JOIN HANDLES h 
    ON e.Emp_ID = h.Emp_ID
JOIN PAPER_ORDER po 
    ON h.Order_no = po.Order_number
GROUP BY e.Emp_ID, e.Name
ORDER BY total_handled_amount DESC
LIMIT 1;

-- =========================
-- Operations Analysis
-- =========================

-- Analysis 3: Identify orders shipped later than required date
SELECT 
    ol.Order_no, 
    ol.Line_number, 
    ol.Reg_ship_date, 
    ol.Act_ship_date, 
    c.Cus_name, 
    b.Br_number, 
    e.Name AS employee_name
FROM ORDER_LINE ol
JOIN CUSTOMER c 
    ON ol.Cus_no = c.Cus_number
JOIN BRANCH b 
    ON ol.Cus_no = b.Cus_no 
   AND ol.Br_no = b.Br_number
JOIN HANDLES h 
    ON ol.Order_no = h.Order_no
JOIN EMPLOYEE e 
    ON h.Emp_ID = e.Emp_ID
WHERE ol.Act_ship_date > ol.Reg_ship_date;

-- =========================
-- Product Analysis
-- =========================

-- Analysis 4: Analyze product demand and revenue contribution
SELECT 
    p.Type_number, 
    p.Size, 
    SUM(oi.Quantity) AS total_quantity,
    SUM(oi.Quantity * p.Unit_price) AS total_revenue
FROM PAPER p
JOIN ORDER_ITEM oi 
    ON p.Type_number = oi.Type_no
GROUP BY p.Type_number, p.Size
ORDER BY total_revenue DESC;

-- =========================
-- Additional Exploration (Optional)
-- =========================

-- Analysis 5: Retrieve order details for a specific customer branch (example case)
SELECT 
    ol.Order_no, 
    ol.Line_number, 
    p.Type_number, 
    p.Size, 
    oi.Quantity
FROM ORDER_LINE ol
JOIN ORDER_ITEM oi 
    ON ol.Order_no = oi.Order_no 
   AND ol.Line_number = oi.Line_no
JOIN PAPER p 
    ON oi.Type_no = p.Type_number
JOIN BRANCH b 
    ON ol.Cus_no = b.Cus_no 
   AND ol.Br_no = b.Br_number
WHERE b.Cus_no = 1 
  AND b.Br_number = 1;