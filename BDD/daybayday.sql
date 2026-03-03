-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 02 mars 2026 à 12:06
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `daybayday`
--

-- --------------------------------------------------------

--
-- Structure de la table `absences`
--

CREATE TABLE IF NOT EXISTS `absences` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `comment` text DEFAULT NULL,
  `start_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `end_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `medical_certificate` tinyint(1) DEFAULT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `absences_user_id_foreign` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `activities`
--

CREATE TABLE IF NOT EXISTS `activities` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `log_name` varchar(255) DEFAULT NULL,
  `causer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `causer_type` varchar(255) DEFAULT NULL,
  `text` varchar(255) NOT NULL,
  `source_type` varchar(255) NOT NULL,
  `source_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(64) NOT NULL,
  `properties` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`properties`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `activities`
--

INSERT INTO `activities` (`id`, `external_id`, `log_name`, `causer_id`, `causer_type`, `text`, `source_type`, `source_id`, `ip_address`, `properties`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '', 'client', 1, 'App\\Models\\User', 'Client E-tice was assigned to Admin', 'App\\Models\\Client', 1, '', '{\"action\":\"created\"}', '2026-02-17 06:44:04', '2026-02-17 06:44:04', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `appointments`
--

CREATE TABLE IF NOT EXISTS `appointments` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `source_type` varchar(255) DEFAULT NULL,
  `source_id` bigint(20) UNSIGNED DEFAULT NULL,
  `color` varchar(10) NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `client_id` int(10) UNSIGNED DEFAULT NULL,
  `start_at` timestamp NULL DEFAULT NULL,
  `end_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `appointments_source_type_source_id_index` (`source_type`,`source_id`),
  KEY `appointments_user_id_foreign` (`user_id`),
  KEY `appointments_client_id_foreign` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `business_hours`
--

CREATE TABLE IF NOT EXISTS `business_hours` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `day` varchar(255) NOT NULL,
  `open_time` time DEFAULT NULL,
  `close_time` time DEFAULT NULL,
  `settings_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `business_hours_settings_id_foreign` (`settings_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `business_hours`
--

INSERT INTO `business_hours` (`id`, `day`, `open_time`, `close_time`, `settings_id`, `created_at`, `updated_at`) VALUES
(1, 'monday', '09:00:00', '18:00:00', 1, '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(2, 'tuesday', '09:00:00', '18:00:00', 1, '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(3, 'wednesday', '09:00:00', '18:00:00', 1, '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(4, 'thursday', '09:00:00', '18:00:00', 1, '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(5, 'friday', '09:00:00', '18:00:00', 1, '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(6, 'saturday', '09:00:00', '18:00:00', 1, '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(7, 'sunday', '09:00:00', '18:00:00', 1, '2026-02-17 06:29:11', '2026-02-17 06:29:11');

-- --------------------------------------------------------

--
-- Structure de la table `clients`
--

CREATE TABLE IF NOT EXISTS `clients` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `zipcode` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) NOT NULL,
  `vat` varchar(255) DEFAULT NULL,
  `company_type` varchar(255) DEFAULT NULL,
  `client_number` bigint(20) DEFAULT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `industry_id` int(10) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `clients_user_id_foreign` (`user_id`),
  KEY `clients_industry_id_foreign` (`industry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `clients`
--

INSERT INTO `clients` (`id`, `external_id`, `address`, `zipcode`, `city`, `company_name`, `vat`, `company_type`, `client_number`, `user_id`, `industry_id`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'cf04f33b-3b33-40cd-83b7-3aff34f1de5c', 'lot 3f 155 Antohomadinika', '101', 'Antananarivo', 'E-tice', '', '', 10000, 1, 1, NULL, '2026-02-17 06:44:04', '2026-02-17 06:44:04');

-- --------------------------------------------------------

--
-- Structure de la table `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `source_type` varchar(255) NOT NULL,
  `source_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `comments_source_type_source_id_index` (`source_type`,`source_id`),
  KEY `comments_user_id_foreign` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `contacts`
--

CREATE TABLE IF NOT EXISTS `contacts` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `primary_number` varchar(255) DEFAULT NULL,
  `secondary_number` varchar(255) DEFAULT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `is_primary` tinyint(1) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contacts_client_id_foreign` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `contacts`
--

INSERT INTO `contacts` (`id`, `external_id`, `name`, `email`, `primary_number`, `secondary_number`, `client_id`, `is_primary`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, '2158643a-270b-4265-bd8c-b671352d7a7a', 'tsiory RABEARIVONY', 'tsiory.rabearivony@student.passerellesnumeriques.org', '', '', 1, 1, NULL, '2026-02-17 06:44:04', '2026-02-17 06:44:04');

-- --------------------------------------------------------

--
-- Structure de la table `departments`
--

CREATE TABLE IF NOT EXISTS `departments` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `departments`
--

INSERT INTO `departments` (`id`, `external_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'd1cb2bdd-7e20-44b9-8164-3fb8e86b67eb', 'Management', NULL, '2026-02-17 06:29:11', '2026-02-17 06:29:11');

-- --------------------------------------------------------

--
-- Structure de la table `department_user`
--

CREATE TABLE IF NOT EXISTS `department_user` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `department_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `department_user_department_id_foreign` (`department_id`),
  KEY `department_user_user_id_foreign` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `department_user`
--

INSERT INTO `department_user` (`id`, `department_id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `documents`
--

CREATE TABLE IF NOT EXISTS `documents` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `size` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `original_filename` varchar(255) NOT NULL,
  `mime` varchar(255) NOT NULL,
  `integration_id` varchar(255) DEFAULT NULL,
  `integration_type` varchar(255) NOT NULL,
  `source_type` varchar(255) NOT NULL,
  `source_id` bigint(20) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `documents_source_type_source_id_index` (`source_type`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `industries`
--

CREATE TABLE IF NOT EXISTS `industries` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `industries`
--

INSERT INTO `industries` (`id`, `external_id`, `name`) VALUES
(1, '9bec137b-092a-4312-9c8b-61a4fde6a668', 'Accommodations'),
(2, '59ac9fad-56e6-4bf5-8378-913351f32c5f', 'Accounting'),
(3, '0959bde0-8447-4a2b-94da-91288235699b', 'Auto'),
(4, 'b4155042-fbca-4bc1-8824-bd7f43b23698', 'Beauty & Cosmetics'),
(5, 'cea26954-d71f-4a7c-a466-e28ab0467f4c', 'Carpenter'),
(6, '782bf652-2be0-4a19-8aa1-3469b30cc4a9', 'Communications'),
(7, '4f6b3455-57fb-45f1-a654-84927e29327a', 'Computer & IT'),
(8, '954eebdf-925c-4413-8684-ee652f50d17a', 'Construction'),
(9, '96d52718-2e82-4412-8570-9f597de22c1e', 'Consulting'),
(10, '6aad1708-b55c-4328-ac76-38281a322436', 'Education'),
(11, 'aea9136d-144c-4786-8976-722f90b26c30', 'Electronics'),
(12, 'e1829e9d-1eea-4756-aec2-b871cc8a9b65', 'Entertainment'),
(13, '92d90f16-bed1-4172-9992-a059865c7c2d', 'Food & Beverages'),
(14, '6e24a486-3072-4d48-b0da-2cad86406d9d', 'Legal Services'),
(15, '24880b23-c9d4-4680-b85c-8efedcca8e8c', 'Marketing'),
(16, '774698c5-4832-411a-a556-54be4f5ae552', 'Real Estate'),
(17, '962375ae-b5ec-4797-87fe-7bcd385df1af', 'Retail'),
(18, '906e0e6d-1efa-4abf-afff-27177716e430', 'Sports'),
(19, '15e64cc3-8d66-426b-81fd-6acbe8ba518f', 'Technology'),
(20, '9b359f8c-a030-4b4c-b9d5-a1a7c401f761', 'Tourism'),
(21, '46516b34-f5f3-46bf-952d-282f6e18e918', 'Transportation'),
(22, '2dff30b2-665f-478c-bd18-a4062c560e03', 'Travel'),
(23, '8a412210-ba69-4f83-9ec3-9509850d3ac6', 'Utilities'),
(24, 'f4b50996-b296-4436-8533-0d8f60d3789b', 'Web Services'),
(25, '9729bb46-2b90-4a38-8f0e-5f68691beae4', 'Other');

-- --------------------------------------------------------

--
-- Structure de la table `integrations`
--

CREATE TABLE IF NOT EXISTS `integrations` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `client_secret` int(11) DEFAULT NULL,
  `api_key` varchar(255) DEFAULT NULL,
  `api_type` varchar(255) DEFAULT NULL,
  `org_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `invoices`
--

CREATE TABLE IF NOT EXISTS `invoices` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `invoice_number` bigint(20) DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `due_at` datetime DEFAULT NULL,
  `integration_invoice_id` varchar(255) DEFAULT NULL,
  `integration_type` varchar(255) DEFAULT NULL,
  `source_type` varchar(255) DEFAULT NULL,
  `source_id` bigint(20) UNSIGNED DEFAULT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `offer_id` int(10) UNSIGNED DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoices_client_id_foreign` (`client_id`),
  KEY `invoices_source_type_source_id_index` (`source_type`,`source_id`),
  KEY `invoices_offer_id_foreign` (`offer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `invoice_lines`
--

CREATE TABLE IF NOT EXISTS `invoice_lines` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `comment` text NOT NULL,
  `price` int(11) NOT NULL,
  `invoice_id` int(10) UNSIGNED DEFAULT NULL,
  `offer_id` int(10) UNSIGNED DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `product_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_lines_offer_id_foreign` (`offer_id`),
  KEY `invoice_lines_invoice_id_foreign` (`invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `leads`
--

CREATE TABLE IF NOT EXISTS `leads` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status_id` int(10) UNSIGNED NOT NULL,
  `user_assigned_id` int(10) UNSIGNED NOT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `user_created_id` int(10) UNSIGNED NOT NULL,
  `qualified` tinyint(1) NOT NULL DEFAULT 0,
  `result` varchar(255) DEFAULT NULL,
  `deadline` datetime NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `leads_status_id_foreign` (`status_id`),
  KEY `leads_user_assigned_id_foreign` (`user_assigned_id`),
  KEY `leads_client_id_foreign` (`client_id`),
  KEY `leads_user_created_id_foreign` (`user_created_id`),
  KEY `leads_qualified_index` (`qualified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `mails`
--

CREATE TABLE IF NOT EXISTS `mails` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) NOT NULL,
  `body` varchar(255) DEFAULT NULL,
  `template` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `send_at` timestamp NULL DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mails_user_id_foreign` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `migrations`
--

CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2015_06_04_124835_create_industries_table', 1),
(4, '2015_10_15_143830_create_status_table', 1),
(5, '2015_12_28_163028_create_clients_table', 1),
(6, '2015_12_29_154026_create_invocies_table', 1),
(7, '2015_12_29_204031_projects_table', 1),
(8, '2015_12_29_204031_tasks_table', 1),
(9, '2016_01_10_204413_create_comments_table', 1),
(10, '2016_01_18_113656_create_leads_table', 1),
(11, '2016_01_23_144854_settings', 1),
(12, '2016_01_26_003903_documents', 1),
(13, '2016_01_31_211926_invoice_lines_table', 1),
(14, '2016_03_21_171847_create_department_table', 1),
(15, '2016_03_21_172416_create_department_user_table', 1),
(16, '2016_04_06_230504_integrations', 1),
(17, '2016_05_21_205532_create_activities_table', 1),
(18, '2016_08_26_205017_entrust_setup_tables', 1),
(19, '2016_11_04_200855_create_notifications_table', 1),
(20, '2017_10_28_131549_create_contacts_table', 1),
(21, '2019_05_03_000001_create_customer_columns', 1),
(22, '2019_05_03_000002_create_subscriptions_table', 1),
(23, '2019_11_29_092917_add_vat_and_currency', 1),
(24, '2019_11_29_111929_add_invoice_number_to_invoice', 1),
(25, '2019_12_09_201950_create_mails_table', 1),
(26, '2019_12_19_200049_add_billing_integration_id_to_invoices', 1),
(27, '2020_01_06_203615_create_payments_table', 1),
(28, '2020_01_10_120239_create_credit_notes_table', 1),
(29, '2020_01_10_121248_create_credit_lines_table', 1),
(30, '2020_01_28_195156_add_language_options', 1),
(31, '2020_02_20_192015_alter_leads_table_support_qualified', 1),
(32, '2020_03_30_163030_create_appointments_table', 1),
(33, '2020_04_06_075838_create_business_hours_table', 1),
(34, '2020_04_08_070242_create_absences_table', 1),
(35, '2020_05_09_113503_add_cascading_for_tables', 1),
(36, '2020_09_29_173256_add_soft_delete_to_tables', 1),
(37, '2021_01_09_102659_add_cascading_for_appointments', 1),
(38, '2021_02_10_153102_create_offers_table', 1),
(39, '2021_02_11_161257_alter_invoices_table_add_source', 1),
(40, '2021_02_11_162602_create_products_table', 1),
(41, '2021_03_02_132033_alter_comments_table_add_long_text', 1),
(42, '2021_04_15_073908_remove_qualified_from_leads', 1);

-- --------------------------------------------------------

--
-- Structure de la table `notifications`
--

CREATE TABLE IF NOT EXISTS `notifications` (
  `id` char(36) NOT NULL,
  `type` varchar(255) NOT NULL,
  `notifiable_type` varchar(255) NOT NULL,
  `notifiable_id` bigint(20) UNSIGNED NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `notifications`
--

INSERT INTO `notifications` (`id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
('d748b695-aea6-4b94-9238-bb795fcfdaaa', 'App\\Notifications\\ClientActionNotification', 'App\\Models\\User', 1, '{\"assigned_user\":1,\"created_user\":1,\"message\":\"Client E-tice was assigned to you\",\"type\":\"App\\\\Models\\\\Client\",\"type_id\":1,\"url\":\"http:\\/\\/localhost:8000\\/clients\\/cf04f33b-3b33-40cd-83b7-3aff34f1de5c\",\"action\":\"created\"}', NULL, '2026-02-17 06:44:04', '2026-02-17 06:44:04');

-- --------------------------------------------------------

--
-- Structure de la table `offers`
--

CREATE TABLE IF NOT EXISTS `offers` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `sent_at` datetime DEFAULT NULL,
  `source_type` varchar(255) DEFAULT NULL,
  `source_id` bigint(20) UNSIGNED DEFAULT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `status` varchar(255) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `offers_source_type_source_id_index` (`source_type`,`source_id`),
  KEY `offers_client_id_foreign` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `password_resets`
--

CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  KEY `password_resets_email_index` (`email`),
  KEY `password_resets_token_index` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `payments`
--

CREATE TABLE IF NOT EXISTS `payments` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `payment_source` varchar(255) NOT NULL,
  `payment_date` date NOT NULL,
  `integration_payment_id` varchar(255) DEFAULT NULL,
  `integration_type` varchar(255) DEFAULT NULL,
  `invoice_id` int(10) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payments_invoice_id_foreign` (`invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `permissions`
--

CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `grouping` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `permissions`
--
\
INSERT INTO `permissions` (`id`, `external_id`, `name`, `display_name`, `description`, `grouping`, `created_at`, `updated_at`) VALUES
(1, '', 'payment-create', 'Add payment', 'Be able to add a new payment on a invoice', 'payment', '2026-02-17 06:29:10', '2026-02-17 06:29:10'),
(2, '', 'payment-delete', 'Delete payment', 'Be able to delete a payment', 'payment', '2026-02-17 06:29:10', '2026-02-17 06:29:10'),
(3, '', 'calendar-view', 'View calendar', 'Be able to view the calendar for appointments', 'appointment', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(4, '', 'appointment-create', 'Add appointment', 'Be able to create a new appointment for a user', 'appointment', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(5, '', 'appointment-edit', 'Edit appointment', 'Be able to edit appointment such as times and title', 'appointment', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(6, '', 'appointment-delete', 'Delete appointment', 'Be able to delete an appointment', 'appointment', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(7, '', 'absence-manage', 'Manage absences', 'Be able to manage absences for all users', 'hr', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(8, '', 'absence-view', 'View absences', 'Be able to view absences for all users and see who is absent today on the dashboard', 'hr', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(9, '', 'offer-create', 'Add offer', 'Be able to create an offer', 'offer', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(10, '', 'offer-edit', 'Edit offer', 'Be able to edit an offer', 'offer', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(11, '', 'offer-delete', 'Delete offer', 'Be able to delete an offer', 'offer', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(12, '', 'product-create', 'Add product', 'Be able to create an product', 'product', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(13, '', 'product-edit', 'Edit product', 'Be able to edit an product', 'product', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(14, '', 'product-delete', 'Delete product', 'Be able to delete an product', 'product', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(15, '', 'user-create', 'Create user', 'Be able to create a new user', 'user', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(16, '', 'user-update', 'Update user', 'Be able to update a user\'s information', 'user', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(17, '', 'user-delete', 'Delete user', 'Be able to delete a user', 'user', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(18, '', 'client-create', 'Create client', 'Permission to create client', 'client', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(19, '', 'client-update', 'Update client', 'Permission to update client', 'client', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(20, '', 'client-delete', 'Delete client', 'Permission to delete client', 'client', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(21, '', 'document-delete', 'Delete document', 'Permission to delete a document associated with a client', 'document', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(22, '', 'document-upload', 'Upload document', 'Be able to upload a document associated with a client', 'document', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(23, '', 'task-create', 'Create task', 'Permission to create task', 'task', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(24, '', 'task-update-status', 'Update task status', 'Permission to update task status', 'task', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(25, '', 'task-update-deadline', 'Change task deadline', 'Permission to update a tasks deadline', 'task', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(26, '', 'can-assign-new-user-to-task', 'Change assigned user', 'Permission to change the assigned user on a task', 'task', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(27, '', 'task-update-linked-project', 'Changed linked project', 'Be able to change the project which is linked to a task', 'task', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(28, '', 'task-upload-files', 'Upload files to task', 'Allowed to upload files for a task', 'task', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(29, '', 'modify-invoice-lines', 'Modify invoice lines on a invoice / task', 'Permission to create and update invoice lines on task, and invoices', 'invoice', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(30, '', 'invoice-see', 'See invoices and it\'s invoice lines', 'Permission to see invoices on customer, and it\'s associated task', 'invoice', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(31, '', 'invoice-send', 'Send invoices to clients', 'Be able to set an invoice as send to an customer (Or Send it if billing integration is active)', 'invoice', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(32, '', 'invoice-pay', 'Set an invoice as paid', 'Be able to set an invoice as paid or not paid', 'invoice', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(33, '', 'lead-create', 'Create lead', 'Permission to create lead', 'lead', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(34, '', 'lead-update-status', 'Update lead status', 'Permission to update lead status', 'lead', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(35, '', 'lead-update-deadline', 'Change lead deadline', 'Permission to update a lead deadline', 'lead', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(36, '', 'can-assign-new-user-to-lead', 'Change assigned user', 'Permission to change the assigned user on a lead', 'lead', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(37, '', 'project-create', 'Create project', 'Permission to create project', 'project', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(38, '', 'project-update-status', 'Update project status', 'Permission to update project status', 'project', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(39, '', 'project-update-deadline', 'Change project deadline', 'Permission to update a projects deadline', 'project', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(40, '', 'can-assign-new-user-to-project', 'Change assigned user', 'Permission to change the assigned user on a project', 'project', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(41, '', 'project-upload-files', 'Upload files to project', 'Allowed to upload files for a project', 'project', '2026-02-17 06:29:11', '2026-02-17 06:29:11');

-- --------------------------------------------------------

--
-- Structure de la table `permission_role`
--

CREATE TABLE IF NOT EXISTS `permission_role` (
  `permission_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `permission_role_role_id_foreign` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `permission_role`
--

INSERT INTO `permission_role` (`permission_id`, `role_id`) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(4, 1),
(4, 2),
(5, 1),
(5, 2),
(6, 1),
(6, 2),
(7, 1),
(7, 2),
(8, 1),
(8, 2),
(9, 1),
(9, 2),
(10, 1),
(10, 2),
(11, 1),
(11, 2),
(12, 1),
(12, 2),
(13, 1),
(13, 2),
(14, 1),
(14, 2),
(15, 1),
(15, 2),
(16, 1),
(16, 2),
(17, 1),
(17, 2),
(18, 1),
(18, 2),
(19, 1),
(19, 2),
(20, 1),
(20, 2),
(21, 1),
(21, 2),
(22, 1),
(22, 2),
(23, 1),
(23, 2),
(24, 1),
(24, 2),
(25, 1),
(25, 2),
(26, 1),
(26, 2),
(27, 1),
(27, 2),
(28, 1),
(28, 2),
(29, 1),
(29, 2),
(30, 1),
(30, 2),
(31, 1),
(31, 2),
(32, 1),
(32, 2),
(33, 1),
(33, 2),
(34, 1),
(34, 2),
(35, 1),
(35, 2),
(36, 1),
(36, 2),
(37, 1),
(37, 2),
(38, 1),
(38, 2),
(39, 1),
(39, 2),
(40, 1),
(40, 2),
(41, 1),
(41, 2);

-- --------------------------------------------------------

--
-- Structure de la table `products`
--

CREATE TABLE IF NOT EXISTS `products` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `external_id` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `number` varchar(255) NOT NULL,
  `default_type` varchar(255) NOT NULL,
  `archived` tinyint(1) NOT NULL,
  `integration_type` varchar(255) DEFAULT NULL,
  `integration_id` bigint(20) UNSIGNED DEFAULT NULL,
  `price` int(11) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `products_integration_type_integration_id_index` (`integration_type`,`integration_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `projects`
--

CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status_id` int(10) UNSIGNED NOT NULL,
  `user_assigned_id` int(10) UNSIGNED NOT NULL,
  `user_created_id` int(10) UNSIGNED NOT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `invoice_id` int(10) UNSIGNED DEFAULT NULL,
  `deadline` date NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `projects_status_id_foreign` (`status_id`),
  KEY `projects_user_assigned_id_foreign` (`user_assigned_id`),
  KEY `projects_user_created_id_foreign` (`user_created_id`),
  KEY `projects_client_id_foreign` (`client_id`),
  KEY `projects_invoice_id_foreign` (`invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `roles`
--

INSERT INTO `roles` (`id`, `external_id`, `name`, `display_name`, `description`, `created_at`, `updated_at`) VALUES
(1, '749a365c-fce5-4146-8b07-ce7b9dd7ec5d', 'owner', 'Owner', 'Owner', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(2, '7fe72944-eb39-49c5-af8d-584046f20c60', 'administrator', 'Administrator', 'System Administrator', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(3, 'df78c531-089a-44bd-be5a-82c7af3e26a2', 'manager', 'Manager', 'System Manager', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(4, '2a068c5e-67bb-477d-a576-764790c231bf', 'employee', 'Employee', 'Employee', '2026-02-17 06:29:11', '2026-02-17 06:29:11');

-- --------------------------------------------------------

--
-- Structure de la table `role_user`
--

CREATE TABLE IF NOT EXISTS `role_user` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_user_role_id_foreign` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `role_user`
--

INSERT INTO `role_user` (`user_id`, `role_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_number` int(11) NOT NULL,
  `invoice_number` int(11) NOT NULL,
  `country` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'USD',
  `vat` smallint(6) NOT NULL DEFAULT 725,
  `max_users` int(11) NOT NULL,
  `language` varchar(2) NOT NULL DEFAULT 'EN',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `settings`
--

INSERT INTO `settings` (`id`, `client_number`, `invoice_number`, `country`, `company`, `currency`, `vat`, `max_users`, `language`, `created_at`, `updated_at`) VALUES
(1, 10001, 10000, 'en', 'Media', 'USD', 725, 10, 'EN', NULL, '2026-02-17 06:44:04');

-- --------------------------------------------------------

--
-- Structure de la table `statuses`
--

CREATE TABLE IF NOT EXISTS `statuses` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `source_type` varchar(255) NOT NULL,
  `color` varchar(255) NOT NULL DEFAULT '#000000',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `statuses`
--

INSERT INTO `statuses` (`id`, `external_id`, `title`, `source_type`, `color`, `created_at`, `updated_at`) VALUES
(1, '430c6a56-1c8e-41e6-8a21-35de2f1b2550', 'Open', 'App\\Models\\Task', '#2FA599', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(2, '8d09294b-34b9-4b67-afa3-299095121071', 'In-progress', 'App\\Models\\Task', '#2FA55E', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(3, '5ba6f9b6-246f-4ff6-a801-f964bfdfc16e', 'Pending', 'App\\Models\\Task', '#EFAC57', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(4, '942e0c2f-83d3-4bcf-b667-dc420839e205', 'Waiting client', 'App\\Models\\Task', '#60C0DC', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(5, 'a8c3fd85-009f-4895-b4a9-872c7661b1fc', 'Blocked', 'App\\Models\\Task', '#E6733E', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(6, '678aefb2-afaa-433d-8463-bb64f431cd82', 'Closed', 'App\\Models\\Task', '#D75453', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(7, '1f393e7d-e532-4312-90bc-f08fa0b22dec', 'Open', 'App\\Models\\Lead', '#2FA599', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(8, 'ab5c6669-198a-4027-8a36-cf0e3937a612', 'Pending', 'App\\Models\\Lead', '#EFAC57', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(9, 'd1647776-82cc-41f7-ac73-551e283433b5', 'Waiting client', 'App\\Models\\Lead', '#60C0DC', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(10, '14d252f4-8b2b-4a96-b18d-579fa2e25cf1', 'Closed', 'App\\Models\\Lead', '#D75453', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(11, 'c932b29c-ffd6-40ef-8db0-d2392d36cdbc', 'Open', 'App\\Models\\Project', '#2FA599', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(12, 'ea3db386-53d9-4e44-ab38-74274580c0f3', 'In-progress', 'App\\Models\\Project', '#3CA3BA', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(13, '1cb9e00e-6177-420f-96ee-43d9305de88d', 'Blocked', 'App\\Models\\Project', '#60C0DC', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(14, '1b2672f4-858e-400e-b63d-b5a88dd5b701', 'Cancelled', 'App\\Models\\Project', '#821414', '2026-02-17 06:29:11', '2026-02-17 06:29:11'),
(15, '01d0fc8d-347e-4ead-91d0-d502887063c4', 'Completed', 'App\\Models\\Project', '#D75453', '2026-02-17 06:29:11', '2026-02-17 06:29:11');

-- --------------------------------------------------------

--
-- Structure de la table `subscriptions`
--

CREATE TABLE IF NOT EXISTS `subscriptions` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `stripe_id` varchar(255) NOT NULL,
  `stripe_status` varchar(255) NOT NULL,
  `stripe_plan` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `trial_ends_at` timestamp NULL DEFAULT NULL,
  `ends_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subscriptions_user_id_stripe_status_index` (`user_id`,`stripe_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `tasks`
--

CREATE TABLE IF NOT EXISTS `tasks` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status_id` int(10) UNSIGNED NOT NULL,
  `user_assigned_id` int(10) UNSIGNED NOT NULL,
  `user_created_id` int(10) UNSIGNED NOT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `project_id` int(10) UNSIGNED DEFAULT NULL,
  `deadline` date NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tasks_status_id_foreign` (`status_id`),
  KEY `tasks_user_assigned_id_foreign` (`user_assigned_id`),
  KEY `tasks_user_created_id_foreign` (`user_created_id`),
  KEY `tasks_client_id_foreign` (`client_id`),
  KEY `tasks_project_id_foreign` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(60) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `primary_number` varchar(255) DEFAULT NULL,
  `secondary_number` varchar(255) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `language` varchar(2) NOT NULL DEFAULT 'EN',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `external_id`, `name`, `email`, `password`, `address`, `primary_number`, `secondary_number`, `image_path`, `remember_token`, `language`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'a8975c9f-ae3e-45e0-8dd9-950be7b13451', 'Admin', 'admin@admin.com', '$2y$10$8AroycfTAGwHIjKyUspHeOhm64ZZQ0J0c.XzBm3iITxGw5ukhng5i', '', NULL, NULL, '', '8LT88qLeKGQTxLtdeSBnZmzBvnfUIybSJzgrXuptFqT1eN49R9BhdUXNUohQ', 'EN', NULL, '2016-06-04 10:42:19', '2016-06-04 10:42:19');

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `absences`
--
ALTER TABLE `absences`
  ADD CONSTRAINT `absences_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `business_hours`
--
ALTER TABLE `business_hours`
  ADD CONSTRAINT `business_hours_settings_id_foreign` FOREIGN KEY (`settings_id`) REFERENCES `settings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `clients_industry_id_foreign` FOREIGN KEY (`industry_id`) REFERENCES `industries` (`id`),
  ADD CONSTRAINT `clients_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `contacts_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `department_user`
--
ALTER TABLE `department_user`
  ADD CONSTRAINT `department_user_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `department_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoices_offer_id_foreign` FOREIGN KEY (`offer_id`) REFERENCES `offers` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `invoice_lines`
--
ALTER TABLE `invoice_lines`
  ADD CONSTRAINT `invoice_lines_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoice_lines_offer_id_foreign` FOREIGN KEY (`offer_id`) REFERENCES `offers` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `leads`
--
ALTER TABLE `leads`
  ADD CONSTRAINT `leads_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `leads_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`),
  ADD CONSTRAINT `leads_user_assigned_id_foreign` FOREIGN KEY (`user_assigned_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `leads_user_created_id_foreign` FOREIGN KEY (`user_created_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `mails`
--
ALTER TABLE `mails`
  ADD CONSTRAINT `mails_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `offers`
--
ALTER TABLE `offers`
  ADD CONSTRAINT `offers_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `projects_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`),
  ADD CONSTRAINT `projects_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`),
  ADD CONSTRAINT `projects_user_assigned_id_foreign` FOREIGN KEY (`user_assigned_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `projects_user_created_id_foreign` FOREIGN KEY (`user_created_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `role_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tasks_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `tasks_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`),
  ADD CONSTRAINT `tasks_user_assigned_id_foreign` FOREIGN KEY (`user_assigned_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `tasks_user_created_id_foreign` FOREIGN KEY (`user_created_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
