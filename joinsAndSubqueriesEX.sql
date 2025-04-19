-- Create view for average cost of products supplied by each vendor
CREATE VIEW VendorProductAvg AS
SELECT 
    V.V_CODE,
    V.V_NAME,
    AVG(P.P_PRICE) AS AvgProductPrice
FROM 
    VENDOR V
    LEFT JOIN PRODUCT P ON V.V_CODE = P.V_CODE
GROUP BY 
    V.V_CODE, V.V_NAME;

-- Query 1 - List customers with invoice numbers (including those with no invoices)
SELECT 
    C.CUS_LNAME,
    C.CUS_FNAME,
    I.INV_NUMBER
FROM 
    CUSTOMER C
    LEFT JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
ORDER BY 
    C.CUS_LNAME, C.CUS_FNAME;

-- Query 2 - Products supplied by Tennessee vendors
SELECT 
    P.P_CODE,
    P.P_DESCRIPT,
    V.V_NAME,
    V.V_STATE
FROM 
    PRODUCT P
    JOIN VENDOR V ON P.V_CODE = V.V_CODE
WHERE 
    V.V_STATE = 'TN';

-- Query 3 - Invoice count and total purchase amount by customer
SELECT 
    C.CUS_CODE,
    C.CUS_LNAME,
    C.CUS_FNAME,
    COUNT(DISTINCT I.INV_NUMBER) AS InvoiceCount,
    SUM(L.LINE_UNITS * L.LINE_PRICE) AS TotalPurchaseAmount
FROM 
    CUSTOMER C
    LEFT JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
    LEFT JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY 
    C.CUS_CODE, C.CUS_LNAME, C.CUS_FNAME
ORDER BY 
    C.CUS_LNAME, C.CUS_FNAME;

-- Query 4 - Customer code, balance, and total purchases
SELECT 
    C.CUS_CODE,
    C.CUS_BALANCE,
    SUM(L.LINE_UNITS * L.LINE_PRICE) AS TotalPurchases
FROM 
    CUSTOMER C
    LEFT JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
    LEFT JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY 
    C.CUS_CODE, C.CUS_BALANCE
ORDER BY 
    C.CUS_CODE;

-- Query 5 - Products never included in any invoice
SELECT 
    P.P_CODE,
    P.P_DESCRIPT,
    P.P_PRICE
FROM 
    PRODUCT P
    LEFT JOIN LINE L ON P.P_CODE = L.P_CODE
WHERE 
    L.INV_NUMBER IS NULL
ORDER BY 
    P.P_CODE;

-- Query 6 - Products priced higher than average for same discount but different vendors
SELECT 
    P1.P_CODE,
    P1.P_DESCRIPT,
    P1.P_PRICE,
    P1.P_DISCOUNT,
    P1.V_CODE
FROM 
    PRODUCT P1
WHERE 
    P1.P_PRICE > (
        SELECT 
            AVG(P2.P_PRICE)
        FROM 
            PRODUCT P2
        WHERE 
            P2.P_DISCOUNT = P1.P_DISCOUNT
            AND (P2.V_CODE != P1.V_CODE OR P2.V_CODE IS NULL OR P1.V_CODE IS NULL)
    )
ORDER BY 
    P1.P_DISCOUNT, P1.P_PRICE DESC;

-- Query 7 - Latest invoice details for each customer
SELECT 
    C.CUS_CODE,
    C.CUS_LNAME,
    C.CUS_FNAME,
    I.INV_NUMBER,
    I.INV_DATE
FROM 
    CUSTOMER C
    JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
WHERE 
    I.INV_DATE = (
        SELECT 
            MAX(INV_DATE)
        FROM 
            INVOICE
        WHERE 
            CUS_CODE = C.CUS_CODE
    )
ORDER BY 
    C.CUS_LNAME, C.CUS_FNAME;

-- Query 8 - Top 3 most popular products (by units sold)
SELECT 
    P.P_CODE,
    P.P_DESCRIPT,
    SUM(L.LINE_UNITS) AS TotalUnitsSold
FROM 
    PRODUCT P
    JOIN LINE L ON P.P_CODE = L.P_CODE
GROUP BY 
    P.P_CODE, P.P_DESCRIPT
ORDER BY 
    TotalUnitsSold DESC
LIMIT 3;

-- Query 9 - Customers who bought all products from vendor 21225
SELECT 
    C.CUS_CODE,
    C.CUS_LNAME,
    C.CUS_FNAME
FROM 
    CUSTOMER C
WHERE 
    NOT EXISTS (
        SELECT 
            P.P_CODE
        FROM 
            PRODUCT P
        WHERE 
            P.V_CODE = 21225
        AND NOT EXISTS (
            SELECT 
                *
            FROM 
                INVOICE I
                JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
            WHERE 
                I.CUS_CODE = C.CUS_CODE
                AND L.P_CODE = P.P_CODE
        )
    );