select * from sale_order
select * from sale_order_line


---2)Compute a cumulative summary of sales for each day. (from 2016-01-01)

select order_date,total_order,sum(total_order)over(order by order_date) as Cumlutive_order
from
(select t1.order_placed_dt as order_date,
count(t1.order_placed_dt)as total_order
from sale_order t1 group by t1.order_placed_dt) as b order by order_date asc

---3)Find the number of order placed and number of orders authorized for each day

select t1.order_placed_dt as order_date,
count(t1.order_placed_dt)as total_order
from sale_order t1 where status = 'Created' group by t1.order_placed_dt 

---4)Find the order number which are in “Created” status for more than 2 days.

select t1.order_placed_dt as order_date,
count(t1.order_placed_dt)as total_order
from sale_order t1 where status = 'Created' group by t1.order_placed_dt 

---5)Find the order number which has different orders statuses for each line.

select t1.sales_order_num from sale_order t1
join sale_order_line t2
on t1.sales_order_num = t2.sales_order_num
and t1.status != t2.status

---6)Find the orders which are shipped within 24hours from the time of order placement.

select distinct sales_order_num from sale_order where status = 'Shipped'
and
datediff(hh,src_sts_upd_ts,order_placed_ts)<=24

---7)Find the orders where each line is shipped to customer on different dates.

select distinct sales_order_num from sale_order_line where status = 'Shipped'
and
order_placed_dt!=src_sts_chng_dt

---8)Find the order total amount and number of items purchased for each order.

select sales_order_num,
sum(cast (sales_order_line_num as int))as total_number,
sum(cast(sales_order_line_num as int) * cast(unit_price as float))
 as total_amount
from sale_order where status in('Shipped','Ordered') group by sales_order_num

---10)Find the total number of orders and average number of line for each day

select order_placed_dt,
count(sales_order_num) as 'Number of Order',
avg(cast(sales_order_line_num as int))as 'Average Order'
from sale_order group by order_placed_dt


---11)Find the number of order in all the statuses for each day.

select order_placed_dt,
(select count(status('Shipped')) from sale_order where status= 'Shipped') as 'Shipped' ,
(select count(status) from sale_order where status= 'Cancelled'  )as 'Cancelled',
(select count(*) from sale_order where status= 'Created'  )as 'Created',
(select count(*) from sale_order where status= 'Returned'  )as 'Returned',
(select count(*) from sale_order where status= 'Ordered'  )as 'Ordered'
from sale_order group by order_placed_dt

