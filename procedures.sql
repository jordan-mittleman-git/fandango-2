IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'GetMoviesAtTheaterOnDate'
)
DROP PROCEDURE dbo.GetMoviesAtTheaterOnDate
GO

-- Queries (Procedures) --

CREATE PROCEDURE dbo.GetMoviesAtTheaterOnDate
@theater varchar(255), @date date
AS
SELECT movie_id
FROM dbo.Schedule
WHERE theater_addr = @theater AND date = @date;
GO

DECLARE @theater varchar(255), @date date
SELECT @theater = 'Theater 1', @date = '2020-01-10'
EXEC GetMoviesAtTheaterOnDate @theater, @date
GO

---------------------------------------------------------------

CREATE PROCEDURE GetMoviesAtTheaterOnDateRange
@theater varchar(255), @start_date date, @end_date date
AS
SELECT DISTINCT movie_id
FROM Schedule
WHERE theater_addr = @theater AND date > @start_date AND date < @end_date;
GO

DECLARE @theater varchar(255), @start_date date, @end_date date
SELECT @theater = 'Theater 1', @start_date = '2020-01-10', @end_date = '2020-01-13'
EXEC GetMoviesAtTheaterOnDateRange @theater, @start_date, @end_date
GO

---------------------------------------------------------------

CREATE PROCEDURE GetTheatersPlayingMovieOnDate
@movie varchar(255), @date date
AS
SELECT DISTINCT theater_addr
FROM Schedule
WHERE movie_id = @movie AND date = @date;
GO

DECLARE @movie varchar(255), @date date
SELECT @movie = 'Thor', @date = '2020-01-10'
EXEC GetTheatersPlayingMovieOnDate @movie, @date
GO

---------------------------------------------------------------

CREATE PROCEDURE GetTheatersPlayingMovieOnDateRange
@movie varchar(255), @start_date date, @end_date date
AS
SELECT DISTINCT theater_addr
FROM Schedule
WHERE movie_id = @movie AND date > @start_date AND date < @end_date;
GO

DECLARE @movie varchar(255), @start_date date, @end_date date
SELECT @movie = 'Thor', @start_date = '2020-01-10', @end_date = '2020-01-13'
EXEC GetTheatersPlayingMovieOnDateRange @movie, @start_date, @end_date
GO

---------------------------------------------------------------

CREATE PROCEDURE GetMoviesWithRating
@rating varchar(255)
AS
SELECT DISTINCT movie_id
FROM Movie
WHERE rating = @rating;
GO

DECLARE @rating varchar(255)
SELECT @rating = 'PG13'
EXEC GetMoviesWithRating @rating
GO

---------------------------------------------------------------

CREATE PROCEDURE GetMoviesWithRatingAtTheaterOnDate
@theater varchar(255), @date date, @rating varchar(255)
AS
SELECT DISTINCT M.movie_id
FROM Schedule S, Movie M
WHERE S.movie_id = M.movie_id AND S.theater_addr = @theater AND M.rating = @rating AND S.date = @date;
GO

DECLARE @theater varchar(255), @date date, @rating varchar(255)
SELECT @theater = 'Theater 1', @date = '2020-01-10', @rating = 'PG13'
EXEC GetMoviesWithRatingAtTheaterOnDate @theater, @date, @rating
GO

---------------------------------------------------------------

CREATE PROCEDURE MakeReservation
@user varchar(255), @seat int, @room int, @theater varchar(255), @date date, @time varchar(255)
AS
UPDATE Listings 
SET user_id = @user
WHERE seat_number = @seat AND room_number = @room AND theater_addr = @theater AND date = @date AND time_slot = @time;
GO

CREATE PROCEDURE GetUserReservations
@user varchar(255)
AS
SELECT *
FROM Listings
WHERE user_id = @user;
GO

DECLARE @user varchar(255), @seat int, @room int, @theater varchar(255), @date date, @time varchar(255)
SELECT @user = 'John123', @seat = 2, @room = 5, @theater = 'theater 123', @date = '2020-01-10', @time = 'morning'
EXEC MakeReservation @user, @seat, @room, @theater, @date, @time

EXEC GetUserReservations @user
GO

---------------------------------------------------------------

-- I want to figure out how to get the capacity of a given room and subtract it from the number of seats taken
CREATE PROCEDURE GetNumberOfSeatsAvailable
@theater varchar(255), @room varchar(255), @date date
AS
SELECT COUNT(*)
FROM Listings L, Room R
WHERE R.number = L.room_number AND R.theater_addr = L.theater_addr AND L.theater_addr = @theater 
    AND L.room_number = @room AND L.date = @date AND L.user_id IS NULL;
GO

DECLARE @theater varchar(255), @date date, @room varchar(255)
SELECT @theater = 'Theater 1', @date = '2020-01-10', @room = 'Room 1'
EXEC GetNumberOfSeatsAvailable @theater, @date, @room