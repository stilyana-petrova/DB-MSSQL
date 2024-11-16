create database jobbd
go
use jobbd
go

--primary key is not null

alter database current
collate cyrillic_general_ci_as

create table regions
(region_id smallint not null identity (1,1) primary key,
[name] varchar(25) not null unique
)

--drop table regions

create table countries
(
country_id char(2) primary key,
[name] varchar(40) not null,
region_id smallint,

constraint fk_country_region
foreign key (region_id)
references regions(region_id)
)

create table customers
(
customer_id numeric(6) primary key, 
country_id char(2) not null foreign key references countries, 
fname varchar(20) not null, 
lname varchar(20) not null, 
[address] text, 
email varchar(30), 
gender char(1) default '-'
check (gender in('M', 'F', null))
)

create table jobs
(
job_id varchar(10) primary key, 
job_title varchar(35) not null, 
min_salary numeric(6), 
max_salary numeric(6)
)

create table employees
(
employee_id int primary key, 
fname varchar(20) not null,
lname varchar(20) not null,
email varchar(40) not null unique, 
phone varchar(20), 
hire_date datetime not null, 
salary numeric(8, 2) not null check(salary>0), 
job_id varchar(10) not null references jobs, --fk
manager_id int,
department_id int

--self reference
foreign key (manager_id) references employees(employee_id)
)

create table departments
(
department int primary key, 
[name] varchar(30) not null,
manager_id int,
country_id char(2) not null,
city varchar(30) not null,
[state] varchar(25),
[address] varchar(40),
postal_code varchar(12)

foreign key (manager_id) references employees(employee_id),
foreign key (country_id) references countries(country_id)
)

alter table employees
add foreign key (department_id) references departments


create table products
(
product_id int primary key,
[name] varchar(40) not null,
price numeric(8, 2) not null,
descr varchar(2000)
)

create table orders
(
order_id int primary key,
order_date datetime not null,
customer_id numeric(6) not null references customers,
employee_id int not null references employees,
ship_address varchar(150)
)

create table order_items
(
order_id int not null references orders on delete cascade on update cascade,
product_id integer not null references products,
primary key(order_id, product_id),
unit_price numeric(8, 2) not null,
quantity numeric(8) not null
)


insert into regions([name]) values ('Източна Европа')
select * from regions

insert into countries values ('BG', 'България', 1)
select * from countries

insert into customers values (1, 'BG', 'Илия','Иванов', null, null, null)
select * from customers

insert into jobs values('MNG', 'Мениджър', null, null)
select * from jobs

insert into departments values (10, 'QA отдел',null, 'BG', 'Пловдив', null, null, null)
select * from departments

insert into employees (employee_id, fname, lname, email, hire_date, salary, job_id) 
values (10, 'Гергана', 'Илиева', 'gilieva@gmail.com', convert (datetime, '20-09-2024', 105), 3000, 'MNG')
select * from employees


insert into products (product_id, [name], price) values (1, 'fm adata', 18.5), 
(2, 'mouse logi', 50)
select *from products


insert into orders (order_id, order_date, customer_id, employee_id) values(100, getdate(), 1, 10)
select *from orders


insert into order_items (order_id, product_id, unit_price, quantity) values (100, 1, 18, 3), (100, 2, 50, 1)
select *from order_items


--employee with id=10

update employees
set salary=salary+600
where employee_id=10


--on delete cascade
delete from orders
select*from order_items

delete from customers
delete from departments
delete from countries
delete from regions
delete from products
delete from employees
delete from jobs
delete from order_items

alter table products
alter column  name varchar(70) not null


/*Задача 3-2. 
Да се увеличи количеството с 2 броя на
продукт с идентификатор 2254 в 
поръчка с идентификатор 2354.*/

update order_items
set quantity=quantity+2
where product_id=2254 and order_id=2354
select*from order_items

--Задача 3-3.
--Да се изтрие служител с идентификатор 183.
delete from employees where employee_id=183


--Пример 4-1. 
--Да се изведат имената, датите на назначаване и заплатите на всички служители.

select fname+' '+ lname as name, hire_date, salary from employees

/*Пример 4-2.
Да се изведат всички данни за продуктите, с цена по-голяма от 2000. 
Резултатът нека бъде подреден по цена на продукт възходящо.*/


select * from products 
where price>2000 order by price 

