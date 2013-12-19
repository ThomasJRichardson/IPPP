USE [IPPP]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_MOBILE_LOG]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[IP_WEB_MOBILE_LOG]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_MOBILE_LOG]') AND type in (N'U'))
		PRINT '*** Unable to drop Table: [dbo].[IP_WEB_MOBILE_LOG]'
	ELSE
		PRINT 'DROPPED Table: [dbo].[IP_WEB_MOBILE_LOG]'
END 
GO

/****** Object:  Table [dbo].[IP_WEB_MOBILE_LOG]    Script Date: 13-nov-2013 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IP_WEB_MOBILE_LOG](
	[Username]		[varchar](15)	NOT NULL,
	[PersonUID]		[int]		NULL,

	[PhoneMobile]		[varchar](255)	NULL,

	[_CreatedWhen]		[datetime]	NOT NULL,
	[_CreatedBy]		[varchar](32)	NOT NULL,
	[_CreatedOn]		[varchar](32)	NOT NULL,
	[_CreatedIn]		[varchar](32)	NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_MOBILE_LOG]') AND type in (N'U'))
	PRINT 'Created Table: [dbo].[IP_WEB_MOBILE_LOG]'
ELSE
	PRINT '*** Unable to create Table: [dbo].[IP_WEB_MOBILE_LOG]'
GO
