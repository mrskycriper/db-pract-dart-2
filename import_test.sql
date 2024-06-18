CREATE DATABASE lab_2 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE lab_2;

CREATE TABLE `Individuals` (
  `id` int AUTO_INCREMENT PRIMARY KEY,
  `first_name` tinytext NOT NULL,
  `last_name` tinytext NOT NULL,
  `middle_name` tinytext,
  `passport` tinytext NOT NULL,
  `tax_id` tinytext,
  `isurance_id` tinytext,
  `drivers_license` tinytext,
  `additional_documents` text,
  `notes` text,
  `borrower_id` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `Loans` (
  `id` int AUTO_INCREMENT PRIMARY KEY,
  `individual_id` int NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `due_date` date NOT NULL,
  `conditions` text NOT NULL,
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `OrganizationLoans` (
  `id` int PRIMARY KEY,
  `organization_id` int NOT NULL,
  `individual_id` int NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `due_date` date NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `conditions` text NOT NULL,
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `Loans`ADD FOREIGN KEY (`individual_id`) REFERENCES `Individuals` (`id`);

ALTER TABLE `OrganizationLoans` ADD FOREIGN KEY (`individual_id`) REFERENCES `Individuals` (`id`);

INSERT INTO Individuals (last_name, first_name, middle_name, passport, tax_id, isurance_id, drivers_license, additional_documents, notes)
VALUES
('Ivanov', 'Ivan', 'Ivanovich', '4510123456', '770123456789', '12345678901', '5012345678', 'Passport copy, lease agreement', 'Excellent client with good credit history'),
('Petrova', 'Anna', 'Sergeevna', '4510234567', '780234567890', '23456789012', '5012346789', 'Passport copy, income statement', 'Regular client, always pays on time'),
('Sidorova', 'Maria', 'Alexandrovna', '4510345678', '773456789012', '34567890123', '5012347890', 'Passport copy, employment contract', 'New client, additional verification required'),
('Kuznetsov', 'Dmitry', 'Petrovich', '4510456789', '774567890123', '45678901234', '5012348901', 'Passport copy, bank statement', 'High-income client'),
('Smirnova', 'Ekaterina', 'Vladimirovna', '4510567890', '775678901234', '56789012345', '5012349012', 'Passport copy, sale agreement', 'Client with stable financial situation'),
('Popov', 'Alexey', 'Igorevich', '4510678901', '776789012345', '67890123456', '5012340123', 'Passport copy, tax certificate', 'Client with previous loans in other banks');
