USE master
GO

IF NOT EXISTS(SELECT * sys.databases WHERE name='footballAgencyDB_BBD_')
  BEGIN
    CREATE DATABASE footballAgencyDB_BBD_;
 END;
GO


USE footballAgencyDB_BBD_;
GO





--**************************************************************************************************************************************


-- CREATE TABLES

/*This query creates a tables of all the agents for the players*/
CREATE TABLE Agents(
	AgentID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	AgentName VARCHAR(120)NOT NULL,
	Email NVARCHAR(150) NOT NULL,
	ContactNumber VARCHAR(10) NOT NULL,
);
GO

/*This query creates a table for a player record*/
CREATE TABLE Players(
	PlayerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	FirstName VARCHAR(120) NOT NULL,
	LastName VARCHAR(120) NOT NULL,
	Nationality VARCHAR(3) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Position VARCHAR(2) NOT NULL,
	Footed VARCHAR(5) NOT NULL,
	Active BIT NOT NULL,  
	AgentID INT NOT NULL

	CONSTRAINT fk_AgentID FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);
GO

/*A TABLE THAT STORES TEAMS WHICH PLAYERS HAVE PLAYED OR PLAY FOR*/

CREATE TABLE Teams(
	TeamID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	TeamName VARCHAR(120) NOT NULL,
	LeagueID INT,

	CONSTRAINT fk_LeagueID FOREIGN KEY (LeagueID) REFERENCES League(LeagueID)
	
);	
GO

CREATE TABLE League(
    LeagueID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	LeagueName  VARCHAR(120) NOT NULL
);

ALTER TABLE Teams
ADD CONSTRAINT uc_Teams UNIQUE(TeamName);
GO


/*A TABLE THAT STORES CONTRACT DETAILS ABOUT ALL ACTIVE PLAYERS / PLAYERS THAT ARE SIGNED.*/

