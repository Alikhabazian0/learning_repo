--1-
SELECT C.categoryname, 
       SUM(qty * OD.unitprice * (1 - discount)) AmountSale
FROM Sales.OrderDetails OD
     INNER JOIN Sales.Orders O ON O.orderid = OD.orderid
     INNER JOIN Production.Products P ON P.productid = OD.productid
     INNER JOIN Production.Categories C ON C.categoryid = P.categoryid
GROUP BY C.categoryname;
----------------------------------------------
--2-
SELECT C.country, 
       AVG(DATEDIFF(DAY, requireddate, shippeddate)) AS AvgDelay
FROM Sales.Orders o
     INNER JOIN Sales.Customers C ON C.custid = O.custid
	 WHERE DATEDIFF(DAY, requireddate, shippeddate)>0
GROUP BY C.country;
----------------------------------------------
--3-
SELECT firstname + ' ' + lastname FullName, 
       SUM(QTY) SumQty, 
       SUM(qty * unitprice) AmountSale
FROM Sales.OrderDetails OD
     INNER JOIN Sales.Orders O ON O.orderid = OD.orderid
     INNER JOIN HR.Employees E ON E.empid = O.empid
GROUP BY E.firstname, 
         E.lastname;
----------------------------------------------
--4-
DECLARE @Disc1 DECIMAL(5, 2)= 0.02;
DECLARE @Disc2 DECIMAL(5, 2)= 0.01;
WITH CTE
     AS (SELECT custid, 
                SUM(qty * unitprice * (1 - discount)) AfterDiscSale
         FROM SALES.Orders O
              INNER JOIN Sales.OrderDetails OD ON OD.orderid = O.orderid
         GROUP BY custid),
     CTE2
     AS (SELECT custid, 
                SUM(qty * unitprice * (1 - IIF(discount < 0.05, discount + @Disc1, discount + @Disc2))) AfterDiscSale1
         FROM SALES.Orders O
              INNER JOIN Sales.OrderDetails OD ON OD.orderid = O.orderid
         GROUP BY custid)
     SELECT C1.custid, 
            C1.AfterDiscSale, 
            C2.AfterDiscSale1, 
            ((C2.AfterDiscSale1 - C1.AfterDiscSale) / C1.AfterDiscSale) * 100 ChangePercent
     FROM CTE C1
          INNER JOIN CTE2 C2 ON C1.custid = C2.custid;
----------------------------------------------
--5-
WITH CTE
     AS (SELECT custid, 
                SUM(qty * unitprice * (1 - discount)) BeforeFine
         FROM SALES.Orders O
              INNER JOIN Sales.OrderDetails OD ON OD.orderid = O.orderid
         GROUP BY custid),
     CTE2
     AS (SELECT custid, 
                SUM(DATEDIFF(DAY, requireddate, IIF(shippeddate IS NOT NULL, shippeddate, DATEADD(DAY, 40, OrderDate)))) DelayDays
         FROM SALES.Orders
         WHERE DATEDIFF(DAY, requireddate, IIF(shippeddate IS NOT NULL, shippeddate, DATEADD(DAY, 40, OrderDate))) > 0
         GROUP BY custid),
     CTE3
     AS (SELECT C1.custid, 
                C1.BeforeFine, 
                C1.BeforeFine - (ISNULL(C2.DelayDays, 0) * 0.001 * C1.BeforeFine) AfterFine, 
                ((ISNULL(-C2.DelayDays, 0) * 0.001 * C1.BeforeFine) / C1.BeforeFine) * 100 ChangePercent
         FROM CTE C1
              LEFT JOIN CTE2 C2 ON C1.CUSTID = C2.custid),
     CTE4
     AS (SELECT 'Total' AS Custid, 
                SUM(BeforeFine) BeforeFine, 
                SUM(AfterFine) AfterFine, 
                ((SUM(AfterFine) - SUM(BeforeFine)) / SUM(BeforeFine)) * 100 ChangePercent
         FROM CTE3)
     SELECT CAST(C3.custid AS VARCHAR(10)) custid, 
            C3.BeforeFine, 
            ISNULL(C3.AfterFine, 0) AfterFine, 
            ISNULL(C3.ChangePercent, 0) ChangePercent
     FROM CTE3 C3
     UNION ALL
     SELECT C4.Custid, 
            C4.BeforeFine, 
            ISNULL(C4.AfterFine, 0) AfterFine, 
            ISNULL(C4.ChangePercent, 0) ChangePercent
     FROM CTE4 C4;