--Пример 4-3.
--Да се изведе броя на всички служители.

select count(*) from employees 
--select count(*) [count employees] from employees 
--select count(*) 'count employees' from employees 
--select count(*) as count from employees 
--select count(employee_id) from employees



--Пример 4-4. 
--Да се изведе броя служители, групирани по отдела, в който работят.


select count(*) as [count], department_id from employees 
group by department_id


--групирани по длъжност

select count(*) as [count], job_id from employees 
group by job_id

 
 --Задача 4-1. 
--Да се изведат имената, заплатите и идентификаторите на длъжностите на
--служителите, работещи в отдели 50 и 80. Резултатът да е подреден по фамилия на служител във възходящ ред.


select fname, lname, salary, job_id from employees
where department_id=50 or department_id=80
order by lname


--Задача 4-2. 
--Да се изведат общата сума на заплатите и броя служители в отдел 60.

select count(*) as employeeCount, sum(salary) as salarySum from employees
where department_id=60

--Задача 4-3. 
--За всички поръчки да се изведат идентификатор на поръчка и обща стойност на
--поръчката. Резултатът да е подреден по стойност на поръчката в низходящ ред.

select order_id, unit_price from order_items 
order by unit_price desc

-------------------------------------------------------------------------------------------
-------------------------------------Set operators-----------------------------------------
--Условия:
--Броят на колоните във всички заявки трябва да бъде еднакъв;
--Колоните трябва да бъдат от съвместими типове от данни.

select * from products
where price not between 20 and 1000

select * from products
where descr is not null

select * from products 
where name like 'кабел%'



--union - union all
--intersect
--except

---------------------------------------UNION ----------------------------------------------
/*	Резултатни набори, които се обединяват. В целия израз може да присъства само една клауза , 
	ORDER BY накрая сортираща обединения резултат. */


--Пример 4-5. 
--Да се изведат идентификаторите на държавите, в които има клиенти или отдели на фирмата.
select country_id from customers union select country_id from departments


--Пример 4-6. 
--Да се изведат идентификаторите на държавите, в които има клиенти или отдели на фирмата. 
--Нека в резултатния набор участват и дублиращите се записи.

select country_id from customers union all select country_id from departments


/*Задача 4-4. 
Да се изведат всички малки имена на клиенти и служители с евентуалните
повторения, сортирани в низходящ ред по име. */

select trim(fname) from customers union all select trim(fname)from employees 
order by 1 desc


/*Задача 4-5.
Да се изведат име и фамилия на клиенти и служители без повторения, а като
трета колона за клиентите да се използва израз, генериращ низа „Клиент
(<идентификатор>)“, за служителите – „Служител (<идентификатор>)“. */


select fname, lname, 'Клиент
('+country_id+')' from customers union all 
select fname, lname, 'Служител('+ cast (isnull (department_id, 0) as varchar)from employees 

----------------------------------INTERSECT(сечение)---------------------------------------
/*Резултатът съдържа общите за двата резултатни набора редове, без дубликати. 

Пример 4-7. 
а се изведат id на държавите, в които има клиенти и отдели на фирмата едновременно.*/

select country_id from customers intersect select country_id from  departments

--Задача 4-6. 
--Да се изведат общите собствени имена на клиенти и служители.

select trim(fname) from customers intersect select trim(fname)from employees 


----------------------------------EXCEPT---------------------------------------------------
/*връща редовете, върнати от първата заявка, които не се срещат измежду редове от втората. */

--Пример 4-8.
--Изведи id на държавите, в които има клиенти и в същото време няма отдели на фирмата.

select country_id from customers except select country_id from  departments


/*Задача 4-7. 
Да се изведат собствени имена на клиенти, които не се срещат сред тези на служители.*/



-------------------------------------------------------------------------------------------
------------------------------------ JOIN -------------------------------------------------
--JOIN се използва за извличане на данни от две или повече таблици, като редовете им се
--комбинират чрез логическа връзка между таблиците, която може да бъде във FROM или WHERE.
--Обикновено тази връзка е първичен/външен ключ, но не задължително.

-----------------------------------------------------------------------------------------
-----------------------------INNER JOIN или просто JOIN----------------------------------
-----------------------------------------------------------------------------------------
--Извеждат редовете от две/повече таблици, които имат съвпадащи стойности в колоните,
--посочени в условието за сравнение.

