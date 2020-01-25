--Nortwind database

select * from Products
select * from Suppliers
select * from Customers
select * from Order_Details
select * from Orders
select * from Shippers
select * from Employees
select * from Territories
select * from Categories

---1)Display the product names along with their supplier name

select p.ProductName,s.CompanyName from products p
left join Suppliers s
on p.SupplierID = s.SupplierID

---2)Display the product names and the category which the products fall under. Also display the supplier’s name

select p.ProductName,c.CategoryName,s.CompanyName from products p
left join Categories c
on p.CategoryID = c.CategoryID
left join Suppliers s
on p.SupplierID = s.SupplierID

---3)Display the Order_id, Contact name and the number of products purchased by the customer

select [Order ID],[Contact Name],count([Products]) as [Total Products] from
(select o.OrderID as [Order ID],
c.ContactName as [Contact Name],
od.productid as [Products] from Customers c
left join Orders o
on c.CustomerID = o.CustomerID
left join Order_Details od
on o.OrderID = od.OrderID)
as a
group by [Order ID],[Contact Name]

---4)Display the Order_Id, Contact name and the shipping company name having Brazil as the ship country

select o.OrderID as [Order ID],
c.ContactName as [Contact Name],
s.CompanyName as [Shipper name]
from Orders o
left join Customers c
on o.CustomerID = c.CustomerID
left join Shippers s
on o.ShipVia = s.ShipperID
where o.ShipCountry = 'Brazil'

---5)Display the Order_Id, contact name along with the employee’s name who handled that sale. Also display the total amount of that particular order

select o.OrderID as [Order ID],
c.ContactName as [Contact Name],
concat(e.FirstName,' ',e.LastName) as [Employee name],
cast(a.[total amount] as decimal(10,2))as [Total Amount]
from Orders o
left join Customers c
on o.CustomerID = c.CustomerID
left join Employees e
on o.EmployeeID = e.EmployeeID
left join(
select orderid, 
sum((unitprice*(1-discount))*quantity) as [total amount]
from Order_Details group by orderid) as a
on o.OrderID = a.OrderID

---6)Display the product names that were sold by the sales manager

select distinct (productname) as[Product name] from Products p
left join Order_Details od
on p.ProductID = od.ProductID
left join Orders o
on od.OrderID = o.OrderID
left join Employees e
on o.employeeid = e.employeeid
where e.Title ='Sales Manager'

---7)Fetch all the columns from suppliers with the corresponding product id and product name. If the Region is Null concatenate the rst letters of country 
--and city, should be in Upper case.

select p.ProductID,p.ProductName, s.SupplierID,s.CompanyName,s.ContactName,
s.ContactTitle,s.Address,s.City,
case
when s.Region is null then UPPER(CONCAT(SUBSTRING(s.Country,1,1),SUBSTRING(s.City,1,1)))
else s.Region end as Region,
s.PostalCode,s.Country,s.Phone,s.Fax,s.HomePage
from Products p
left join Suppliers s
on p.SupplierID = s.SupplierID

---8)Display the company name, contact name, city along with the Unit price from products. Fetch all the records from suppliers. Handle the null values

select s.CompanyName,s.ContactName,s.City,p.ProductName,p.UnitPrice,
s.Address,
case
when s.Region is null then UPPER(CONCAT(SUBSTRING(s.Country,1,1),SUBSTRING(s.City,1,1)))
else s.Region end as Region,
s.PostalCode,s.Country,s.Phone,
case
when s.Fax is null then s.Phone
else s.Fax end as Fax,
case
when s.HomePage is null then 'No HomePage/No Website'
else s.HomePage end as Homepage
from Suppliers s
left join Products p
on s.SupplierID = p.SupplierID


---9)Select customer id, ship name, ship city, territory description, unit price and discount wherein the territory id should not exceed four characters and 
--the ship via should be 1 or 2. If the discount is 0, then replace it with 6% unit price.

select distinct * from(
select c.CustomerID,o.ShipName,o.ShipCity,
t.TerritoryDescription,od.UnitPrice,
case
when
od.Discount = 0 then 0.06
else od.Discount 
end as Discount,
SUBSTRING(et.territoryid,1,4) as [Territory ID]
from Orders o
 inner join  Customers c on o.CustomerID = c.CustomerID 
 join Employees e on o.EmployeeID = e.EmployeeID
 join Order_Details od on o.OrderID = od.OrderID
 join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
 join Territories t on et.TerritoryID = t.TerritoryID
where o.ShipVia = 1 or o.ShipVia = 2) as a

---10)Display the order id, customer id, Unit price, quantity where the discount should be greater than zero.

select o.OrderID,o.CustomerID,od.UnitPrice,od.Quantity
from Orders o
left join Order_Details od
on o.OrderID = od.OrderID
where od.Discount>0

---11)Select the category id, category name, description, product name, and supplier id and
--unit price. Where the description should not exceed two subcategories.

select ca.CategoryID,ca.CategoryID,CONCAT(
substring(ca.Description,1,CHARINDEX(',',ca.Description)),' ',
SUBSTRING(ca.Description,CHARINDEX(',',ca.Description)+1,CHARINDEX(',',ca.Description))) as [Description]
from Categories ca
join Products p
on ca.CategoryID = p.CategoryID


---12)Write a query to select only the rst letter in each word present in the column 'Contact Name'. (E.g.: A Beautiful Mind-ABM) and name this column as 'Short
--Name'. Do order by 'Short Form'.(use Suppliers table )

select * from Suppliers

select 
upper(concat(substring(contactname,1,1),substring(contactname,charindex(' ',contactname)+1,1)
)
)as [Short Name]
from Suppliers