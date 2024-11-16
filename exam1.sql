create database exam1
go
use exam1
go

alter database current collate Cyrillic_General_CI_AI

create table people 
(
person_id int primary key, 
name varchar(50) not null
)

create table cars(
car_id int primary key,
model varchar(40) not null,
person_id int not null references people
)

--2. Добави атрибут MARK от тип низ от символи с варираща дължина и краен брой символи 40 знака. Нека колоната бъде задължителна за въвеждане.

alter table cars add mark varchar(40) not null

--3. Въведи записи във всяка от таблиците.
insert into people 
values(1, 'Petar'), (2, 'Martin'), (3, 'Ivan'), (4, 'Milena'), (5, 'Petya')
select * from people

insert into cars (car_id, model, mark, person_id) values
(100, 'golf 5', 'vw', 1),
(101, 'sfdvs', 'ss', 2),
(102, 'sdfsdvs', '233', 2),
(103, 'sds', 'ad2', 3),
(104, 'DSgg', '22', 4),
(105, 'golf 5', 'arwer', 5)

select * from cars

--4. Изтрий автомобила с последния въведен от теб идентификатор.

delete from cars where car_id=105

--5. Промени името на последния въведен от теб собственик на автомобил .
update people set name ='Vasil' where person_id=3

--6. Изведи имената на хората и техните модели коли. Но нека участват и хора, които нямат коли изобщо.
select * from cars c join people p on p.person_id=c.person_id

--7. Изведи колко автомобила има всеки човек.
select name, count(car_id) from cars c join people p on p.person_id=c.person_id
group by name, p.person_id