--Пример 4-10. 
--	Да се изведат държавите и регионите, в които се намират.

--inner join
--1
select * from regions join countries on regions.region_id=countries.region_id

--2 
select * from regions, countries where regions.region_id=countries.region_id

--3
select * from regions r, countries c where r.region_id=c.region_id


--Пример 4-11.
--	Изведи имена на клиенти, имена на държавите от които са, и имена на регионите на държавите.

--1
select fname, lname, c.name, r.name from regions r, countries c, customers cu where r.region_id=c.region_id and cu.country_id=c.country_id

--2
select fname, lname, c.name, r.name 
from regions r join countries c on r.region_id=c.region_id join customers cu on cu.country_id=c.country_id


-----------------------------------------------------------------------------------------
-------------------------------Видове OUTER JOIN-----------------------------------------
-----------------------------------------------------------------------------------------

--Пример 4-12. 
--	Да се изведат регионите и държавите, които се намират в тях. Резултатният
--	набор да включва и регионите, в които няма въведени държави.

select * from regions r left join countries c on r.region_id=c.region_id



--Пример 4-13. 
--	Да се изведат държавите и регионите, в които се намират. 
--	Резултатния набор да включва държавите, за които няма въведен регион.

select * from countries c left join regions r on r.region_id=c.region_id


--select * from countries c left join regions r on r.region_id=c.region_id
--where r.region_id is null

/*Пример 4-14.
Да се изведат държавите и регионите, в които се намират. 
Резултатния набор да включва държавите, за които няма въведен регион и регионите, 
за които няма въведени държави.*/

select * from countries c full join regions r on r.region_id=c.region_id

-----------------------------------------------------------------------------------------
----------------------------4.6.6. Други JOIN вариации---------------------------------
-----------------------------------------------------------------------------------------
--НАЗВАНИЯ НА JOIN СПРЯМО ИЗПОЛЗВАНИТЕ ОПЕРАТОРИ:
-- =                    EQUI JOIN 
--!= >< NOT BETWEEN AND NON-EQUI JOIN
--IN      / EXISTS      SEMI JOIN
--NOT IN / NOT EXISTS   ANTI JOIN 
-----------------------------------------------------------------------------------------


/*Пример 4-16.
Да се изведат отделите, в които има назначени служители.*/

--1 inner join
select distinct name from departments d join employees e on e.department_id=d.department_id

--2 semi join
select name from departments where department_id in (select department_id from employees)

--3

select name from departments where exists (select * from employees e where e.department_id=d.department_id)

--Пример 4-17.
--	Да се изведат имената на клиентите, които все още не са правили поръчки.

--1 outer join
select fname, lname, order_id from orders o right join customers c on o.customer_id=c.customer_id
where order_id is null

--2 anti-join
select fname, lname from customers where customer_id not in (select customer_id from orders)

--Пример 4-18. 
--	Да се изведат комбинациите от всички региони и държави, сортирани поиме на държава.

select * from regions, countries


--Задача 4-8. 
--	Извлечи идентификатори, дати на поръчките и имена на служители, които са ги обработили.

select order_id, order_date, fname, lname from orders o join employees e on e.employee_id=o.employee_id


--Задача 4-9. 
--	Да се изведат имената на всички клиенти и id на поръчките им. 
--	В резултатния набор да участват и клиентите, които все още не са правили поръчки.

--Задача 4-11. 
--	Да се изведат имената на всички клиенти, които са от държави в регион „Западна Европа“

select fname, lname from customers c join countries co on co.country_id=c.country_id join regions r on r.region_id=co.region_id where r.name='Западна Европа'

-----------------------------------------------------------------------------------------
---------------------------------4.7.1. TOP ---------------------------------------------
--  TOP връща първите N реда в неопределен ред, за желаната подредба използваме ORDER BY!
-----------------------------------------------------------------------------------------

-- Пример 4-19. 
-- 7-те продукта с най-ниска цена.

select top 7 * from products order by price

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

