USE [IPPP]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_PF_LOCAL]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[IP_PF_LOCAL]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_PF_LOCAL]') AND type in (N'U'))
		PRINT '*** Unable to drop Table: [dbo].[IP_PF_LOCAL]'
	ELSE
		PRINT 'DROPPED Table: [dbo].[IP_PF_LOCAL]'
END 
GO

/****** Object:  Table [dbo].[IP_PF_LOCAL]    Script Date: 13-nov-2013 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IP_PF_LOCAL](
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
	[MaritalStatus]		[varchar](10)	NULL,

	[DateEmpStart_1]	[datetime]	NOT NULL,
	[DateEmpCease_1]	[datetime]	NULL,
	[DateJoinedScheme_1]	[datetime]	NULL,
	[SchemeCategory_1]	[varchar](100)	not null,
	[PensionableSalary_1]	[decimal](38,2)	NULL,
	[TransferIn_1]		[char](1)	NULL,
	[NormalRetDate_1]	[datetime]	null,

	[DateEmpStart_2]	[datetime]	NULL,
	[DateEmpCease_2]	[datetime]	NULL,
	[DateJoinedScheme_2]	[datetime]	NULL,
	[SchemeCategory_2]	[varchar](100)	null,
	[PensionableSalary_2]	[decimal](38,2)	NULL,
	[TransferIn_2]		[char](1)	NULL,
	[NormalRetDate_2]	[datetime]	null,

	[ServiceRecordVerified]	[varchar](20)	null
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_PF_LOCAL]') AND type in (N'U'))
	PRINT 'Created Table: [dbo].[IP_PF_LOCAL]'
ELSE
	PRINT '*** Unable to create Table: [dbo].[IP_PF_LOCAL]'
GO
