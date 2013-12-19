USE [IPPP]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_PF_PROFILE_DIFF]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[IP_PF_PROFILE_DIFF]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_PF_PROFILE_DIFF]') AND type in (N'U'))
		PRINT '*** Unable to drop Table: [dbo].[IP_PF_PROFILE_DIFF]'
	ELSE
		PRINT 'DROPPED Table: [dbo].[IP_PF_PROFILE_DIFF]'
END 
GO

/****** Object:  Table [dbo].[IP_PF_PROFILE_DIFF]    Script Date: 13-nov-2013 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IP_PF_PROFILE_DIFF](
	[Username]		[varchar](15)	NOT NULL PRIMARY KEY,		--PROFUND Person.Reference
	[PersonUID]		[int]		NULL,				--PROFUND Person.PersonUID

	[PPSN]			[varchar](20)	NULL,
	[Surname]		[varchar](40)	NULL,
	[Forename]		[varchar](20)	NULL,

	[Address1]		[varchar](100)	NULL,
	[Address2]		[varchar](100)	NULL,
	[Address3]		[varchar](100)	NULL,
	[Address4]		[varchar](100)	NULL,

	[PhoneHome]		[varchar](50)	NULL,
	[PhoneMobile]		[varchar](255)	NULL,
	[Email]			[varchar](255)	NULL,

	[DateOfBirth]		[datetime]	NULL,
	[Gender]		[varchar](6)	NULL,
	[MaritalStatus]		[varchar](10)	NULL

--	[ServiceRecordVerified]	[varchar](20)	null
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_PF_PROFILE_DIFF]') AND type in (N'U'))
	PRINT 'Created Table: [dbo].[IP_PF_PROFILE_DIFF]'
ELSE
	PRINT '*** Unable to create Table: [dbo].[IP_PF_PROFILE_DIFF]'
GO
