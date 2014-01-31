USE [IPPP]
GO

/*
Environments:	DEV use APTLIVE, .10/11 commented out
		QA use APTLIVE, .11
		PROD use APTLIVE, .10
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Synch_IP_TIDYUP]') AND type in (N'P', N'PC'))
begin
	DROP PROCEDURE [dbo].[Synch_IP_TIDYUP]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Synch_IP_TIDYUP]') AND type in (N'P', N'PC'))
		PRINT '*** UNABLE to Drop Procedure: Synch_IP_TIDYUP'
	ELSE
		PRINT 'DROPPED Procedure: Synch_IP_TIDYUP'
end
GO

USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[Synch_IP_TIDYUP]    Script Date: 11/19/2013 09:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Synch_IP_TIDYUP]
AS
set nocount on;

DECLARE	@ErrorMessage NVARCHAR(4000),
	@ErrorSeverity INT,
	@ErrorState INT;

BEGIN TRY
	delete from IP_PF_ARC;
	delete from IP_WEB_ARCHIVE;

	insert into dbo.IP_PF_ARC
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
			as PensionableSalary_1,
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

	insert into dbo.IP_WEB_ARCHIVE
	select *
	from [10.192.23.10].IPPP.dbo.IP_WEB;

	--Local ASP Tables now, just for the hell of it
	
	update P
	set		P.LastName = X.Surname,
			P.FirstName = X.Forename,
			P.Address1 = X.Address1,
			P.Address2 = X.Address2,
			P.Address3 = X.Address3,
			P.Address4 = X.Address4,
			P.PhoneHome = X.PhoneHome,
			P.PhoneMobile = X.PhoneMobile
	from APT2012.dbo.aspnet_Profile P
	inner join APT2012.dbo.aspnet_Users U on U.UserId = P.UserId
	inner join
	(
	select	Username,
			Surname,
			Forename,
			Address1,
			Address2,
			Address3,
			Address4,
			PhoneHome,
			PhoneMobile
	from IPPP.dbo.IP_WEB_ARCHIVE W

	except

	select	U.UserName,
			P.LastName,
			P.FirstName,
			P.Address1,
			P.Address2,
			P.Address3,
			P.Address4,
			P.PhoneHome,
			P.PhoneMobile
	from APT2012.dbo.aspnet_Profile P
	inner join APT2012.dbo.aspnet_Users U on U.UserId = P.UserId
	) X
	on X.Username = U.UserName

	update M
	set		M.Email = X.Email
	from APT2012.dbo.aspnet_Membership M
	inner join APT2012.dbo.aspnet_Users U on U.UserId = M.UserId
	inner join
	(
	select	Username,
			Email
	from IPPP.dbo.IP_WEB_ARCHIVE W

	except

	select	U.UserName,
			M.Email
	from APT2012.dbo.aspnet_Membership M
	inner join APT2012.dbo.aspnet_Users U on U.UserId = M.UserId
	) X
	on X.Username = U.UserName

	delete from APT2012.dbo.ASP_PROFILE_UPDATES
	where UserId in (
	select UserId from APT2012.dbo.aspnet_Users where UserName like 'IP-%'
	)

	delete from APT2012.dbo.ASP_PROFILE_UPDATE_LOG
	where UserId in (
	select UserId from APT2012.dbo.aspnet_Users where UserName like 'IP-%'
	)
END TRY

BEGIN CATCH
	SELECT	@ErrorMessage = 'Error in procedure Synch_IP_TIDYUP: ' + ERROR_MESSAGE(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE();

	RAISERROR (	@ErrorMessage,
			@ErrorSeverity,
			@ErrorState	);

	if @@TRANCOUNT > 0
		rollback transaction;
END CATCH





GO


