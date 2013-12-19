USE [IPPP]
GO

/****** Object:  Table [dbo].[IPPP_TABLE_COUNTS]    Script Date: 12/09/2013 11:40:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IPPP_TABLE_COUNTS]') AND type in (N'U'))
DROP TABLE [dbo].[IPPP_TABLE_COUNTS]
GO

USE [IPPP]
GO

/****** Object:  Table [dbo].[IPPP_TABLE_COUNTS]    Script Date: 12/09/2013 11:40:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IPPP_TABLE_COUNTS](
	[table_name] [varchar](50) NOT NULL,
	[record_count] [int] NULL,
	[new_count] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


