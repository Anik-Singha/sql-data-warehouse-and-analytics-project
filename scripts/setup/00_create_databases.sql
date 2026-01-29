/*
==================================================
 Script Name : 00_create_databases.sql
 Purpose     : Create databases for Medallion Architecture
 Databases   : bronze, silver, gold
 Author      : Anik Singha
==================================================
*/

CREATE DATABASE IF NOT EXISTS bronze;
CREATE DATABASE IF NOT EXISTS silver;
CREATE DATABASE IF NOT EXISTS gold;
