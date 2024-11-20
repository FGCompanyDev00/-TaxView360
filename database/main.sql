-- Create the Users table
CREATE TABLE `Users` (
    `user_id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) UNIQUE NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `role` ENUM('admin', 'accountant', 'auditor') NOT NULL,
    `status` ENUM('active', 'suspended') NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create the Clients table
CREATE TABLE `Clients` (
    `client_id` INT AUTO_INCREMENT PRIMARY KEY,
    `company_name` VARCHAR(255) NOT NULL,
    `contact_name` VARCHAR(255) NOT NULL,
    `contact_email` VARCHAR(255),
    `contact_phone` VARCHAR(20),
    `assigned_accountant_id` INT,
    `status` ENUM('active', 'inactive') NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`assigned_accountant_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL
);

-- Create the Client Updates table (Audit Log for Client Updates)
CREATE TABLE `Client_Updates` (
    `update_id` INT AUTO_INCREMENT PRIMARY KEY,
    `client_id` INT NOT NULL,
    `updated_by` INT NOT NULL,
    `update_details` TEXT,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`client_id`) REFERENCES `Clients`(`client_id`) ON DELETE CASCADE,
    FOREIGN KEY (`updated_by`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE
);

-- Create the Accounts table
CREATE TABLE `Accounts` (
    `account_id` INT AUTO_INCREMENT PRIMARY KEY,
    `client_id` INT NOT NULL,
    `work_status` ENUM('in_progress', 'completed', 'pending') NOT NULL,
    `last_updated_by` INT NOT NULL,
    `last_updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`client_id`) REFERENCES `Clients`(`client_id`) ON DELETE CASCADE,
    FOREIGN KEY (`last_updated_by`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE
);

-- Create the Audits table
CREATE TABLE `Audits` (
    `audit_id` INT AUTO_INCREMENT PRIMARY KEY,
    `company_name` VARCHAR(255) NOT NULL,
    `audit_type` ENUM('Tax', 'Financial') NOT NULL,
    `status` ENUM('pending', 'in_progress', 'completed') NOT NULL,
    `assigned_auditor_id` INT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`assigned_auditor_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL
);

-- Create the Audit Logs table (Audit History)
CREATE TABLE `Audit_Logs` (
    `log_id` INT AUTO_INCREMENT PRIMARY KEY,
    `audit_id` INT NOT NULL,
    `action_taken` TEXT NOT NULL,
    `performed_by` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`audit_id`) REFERENCES `Audits`(`audit_id`) ON DELETE CASCADE,
    FOREIGN KEY (`performed_by`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE
);

-- Create the Tax Records table
CREATE TABLE `Tax_Records` (
    `tax_record_id` INT AUTO_INCREMENT PRIMARY KEY,
    `company_id` INT NOT NULL,
    `tax_form_type` ENUM('Borang C', 'Borang E', 'CP204') NOT NULL,
    `tax_value` DECIMAL(15, 2) NOT NULL,
    `filing_date` DATE NOT NULL,
    `last_updated_by` INT NOT NULL,
    `last_updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`company_id`) REFERENCES `Clients`(`client_id`) ON DELETE CASCADE,
    FOREIGN KEY (`last_updated_by`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE
);
