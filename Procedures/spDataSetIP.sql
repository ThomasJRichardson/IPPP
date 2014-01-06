USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[spDataSetIP]    Script Date: 01/02/2014 09:57:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spDataSetIP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spDataSetIP]
GO

USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[spDataSetIP]    Script Date: 01/02/2014 09:57:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure
[dbo].[spDataSetIP]
AS
select Username,PPSN,Surname,Forename,
Address1, Address2, Address3, Address4,
PhoneHome,PhoneMobile,Email,
DateOfBirth, Gender, MaritalStatus,

ProfileLastUpdateBy, ProfileLastUpdateAt,

case when blnCorrect is null then '-'
when blnCorrect = 1 then 'Accepted'
when blnCorrect = 0 then '*REJECTED *'
else 'Unknown'
end as Status,

DateEmpStart_1, DateEmpCease_1, DateJoinedScheme_1, SchemeCategory_1,
PensionableSalary_1, TransferIn_1, NormalRetDate_1,

DateEmpStart_2, DateEmpCease_2, DateJoinedScheme_2, SchemeCategory_2,
PensionableSalary_2, TransferIn_2, NormalRetDate_2,

MemberServiceUpdateAt

from IP_WEB_ARCHIVE

GO


