/*
==========================================================
Create Database and Schemas
==========================================================
Script Purpose:
  This script creates a new database named "DataWareHouse" after checking if it already exists.
  If the Database exists, it is dropped and recreated. Additionally, the script sets up three schemas
  within the database: 'bronze', 'silver', 'gold'.

Warming:
  Running this script will drop the entire 'DataWareHouse' database if it exists.
  All data in the database will be permanently. Proceed with caution
  andensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWareHouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DatawWareHouse')
BEGIN
  ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWareHouse;
END;
GO

-- Create the 'DataWareHouse' database
CREATE DATABASE DataWareHouse;
GO

USE DataWareHouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
