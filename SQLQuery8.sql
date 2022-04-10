USE footballDB;


/*A TABLE THAT STORES ALL PLAYERS */

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
	Active VARCHAR(3) NOT NULL
);
GO


INSERT INTO Players 
VALUES ('Leon', 'Zulu', 'lz@gmail.com', '0841264875', 'RSA', '1980-01-29', 'RW', 'Left', 'Yes'),
('Peter', 'Shalulile', 'Shalu@gmail.com', '0741264845', 'MAL', '1980-08-30', 'FW', 'Right', 'Yes'),
('Melvin', 'Parker', 'mp@gmail.com', '0871264890', 'RSA', '1982-04-19', 'FW', 'Right', 'Yes'),
('Amen', 'Nkala', 'Amen@gmail.com', '0761264845', 'RSA', '1995-05-18', 'LW', 'Left', 'No'),
('Bonga', 'Dube', 'bd@gmail.com', '0671264770', 'RSA', '1984-07-19', 'RW', 'Right', 'No'),
('Andile','Dimba','ab@gmail.com', '0738584679', 'RSA','1996-09-20', 'GK', 'Right', 'Yes')

INSERT INTO Players 
VALUES ('Duncan','Zungu', 'dz@gmail.com', '0824657895', 'RSA','1982-04-04', 'LB', 'Left', 'Yes')








/*A TABLE THAT STORES TEAMS WHICH PLAYERS HAVE PLAYED OR PLAY FOR*/

CREATE TABLE Teams(
	TeamID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	TeamName VARCHAR(120) NULL,
	League VARCHAR(120) NULL
);	




INSERT INTO Teams 
VALUES ('Happy Heart', 'Vodacom challenge'),
 ('Mamelodi Sundowns', 'DSTV League'),
 ('Royal AM', 'DSTV League'),
 ('Santos', 'Glad Africa League'),
 ('Stellenbosch FC', 'DSTV League'),
 ('Steenburg Utd', 'ABC Motsepe League'),
 ('Young Africans', 'Vodacom premier League'),
 ('Blue Birds', 'Vodacom challenge')





/*A TABLE THAT STORES CONTRACT DETAILS ABOUT ALL ACTIVE PLAYERS / PLAYERS THAT ARE SIGNED.*/

CREATE TABLE ActivePlayers(
	Ac_ID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	PlayerID INT FOREIGN KEY REFERENCES Players(PlayerID),
	TeamID INT FOREIGN KEY REFERENCES Teams(TeamID),
	DateSigned DATE,
	ContractType VARCHAR(50),
	Contract_Months INT,
	Salary MONEY
);
GO


INSERT INTO ActivePlayers (PlayerID)

SELECT PlayerID
	FROM Players
	WHERE Active = 'Yes';
GO


/*
INSERT INTO ActivePlayers 
VALUES(2,2,2020,'Parent team',36, 1450000.00 ),
(3,3,2019,'Parent team',36, 120000.00 ),
(4,4,2018,'Parent team',36, 4500000.00 ),
(6,5,2022,'Loan',12, 90000.00 ),
(5,5,2022,'Loan',12, 450000.00 ),
(7,2,2021,'Parent team', 24, 100000)

GO

*/




/*A  Table to store data about all Players' statistics*/

CREATE TABLE PlayersStats(
	StatID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	PlayerID INT FOREIGN KEY REFERENCES Players(PlayerID) NOT NULL,
	MatchesPlayed SMALLINT,
	TotalMinutes INT,
	Nineties SMALLINT,
	Goals TINYINT,
	Assists SMALLINT,
	AvgDistancePerGame DECIMAL
);
GO


INSERT INTO PlayersStats (PlayerID,MatchesPlayed,TotalMinutes,Goals,Assists,AvgDistancePerGame)
VALUES (6,30,2694,2,0,1200),
(2,1,78,0,5,100),
(3,4,351,2,0,250),
(4,16,1000,0,0,700),
(5,19,1604,0,1,770)
GO

INSERT INTO PlayersStats (PlayerID,MatchesPlayed,TotalMinutes,Goals,Assists,AvgDistancePerGame)
VALUES(7,26,2338,2,1,678)
GO




/*function to calculate  number of ninety minutes each player has played*/

CREATE FUNCTION dbo.calcNineties(@TotalMinute INT)

RETURNS INT AS 
BEGIN
	RETURN @TotalMinute/90
END;
GO



/*CALLING THE UDF FUNCTION TO CALCULATE  NUMBER OF NINETY MINUTES EACH PLAYER PLAYED*/
SELECT StatID, MatchesPlayed, dbo.calcNineties(TotalMinutes) AS Nine_ties FROM PlayersStats
GO


/*  A PROCEDURE THAT UPDATES NINETY-MINUTES ATTRIBUTE ON THE STATISTICS TABLE AFTER EVERY MATCHDAY */



CREATE PROCEDURE spUpdateNineties
AS
UPDATE PlayersStats SET PlayersStats.Nineties = dbo.calcNineties(PlayersStats.TotalMinutes) 
GO

/***************** EXECUTE PROCEDURE ***************/
EXEC spUpdateNineties;
GO



/****************************************************************************************************/









/****************************************************************************************************/

/* CREATING A PROCEDURE TO UPDATE ACTIVE PLAYERS*/

CREATE PROCEDURE spUpdateContract @Player INT, @Team INT, @Date Date, @Type VARCHAR(50), @Months INT, @Salary MONEY
AS
BEGIN TRANSACTION
UPDATE ActivePlayers SET TeamID = @Team, DateSigned = @Date, ContractType = @Type, Contract_Months = @Months, Salary = @Salary
WHERE PlayerID = @Player
COMMIT

/*EXECUTE THE PROCEDURE */
EXEC spUpdateContract @Player = 3, @Team = 1, @Date = '2015', @Type = 'Loan', @Months = 24, @Salary = 245670.76
GO

/****************************************************************************************************/





CREATE VIEW view_PlayersStats
AS SELECT P.FirstName + ' ' + P.LastName AS 'Name', 