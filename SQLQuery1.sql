create database SI_DB
go

use SI_DB
go

create table Students
(
  Fnum varchar(3) not null primary key,--inline
  [Name] varchar(40) not null,
  Phone varchar(12) null,
  gender char(1) null default '-' check (gender in('M', 'F', '-', null))
  --age tinyint check(age between 18 and 100),

  --constraint PK_Students primary key (fnum) --out of line
)

/*
alter table Students
add [address] varchar(10) not null

alter table Students
alter column [address] varchar(40)

alter table Students
drop column [address]

alter table Students
add constraint UQ_Phone unique (Phone) --alternative key

alter table Students
drop constraint UQ_Phone


drop table Students

use master
--drop database SI_BD

*/
insert into Students(Fnum, [Name])
values ('100', 'angel ivanov')

insert into Students --all columns
values('101', 'mira ilieva', null, 'F'),
('102', 'martin petrov', '0214563214', default),
('103', 'dimitar penchev', '0214568745', 'M'),
('104', 'todor todorov', null, null)


update Students
set Phone='01245789630', gender='M'
where Fnum=104

select * from Students

delete from Students
where Fnum='100'

select * from Students
--where Fnum>103 and Phone like '%01%'
where Phone is not null
order by [Name] desc


