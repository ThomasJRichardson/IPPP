USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[spDataQueriesIP]    Script Date: 01/02/2014 09:57:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spDataQueriesIP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spDataQueriesIP]
GO

USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[spDataQueriesIP]    Script Date: 01/02/2014 09:57:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure
[dbo].[spDataQueriesIP]
AS
select Username,PPSN,Surname,Forename,
PhoneHome,PhoneMobile,Email,

case when DateEmpStart_1 <> DateEmpStart_m1
then 'Date Emp Started s/be ' + CONVERT(varchar,DateEmpStart_m1,106) + ', ' else '' end +

case when DateEmpCease_1 <> DateEmpCease_m1
then 'Date Emp Ceased s/be ' + CONVERT(varchar,DateEmpCease_m1,106) + ', ' else '' end +

case when DateJoinedScheme_1 <> DateJoinedScheme_m1
then 'DJS s/be ' + CONVERT(varchar,DateJoinedScheme_m1,106) + ', ' else '' end +

case when SchemeCategory_1 <> SchemeCategory_m1
then 'Scheme Category s/be ' + SchemeCategory_m1 + ', ' else '' end +

case when PensionableSalary_1 <> PensionableSalary_m1
then 'Salary s/be ' + CONVERT(varchar,PensionableSalary_m1) + ', ' else '' end +

case when TransferIn_1 <> TransferIn_m1
then 'Transfer In? s/be ' + TransferIn_m1 + ', ' else '' end +

case when NormalRetDate_1 <> NormalRetDate_m1
then 'Retirement date s/be ' + CONVERT(varchar,NormalRetDate_m1,106) + ', ' else '' end

as Data_queried,

DateEmpStart_1, DateEmpCease_1, DateJoinedScheme_1, SchemeCategory_1,
PensionableSalary_1, TransferIn_1, NormalRetDate_1, MemberServiceUpdateAt

from IP_WEB_ARCHIVE
where blnCorrect = 0

GO


