USE [IPPP]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_MOBILE_DIFF]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[IP_WEB_MOBILE_DIFF]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_MOBILE_DIFF]') AND type in (N'U'))
		PRINT '*** Unable to drop Table: [dbo].[IP_WEB_MOBILE_DIFF]'
	ELSE
		PRINT 'DROPPED Table: [dbo].[IP_WEB_MOBILE_DIFF]'
END 
GO

/****** Object:  Table [dbo].[IP_WEB_MOBILE_DIFF]    Script Date: 13-nov-2013 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IP_WEB_MOBILE_DIFF](
	[Username]		[varchar](15)	NOT NULL PRIMARY KEY,		--PROFUND Person.Reference
	[PersonUID]		[int]		NULL,				--PROFUND Person.PersonUID

	[PhoneMobile]		[varchar](255)	NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_MOBILE_DIFF]') AND type in (N'U'))
	PRINT 'Created Table: [dbo].[IP_WEB_MOBILE_DIFF]'
ELSE
	PRINT '*** Unable to create Table: [dbo].[IP_WEB_MOBILE_DIFF]'
GO
