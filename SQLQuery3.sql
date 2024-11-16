--?????? 2-1. 
--?? ?? ??????? ???? ?? ????? ? ??? TESTDB.
 
--?????? 2-2. 
--?? ?? ??????? ??????? ? ???? ???? ????? ? ??? COUNTRIES ? ???????? ??????:
--country_code � ? ??? char(3);
--name � ??? varchar(40);
--population � ??? int.
 
--?????? 2-3. 
--?? ?? ?????? ??? ??????? ? ????????? COUNTRIES 
--? ??? phone_code, ????? ?? ??????? ???? ????? ?? 3 ?????.
 
--?????? 2-4. 
--?? ?? ?????? ??? ? ????????? COUNTRIES ??? ???????? ?????:
--country_code: BGR;
--name: Bulgaria;
--population: 7500000;
--phone_code: 359.
 
--?????? 2-5. ?? ?? ??????? ??????????? ?? ???????? ?? 6 ???????.
 
--?????? 2-6. ?? ?? ??????? ?????? ?????? ? ????????? COUNTRIES.
 
--?????? 2-7. ?? ?? ?????? ????????? COUNTRIES ?? ?????? ?????.
 
--?????? 2-8. ?? ?? ?????? ?????? ????? TESTDB.

--insert, create, delete ?? ???? ?? ????????


create database testbd
go
use testbd
go

create table countries
(
country_code char(3), 
[name] varchar(40),
population int
)


alter table countries
add phone_code int check(phone_code between 0 and 999)
--check(phone_code like '[0-9] [0-9] [0-9]' varchar

insert into countries values('BGR', 'Bulgaria', 7500000, 359)

update countries
set population=6000000 where country_code='BGN'

delete from countries

drop table countries

use master

drop database testbd
