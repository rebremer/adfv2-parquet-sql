### Make sure the following 2 SQL statements are executed using AAD admin in SQLDB, such that ADFv2 Managed Instance can add database ###

#CREATE USER [<<your Data Factory name>>] FROM EXTERNAL PROVIDER;
#EXEC sp_addrolemember [db_datawriter], [<<your Data Factory name>>];


USE [test-edlprod1-db2]
GO

/****** Object:  Table [dbo].[SalesLTAddress]    Script Date: 23/12/2019 11:57:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SalesLTAddress](
	[AddressID] [int] NULL,
	[AddressLine1] [nvarchar](350) NULL,
	[AddressLine2] [nvarchar](350) NULL,
	[City] [nvarchar](350) NULL,
	[StateProvince] [nvarchar](350) NULL,
	[CountryRegion] [nvarchar](350) NULL,
	[PostalCode] [nvarchar](350) NULL,
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL
)
GO


USE [test-edlprod1-db2]
GO

/****** Object:  Table [dbo].[SalesLTAddress_staging]    Script Date: 23/12/2019 11:58:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SalesLTAddress_staging](
	[AddressID] [int] NULL,
	[AddressLine1] [nvarchar](350) NULL,
	[AddressLine2] [nvarchar](350) NULL,
	[City] [nvarchar](350) NULL,
	[StateProvince] [nvarchar](350) NULL,
	[CountryRegion] [nvarchar](350) NULL,
	[PostalCode] [nvarchar](350) NULL,
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL
)
GO


USE [test-edlprod1-db2]
GO

/****** Object:  StoredProcedure [dbo].[SP_INSERT_STAGING_SalesLTAddress]    Script Date: 23/12/2019 11:58:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[SP_INSERT_STAGING_SalesLTAddress]
AS
BEGIN

   INSERT INTO [dbo].[SalesLTAddress]
   SELECT * FROM [dbo].[SalesLTAddress_staging] sa_staging
   WHERE NOT EXISTS (
	  SELECT 1 FROM [dbo].[SalesLTAddress] sa
	  WHERE sa_staging.AddressID = AddressID)

   DELETE FROM [dbo].[SalesLTAddress_staging]
END
GO