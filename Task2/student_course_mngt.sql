-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Nov 17, 2013 at 03:12 PM
-- Server version: 5.5.27
-- PHP Version: 5.4.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `student_course_mngt`
--

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE IF NOT EXISTS `branch` (
  `program` varchar(30) DEFAULT NULL,
  `name` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`name`),
  KEY `program` (`program`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `branch_assign_course`
--

CREATE TABLE IF NOT EXISTS `branch_assign_course` (
  `name` varchar(30) NOT NULL DEFAULT '',
  `code` char(6) NOT NULL DEFAULT '',
  `type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`name`,`code`),
  KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `classification`
--

CREATE TABLE IF NOT EXISTS `classification` (
  `type` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `classified`
--

CREATE TABLE IF NOT EXISTS `classified` (
  `code` char(6) NOT NULL DEFAULT '',
  `type` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`code`,`type`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE IF NOT EXISTS `course` (
  `code` char(6) NOT NULL DEFAULT '',
  `name` varchar(30) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  `dept` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `dept` (`dept`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE IF NOT EXISTS `department` (
  `name` varchar(30) NOT NULL DEFAULT '',
  `abbr` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `dept_host_program`
--

CREATE TABLE IF NOT EXISTS `dept_host_program` (
  `dept` varchar(30) NOT NULL DEFAULT '',
  `program` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`dept`,`program`),
  KEY `program` (`program`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `enrollment`
--

CREATE TABLE IF NOT EXISTS `enrollment` (
  `id` char(6) NOT NULL DEFAULT '',
  `code` char(6) NOT NULL DEFAULT '',
  `grade` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`,`code`),
  KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `prerequisite`
--

CREATE TABLE IF NOT EXISTS `prerequisite` (
  `course` char(6) NOT NULL DEFAULT '',
  `precourse` char(6) NOT NULL DEFAULT '',
  PRIMARY KEY (`course`,`precourse`),
  KEY `precourse` (`precourse`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `program`
--

CREATE TABLE IF NOT EXISTS `program` (
  `name` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `program_assign_course`
--

CREATE TABLE IF NOT EXISTS `program_assign_course` (
  `name` varchar(30) NOT NULL DEFAULT '',
  `code` char(6) NOT NULL DEFAULT '',
  `type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`name`,`code`),
  KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `register_course`
--

CREATE TABLE IF NOT EXISTS `register_course` (
  `id` char(6) NOT NULL DEFAULT '',
  `code` char(6) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`code`),
  KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `restricted_course`
--

CREATE TABLE IF NOT EXISTS `restricted_course` (
  `code` char(6) NOT NULL DEFAULT '',
  `restriction` int(11) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE IF NOT EXISTS `student` (
  `id` char(6) NOT NULL DEFAULT '',
  `name` varchar(30) DEFAULT NULL,
  `program` varchar(30) DEFAULT NULL,
  `branch` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `program` (`program`,`branch`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `waitinglist`
--

CREATE TABLE IF NOT EXISTS `waitinglist` (
  `id` char(6) NOT NULL DEFAULT '',
  `code` char(6) NOT NULL DEFAULT '',
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`,`code`),
  KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `branch`
--
ALTER TABLE `branch`
  ADD CONSTRAINT `branch_ibfk_1` FOREIGN KEY (`program`) REFERENCES `program` (`name`);

--
-- Constraints for table `branch_assign_course`
--
ALTER TABLE `branch_assign_course`
  ADD CONSTRAINT `branch_assign_course_ibfk_1` FOREIGN KEY (`name`) REFERENCES `branch` (`name`),
  ADD CONSTRAINT `branch_assign_course_ibfk_2` FOREIGN KEY (`code`) REFERENCES `course` (`code`);

--
-- Constraints for table `classified`
--
ALTER TABLE `classified`
  ADD CONSTRAINT `classified_ibfk_1` FOREIGN KEY (`code`) REFERENCES `course` (`code`),
  ADD CONSTRAINT `classified_ibfk_2` FOREIGN KEY (`type`) REFERENCES `classification` (`type`);

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_ibfk_1` FOREIGN KEY (`dept`) REFERENCES `department` (`name`);

--
-- Constraints for table `dept_host_program`
--
ALTER TABLE `dept_host_program`
  ADD CONSTRAINT `dept_host_program_ibfk_1` FOREIGN KEY (`dept`) REFERENCES `department` (`name`),
  ADD CONSTRAINT `dept_host_program_ibfk_2` FOREIGN KEY (`program`) REFERENCES `program` (`name`);

--
-- Constraints for table `enrollment`
--
ALTER TABLE `enrollment`
  ADD CONSTRAINT `enrollment_ibfk_1` FOREIGN KEY (`id`) REFERENCES `student` (`id`),
  ADD CONSTRAINT `enrollment_ibfk_2` FOREIGN KEY (`code`) REFERENCES `course` (`code`);

--
-- Constraints for table `prerequisite`
--
ALTER TABLE `prerequisite`
  ADD CONSTRAINT `prerequisite_ibfk_1` FOREIGN KEY (`course`) REFERENCES `course` (`code`),
  ADD CONSTRAINT `prerequisite_ibfk_2` FOREIGN KEY (`precourse`) REFERENCES `course` (`code`);

--
-- Constraints for table `program_assign_course`
--
ALTER TABLE `program_assign_course`
  ADD CONSTRAINT `program_assign_course_ibfk_1` FOREIGN KEY (`name`) REFERENCES `program` (`name`),
  ADD CONSTRAINT `program_assign_course_ibfk_2` FOREIGN KEY (`code`) REFERENCES `course` (`code`);

--
-- Constraints for table `register_course`
--
ALTER TABLE `register_course`
  ADD CONSTRAINT `register_course_ibfk_1` FOREIGN KEY (`id`) REFERENCES `student` (`id`),
  ADD CONSTRAINT `register_course_ibfk_2` FOREIGN KEY (`code`) REFERENCES `course` (`code`);

--
-- Constraints for table `restricted_course`
--
ALTER TABLE `restricted_course`
  ADD CONSTRAINT `restricted_course_ibfk_1` FOREIGN KEY (`code`) REFERENCES `course` (`code`);

--
-- Constraints for table `student`
--
ALTER TABLE `student`
  ADD CONSTRAINT `student_ibfk_1` FOREIGN KEY (`program`, `branch`) REFERENCES `branch` (`program`, `name`);

--
-- Constraints for table `waitinglist`
--
ALTER TABLE `waitinglist`
  ADD CONSTRAINT `waitinglist_ibfk_1` FOREIGN KEY (`id`) REFERENCES `student` (`id`),
  ADD CONSTRAINT `waitinglist_ibfk_2` FOREIGN KEY (`code`) REFERENCES `restricted_course` (`code`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
