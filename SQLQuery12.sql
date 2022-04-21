USE master
GO

CREATE DATABASE dell_DBmyDB;
GO


USE dell_DBmyDB;
GO





--**************************************************************************************************************************************


-- CREATE TABLES

/*This query creates a tables of all the agents for the players*/


--AGENTS LOGIN DETAILS=====ENTRY POINT




CREATE TABLE Agencies(

	Agency_ID INT IDENTITY(100,1) PRIMARY KEY NOT NULL,
	AgencyName VARCHAR(120)NOT NULL,
	Physical_Address VARCHAR(250)NOT NULL,
	Contact_Number VARCHAR(10) NOT NULL,
	Email_address VARCHAR(100) NOT NULL,

	CONSTRAINT u_name UNIQUE (AgencyName)
);


INSERT  INTO Agencies
VALUES('DMT Sporting', '917 Grunter rd, Hatfield', '0127549968','info@dmtsporting.co.za'),
('Total Sporting','1192, Elukwatini', '0137552968','info@TotalSporting.co.za'),
('Spurs MP','2356, Oshoek', '0137592123','info@SpursMP.co.za')
GO

--***************************************************************************************************************





CREATE TABLE Agents(
	AgentID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(120)NOT NULL,
	LastName  VARCHAR(120)NOT NULL,
	Physical_Address VARCHAR(250)NOT NULL,
	Email_address NVARCHAR(150) NOT NULL,
	ContactNumber VARCHAR(10) NOT NULL,
	Agency_ID INT NOT NULL

	CONSTRAINT fk_agencyID FOREIGN KEY (Agency_ID) REFERENCES Agencies(Agency_ID)
);
INSERT INTO Agents
Values('Hlubi ','Nkosi', '667 Litjelembube', 'jd@gmail.com', '0746579832',100),
('Lihle ','Dhludhlu', '128 Glenmore, Dundonald', 'jd@gmail.com', '0746579832',101),
('Temazomba ','Dube', '2890 Mpuluzi, Mayflower', 'jd@gmail.com', '0746579832',102)


--*************************************************************************************************************


CREATE TABLE FootType(
   FootID int identity(1,1) PRIMARY KEY NOT NULL,
   NameFoot Varchar(5)

   CONSTRAINT u_foot UNIQUE (NameFoot)
);

INSERT INTO FootType
VALUES
('LEFT'),
('RIGHT')



--***************************************************************************************************************




CREATE TABLE Activity_Status(
	ActiveID INT IDENTITY(0,1) PRIMARY KEY NOT NULL,
	ActivityState BIT NOT NULL,
	ActivityStateDescr VARCHAR(10) NOT NULL,


	CONSTRAINT u_active UNIQUE (ActivityState),
	CONSTRAINT u_activeDescr UNIQUE (ActivityStateDescr)
);


INSERT INTO Activity_Status
VALUES
(0, 'NOT ACTIVE'),
(1, 'ACTIVE');
GO

--***************************************************************************************************************




CREATE TABLE Positions(
	 PositionID INT IDENTITY(1,1) primary key NOT NULL,
	 PositionName VARCHAR(60) NOT NULL,
	 positionNumber VARCHAR(2) NOT NULL

	 CONSTRAINT u_PositionName UNIQUE (PositionName),
	 CONSTRAINT u_PositionNumber UNIQUE (positionNumber)
);


INSERT INTO Positions
VALUES
('Goalkeeper', 1),
('Striker', 11),
('Mid Defender', 5),
('front Defender',6),
('Right back', 2),
('Left Back', 3),
('Middle Fielder', 9),
('Left Wing', 8),
('Right Wing',10),
('Defensive MidField', 4),
('Attacking MidField',7)
;
GO

--***************************************************************************************************************





CREATE TABLE Players(
	PlayerID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(120) NOT NULL,
	LastName VARCHAR(120) NOT NULL,
	Nationality VARCHAR(3) NOT NULL,
	DateOfBirth DATE NOT NULL,

	PositionID INT NOT NULL,
	ActiveID INT NOT NULL,  
	AgentID INT NOT NULL,
	FootID INT NOT NULL,

	CONSTRAINT fk_position FOREIGN KEY (positionID) REFERENCES Positions(positionID),
	CONSTRAINT fk_ActiveID FOREIGN KEY (ActiveID) REFERENCES Activity_Status(ActiveID),
	CONSTRAINT fk_AgentID FOREIGN KEY (AgentID) REFERENCES Agents(AgentID),
	CONSTRAINT fk_footID FOREIGN KEY (FootID) REFERENCES FootType(FootID)
);
GO


INSERT INTO Players 
VALUES ('Leon', 'Zulu', 'RSA', '1980-01-29',1, 0, 3,1),
('Peter', 'Shalulile', 'MAL', '1980-08-30',2, 1, 1,2),
('Melvin', 'Parker',  'RSA', '1982-04-19',3, 1, 3,2),
('Amen', 'Nkala',  'RSA', '1995-05-18',4, 0, 1,2),
('Bonga', 'Dube',  'RSA', '1984-07-19',5, 1, 2,1);
GO

