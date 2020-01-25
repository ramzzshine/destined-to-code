CREATE TABLE [dbo].[Flights](
	[flno] [varchar](25) ,
	[frm] [varchar](70) ,
	[arr_to] [varchar](70) ,
	[distance] [int] ,
	[departs] [datetime],
	[arrives] [datetime] ,
	[price] [int] 
)

CREATE TABLE [dbo].[Aircraft](
	[aid] [int] ,
	[aname] [varchar](50) ,
	[cruisingrange] [int] 
)

CREATE TABLE [dbo].[Certified](
	[eid] [int] ,
	[aid] [int] 
)

CREATE TABLE [dbo].[Employees](
	[eid] [int] NULL,
	[ename] [varchar](60) ,
	[salary] [int] 
)

insert into Aircraft values( 1,'Trans Anguilla Air',456689)

insert into Aircraft values( 5,'REDjet',8756689)

insert into Aircraft values( 8,'Fly BVI',56689)

insert into Aircraft values( 11,'International AirLink',9089)

insert into Aircraft values( 3,'M&N Aviation',432109)

insert into Employees values(101, 'CHRISTOPHER',57000)

insert into Employees values(335, 'EDWARD',115000 )

insert into Employees values(670, 'MATTHEW',115000 )


insert into Employees values(120,'ERIC', 10000)

insert into Employees values(225, 'DOUGLAS', 23000)


insert into Certified values (101,5)

insert into Certified values(335,11)

insert into Certified values(670,5)

insert into Certified values (120,11)

insert into Certified values(225,5)

------------------------------------------------------------



insert into Flights values('RUS 1727','Los Angeles','Honolulu',180, '14:30','16:30',2000) 

insert into Flights values('LH 4234', 'New York' , 'Madison', 190,'11:38','14:33',1888) 

insert into Flights values('TP 559', 'Madison' , 'New York',230,'10:23','14:39',2500) 

insert into Flights values('LH 1704', 'Los Angeles', 'NewYork', 145,'9:30','12:54', 3020) 

insert into Flights values('UA 882', 'Utah' ,'Seattle',87,'13:20','15:40',1200) 

insert into FLights values('AI 512', 'Seattle', 'Chicago',123,'12:35','16:30',2500) 

insert into Flights values('TAA 432','Washington', 'Sans Fransisco',230,'8:44','12:00',3200) 

insert into Flights values('LH 4234', 'Detriot', 'Los angeles',156,'11:56','15:40',2200) 

insert into Flights values('RJ 1235','Sans Fransisco','Detriot',102,'11:30','16:30',900) 

insert into Flights values('LH 4234','Chicago','NewYork',169,'02:33','05:30',1400) 

insert into Flights values('LH 4234','Sans Fransisco','Chicago',83,'15:20','18:40',900) 


insert into Flights values('LH 4234','Washington','Detriot',78,'5:30','10:23',1300)


CREATE TABLE junctions (
[JuncNo] INTEGER,
[TrafficLight] INTEGER,
[JuncName] varchar(50));

CREATE TABLE roads (
[link_id] INTEGER,
[FJunc] INTEGER,
[TJunc] INTEGER,
[roadname] varchar(60),
[link_len] decimal(10,3),
[cityname] varchar(60),
[zipcode] varchar(12));

insert into roads
(link_id,fjunc,tjunc,roadname,link_len,cityname,zipcode)
values
(112,18,8 ,'Archibald St' ,29.39 ,'Hatsfield','56349')
,(113,8,19 ,'Archibald St' ,34.56 ,'Hatsfield','56349')
,(119,30,12 ,'Factory Yard' ,157.48 ,'Hatsfield','56349')
,(122,7,8 ,'High Amplitude Avenue',31.30 ,'Hatsfield','56349')
,(117,18,20, 'Archibald St' ,51.34,'Hatsfield','56349')
,(120,20,6, 'South west st.' ,94.45,'Hatsfield','56349')
,(116,16,11, 'Morington Avenue' ,12.42,'Hatsfield','56349')
,(111,11,13, 'Morington Avenue' ,10.23,'Hatsfield','56349')
,(190,13,23, 'Morington Avenue' ,23.67,'Hatsfield','56349')
,(191,11,12, 'Factory Yard' ,11.23,'Hatsfield','56349')
,(194,14,12, 'Clinton street' ,31.23,'Hatsfield','56349')
,(144,20,23, 'Mossern street' ,31.23,'Hatsfield','56349')
,(145,26,23, 'Walker Avenue' ,22.53,'Hatsfield','56349')

insert into junctions
(JuncNo,TrafficLight,JuncName)
values
(8,1,'JN001')
,(10,0,'JN008')
,(11,0,'JN089')
,(12,0,'JN034')

SELECT * FROM ROADS
SELECT * FROM JUNCTIONS

--1)What is the longest street/road in this layout?

select roadname, sum (link_len) as total_len from roads
group by roadname order by total_len desc   

--2)Does these two streets intersects ("Archibald St" & "High Amplitude Avenue")?

SELECT R.ROADNAME , J. JUNCNAME AS A_JUNCTIONNAME, JU.JUNCNAME AS  B_JUNCTIONNAME FROM ROADS AS R
JOIN JUNCTIONS AS J
ON R.FJUNC = J.JUNCNO
JOIN JUNCTIONS AS J ON R.TJUNC = J.JUNCNO 



select * from Flights

-- 1. A customer wants to travel from Madison to New York with no more than two changes of flight. List the choice of departure times from Madison 
--if the customer wants to arrive in NewYork by 6 p.m.
select flno,frm,arr_to from Flights where frm = 'Madison' and arr_to = 'New York' and datepart(hour,arrives)<18

--2)Identify the routes that can be piloted by every pilot who makes more than $100,000.

select distinct f.frm, f.arr_to from Flights as f
where not exists 
(select * from employees as e where
e.salary >100000
and not exists 
(select * from aircraft as a , certified as c
where a.cruisingrange > f.distance and e.eid = c.eid and a.aid = c.aid))

--3)Find the names of aircraft such that all pilots certied to operate them earn more than $80,000

select distinct A.aname from Aircraft as A
where A.aid in (select c.aid from certified as c, employees as e
where c.eid = e.eid and
not exists (select * from employees as e1
where e1.eid = e.eid and e1.salary < 80000))

--4)For all aircraft with cruising range over 1000 miles, nd the name of the aircraft and the average salary of all pilots certied for this aircraft.

select temp.name, temp.avgsalary from (
select A.aid, a.aname as name , AVG (E.salary)as avgsalary
from Aircraft as a, Certified as c, employees as e
where a.aid = c.aid and c.eid = e.eid and a.cruisingrange>1000
group by a.aid, a.aname) as temp