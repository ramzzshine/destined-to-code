--Airport database

select * from passenger
select * from pass_in_trip
select * from company
select * from trip

---1)Find the names of the different passengers, who flew more than once in the same seat. --Result Set: Name, Place, No of Trips
select * from (
select p.name,
pt.place,
count(pt.trip_no)as[No of Trip]
from passenger p
join pass_in_trip pt on p.id_psg = pt.id_psg
group by p.name,pt.place
) as a where [No of Trip]>1

---2)For the days between 2003-04-01 and 2003-04-07, find the number of trips from the town Rostov.
--Result set: date, number of trips

select date,count(trip_no) as[No Of Trip]
from pass_in_trip where date between '2003-04-01' and '2003-04-07'
group by date

---3)List the passengers who have visited Moscow more than once.
--Result set: name, number of visits to Moscow.

select * from 
(select p.name,count(pt.trip_no) as [No of Trip]
from passenger p
join pass_in_trip pt on p.id_psg = pt.id_psg
join trip t on pt.trip_no = t.trip_no
where  t.town_to ='Moscow' group by p.name)as a where [No of Trip]>1

---4)For each company, find the number of passengers (if any) who travelled in April 2003 by every ten-day period.
--Result set: name, 1-10, 11-20, 21-30

select name,count([1-10]) as [1-10] ,count([11-10]) as [11-10],count([21-10]) as [21-10] from
(select c.name,
case
when
pt.date<'2003-04-10' then 1
else null
end as [1-10],
case
when
pt.date>'2003-04-10' and pt.date<'2003-04-20'  then 1
else null
end as [11-10],
case
when
pt.date>'2003-04-20' and pt.date<'2003-05-1'  then 1
else null
end as [21-10]
from company c
join trip t on c.id_comp = t.id_comp
join pass_in_trip pt on t.trip_no = pt.trip_no) as a group by name


---5)Determine the total number of routes served by the flight(s) which has the maximum number of trips. A -B and B - A are to be considered as DIFFERENT routes.
--Result Set: Number of Trips

select count (*) as [Number of trip] from
(
select distinct plane,town_from,town_to from trip
)as a


---6)Among the clients who only use a single company, find the passengers who have flown the most.
--Result set: passenger name, number of trips.

select distinct name,count(trip_no)as[No of trip] from(
select  p.name,t.id_comp,t.trip_no 
from passenger p
join pass_in_trip pt on p.id_psg = pt.id_psg
join trip t on pt.trip_no = t.trip_no 
)as a group by name,id_comp


---7)Find the passengers who spent the most amount of time in flight than others.
--Result set: passenger name, total flying time in minutes.

select name,sum([Flying Minutes]) as [Total Flying Minutes] from
(
select name,
datediff(mi,t.time_out,t.time_in) as[Flying Minutes]
from passenger p 
join pass_in_trip pt on p.id_psg = pt.id_psg
join trip t on pt.trip_no = t.trip_no
) as a group by name

