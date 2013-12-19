USE [IPPP]
GO

/*
Environments:	DEV use APTTEST, .10/11 commented out
		QA use APTTEST, .11
		PROD use APTTEST, .10
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
		JC1.LongDesc as SchemeCategory_1,
		SAL1.Value as PensionableSalary_1,
		left(EE.PayrollNumber,1) as TransferIn_1,
		SM1.SchemeRetirementDate as NormalRetDate_1,

		E2.DateFirstEmployed as DateEmpStart_2,
		E2X.EffDate as DateEmpCease_2,
		SM2.DateJoinedScheme as DateJoinedScheme_2,
		JC2.LongDesc as SchemeCategory_2,
		SAL2.Value as PensionableSalary_2,
		left(E2.PayrollNumber,1) as TransferIn_2,
		SM2.SchemeRetirementDate as NormalRetDate_2,

		P.PrevSurname as ServiceRecordVerified

	from APTTEST.dbo.Person P

	left outer join APTTEST.dbo.Communications Email on Email.ParentUID = P.PersonUID and Email.Catid = 802
	left outer join APTTEST.dbo.Communications Mobile on Mobile.ParentUID = P.PersonUID and Mobile.Catid = 800

	left outer join APTTEST.dbo.StringHistory MAR on MAR.ParentUID = P.PersonUID and MAR.CatID = 1200

	inner join APTTEST.dbo.Employee EE on EE.PersonUID = P.PersonUID
		and EE.DateFirstEmployed = (select min(DateFirstEmployed) from APTTEST.dbo.Employee where PersonUID = P.PersonUID)

	left outer join APTTEST.dbo.Employee E2 on E2.PersonUID = P.PersonUID
		and E2.DateFirstEmployed <> EE.DateFirstEmployed

	left outer join APTTEST.dbo.Address A on A.ParentUID = P.PersonUID and A.CatId = 1
	
	left outer join APTTEST.dbo.IntegerHistory EEX on EEX.ParentUID = EE.EmployeeUID and EEX.CatID = 4137 and EEX.Value = 4119

	left outer join APTTEST.dbo.IntegerHistory EEJC on EEJC.ParentUID = EE.EmployeeUID and EEJC.CatID = 1002

	left outer join APTTEST.dbo.CurrencyHistory SAL1 on SAL1.ParentUID = EE.EmployeeUID and SAL1.CatID = 201

	left outer join APTTEST.dbo.JobClass JC1 on JC1.JobClassUID = EEJC.Value

	inner join APTTEST.dbo.SchemeMember SM1 on SM1.EmployeeUID = EE.EmployeeUID

	left outer join APTTEST.dbo.IntegerHistory E2X on E2X.ParentUID = E2.EmployeeUID and E2X.CatID = 4137 and E2X.Value = 4119

	left outer join APTTEST.dbo.IntegerHistory E2JC on E2JC.ParentUID = E2.EmployeeUID and E2JC.CatID = 1002

	left outer join APTTEST.dbo.CurrencyHistory SAL2 on SAL2.ParentUID = E2.EmployeeUID and SAL2.CatID = 201

	left outer join APTTEST.dbo.JobClass JC2 on JC2.JobClassUID = E2JC.Value

	left outer join APTTEST.dbo.SchemeMember SM2 on SM2.EmployeeUID = E2.EmployeeUID

	where P.Reference like 'IP-%';

	if (select count(1) from IP_PF_ARC) = 0
	begin
		update W
		set W.PErsonUID = P.PersonUID
		from		IP_WEB W
		inner join	APTTEST.dbo.Person P
			on		P.Reference = W.Username;

		insert into IP_PF_ARC
		select * from IP_PF_LOCAL;

		delete from IP_WEB_ARCHIVE;

		insert into IP_WEB_ARCHIVE
		select * from IP_WEB;
	end

	if (select count(1) from IP_WEB) = 0
	begin
		insert into [dbo].[IP_WEB] (
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
		[MaritalStatus],

		[ProfileLastUpdateBy],
		[ProfileLastUpdateAt],

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

		[ServiceLastUpdateAt],

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

		[blnCorrect],
		[MemberServiceUpdateAt]
		)
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
		[MaritalStatus],

		'APT',
		getdate(),

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

		getdate(),

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

		null,
		null
		from	IP_PF_LOCAL;

		delete from IP_WEB_ARCHIVE;

		insert into IP_WEB_ARCHIVE
		select * from IP_WEB;
	end

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
		[NormalRetDate_2]
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
		[NormalRetDate_2]
	from IP_PF_ARC;

	insert into dbo.IP_WEB_LOCAL
	select *
	from /*[10.192.23.11].*/IPPP.dbo.IP_WEB;

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
		[NormalRetDate_m2]
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
		[NormalRetDate_m2]
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

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Synch_IP_PREP]') AND type in (N'P', N'PC'))
	PRINT 'CREATED Procedure: Synch_IP_PREP'
ELSE
	PRINT '*** UNABLE to create Procedure: Synch_IP_PREP'
GO