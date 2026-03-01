-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 11, 2025 at 12:55 AM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tea9`
--

-- --------------------------------------------------------

--
-- Table structure for table `language`
--

DROP TABLE IF EXISTS `language`;
CREATE TABLE IF NOT EXISTS `language` (
  `LanguageID` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `LanguageName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`LanguageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `language`
--

INSERT INTO `language` (`LanguageID`, `LanguageName`) VALUES
('en', 'English'),
('in', 'Hindi'),
('vi', 'Vietnamese');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `ProductID` int NOT NULL AUTO_INCREMENT,
  `Price` decimal(15,2) NOT NULL,
  `Weight` decimal(6,2) DEFAULT NULL,
  `ProductCategoryID` int NOT NULL,
  PRIMARY KEY (`ProductID`),
  KEY `ProductCategoryID` (`ProductCategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`ProductID`, `Price`, `Weight`, `ProductCategoryID`) VALUES
(1, 12000000.00, 180.00, 1),
(2, 15000000.00, 200.00, 1),
(3, 10000000.00, 170.00, 1),
(4, 250000.00, 20.00, 2),
(5, 500000.00, 15.00, 2),
(6, 350000.00, 25.00, 2),
(7, 18000000.00, 2200.00, 3),
(8, 22000000.00, 2000.00, 3),
(9, 20000000.00, 2100.00, 3),
(10, 2000000.00, 0.00, 4),
(11, 1500000.00, 0.00, 4),
(12, 3000000.00, 0.00, 4),
(16, 20000000.00, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `productcategory`
--

DROP TABLE IF EXISTS `productcategory`;
CREATE TABLE IF NOT EXISTS `productcategory` (
  `ProductCategoryID` int NOT NULL AUTO_INCREMENT,
  `CanBeShipped` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ProductCategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `productcategory`
--

INSERT INTO `productcategory` (`ProductCategoryID`, `CanBeShipped`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 0);

-- --------------------------------------------------------

--
-- Table structure for table `productcategorytranslation`
--

DROP TABLE IF EXISTS `productcategorytranslation`;
CREATE TABLE IF NOT EXISTS `productcategorytranslation` (
  `ProductCategoryID` int NOT NULL,
  `LanguageID` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CategoryName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ProductCategoryID`,`LanguageID`),
  KEY `LanguageID` (`LanguageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `productcategorytranslation`
--

INSERT INTO `productcategorytranslation` (`ProductCategoryID`, `LanguageID`, `CategoryName`) VALUES
(1, 'en', 'Phones'),
(1, 'in', 'फ़ोन'),
(1, 'vi', 'Điện thoại'),
(2, 'en', 'Accessories'),
(2, 'in', 'सहायक उपकरण'),
(2, 'vi', 'Phụ kiện'),
(3, 'en', 'Laptops'),
(3, 'in', 'लैपटॉप'),
(3, 'vi', 'Laptop'),
(4, 'en', 'Software'),
(4, 'in', 'सॉफ्टवेयर'),
(4, 'vi', 'Phần mềm');

-- --------------------------------------------------------

--
-- Table structure for table `producttranslation`
--

DROP TABLE IF EXISTS `producttranslation`;
CREATE TABLE IF NOT EXISTS `producttranslation` (
  `ProductID` int NOT NULL,
  `LanguageID` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ProductName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ProductDescription` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ProductID`,`LanguageID`),
  KEY `LanguageID` (`LanguageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `producttranslation`
--

INSERT INTO `producttranslation` (`ProductID`, `LanguageID`, `ProductName`, `ProductDescription`) VALUES
(1, 'en', 'Phone A1', '6.1\" display'),
(1, 'in', 'फ़ोन A1', '6.1\" डिस्प्ले'),
(1, 'vi', 'Điện thoại A1', 'Màn hình 6.1\"'),
(2, 'en', 'Phone X2', '5000mAh battery, dual camera'),
(2, 'in', 'फ़ोन X2', '5000mAh बैटरी, डुअल कैमरा'),
(2, 'vi', 'Điện thoại X2', 'Pin 5000mAh, camera kép'),
(3, 'en', 'Phone Y3', 'Octa-core chip, 8GB RAM'),
(3, 'in', 'फ़ोन Y3', 'ऑक्टा-कोर चिप, 8GB RAM'),
(3, 'vi', 'Điện thoại Y3', 'Chip 8 nhân, RAM 8GB'),
(4, 'en', 'Headset B2', 'Bluetooth 5.0'),
(4, 'in', 'हेडसेट B2', 'Bluetooth 5.0'),
(4, 'vi', 'Tai nghe B2', 'Bluetooth 5.0'),
(5, 'en', 'Fast Charger C3', 'Supports 65W charging'),
(5, 'in', 'फास्ट चार्जर C3', '65W चार्जिंग सपोर्ट'),
(5, 'vi', 'Sạc nhanh C3', 'Hỗ trợ sạc 65W'),
(6, 'en', 'Mouse D4', 'Wireless mouse 2.4GHz'),
(6, 'in', 'माउस D4', 'वायरलेस माउस 2.4GHz'),
(6, 'vi', 'Chuột D4', 'Chuột không dây 2.4GHz'),
(7, 'en', 'Laptop L5', 'Core i5, 16GB RAM, 512GB SSD'),
(7, 'in', 'लैपटॉप L5', 'Core i5, 16GB RAM, 512GB SSD'),
(7, 'vi', 'Laptop L5', 'Core i5, 16GB RAM, SSD 512GB'),
(8, 'en', 'Laptop Pro 14', 'Core i7, 14\" Retina display'),
(8, 'in', 'लैपटॉप Pro 14', 'Core i7, 14\" Retina डिस्प्ले'),
(8, 'vi', 'Laptop Pro 14', 'Core i7, màn hình 14\" Retina'),
(9, 'en', 'Gaming Laptop Z', 'RTX 4060, 15.6\" 144Hz'),
(9, 'in', 'गेमिंग लैपटॉप Z', 'RTX 4060, 15.6\" 144Hz'),
(9, 'vi', 'Laptop Gamer Z', 'RTX 4060, màn 15.6\" 144Hz'),
(10, 'en', 'Accounting Software EBiz', 'Finance management for SMEs'),
(10, 'in', 'एकाउंटिंग सॉफ्टवेयर EBiz', 'SME के लिए वित्त प्रबंधन'),
(10, 'vi', 'Phần mềm kế toán EBiz', 'Quản lý tài chính cho SME'),
(11, 'en', 'CRM Software Pro', 'Customer management'),
(11, 'in', 'CRM सॉफ्टवेयर Pro', 'ग्राहक प्रबंधन'),
(11, 'vi', 'Phần mềm CRM Pro', 'Quản lý khách hàng'),
(12, 'en', 'HRM Software', 'Human Resource Management'),
(12, 'in', 'HRM सॉफ्टवेयर', 'मानव संसाधन प्रबंधन'),
(12, 'vi', 'Phần mềm HRM', 'Quản lý nhân sự'),
(16, 'vi', 'Sss23', '');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`ProductCategoryID`) REFERENCES `productcategory` (`ProductCategoryID`) ON DELETE CASCADE;

--
-- Constraints for table `productcategorytranslation`
--
ALTER TABLE `productcategorytranslation`
  ADD CONSTRAINT `productcategorytranslation_ibfk_1` FOREIGN KEY (`ProductCategoryID`) REFERENCES `productcategory` (`ProductCategoryID`) ON DELETE CASCADE,
  ADD CONSTRAINT `productcategorytranslation_ibfk_2` FOREIGN KEY (`LanguageID`) REFERENCES `language` (`LanguageID`) ON DELETE CASCADE;

--
-- Constraints for table `producttranslation`
--
ALTER TABLE `producttranslation`
  ADD CONSTRAINT `producttranslation_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`) ON DELETE CASCADE,
  ADD CONSTRAINT `producttranslation_ibfk_2` FOREIGN KEY (`LanguageID`) REFERENCES `language` (`LanguageID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
