/*
To remove the database use:
DROP SCHEMA IF EXISTS login; from commandline
Or PHPMyAdmin - databases - Operations to do this.
PHPMyAdmin doesn't allow DROP DATABASE in a script or SQL-Window
 */
-- Use GRANT-Statement, if you work with Docker, not necessary with Vagrant
-- GRANT ALL PRIVILEGES ON *.* TO 'onlineshop'@'localhost';
CREATE SCHEMA IF NOT EXISTS `login` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE login;
-- place your solutions here
