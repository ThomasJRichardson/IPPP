USE [IPPP]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_ADDRESS_LOG]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[IP_WEB_ADDRESS_LOG]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_ADDRESS_LOG]') AND type in (N'U'))
		PRINT '*** Unable to drop Table: [dbo].[IP_WEB_ADDRESS_LOG]'
	ELSE
		PRINT 'DROPPED Table: [dbo].[IP_WEB_ADDRESS_LOG]'
END 
GO

/****** Object:  Table [dbo].[IP_WEB_ADDRESS_LOG]    Script Date: 13-nov-2013 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IP_WEB_ADDRESS_LOG](
	[Username]		[varchar](15)	NOT NULL,
	[PersonUID]		[int]		NULL,

	[Address1]		[varchar](100)	NULL,
	[Address2]		[varchar](100)	NULL,
	[Address3]		[varchar](100)	NULL,
	[Address4]		[varchar](100)	NULL,
	[PhoneHome]		[varchar](50)	NULL,

	[_CreatedWhen]		[datetime]	NOT NULL,
	[_CreatedBy]		[varchar](32)	NOT NULL,
	[_CreatedOn]		[varchar](32)	NOT NULL,
	[_CreatedIn]		[varchar](32)	NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_ADDRESS_LOG]') AND type in (N'U'))
	PRINT 'Created Table: [dbo].[IP_WEB_ADDRESS_LOG]'
ELSE
	PRINT '*** Unable to create Table: [dbo].[IP_WEB_ADDRESS_LOG]'
GO
