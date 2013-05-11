-- phpMyAdmin SQL Dump
-- version 3.5.8.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 11, 2013 at 02:48 PM
-- Server version: 5.5.31-0ubuntu0.13.04.1
-- PHP Version: 5.4.9-4ubuntu2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `strojno`
--

-- --------------------------------------------------------

--
-- Table structure for table `tablice`
--

CREATE TABLE IF NOT EXISTS `tablice` (
  `id` int(11) NOT NULL,
  `extension` varchar(255) NOT NULL,
  `opis` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tablice`
--

INSERT INTO `tablice` (`id`, `extension`, `opis`) VALUES
(1, 'jpg', 'ispravna'),
(2, 'jpg', 'ispravna'),
(3, 'jpg', 'ispravna'),
(4, 'jpg', 'ispravna'),
(5, 'jpg', 'ispravna'),
(6, 'jpg', 'ispravna'),
(7, 'jpg', 'ispravna'),
(8, 'jpg', 'ispravna'),
(9, 'jpg', 'ispravna'),
(10, 'jpg', 'ispravna'),
(11, 'jpg', 'ispravna'),
(12, 'jpg', 'ispravna'),
(13, 'jpg', 'ispravna'),
(14, 'jpg', 'ispravna'),
(15, 'jpg', 'ispravna'),
(16, 'jpg', 'ispravna'),
(17, 'jpg', 'ispravna'),
(18, 'jpg', 'ispravna'),
(19, 'jpg', 'ispravna'),
(20, 'jpg', 'ispravna'),
(21, 'jpg', 'ispravna'),
(22, 'jpg', 'ispravna'),
(23, 'jpg', 'ispravna'),
(24, 'jpg', 'ispravna'),
(25, 'jpg', 'ispravna'),
(26, 'jpg', 'ispravna'),
(27, 'jpg', 'ispravna'),
(28, 'jpg', 'ispravna'),
(29, 'jpg', 'neispravna'),
(30, 'jpg', 'neispravan'),
(31, 'jpg', 'neispravna'),
(32, 'jpg', 'ispravna'),
(33, 'jpg', 'ispravna'),
(34, 'jpg', 'ispravna'),
(35, 'jpg', 'ispravna'),
(36, 'jpg', 'ispravna'),
(37, 'jpg', 'ispravna'),
(38, 'jpg', 'ispravna'),
(39, 'jpg', 'ispravna'),
(40, 'jpg', 'ispravna'),
(41, 'jpg', 'ispravna'),
(42, 'jpg', 'ispravna'),
(43, 'jpg', 'ispravna'),
(44, 'jpg', 'ispravna'),
(45, 'jpg', 'ispravna'),
(46, 'jpg', 'ispravna'),
(47, 'jpg', 'ispravna'),
(48, 'jpg', 'ispravna'),
(49, 'jpg', 'ispravna'),
(50, 'jpg', 'ispravna'),
(51, 'jpg', 'ispravna'),
(52, 'jpg', 'neispravna'),
(53, 'jpg', 'neispravan'),
(54, 'jpg', 'neispravna'),
(55, 'jpg', 'neispravan'),
(56, 'jpg', 'neispravna'),
(57, 'jpg', 'neispravan'),
(58, 'jpg', 'neispravna'),
(59, 'jpg', 'neispravan'),
(60, 'jpg', 'neispravna'),
(61, 'jpg', 'neispravan'),
(62, 'jpg', 'neispravna'),
(63, 'jpg', 'neispravan'),
(64, 'jpg', 'neispravna'),
(65, 'jpg', 'neispravan'),
(66, 'jpg', 'neispravna'),
(67, 'jpg', 'neispravan'),
(68, 'jpg', 'neispravna'),
(69, 'jpg', 'neispravan'),
(70, 'jpg', 'neispravna'),
(71, 'jpg', 'neispravan'),
(72, 'jpg', 'neispravna');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
