create database exam2
go
use exam2
go

create table pizzas (
pizza_id int primary key,
pizza_type varchar(20) not null
)

create table clients
(
client_id int primary key,
name varchar(30) not null,
phone varchar(10) not null
)

create table pizza_orders(
pizza_id int not null references pizzas,
client_id int not null references clients,
primary key(pizza_id, client_id),
quantity int not null, 
size char(1) not null check (size in('S', 'B')),
[datetime] datetime not null
)

alter table pizza_orders 
add price decimal(5, 2) check(price>0)

alter table clients
drop column phone

insert into pizzas values (1, 'Margarita'), (2, 'New Yourk'),
(3, 'Poland')

insert into clients values (1, 'Gosho'), (2, 'Pesho'), (3, 'Maria')

insert into pizza_orders values
(1, 2, 2, 'S', getdate(), 20.0),
(2, 3, 1, 'B', '2022-08-13 12:45', 13.50),
(3, 1, 3, 'S', '2023-08-13', 34.80)

update pizza_orders
set quantity=5, size='B'
where pizza_id=1

delete from pizza_orders where pizza_id=3

select name, datetime, size from clients c join pizza_orders po
on po.client_id=c.client_id
where size='S'
order by name desc

