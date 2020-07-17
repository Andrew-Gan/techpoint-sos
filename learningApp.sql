DROP DATABASE IF EXISTS `learningApp` ;
CREATE DATABASE `learningApp` ;
USE `learningApp` ;

SET NAMES utf8mb4 ;
SET character_set_client = utf8mb4 ;

-- --------------------------------------------------------

--
-- Table structure for table `assignmentQuestions`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `accountID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(40) COLLATE ascii_bin NOT NULL,
  `email` varchar(30) COLLATE ascii_bin NOT NULL,
  `password` varchar(40) COLLATE ascii_bin NOT NULL,
  `major` varchar(30) COLLATE ascii_bin NULL,
  `year` varchar(10) COLLATE ascii_bin NULL,
  `college` varchar(40) COLLATE ascii_bin NULL,
  `regCourse` varchar(100) COLLATE ascii_bin NULL,
  `receivedScore` int NULL,
  `deductedScore` int NULL,
  `privilege` int NOT NULL,
  PRIMARY KEY (`accountID`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii COLLATE=ascii_bin;

INSERT INTO accounts
VALUE (NULL, 'Teacher 00', 'teacher00@purdue.edu', '123456', NULL, NULL, 'Purdue University', NULL, 0, 0, 3);

INSERT INTO accounts
VALUE (NULL, 'Student 00', 'student00@purdue.edu', '123456', 'Computer Engineering', 'Sophomore', 'Purdue University', 'ECE 20100,ECE20200', 0, 0, 4);

INSERT INTO accounts
VALUE (NULL, 'Student 01', 'student01@purdue.edu', '123456', 'Computer Engineering', 'Freshman', 'Purdue University', 'ECE 20100,', 0, 0, 4);

INSERT INTO accounts
VALUE (NULL, 'Student 02', 'student02@purdue.edu', '123456', 'Electrical Engineering', 'Freshman', 'Purdue University', 'ECE 20100,', 0, 0, 4);

-- --------------------------------------------------------

--
-- Table structure for table `assignmentQuestions`
--

CREATE TABLE IF NOT EXISTS `assignmentQuestions` (
  `assignID` int NOT NULL AUTO_INCREMENT,
  `assignTitle` varchar(30) COLLATE ascii_bin NOT NULL,
  `courseID` varchar(15) COLLATE ascii_bin NOT NULL,
  `content` varchar(200) COLLATE ascii_bin NOT NULL,
  `dueDate` int NOT NULL,
  `instrID` int NOT NULL,
  `maxScore` int NOT NULL,
  PRIMARY KEY (`assignID`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- --------------------------------------------------------

--
-- Table structure for table `assignmentSubmissions`
--

CREATE TABLE IF NOT EXISTS `assignmentSubmissions` (
  `submitID` int NOT NULL AUTO_INCREMENT,
  `courseID` varchar(15) COLLATE ascii_bin NOT NULL,
  `assignID` int NOT NULL,
  `content` varchar(200) COLLATE ascii_bin NOT NULL,
  `submitDate` int NOT NULL,
  `studentID` int NOT NULL,
  `recScore` int NOT NULL,
  `remarks` varchar(100) COLLATE ascii_bin NOT NULL,
  PRIMARY KEY (`submitID`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- --------------------------------------------------------

--
-- Table structure for table `peerReviews`
--

CREATE TABLE IF NOT EXISTS `peerReviews` (
  `peerID` int NOT NULL AUTO_INCREMENT,
  `submitID` int NOT NULL,
  `content` varchar(100) COLLATE ascii_bin NOT NULL,
  `reviewerID` int NOT NULL,
  `reviewedID` int NOT NULL,
  `instrID` int NOT NULL,
  `dueDate` int NOT NULL,
  PRIMARY KEY (`peerID`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- --------------------------------------------------------

--
-- Table structure for table `rewardsList`
--

CREATE TABLE IF NOT EXISTS `rewardsList` (
  `rewardID` int NOT NULL,
  `title` varchar(20) COLLATE ascii_bin NOT NULL,
  `desc` int NOT NULL,
  `cost` int NOT NULL,
  `hasLimit` int NOT NULL,
  `redeemLimit` int NOT NULL,
  PRIMARY KEY (`rewardID`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- --------------------------------------------------------

--
-- Table structure for table `redeemedRewards`
--

CREATE TABLE IF NOT EXISTS `redeemedRewards` (
  `redeemedRewards` int NOT NULL,
  `studentID` int NOT NULL,
  `rewardID` int NOT NULL,
  `redeemDate` int NOT NULL,
  PRIMARY KEY (`redeemedRewards`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii COLLATE=ascii_bin;
