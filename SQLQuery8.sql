USE master;

CREATE DATABASE footballAgencyDB;

USE footballAgencyDB;

CREATE TABLE Agents(
	AgentID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	AgentName VARCHAR(120),
	Email NVARCHAR(150) NULL,
	ContactNumber VARCHAR(10) NULL,
);
/*A TABLE THAT STORES ALL PLAYERS */
INSERT INTO Agents
Values('John', 'jd@gmail.com', '0746579832'),
('Siya', 'sk@yahoo.com', '0834562272'),
('Doc', 'dk@aol.com', '0112345673')


CREATE TABLE Players(
	PlayerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	LastName VARCHAR(120) NULL,
	FirstName VARCHAR(120) NULL,
	Nationality VARCHAR(3) NULL,
	DateOfBirth DATE NULL,
	Position VARCHAR(2) NULL,
	Footed VARCHAR(5) NULL,
	Active VARCHAR(3) NOT NULL,
	AgentID INT FOREIGN KEY REFERENCES Agents(AgentID)
);
GO

INSERT INTO Players 
VALUES ('Leon', 'Zulu', 'RSA', '1980-01-29', 'RW', 'Left', 'Yes',1),
('Peter', 'Shalulile', 'MAL', '1980-08-30', 'FW', 'Right', 'Yes',2),
('Melvin', 'Parker',  'RSA', '1982-04-19', 'FW', 'Right', 'Yes',2),
('Amen', 'Nkala',  'RSA', '1995-05-18', 'LW', 'Left', 'No',3),
('Bonga', 'Dube',  'RSA', '1984-07-19', 'RW', 'Right', 'No',1),
('Andile','Dimba', 'RSA','1996-09-20', 'GK', 'Right', 'Yes',2)

INSERT INTO Players 
VALUES ('Duncan','Zungu', 'RSA','1982-04-04', 'LB', 'Left', 'Yes',1)








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


SELECT *
	FROM Players
	WHERE Active = 'Yes';
GO

INSERT INTO ActivePlayers 
VALUES(2,2,'2020-05-09','Parent team',36, 1450000.00 ),
(3,3,'2019-01-30','Parent team',36, 120000.00 ),
(4,4,'2018-02-28','Parent team',36, 4500000.00 ),
(6,5,'2022-04-11','Loan',12, 90000.00 ),
(5,5,'2022-02-09','Loan',12, 450000.00 ),
(7,2,'2021-10-01','Parent team', 24, 100000)

GO






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
BEGIN TRY
	BEGIN TRANSACTION
		UPDATE ActivePlayers SET TeamID = @Team, DateSigned = @Date, ContractType = @Type, Contract_Months = @Months, Salary = @Salary
		WHERE PlayerID = @Player
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
END CATCH

/*EXECUTE THE PROCEDURE */
EXEC spUpdateContract @Player = 3, @Team = 1, @Date = '2015', @Type = 'Loan', @Months = 24, @Salary = 245670.76
GO

/****************************************************************************************************/

CREATE VIEW vPlayersStats
AS
SELECT p.FirstName + ' ' + p.LastName AS Player, p.Nationality, DATEDIFF(year,  p.DateOfBirth, GETDATE()) AS Age ,p.Position, p.Footed, p.Active, 
s.MatchesPlayed, s.TotalMinutes, s.Nineties, s.Goals, s.Assists, s.AvgDistancePerGame, a.AgentName
FROM Players p
INNER JOIN PlayersStats s ON p.PlayerID = s.PlayerID
INNER JOIN Agents a ON  p.AgentID = a.AgentID

CREATE TABLE TransferHistory(
	TransferID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	PlayerID INT FOREIGN KEY REFERENCES Players(PlayerID),
	Primary_TeamID INT FOREIGN KEY REFERENCES Teams(TeamID),
	Secondary_TeamID INT FOREIGN KEY REFERENCES Teams(TeamID),
	TransferDate DATE
);


