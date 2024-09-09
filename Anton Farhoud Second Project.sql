use AdventureWorks2019
go


--Writing a query that displays information about products that have not been ordered.
--Display: ProductId, Name (ProductName), Color, ListPrice, Size.
--Sort the report by ProductId.
SELECT ProductID,Name,Color,ListPrice,Size
FROM Production.Product
EXCEPT
SELECT PP.ProductID,PP.Name,PP.Color,PP.ListPrice,PP.Size
FROM Production.Product PP JOIN Sales.SalesOrderDetail SOD
	ON PP.ProductID=SOD.ProductID
ORDER BY ProductID
go


--Writing a query that displays information about customers who have not placed any orders.
--Display: CustomerId, LastName, FirstName. Sort the report by CustomerId in ascending order.
SELECT CustomerID,ISNULL(PP.LastName,'Unknown') AS LastName
		,ISNULL(PP.FirstName,'Unknown') AS FirstName
FROM Person.Person PP RIGHT JOIN (SELECT C.CustomerID,SOH.SalesOrderID
							FROM Sales.SalesOrderHeader SOH RIGHT JOIN Sales.Customer C
								ON SOH.CustomerID=C.CustomerID
							WHERE SOH.SalesOrderID IS NULL) TBL
					ON PP.BusinessEntityID=TBL.CustomerID
ORDER BY CustomerID
go


--Writing a query that displays information on the top 10 customers who placed the most orders.
--Display: CustomerId, FirstName, LastName, and CountOfOrders.
SELECT TBL.CustomerID,PP.FirstName,PP.LastName,TBL.CountOfOrders
FROM Sales.Customer C JOIN (SELECT TOP 10 CustomerID
							,COUNT(SalesOrderID) AS CountOfOrders
							FROM Sales.SalesOrderHeader
							GROUP BY CustomerID
							ORDER BY CountOfOrders DESC) TBL
		ON C.CustomerID=TBL.CustomerID
			JOIN Person.Person PP
				ON C.PersonID=PP.BusinessEntityID
go


--Writing a query that displays information on employees and their positions.
--Display: FirstName, LastName, JobTitle, HireDate. Also, display the number of employees in the same position (CountOfTitle).
SELECT PP.FirstName,PP.LastName,E.JobTitle,E.HireDate
	,COUNT(*)OVER(PARTITION BY E.JobTitle) AS CountOfTilte
FROM Person.Person PP JOIN HumanResources.Employee E
	ON PP.BusinessEntityID=E.BusinessEntityID
go


--Writing a query that displays the last order date for each customer.
--Display: SalesOrderID, CustomerID, LastName, FirstName, OrderDate (Last Order), and the previous order date.
WITH CTE
	AS(SELECT OH.SalesOrderID,OH.CustomerID,P.LastName,P.FirstName
				,MAX(OH.OrderDate)OVER(PARTITION BY OH.CustomerID ORDER BY OH.OrderDate DESC) AS LastOrder
				,LAG(OH.OrderDate,1)OVER(PARTITION BY OH.CustomerID ORDER BY OH.OrderDate) AS PreviusOrder
				,RANK()OVER(PARTITION BY OH.CustomerID ORDER BY OH.OrderDate DESC) AS RNK
		FROM Person.Person P
				JOIN Sales.Customer C
					ON P.BusinessEntityID=C.PersonID
						JOIN Sales.SalesOrderHeader OH
							ON OH.CustomerID=C.CustomerID)
SELECT SalesOrderID,CustomerID,LastName,FirstName,LastOrder,PreviusOrder
FROM CTE
WHERE RNK=1
go


--Writing a query that displays the most expensive orders in each year and lists the customers with those orders.
--Display: Year, SalesOrderID, LastName, FirstName, and the Total column
WITH cte
	AS (SELECT YEAR(SOH.OrderDate) AS Years,SOH.SalesOrderID
			,SUM(SOD.UnitPrice*(1-UnitPriceDiscount)*OrderQty) AS SUMPrise
			,P.LastName,P.FirstName
			,ROW_NUMBER()OVER(PARTITION BY YEAR(SOH.OrderDate) ORDER BY 
			(SUM(SOD.UnitPrice*(1-UnitPriceDiscount)*OrderQty)) DESC) RN
		FROM Sales.SalesOrderDetail SOD JOIN Sales.SalesOrderHeader SOH
					ON SOH.SalesOrderID=SOD.SalesOrderID
						JOIN Sales.Customer C
							ON C.CustomerID=SOH.CustomerID
								JOIN Person.Person P
									ON C.PersonID=P.BusinessEntityID
		GROUP BY YEAR(SOH.OrderDate),SOH.SalesOrderID,P.LastName,P.FirstName)

