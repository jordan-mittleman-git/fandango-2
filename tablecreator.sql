EXEC sp_MSforeachtable @command1 = "DROP TABLE ?"
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

--exec sp_MSforeachtable "declare @name nvarchar(max); set @name = parsename('?', 1); exec sp_MSdropconstraints @name";
--exec sp_MSforeachtable "drop table ?"

-- Table Creations --

CREATE TABLE RegUser (
   user_id varchar(255) NOT NULL PRIMARY KEY,
   name varchar(255) NOT NULL,
   email varchar(255) NOT NULL UNIQUE,
   phone int NOT NULL
);


CREATE TABLE Theater (
   address varchar(255) NOT NULL PRIMARY KEY,
   name varchar(255) NOT NULL
);


CREATE TABLE Room (
   number int NOT NULL,
   theater_addr varchar(255) NOT NULL,
   capacity int NOT NULL,
   PRIMARY KEY (number, theater_addr),
   FOREIGN KEY (theater_addr) REFERENCES Theater (address)
);


CREATE TABLE Seat (
   seat_number int NOT NULL, 
   room_number int NOT NULL,
   theater_addr varchar(255) NOT NULL,
   PRIMARY KEY (seat_number, room_number, theater_addr),
   FOREIGN KEY (room_number, theater_addr) REFERENCES Room (number, theater_addr)
);


CREATE TABLE Movie (
   movie_id varchar(255) NOT NULL PRIMARY KEY,
   name varchar(255) NOT NULL,
   genre varchar(255) NOT NULL,
   rating varchar(255) NOT NULL CHECK (rating IN ('G', 'PG', 'PG13', 'R', 'NC-17', 'Unrated'))
);


CREATE TABLE Time (
   time_slot varchar(255) NOT NULL CHECK (time_slot IN ('morning', 'afternoon', 'evening')),
   date date NOT NULL,
   PRIMARY KEY (time_slot, date)
);


CREATE TABLE Schedule (
   movie_id varchar(255) NOT NULL, 
   room_number int NOT NULL,
   theater_addr varchar(255) NOT NULL,
   time_slot varchar(255) NOT NULL,
   date date NOT NULL,
   PRIMARY KEY (movie_id, time_slot, date, room_number, theater_addr),
   FOREIGN KEY (movie_id) REFERENCES Movie (movie_id),
   FOREIGN KEY (room_number, theater_addr) REFERENCES Room (number, theater_addr),
   FOREIGN KEY (time_slot, date) REFERENCES Time (time_slot, date)
);


CREATE TABLE Listings (
   user_id varchar(255),
   movie_id varchar(255) NOT NULL, 
   seat_number int NOT NULL,
   room_number int NOT NULL,
   theater_addr varchar(255) NOT NULL,
   time_slot varchar(255) NOT NULL,
   date date NOT NULL,
   PRIMARY KEY (seat_number, room_number, theater_addr, time_slot, date),
   FOREIGN KEY (movie_id, time_slot, date, room_number, theater_addr) REFERENCES Schedule (movie_id, time_slot, date, room_number, theater_addr),
   FOREIGN KEY (user_id) REFERENCES RegUser (user_id),
   FOREIGN KEY (seat_number, room_number, theater_addr) REFERENCES Seat (seat_number, room_number, theater_addr)
   /*FOREIGN KEY movie_id REFERENCES Movie (movie_id),
   FOREIGN KEY room_number REFERENCES Room (number),
   FOREIGN KEY theater_addr REFERENCES Theater (address),
   FOREIGN KEY (time_slot, date) REFERENCES Time (time_slot, date)*/
);