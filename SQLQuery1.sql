USE master;
GO

CREATE DATABASE SAFootballStats;
GO

USE SAFootballStats;

CREATE TABLE Players(
	PlayerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	LastName VARCHAR(120) NULL,
	FirstName VARCHAR(120) NULL,
	Email NVARCHAR(150) NULL,
	ContactNumber VARCHAR(10) NULL,
	Nationality VARCHAR(3) NULL,
	DateOfBirth DATE NULL,
	Position VARCHAR(2) NULL,
	Footed VARCHAR(5) NULL,
	Active VARCHAR NOT NULL
);

INSERT INTO Players 
VALUES ('Leon', 'Zulu', 'lz@gmail.com', '0841264875', 'RSA', '1980-01-29', 'RW', 'Left'),
('Peter', 'Shalulile', 'Shalu@gmail.com', '0741264845', 'MAL', '1980-08-30', 'FW', 'Right'),
('Melvin', 'Parker', 'mp@gmail.com', '0871264890', 'RSA', '1982-04-19', 'FW', 'Right'),
('Amen', 'Nkala', 'Amen@gmail.com', '0761264845', 'RSA', '1995-05-18', 'LW', 'Left'),
('Bonga', 'Dube', 'bd@gmail.com', '0671264770', 'RSA', '1984-07-19', 'RW', 'Right'),
('Andile','Dimba','ab@gmail.com', '0738584679', 'RSA','1996-09-20', 'GK', 'Right')

INSERT INTO Players 
VALUES ('Duncan','Zungu', 'dz@gmail.com', '0824657895', 'RSA','1982-04-04', 'LB', 'Left')


ALTER TABLE Players
ADD Active VARCHAR(3) NULL;

CREATE TABLE Teams(
	TeamID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	TeamName VARCHAR(120) NULL,
	League VARCHAR(120) NULL
);	

INSERT INTO Teams 
VALUES ('Happy Heart', 'Vodacom challenge')


CREATE TABLE PlayersTeams(
	PS_ID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	PlayerID INT FOREIGN KEY REFERENCES Players(PlayerID),
	TeamID INT FOREIGN KEY REFERENCES Teams(TeamID),
	DateSigned DATE,
	ContractType VARCHAR(50),
	Contract_Months INT,
	Salary MONEY
);

ALTER TABLE PlayersTeams
ADD PS_ID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL


INSERT INTO PlayersTeams 
VALUES(2,2,2020,'Parent team',36, 1450000.00 ),
(3,3,2019,'Parent team',36, 120000.00 ),
(4,4,2018,'Parent team',36, 4500000.00 ),
(6,5,2022,'Loan',12, 90000.00 ),
(5,5,2022,'Loan',12, 450000.00 ),
(7,2,2021,'Parent team', 24, 100000)

INSERT INTO PlayersTeams (PlayerID)
VALUES(8)

CREATE TABLE Statistic(
	StatID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	PlayerID INT FOREIGN KEY REFERENCES Players(PlayerID) NOT NULL,
	MatchesPlayed SMALLINT,
	TotalMinutes INT,
	Nineties SMALLINT,
	Goals TINYINT,
	Assists SMALLINT,
	AvgDistancePerGame DECIMAL,
);



CREATE OR ALTER FUNCTION dbo.calcNineties(@TotalMinute INT)

RETURNS INT AS 
BEGIN
	RETURN @TotalMinute/90
END;

USE SAFootballStats;

SELECT StatID, MatchesPlayed, dbo.calcNineties(TotalMinutes) AS Nine_ties FROM Statistic

INSERT INTO Statistic (PlayerID,MatchesPlayed,TotalMinutes,Goals,Assists,AvgDistancePerGame)
VALUES (6,30,2694,2,0,1200),
(2,1,78,0,5,100),
(3,4,351,2,0,250),
(4,16,1000,0,0,700),
(5,19,1604,0,1,770)
INSERT INTO Statistic (PlayerID,MatchesPlayed,TotalMinutes,Goals,Assists,AvgDistancePerGame)
VALUES(7,26,2338,2,1,678)

CREATE PROCEDURE spUpdateNineties
AS
UPDATE Statistic SET Statistic.Nineties = dbo.calcNineties(Statistic.TotalMinutes) 

EXEC spUpdateNineties;

CREATE PROCEDURE spUpdateContract @Player INT, @Team INT, @Date Date, @Type VARCHAR(50), @Months INT, @Salary MONEY
AS
BEGIN TRANSACTION
UPDATE PlayersTeams SET TeamID = @Team, DateSigned = @Date, ContractType = @Type, Contract_Months = @Months, Salary = @Salary
WHERE PlayerID = @Player
COMMIT

EXEC spUpdateContract @Player = 3, @Team = 1, @Date = '2015', @Type = 'Loan', @Months = 24, @Salary = 245670.76

CREATE VIEW vPlayersStats
AS SELECT P.FirstName + ' ' + P.LastName AS 'Name', 
