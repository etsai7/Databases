create table Restaurant (
       ResID       INTEGER,
       ResName     VARCHAR(100),
       Address     VARCHAR(100)
);

create table Type_Of_Restaurant (
       ResID       INTEGER,
       ResTypeID   INTEGER
);

create table Restaurant_Type (
       ResTypeID            INTEGER,
       ResTypeName          VARCHAR(40),
       ResTypeDescription   VARCHAR(100)
);

create table Visits_Restaurant (
       StuID      INTEGER,
       ResID      INTEGER,
       Time       TIMESTAMP,
       Spent      FLOAT
);

insert into Restaurant values ( 1, 'Subway', '3233 St Paul St, Baltimore, MD 21218');
insert into Restaurant values ( 2, 'Honeygrow', '3212 St Paul St, Baltimore, MD 21218');

insert into Restaurant_Type values ( 1, 'Sandwich', 'Simplest there is.');
insert into Restaurant_Type values ( 2, 'Stir-fry', 'Classic Chinese cooking.');

insert into Type_Of_Restaurant values (1, 1);
insert into Type_Of_Restaurant values (2, 2);

insert into Visits_Restaurant values (1001, 1, '2017-10-09 18:15:00', 6.53);
insert into Visits_Restaurant values (1032, 2, '2017-10-08 13:00:30', 13.2);

create table Has_Pet (
       StuID		INTEGER,
       PetID		INTEGER
);

create table Pets (
       PetID		INTEGER,
       PetType		VARCHAR(20)
);

insert into Has_Pet values ( 1001, 2001 );
insert into Has_Pet values ( 1002, 2002 );

insert into Pets values ( 2001, 'cat' );
insert into Pets values ( 2002, 'dog' );