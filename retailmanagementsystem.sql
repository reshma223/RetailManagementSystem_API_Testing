-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 10, 2025 at 07:07 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `retailmanagementsystem`
--

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `first_name`, `last_name`, `email`, `phone`, `address`) VALUES
(1, 'Sita', 'Shrestha', 'sita@example.com', '9800000001', 'Kathmandu, Nepal'),
(2, 'Hari', 'Lama', 'hari@example.com', '9800000002', 'Bhaktapur, Nepal'),
(3, 'Ram', 'Gurung', 'ram@example.com', '9800000003', 'Pokhara, Nepal'),
(4, 'Gita', 'Magar', 'gita@example.com', '9800000004', 'Lalitpur, Nepal'),
(5, 'Kiran', 'Tamang', 'kiran@example.com', '9800000005', 'Biratnagar, Nepal');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_transactions`
--

CREATE TABLE `inventory_transactions` (
  `transaction_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `transaction_type` enum('Sale','Restock','Return','Adjustment') NOT NULL,
  `quantity` int(11) NOT NULL,
  `transaction_date` datetime DEFAULT current_timestamp(),
  `reference_sale_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_transactions`
--

INSERT INTO `inventory_transactions` (`transaction_id`, `product_id`, `transaction_type`, `quantity`, `transaction_date`, `reference_sale_id`) VALUES
(1, 1, 'Sale', 10, '2024-11-01 10:00:00', 1),
(2, 2, 'Restock', 20, '2024-11-02 08:30:00', NULL),
(3, 3, 'Return', 5, '2024-11-03 12:00:00', 3),
(4, 4, 'Adjustment', -2, '2024-11-04 14:45:00', NULL),
(5, 5, 'Sale', 15, '2024-11-05 16:00:00', 5);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `order_status` enum('Pending','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
  `order_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customer_id`, `total_amount`, `order_status`, `order_date`) VALUES
(1, 1, 40.00, 'Shipped', '2024-11-01 09:30:00'),
(2, 2, 25.90, 'Delivered', '2024-11-02 13:45:00'),
(3, 3, 75.00, 'Pending', '2024-11-03 11:15:00'),
(4, 4, 15.00, 'Cancelled', '2024-11-04 10:20:00'),
(5, 5, 32.50, 'Shipped', '2024-11-05 15:55:00');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `sale_id` int(11) NOT NULL,
  `payment_method` enum('Cash','Online') NOT NULL,
  `payment_date` datetime DEFAULT current_timestamp(),
  `amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `sale_id`, `payment_method`, `payment_date`, `amount`) VALUES
(1, 1, 'Cash', '2024-11-01 10:05:00', 40.00),
(2, 2, 'Online', '2024-11-02 14:35:00', 25.99),
(3, 3, 'Cash', '2024-11-03 12:50:00', 75.00),
(4, 4, 'Cash', '2024-11-04 11:25:00', 15.00),
(5, 5, 'Online', '2024-11-05 16:20:00', 32.50);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int(11) NOT NULL,
  `status` enum('Available','Out of Stock','Discontinued') DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `name`, `price`, `stock_quantity`, `status`) VALUES
(1, 'Box', 18.00, 15, 'Available'),
(2, 'Shampoo', 6.59, 50, 'Available'),
(3, 'Notebook', 2.75, 200, 'Available'),
(4, 'Soap', 1.65, 300, 'Available'),
(5, 'Wine', 16.50, 0, 'Out of Stock'),
(7, 'Egg', 15.50, 20, 'Available'),
(8, 'Mouse', 18.00, 15, 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `sale_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_status` enum('Paid','Pending','Refunded') DEFAULT 'Paid',
  `sale_date` datetime DEFAULT current_timestamp(),
  `salesperson_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`sale_id`, `customer_id`, `total_amount`, `payment_status`, `sale_date`, `salesperson_id`) VALUES
(1, 1, 40.00, 'Paid', '2024-11-01 10:00:00', 101),
(2, 2, 25.99, 'Paid', '2024-11-02 14:30:00', 102),
(3, 3, 75.00, 'Pending', '2024-11-03 12:45:00', 103),
(4, 4, 15.00, 'Refunded', '2024-11-04 11:20:00', 104),
(5, 5, 32.50, 'Paid', '2024-11-05 16:15:00', 101),
(6, 6, 150.00, 'Paid', '2024-11-13 10:00:00', 2),
(8, 7, 150.00, 'Paid', '2024-11-13 10:00:00', 2);

-- --------------------------------------------------------

--
-- Table structure for table `shipping`
--

CREATE TABLE `shipping` (
  `shipping_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `shipping_address` text NOT NULL,
  `courier_name` varchar(100) DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `shipping_status` enum('Pending','Shipped','Delivered') DEFAULT 'Pending',
  `shipment_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shipping`
--

INSERT INTO `shipping` (`shipping_id`, `order_id`, `shipping_address`, `courier_name`, `tracking_number`, `shipping_status`, `shipment_date`) VALUES
(1, 1, 'Kathmandu', 'Nepal Courier', 'NC12345', 'Shipped', '2024-11-01 14:00:00'),
(2, 2, 'Bhaktapur', 'Nepal Courier', 'NC12346', 'Delivered', '2024-11-02 18:30:00'),
(3, 3, 'Pokhara', 'Nepal Courier', 'NC12347', 'Pending', NULL),
(4, 4, 'Lalitpur', 'Nepal Courier', 'NC12348', '', NULL),
(5, 5, 'Biratnagar', 'Nepal Courier', 'NC12349', 'Shipped', '2024-11-05 17:30:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD PRIMARY KEY (`transaction_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`sale_id`);

--
-- Indexes for table `shipping`
--
ALTER TABLE `shipping`
  ADD PRIMARY KEY (`shipping_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `sale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `shipping`
--
ALTER TABLE `shipping`
  MODIFY `shipping_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
