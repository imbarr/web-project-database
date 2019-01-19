-- use master;
-- drop database spa;
-- go
-- drop login backend;
-- drop login admin;
-- go

create database spa;
go

use spa;

create table payments (
  card_number char(16) check (card_number like '[0-9]%') not null,
  expiration_month int check (expiration_month >= 1 and expiration_month <= 12) not null,
  expiration_year int check (expiration_year >= 19 and expiration_year <= 35) not null,
  cvc char(3) check (cvc like '[0-9]%') not null,
  money int check (money >= 1000 and money <= 75000) not null,
  comment nvarchar(150) null,
  email varchar(100) check (email like '[a-z,0-9,_,-]%@[a-z,0-9,_,-]%.[a-z][a-z]%') not null,
  is_safe bit not null default 1
);

create table requests (
  account_number char(20) check (account_number like '[0-9]%') not null,
  telephone char(10) check (telephone like '[0-9]%') not null
);

create login backend with password='backendpassword', default_database=spa;
create user backend for login backend;

grant insert on payments to backend;
grant insert on requests to backend;

create login admin with password='adminpassword', default_database=spa;
create user admin for login admin;

grant select, update(is_safe) on payments to admin;
grant select on requests to admin;