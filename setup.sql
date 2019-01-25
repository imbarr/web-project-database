-- use master;
-- drop database spa;
-- go
-- drop login backend;
-- go

create database spa;
go

use spa;

create table payments (
  id int                                                                            not null identity,
  cardNumber char(16) check (cardNumber like '[0-9]%')                              not null,
  expirationMonth int check (expirationMonth >= 1 and expirationMonth <= 12)        not null,
  expirationYear int check (expirationYear >= 19 and expirationYear <= 99)          not null,
  CVC char(3) check (CVC like '[0-9]%')                                             not null,
  money int check (money >= 1000 and money <= 75000)                                not null,
  comment nvarchar(150)                                                             null,
  email varchar(100) check (email like '[a-z,0-9,_,-]%@[a-z,0-9,_,-]%.[a-z][a-z]%') not null,
  isSafe bit                                                                       not null default 1,
  primary key (id)
);

create table requests (
  id int                                                                                 not null identity,
  taxId varchar(12) check (taxId like '[0-9]%' and (len(taxId) = 10 or len(taxId) = 12)) not null,
  BIC char(9) check (BIC like '[0-9]%')                                                  not null,
  accountNumber char(20) check (accountNumber like '[0-9]%')                             not null,
  VAT varchar(4) check (VAT = '10%' or VAT = '18%' or VAT = 'None')                      not null,
  money int check (money >= 1000 and money <= 75000)                                     not null,
  telephone char(12) check (telephone like '+7[0-9]%')                                   not null,
  email varchar(100) check (email like '[a-z,0-9,_,-]%@[a-z,0-9,_,-]%.[a-z][a-z]%')      not null,
  primary key (id)
);

create table admins (
  login    varchar(50) not null,
  password char(64) not null,
  primary key (login)
)

insert into admins values ('admin', convert(char(64), hashbytes('SHA2_256', 'adminpassword'), 2))

create login backend with password='backendpassword', default_database=spa;
create user backend for login backend;

grant insert, select, update(isSafe) on payments to backend;
grant insert, select on requests to backend;
grant select on admins to backend;