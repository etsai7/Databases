drop table Prices;
create table Prices (
       tick     VARCHAR(5),
       date     VARCHAR(10),
       open     FLOAT,
       close    FLOAT,
       high     FLOAT,
       low      FLOAT
);

drop table Volume;
create table Volume (
       tick       VARCHAR(5),
       date       VARCHAR(10),
       volume     FLOAT,
       adjvolume  FLOAT
);

drop table Misc;
create table Misc (
       tick       VARCHAR(5),
       date       VARCHAR(10),
       divi        FLOAT,
       splitratio FLOAT
);

drop table AdjPrices;
create table AdjPrices (
       tick     VARCHAR(5),
       date     VARCHAR(10),
       aopen    FLOAT,
       aclose   FLOAT,
       ahigh    FLOAT,
       alow     FLOAT
);

drop table Company;
create table Company (
       tick       VARCHAR(5),
       name       VARCHAR(25),
       hqkey      VARCHAR(10),
       employees  INTEGER,
       CEO        VARCHAR(20),
       founddate  VARCHAR(10)
);

drop table Location;
create table Location (
       hqkey      VARCHAR(10),
       city     VARCHAR(15),
       state    VARCHAR(10),
       country  VARCHAR(10)
);


insert into Company values ('AAPL', 'Apple', 'CUP', 123000, 'Tim Cook', '1976-04-01');
insert into Company values ('AMZN', 'Amazon', 'SEA', 541000, 'Jeffery Bezos', '1994-07-05');
insert into Company values ('A', 'Agilent', 'SCL', 13500, 'Mike McMullen', '1999-01-01');
insert into Company values ('AMD', 'Advanced Micro Devices', 'SCL', 9100, 'Lisa Su', '1969-05-01');
insert into Company values ('AFL', 'Aflac', 'COL', 9235, 'Dan Amos', '1955-11-17');



insert into Location values ('COL', 'Columbus', 'Georgia', 'US');
insert into Location values ('SCL', 'Santa Clara', 'California', 'US');
insert into Location values ('SEA', 'Seattle', 'Washington', 'US');
insert into Location values ('CUP', 'Cupertino', 'California', 'US');
