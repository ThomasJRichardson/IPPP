USE [IPPP]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_SR_LOG]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[IP_WEB_SR_LOG]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_SR_LOG]') AND type in (N'U'))
		PRINT '*** Unable to drop Table: [dbo].[IP_WEB_SR_LOG]'
	ELSE
		PRINT 'DROPPED Table: [dbo].[IP_WEB_SR_LOG]'
END 
GO

/****** Object:  Table [dbo].[IP_WEB_SR_LOG]    Script Date: 13-nov-2013 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IP_WEB_SR_LOG](
	[Username]		[varchar](15)	NOT NULL,
	[PersonUID]		[int]		NULL,

	[DateEmpStart_m1]	[datetime]	not NULL,
	[DateEmpCease_m1]	[datetime]	NULL,
	[DateJoinedScheme_m1]	[datetime]	NULL,
	[SchemeCategory_m1]	[varchar](100)	not null,
	[PensionableSalary_m1]	[decimal](38,2)	NULL,
	[TransferIn_m1]		[char](1)	NULL,
	[NormalRetDate_m1]	[datetime]	null,

	[DateEmpStart_m2]	[datetime]	NULL,
	[DateEmpCease_m2]	[datetime]	NULL,
	[DateJoinedScheme_m2]	[datetime]	NULL,
	[SchemeCategory_m2]	[varchar](100)	null,
	[PensionableSalary_m2]	[decimal](38,2)	NULL,
	[TransferIn_m2]		[char](1)	NULL,
	[NormalRetDate_m2]	[datetime]	null,

	[blnCorrect]		[bit]		null,

	[_CreatedWhen]		[datetime]	NOT NULL,
	[_CreatedBy]		[varchar](32)	NOT NULL,
	[_CreatedOn]		[varchar](32)	NOT NULL,
	[_CreatedIn]		[varchar](32)	NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_SR_LOG]') AND type in (N'U'))
	PRINT 'Created Table: [dbo].[IP_WEB_SR_LOG]'
ELSE
	PRINT '*** Unable to create Table: [dbo].[IP_WEB_SR_LOG]'
GO
