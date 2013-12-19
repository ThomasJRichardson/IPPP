USE [IPPP]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_ServiceRecord]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[IP_ServiceRecord]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_ServiceRecord]') AND type in (N'U'))
		PRINT '*** Unable to drop Table: [dbo].[IP_ServiceRecord]'
	ELSE
		PRINT 'DROPPED Table: [dbo].[IP_ServiceRecord]'
END 
GO

/****** Object:  Table [dbo].[IP_ServiceRecord]    Script Date: 13-nov-2013 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IP_ServiceRecord](
	[Username]		[varchar](30)	NOT NULL,			--PROFUND Person.Reference

	[DateEmploymentStarted]	[datetime]	NOT NULL,
	[DateEmploymentCeased]	[datetime]	NULL,

	[DateJoinedScheme]	[datetime]	NULL,
	[SchemeCategory]	[varchar](100)	not null,			--PROFUND JobClass.LongDesc
	[PensionableSalary]	[decimal](38,2)	NULL,

	[TransferInFromPrevEmp]	[char](1)	NULL,
	[NormalRetirementDate]	[datetime]	null,

PRIMARY KEY CLUSTERED 
(
	[Username] ASC, [DateEmploymentStarted] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_ServiceRecord]') AND type in (N'U'))
	PRINT 'Created Table: [dbo].[IP_ServiceRecord]'
ELSE
	PRINT '*** Unable to create Table: [dbo].[IP_ServiceRecord]'
GO