--***************************************************************************************************************




CREATE TABLE League(
    LeagueID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	LeagueName  VARCHAR(120) NOT NULL,

	CONSTRAINT u_league UNIQUE (LeagueName)
);



INSERT INTO League
VALUES 
('DSTV League'),
('Glad Africa Championship'),
('ABC Motsepe League'),
('Vodacom League'),
('Vodacom Challenge')
--***********************************************************************************************






CREATE TABLE Teams(
	TeamID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	TeamName VARCHAR(120) NOT NULL,
	LeagueID INT,

	CONSTRAINT fk_LeagueID FOREIGN KEY (LeagueID) REFERENCES League(LeagueID),
	CONSTRAINT uc_Teams UNIQUE(TeamName)
);	


INSERT INTO Teams 
VALUES ('Happy Heart', 4),
 ('Mamelodi Sundowns', 1),
 ('Royal AM', 1),
 ('Santos', 2),
 ('Stellenbosch FC', 1),
 ('Steenburg Utd', 3),
 ('Young Africans', 5),
 ('Blue Birds', 4)


 
--***********************************************************************************************




CREATE TABLE ContractType
 ( 
	ContractID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	TypeOfContract VARCHAR(50) NOT NULL,

	CONSTRAINT u_contract UNIQUE (TypeOfContract)
);


INSERT INTO ContractType
VALUES
('PARENT TEAM'),
('ON LOAN');
GO


--***********************************************************************************************


CREATE TABLE ActivePlayers(
	Ac_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	DateSigned DATE NOT NULL,
	PeriodSigned INT NOT NULL,
	Salary MONEY NOT NULL,

	ContractID INT NOT NULL, 
	PlayerID INT NOT NULL,
	TeamID INT NOT NULL,

	CONSTRAINT fk_contractID FOREIGN KEY (ContractID) REFERENCES ContractType(ContractID)  ,
	CONSTRAINT fk_playerID  FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
	CONSTRAINT fk_teamID  FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);



INSERT INTO ActivePlayers (DateSigned, PeriodSigned, Salary, ContractID, PlayerID, TeamID)
VALUES('2021-01-05',36,145000.00, 1, 5, 2),
( '2020-12-01',12,100000.00, 2, 5, 2 ),
('2020-06-10',36,145000.00, 1, 5, 2),
('2022-01-05',24,145000.00, 1, 5, 2)


--***********************************************************************************************



CREATE TABLE previousTeam(
prevTeamID INT IDENTITY(1,1) PRIMARY KEY,	
PlayerID INT NOT NULL,
TeamID INT NOT NULL,


CONSTRAINT fk_playerID1 FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
CONSTRAINT fk_teamID1 FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
) ;



CREATE TABLE currentTeam(
currentTeamID INT IDENTITY(1,1) PRIMARY KEY,
PlayerID INT NOT NULL,
TeamID INT NOT NULL,

CONSTRAINT fk_playerID2 FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
CONSTRAINT fk_teamID2 FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
) ;


INSERT INTO previousTeam
VALUES(3,3);

INSERT INTO currentTeam
VALUES(3,4);


--**************************************************************************************************************************************





CREATE TABLE PlayerTransferHistory(
	TransferID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	prevTeamID INT NOT NULL,
	currentTeamID INT NOT NULL,
	TransferDate DATE NOT NULL


	CONSTRAINT fk_prevTeam FOREIGN KEY (prevTeamID) REFERENCES  previousTeam(prevTeamID),
	CONSTRAINT fk_currentTeam FOREIGN KEY (currentTeamID) REFERENCES  currentTeam(currentTeamID)
);
GO


INSERT INTO PlayerTransferHistory(prevTeamID, currentTeamID, TransferDate)
VALUES(1, 2, '2022-01-06'),
(2, 3, '2022-01-06');

--**************************************************************************************************************************************


CREATE TABLE PlayersStats(
	StatID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	MatchesPlayed SMALLINT NOT NULL,
	TotalMinutes INT NOT NULL,
	Goals TINYINT NOT NULL,
	Assists SMALLINT NOT NULL,

	PlayerID INT NOT NULL,

	CONSTRAINT fk_PlayerIDTTY FOREIGN KEY(PlayerID) REFERENCES Players(PlayerID)

);
GO


INSERT INTO PlayersStats (MatchesPlayed,TotalMinutes,Goals,Assists,PlayerID)
VALUES
(7, 2338, 2, 1, 1),
(7, 2345, 21, 3, 2 ),
(7, 2338, 2, 1, 3),
(7, 2345, 21, 3, 4),
(7, 2338, 2, 1, 5)

GO


