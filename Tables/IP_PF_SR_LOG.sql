USE [IPPP]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_PF_SR_LOG]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[IP_PF_SR_LOG]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_PF_SR_LOG]') AND type in (N'U'))
		PRINT '*** Unable to drop Table: [dbo].[IP_PF_SR_LOG]'
	ELSE
		PRINT 'DROPPED Table: [dbo].[IP_PF_SR_LOG]'
END 
GO

/****** Object:  Table [dbo].[IP_PF_SR_LOG]    Script Date: 13-nov-2013 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IP_PF_SR_LOG](
	[Username]		[varchar](15)	NOT NULL PRIMARY KEY,		--PROFUND Person.Reference
	[PersonUID]		[int]		NULL,				--PROFUND Person.PersonUID

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

	[_CreatedWhen]		[datetime]	NOT NULL,
	[_CreatedBy]		[varchar](32)	NOT NULL,
	[_CreatedOn]		[varchar](32)	NOT NULL,
	[_CreatedIn]		[varchar](32)	NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IP_PF_SR_LOG]') AND type in (N'U'))
	PRINT 'Created Table: [dbo].[IP_PF_SR_LOG]'
ELSE
	PRINT '*** Unable to create Table: [dbo].[IP_PF_SR_LOG]'
GO