SELECT Years,SalesOrderID,LastName,FirstName,FORMAT(SUMPrise,'###,###.#') AS Total
FROM cte
WHERE RN=1
go


--Display the number of orders placed each month in each year.
--Present the data in a way that shows the comparison between the months over different years.
SELECT MMONTH,[2011],[2012],[2013],[2014]
FROM (SELECT SalesOrderID,YEAR(OrderDate) AS YY,MONTH(OrderDate) AS MMONTH
		FROM Sales.SalesOrderHeader) TBL
PIVOT (COUNT (SalesOrderID) FOR YY IN([2011],[2012],[2013],[2014])) PVT
ORDER BY MMONTH
go


--Writing a query that displays the total amount of orders per month for each year and a cumulative sum for each year.
WITH CTE
	AS(SELECT YEAR(SOH.OrderDate) AS Years
			,MONTH(SOH.OrderDate) AS Months
			,ROUND(SUM(UnitPrice*(1-UnitPriceDiscount)),2) AS Sum_Price
		FROM Sales.SalesOrderDetail SOD
			JOIN Sales.SalesOrderHeader SOH
			ON SOD.SalesOrderID=SOH.SalesOrderID
		GROUP BY YEAR(SOH.OrderDate),MONTH(SOH.OrderDate))
,
CTE2
	AS(SELECT Years,CAST(Months AS nvarchar) AS Months,Sum_Price
				,SUM(Sum_Price)OVER(PARTITION BY Years ORDER BY Months) AS CumSum
				,ROW_NUMBER()OVER(PARTITION BY Years ORDER BY Months) AS RN
		FROM CTE
		GROUP BY Years,Months,Sum_Price
		UNION
		SELECT YEAR(SOH.OrderDate) AS Years
			,'Grand_Total',NULL
			,ROUND(SUM(UnitPrice*(1-UnitPriceDiscount)),2) AS Sum_Price
			,12
		FROM Sales.SalesOrderDetail SOD
			JOIN Sales.SalesOrderHeader SOH
			ON SOD.SalesOrderID=SOH.SalesOrderID
		GROUP BY YEAR(SOH.OrderDate))
SELECT Years,Months,Sum_Price,CumSum
FROM CTE2
ORDER BY Years,RN
go


--Writing a query that displays employees who were rehired by different departments after their initial employment.
--Display: Department Name, Employee ID, Full Name, Hiring Date, Seniority, Previuse Employee Name, Previuse Employee Date and Different Days.
SELECT DepartmentName,EmployeeID,EmployeeFullName,HireDate,Seniority,PreviuseEmpName,PreviusEmpHDate
		,DATEDIFF(DD,PreviusEmpHDate,HireDate) AS DiffDay
FROM (SELECT D.Name AS DepartmentName
			,DH.BusinessEntityID AS EmployeeID
			,CONCAT_WS(' ',P.FirstName,P.LastName) AS EmployeeFullName
			,E.HireDate
			,DATEDIFF(MM,E.HireDate,GETDATE()) AS Seniority
			,LEAD(CONCAT_WS(' ',P.FirstName,P.LastName),1)
				OVER(PARTITION BY D.Name ORDER BY E.HireDate DESC) AS PreviuseEmpName
			,LEAD(E.HireDate,1)
				OVER(PARTITION BY D.Name ORDER BY E.HireDate DESC) AS PreviusEmpHDate
		FROM HumanResources.Department D
				JOIN HumanResources.EmployeeDepartmentHistory DH
					ON D.DepartmentID=DH.DepartmentID
						JOIN HumanResources.Employee E
							ON E.BusinessEntityID=DH.BusinessEntityID
								JOIN Person.Person P
									ON P.BusinessEntityID=E.BusinessEntityID) TBL
go


--Write a query that displays employees who transferred from one department to another within the company.
--Display: Hire Date, Department ID and Team Emloyees.
WITH CTE
	AS(SELECT E.HireDate,ED.DepartmentID
				,CONCAT_WS(' ',E.BusinessEntityID,P.LastName,P.FirstName) AS NameID
		FROM HumanResources.Employee E
				JOIN Person.Person P
					ON E.BusinessEntityID=P.BusinessEntityID
						JOIN HumanResources.EmployeeDepartmentHistory ED
							ON ED.BusinessEntityID=E.BusinessEntityID
		WHERE ED.EndDate IS NULL)
SELECT HireDate,DepartmentID,STRING_AGG(NameID,', ')WITHIN GROUP(ORDER BY HireDate) AS TeamEmployees
FROM CTE
GROUP BY HireDate,DepartmentID
ORDER BY HireDate DESC
go