CREATE TABLE ActivePlayers(
	Ac_ID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	DateSigned DATE NOT NULL,
	periodSigned INT NOT NULL,
	Salary MONEY NOT NULL,

	contractID INT NOT NULL, 
	PlayerID INT NOT NULL,
	TeamID INT NOT NULL,

	CONSTRAINT fk_contractID FOREIGN KEY (contractID) REFERENCES ContractType(contractID)  ,
	CONSTRAINT fk_playerID  FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
	CONSTRAINT fk_teamID  FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
GO


ALTER TABLE ActivePlayers
ADD CONSTRAINT uc_ActivePlyrs UNIQUE (PlayerID);
GO


CREATE TABLE ContractType
 ( 
	contractID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	typeOfContract VARCHAR(50) NOT NULL,

);

CREATE TABLE PlayerTransferHistory(
	TransferID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	PlayerID INT FOREIGN KEY REFERENCES Players(PlayerID) NOT NULL,
	Primary_TeamID INT FOREIGN KEY REFERENCES Teams(TeamID) NOT NULL,
	Secondary_TeamID INT FOREIGN KEY REFERENCES Teams(TeamID) NOT NULL,
	TransferDate DATE NOT NULL
);
GO

CREATE TABLE PlayersStats(
	StatID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	PlayerID INT FOREIGN KEY REFERENCES Players(PlayerID) NOT NULL,
	MatchesPlayed SMALLINT NOT NULL,
	TotalMinutes INT NOT NULL,
	Nineties SMALLINT NOT NULL,
	Goals TINYINT NOT NULL,
	Assists SMALLINT NOT NULL
);
GO




--**************************************************************************************************************************************



--2. INSERT INTO TABLES
--=======================

/*This query insert data into agents table*/
INSERT INTO Agents
Values('NFL', 'jd@gmail.com', '0746579832'),
('TTD', 'sk@yahoo.com', '0834562272'),
('Doc', 'dk@aol.com', '0112345673')
GO


/*This query insert data into Player table*/
INSERT INTO Players 
VALUES ('Leon', 'Zulu', 'RSA', '1980-01-29', 'RW', 'Left', 'Yes',1),
('Peter', 'Shalulile', 'MAL', '1980-08-30', 'FW', 'Right', 'Yes',2),
('Melvin', 'Parker',  'RSA', '1982-04-19', 'FW', 'Right', 'Yes',2),
('Amen', 'Nkala',  'RSA', '1995-05-18', 'LW', 'Left', 'No',3),
('Bonga', 'Dube',  'RSA', '1984-07-19', 'RW', 'Right', 'No',1),
('Andile','Dimba', 'RSA','1996-09-20', 'GK', 'Right', 'Yes',2),
('Duncan','Zungu', 'RSA','1982-04-04', 'LB', 'Left', 'Yes',1)

INSERT INTO Teams 
VALUES ('Happy Heart', 'Vodacom challenge'),
 ('Mamelodi Sundowns', 'DSTV League'),
 ('Royal AM', 'DSTV League'),
 ('Santos', 'Glad Africa League'),
 ('Stellenbosch FC', 'DSTV League'),
 ('Steenburg Utd', 'ABC Motsepe League'),
 ('Young Africans', 'Vodacom premier League'),
 ('Blue Birds', 'Vodacom challenge')

 INSERT INTO ActivePlayers (PlayerID, TeamID, DateSigned, ContractType, Contract_Months, Salary)
VALUES(2,2,'2020-05-09','Parent team',36, 1450000.00 ),
(3,3,'2019-01-30','Parent team',36, 120000.00 ),
(5,5,'2022-02-09','Loan',12, 450000.00 ),
(7,2,'2021-10-01','Parent team', 24, 100000)

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


--**************************************************************************************************************************************






/*VIEW UNSIGNED PLAYERS*/
SELECT *
	FROM Players
	WHERE Active = 'Yes';
GO



--**************************************************************************************************************************************


--STORED PROCEDURES
--===================


CREATE OR ALTER PROCEDURE spUpdateContractExpiry
AS
UPDATE ActivePlayers SET ActivePlayers.Contract_ExpDate = dbo.calc_ContractExpDate( ActivePlayers.DateSigned, ActivePlayers.Contract_Months) 
GO

/***************** EXECUTE PROCEDURE ***************/
EXEC spUpdateContractExpiry;
GO


/*  A PROCEDURE THAT UPDATES NINETY-MINUTES ATTRIBUTE ON THE STATISTICS TABLE AFTER EVERY MATCHDAY */
CREATE OR ALTER PROCEDURE spUpdateNineties
AS
UPDATE PlayersStats SET PlayersStats.Nineties = dbo.calcNineties(PlayersStats.TotalMinutes) 
GO

/***************** EXECUTE PROCEDURE ***************/
EXEC spUpdateNineties;
GO




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




/*Procedure to update transfer of players*/
CREATE PROCEDURE spUpdateTransferHistory
AS
BEGIN 

	INSERT INTO PlayerTransferHistory
	VALUES(
	2, 1, 5, GETDATE())

END ;
GO

/*Execute the Procedure*/
EXEC spUpdateTransferHistory;
GO



--**************************************************************************************************************************************



-- FUNCTIONS
--=============


CREATE OR ALTER FUNCTION dbo.calc_ContractExpDate( @DateSigned DATE, @Contract_Months INT)

RETURNS DATE AS 
BEGIN
	RETURN  DATEADD(MONTH, @Contract_Months, @DateSigned)  
END;
GO

--==================================================================================--



/*function to calculate  number of ninety minutes each player has played*/
CREATE OR ALTER FUNCTION dbo.calcNineties(@TotalMinute INT)

RETURNS INT AS 
BEGIN
	RETURN @TotalMinute/90
END;
GO

/*CALLING THE UDF FUNCTION TO CALCULATE  NUMBER OF NINETY MINUTES EACH PLAYER PLAYED*/
SELECT StatID, MatchesPlayed, dbo.calcNineties(TotalMinutes) AS Nine_ties FROM PlayersStats
GO





/*********************************************************************************************************************************************/

--VIEWS
--=======

CREATE OR ALTER VIEW vPlayersStats
AS
SELECT p.FirstName + ' ' + p.LastName AS Player, p.Nationality, DATEDIFF(year,  p.DateOfBirth, GETDATE()) AS Age ,p.Position, p.Footed,
 p.Active, s.MatchesPlayed, s.TotalMinutes, s.Nineties, s.Goals, s.Assists, s.AvgDistancePerGame, a.AgentName
FROM Players p
FULL OUTER JOIN PlayersStats s ON p.PlayerID = s.PlayerID
FULL OUTER JOIN Agents a ON  p.AgentID = a.AgentID
ORDER BY p.FirstName OFFSET 0 ROWS;
GO

--=========================================================================--


/*A VIEW THAT WILL SHOW ALL PLAYERS WHICH ARE NOT SIGNED*/
CREATE OR ALTER VIEW vUnSignedPlayers
AS
SELECT   p.FirstName + ' ' + p.LastName AS Player, p.Nationality, DATEDIFF(year,  p.DateOfBirth, GETDATE()) AS Age ,p.Position, p.Footed, 
s.MatchesPlayed, s.TotalMinutes, s.Nineties, s.Goals, s.Assists, s.AvgDistancePerGame, a.AgentName
FROM Players p 
LEFT JOIN PlayersStats s ON p.PlayerID = s.PlayerID 
LEFT JOIN Agents a ON  p.AgentID = a.AgentID
WHERE p.Active = 'No'

GO

/****************************************************************************************************/


--TRANSACTIONS
--===========




CREATE PROCEDURE sptransferPlayer @Player INT, @Team INT, @Date Date, @Type INT, @Months INT, @Salary MONEY
AS
BEGIN TRY
	BEGIN TRANSACTION
		
		UPDATE ActivePlayers
		SET TeamID = @Team,
				 DateSigned = @Date ,
				 contractID = @Type,
				 periodSigned = @Months,
				 Salary = @Salary
		WHERE PlayerID = @player


		INSERT INTO PlayerTransferHistory
		VALUES(
		@Player , @Primary_TeamID, @Secondary_TeamID , @Date  );

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
END CATCH