--SELECT КОЛОНА1, COUNT(КОЛОНА2) БРОЙ, КОЛОНА3
--FROM ТАБЛИЦА1 Т1 JOIN ТАБЛИЦА2 Т2
--ON   Т1.Т_ID=T2.T_ID
--WHERE УСЛОВИЯ РАЗЛИЧНИ ОТ АГРЕГАТНИ ФУНКЦИИ - MIN/MAX/SUM/COUNT/AVG
--GROUP BY КОЛОНА1, КОЛОНА3
--HAVING COUNT(КОЛОНА2) > < = ЧИСЛО
--ORDER BY БРОЙ ASC/DESC

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------


--Задача 01
--Изведи имента на клиентите, които са от 'DE', но не са правили поръчки до
--момента

select fname, lname, order_id from orders o right join customers c on o.customer_id=c.customer_id 
join countries co on c.country_id=co.country_id 
where co.country_id='DE' and order_id is null


--Задача 02
-- Изведи колко държави има в съответните региони.

select count(country_id), r.name from countries c join regions r on c.region_id=r.region_id group by r.name


--Задача 03
-- Изведи колко държави има в съответните региони, но нека присъстват само регионите, в които има повече от 5 държави. Сортирай ги по име на регион низходящо.

select count(country_id), r.name from countries c join regions r on c.region_id=r.region_id group by r.name
having count(country_id)>5 order by r.name desc


--Задача 04
---Изведи максималната от всички заплати за идентификатор 'IT_PROG' от таб. със служителите.

select job_id, max(salary) from employees where job_id='IT_PROG' group by job_id

--Задача 05
---Изведи средната заплата за служителите, работещи на
-- определена длъжност (представена с название).

select avg(salary), j.job_title from jobs j join employees e on j.job_id=e.job_id group by j.job_title

-----------------------------------------------------------------------------------------
---------------------------------4.7.2. OFFSET и FETCH ----------------------------------
-----------------------------------------------------------------------------------------

/* Пример 4-21. 
петимата служители, започвайки от 10-ти ред, подредени по дата на постъпване. 
Първата заявка ще покаже всички за демонстрация, втората ще извърши подбора.*/

select * from employees order by hire_date offset 9 rows fetch next 5 rows only

 
/*Задача 4-12. 
вторите 10 най-добре платени служители (подредени по заплата низходящо).*/

select * from employees order by salary desc offset 10 rows fetch next 10 rows only
      
/* Задача 4-13. 
Да се изведат име, фамилия и пол на клиентите, направили последните 5 поръчки.*/

--1
select top 5 fname, lname, gender from customers c join orders o on o.customer_id=c.customer_id order by order_date desc

--2
select fname, lname, gender from customers c join orders o on o.customer_id=c.customer_id order by order_date desc
offset 0 rows fetch next 5 rows only


----------------------------------------------------------------------------------------
-----------------------------Изгледи = Views--------------------------------------------
----------------------------------------------------------------------------------------
--Пример 5-1. 
--Да се създаде изглед, който съдържа име и фамилия на клиентите, както и
--номер и дата на поръчките, които те са направили.

create view orders_customers_view as select fname, lname, order_id, order_date from customers c join orders o on o.customer_id=c.customer_id
 
--Пример 5-2. 
--Да се модифицира горният изглед така, че да съдържа 
--имената на клиентите и съответно кой колко поръчки има.

alter view orders_customers_view as select fname, lname, count(order_id) broi from customers c join orders o on o.customer_id=c.customer_id
group by fname, lname, c.customer_id

select * from orders_customers_view

-- Пример 5-3.
-- Да се създаде изглед, който съдържа имена, отдел и заплата на 5-мата служители с най-висока заплата. 
--За да бъдат извлечени служителите, подредени по заплата, очевидно ще трябва да бъдат сортирани по този критерий.

create view top_salaries as select top 5 fname, lname, department_id, salary from employees order by salary desc
select * from top_salaries


-- Пример 5-4
--Да се създаде изглед, който съдържа имената на продуктите и общо поръчано количество от продукт.

create view product_view as select p.name, sum(quantity) sum_q from products p join order_items o on o.product_id=p.product_id group by p.name
select * from product_view

-- Пример 5-5.	
--Да се създаде изглед, който съдържа десетимата клиенти с най-голям брой поръчки. Ако последният клиент има равен брой поръчки с други клиенти, те също да участват в изгледа.

create view vip10_custs as select top 10 with ties fname, lname, count(order_id) broi from customers c join orders o on o.customer_id=c.customer_id
group by fname, lname, c.customer_id
order by count(order_id) desc

select * from vip10_custs
