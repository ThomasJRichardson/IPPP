USE [IPPP]
GO

/*
Environments:	DEV use APTLIVE, .10/11 commented out
		QA use APTLIVE, .11
		PROD use APTLIVE, .10
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Synch_IP_PREP]') AND type in (N'P', N'PC'))
begin
	DROP PROCEDURE [dbo].[Synch_IP_PREP]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Synch_IP_PREP]') AND type in (N'P', N'PC'))
		PRINT '*** UNABLE to Drop Procedure: Synch_IP_PREP'
	ELSE
		PRINT 'DROPPED Procedure: Synch_IP_PREP'
end
GO

USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[Synch_IP_PREP]    Script Date: 11/19/2013 09:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Synch_IP_PREP]
AS
set nocount on;

DECLARE	@ErrorMessage NVARCHAR(4000),
	@ErrorSeverity INT,
	@ErrorState INT;

BEGIN TRY
	delete from IP_WEB_PERSON_DIFF;
	delete from IP_WEB_ADDRESS_DIFF;
	delete from IP_WEB_EMAIL_DIFF;
	delete from IP_WEB_MOBILE_DIFF;
	delete from IP_WEB_MARSTATUS_DIFF;
	delete from IP_WEB_SR_DIFF;
	delete from IP_PF_PROFILE_DIFF;
	delete from IP_PF_SR_DIFF;
	delete from IP_WEB_LOCAL;
	delete from IP_PF_LOCAL;

	insert into dbo.IP_PF_LOCAL
	select	
		P.Reference as Username,
		P.PersonUID,
		P.Salutation as PPSN,
		P.Surname,
		P.Forename,
		A.Line1 as Address1,
		A.Line2 as Address2,
		A.Line3 as Address3,
		A.Line4 as Address4,
		A.TelephoneNumber as PhoneHome,
		Mobile.Value as PhoneMobile,
		Email.Value as Email,
		P.DateOfBirth,
		P.Sex as Gender,
		case MAR.Value	when 'APA' then 'Separated'
				when 'DIV' then 'Divorced'
				when 'MAR' then 'Married'
				when 'SIN' then 'Single'
				else 'Unknown'
		end as MaritalStatus,

		EE.DateFirstEmployed as DateEmpStart_1,
		EEX.EffDate as DateEmpCease_1,
		SM1.DateJoinedScheme as DateJoinedScheme_1,
		isnull(JC1.LongDesc,'?') as SchemeCategory_1,
		case when P.Reference like 'IP-%' then BASSAL1.Value else PENSAL1.Value end
			as PensionableSalary_1,
		left(EE.PayrollNumber,1) as TransferIn_1,
		SM1.SchemeRetirementDate as NormalRetDate_1,

		E2.DateFirstEmployed as DateEmpStart_2,
		E2X.EffDate as DateEmpCease_2,
		SM2.DateJoinedScheme as DateJoinedScheme_2,
		JC2.LongDesc as SchemeCategory_2,
		case when P.Reference like 'IP-%' then BASSAL2.Value else PENSAL2.Value end
			as PensionableSalary_2,
		left(E2.PayrollNumber,1) as TransferIn_2,
		SM2.SchemeRetirementDate as NormalRetDate_2,

		P.PrevSurname as ServiceRecordVerified,

		case when P.Reference like 'IP-%' then PENSAL1.Value else BASSAL1.Value end
			as FinalSalary_1,
		case when P.Reference like 'IP-%' then PENSAL2.Value else BASSAL2.Value end
			as FinalSalary_2

	from APTLIVE.dbo.Person P

	left outer join APTLIVE.dbo.Communications Email on Email.ParentUID = P.PersonUID and Email.Catid = 802 and Email.EndDate is null
	left outer join APTLIVE.dbo.Communications Mobile on Mobile.ParentUID = P.PersonUID and Mobile.Catid = 800 and Mobile.EndDate is null

	left outer join APTLIVE.dbo.StringHistory MAR on MAR.ParentUID = P.PersonUID and MAR.CatID = 1200

	inner join APTLIVE.dbo.Employee EE on EE.PersonUID = P.PersonUID
		and EE.DateFirstEmployed = (select min(DateFirstEmployed) from APTLIVE.dbo.Employee where PersonUID = P.PersonUID)

	left outer join APTLIVE.dbo.Employee E2 on E2.PersonUID = P.PersonUID
		and E2.DateFirstEmployed <> EE.DateFirstEmployed

	left outer join APTLIVE.dbo.Address A on A.ParentUID = P.PersonUID and A.CatId = 1 and A.EndDate is null
	
	left outer join APTLIVE.dbo.IntegerHistory EEX on EEX.ParentUID = EE.EmployeeUID and EEX.CatID = 4137 and EEX.Value = 4119

	left outer join APTLIVE.dbo.IntegerHistory EEJC on EEJC.ParentUID = EE.EmployeeUID and EEJC.CatID = 1002

	left outer join APTLIVE.dbo.CurrencyHistory BASSAL1 on BASSAL1.ParentUID = EE.EmployeeUID and BASSAL1.CatID = 201 --BASSAL
	left outer join APTLIVE.dbo.CurrencyHistory PENSAL1 on PENSAL1.ParentUID = EE.EmployeeUID and PENSAL1.CatID = 203 --PENSAL

	left outer join APTLIVE.dbo.JobClass JC1 on JC1.JobClassUID = EEJC.Value

	inner join APTLIVE.dbo.SchemeMember SM1 on SM1.EmployeeUID = EE.EmployeeUID

	left outer join APTLIVE.dbo.IntegerHistory E2X on E2X.ParentUID = E2.EmployeeUID and E2X.CatID = 4137 and E2X.Value = 4119

	left outer join APTLIVE.dbo.IntegerHistory E2JC on E2JC.ParentUID = E2.EmployeeUID and E2JC.CatID = 1002

	left outer join APTLIVE.dbo.CurrencyHistory BASSAL2 on BASSAL2.ParentUID = E2.EmployeeUID and BASSAL2.CatID = 201 --BASSAL
	left outer join APTLIVE.dbo.CurrencyHistory PENSAL2 on PENSAL2.ParentUID = E2.EmployeeUID and PENSAL2.CatID = 203 --PENSAL

	left outer join APTLIVE.dbo.JobClass JC2 on JC2.JobClassUID = E2JC.Value

	left outer join APTLIVE.dbo.SchemeMember SM2 on SM2.EmployeeUID = E2.EmployeeUID

	where P.Reference like 'IP-%'
	or P.Reference like 'RY-%';

	insert into IP_PF_PROFILE_DIFF
	select 
		[Username],
		[PersonUID],

		[PPSN],
		[Surname],
		[Forename],

		[Address1],
		[Address2],
		[Address3],
		[Address4],

		[PhoneHome],
		[PhoneMobile],
		[Email],

		[DateOfBirth],
		[Gender],
		[MaritalStatus]
	from IP_PF_LOCAL
	EXCEPT
	select
		[Username],
		[PersonUID],

		[PPSN],
		[Surname],
		[Forename],

		[Address1],
		[Address2],
		[Address3],
		[Address4],

		[PhoneHome],
		[PhoneMobile],
		[Email],

		[DateOfBirth],
		[Gender],
		[MaritalStatus]
	from IP_PF_ARC;

	insert into IP_PF_SR_DIFF
	select 
		[Username],
		[PersonUID],

		[DateEmpStart_1],
		[DateEmpCease_1],
		[DateJoinedScheme_1],
		[SchemeCategory_1],
		[PensionableSalary_1],
		[TransferIn_1],
		[NormalRetDate_1],

		[DateEmpStart_2],
		[DateEmpCease_2],
		[DateJoinedScheme_2],
		[SchemeCategory_2],
		[PensionableSalary_2],
		[TransferIn_2],
		[NormalRetDate_2],
	
		[FinalSalary_1],
		[FinalSalary_2]
	from IP_PF_LOCAL
	EXCEPT
	select
		[Username],
		[PersonUID],

		[DateEmpStart_1],
		[DateEmpCease_1],
		[DateJoinedScheme_1],
		[SchemeCategory_1],
		[PensionableSalary_1],
		[TransferIn_1],
		[NormalRetDate_1],

		[DateEmpStart_2],
		[DateEmpCease_2],
		[DateJoinedScheme_2],
		[SchemeCategory_2],
		[PensionableSalary_2],
		[TransferIn_2],
		[NormalRetDate_2],

		[FinalSalary_1],
		[FinalSalary_2]
	from IP_PF_ARC;

	insert into dbo.IP_WEB_LOCAL
	select *
	from [10.192.23.10].IPPP.dbo.IP_WEB;

	insert into IP_WEB_PERSON_DIFF
	select
		[Username],
		[PersonUID],

		[PPSN],
		[Surname],
		[Forename],
		[DateOfBirth],
		[Gender],
		[blnCorrect]
	from IP_WEB_LOCAL
	EXCEPT
	select
		[Username],
		[PersonUID],

		[PPSN],
		[Surname],
		[Forename],
		[DateOfBirth],
		[Gender],
		[blnCorrect]
	from IP_WEB_ARCHIVE;

	insert into IP_WEB_ADDRESS_DIFF
	select
		[Username],
		[PersonUID],

		[Address1],
		[Address2],
		[Address3],
		[Address4],
		[PhoneHome]
	from IP_WEB_LOCAL
	EXCEPT
	select
		[Username],
		[PersonUID],

		[Address1],
		[Address2],
		[Address3],
		[Address4],
		[PhoneHome]
	from IP_WEB_ARCHIVE;

	insert into IP_WEB_EMAIL_DIFF
	select
		[Username],
		[PersonUID],

		[Email]
	from IP_WEB_LOCAL
	EXCEPT
	select
		[Username],
		[PersonUID],

		[Email]
	from IP_WEB_ARCHIVE;

	insert into IP_WEB_MOBILE_DIFF
	select
		[Username],
		[PersonUID],

		[PhoneMobile]
	from IP_WEB_LOCAL
	EXCEPT
	select
		[Username],
		[PersonUID],

		[PhoneMobile]
	from IP_WEB_ARCHIVE;

	insert into IP_WEB_MARSTATUS_DIFF
	select
		[Username],
		[PersonUID],

		[MaritalStatus]
	from IP_WEB_LOCAL
	EXCEPT
	select
		[Username],
		[PersonUID],

		[MaritalStatus]
	from IP_WEB_ARCHIVE;

	insert into IP_WEB_SR_DIFF
	select
		[Username],
		[PersonUID],

		[DateEmpStart_m1],
		[DateEmpCease_m1],
		[DateJoinedScheme_m1],
		[SchemeCategory_m1],
		[PensionableSalary_m1],
		[TransferIn_m1],
		[NormalRetDate_m1],

		[DateEmpStart_m2],
		[DateEmpCease_m2],
		[DateJoinedScheme_m2],
		[SchemeCategory_m2],
		[PensionableSalary_m2],
		[TransferIn_m2],
		[NormalRetDate_m2],
		
		[FinalSalary_m1],
		[FinalSalary_m2]
	from IP_WEB_LOCAL
	EXCEPT
	select
		[Username],
		[PersonUID],

		[DateEmpStart_m1],
		[DateEmpCease_m1],
		[DateJoinedScheme_m1],
		[SchemeCategory_m1],
		[PensionableSalary_m1],
		[TransferIn_m1],
		[NormalRetDate_m1],

		[DateEmpStart_m2],
		[DateEmpCease_m2],
		[DateJoinedScheme_m2],
		[SchemeCategory_m2],
		[PensionableSalary_m2],
		[TransferIn_m2],
		[NormalRetDate_m2],
		
		[FinalSalary_m1],
		[FinalSalary_m2]
	from IP_WEB_ARCHIVE;

END TRY

BEGIN CATCH
	SELECT	@ErrorMessage = 'Error in procedure Synch_IP_PREP: ' + ERROR_MESSAGE(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE();

	RAISERROR (	@ErrorMessage,
			@ErrorSeverity,
			@ErrorState	);

	if @@TRANCOUNT > 0
		rollback transaction;
END CATCH






GO


