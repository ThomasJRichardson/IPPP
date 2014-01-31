USE [IPPP]
GO

/*
Environments:	DEV use APTTEST, .10/11 commented out
		QA use APTLIVE, .11
		PROD use APTLIVE, .10
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Synch_IP_DATA]') AND type in (N'P', N'PC'))
begin
	DROP PROCEDURE [dbo].[Synch_IP_DATA]

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Synch_IP_DATA]') AND type in (N'P', N'PC'))
		PRINT '*** UNABLE to Drop Procedure: Synch_IP_DATA'
	ELSE
		PRINT 'DROPPED Procedure: Synch_IP_DATA'
end
GO

USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[Synch_IP_DATA]    Script Date: 11/19/2013 09:32:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Synch_IP_DATA]
AS

DECLARE	@ErrorMessage NVARCHAR(4000),
	@ErrorSeverity INT,
	@ErrorState INT;

BEGIN TRY
	--Write profile updates into Profund

	Update P
	set	P.Salutation = case when isnull(U.PPSN,'') = '' then P.Salutation else U.PPSN end,
		P.Surname = case when isnull(U.Surname,'') = '' then P.Surname else U.Surname end,
		P.Forename = case when isnull(U.Forename,'') = '' then P.Forename else U.Forename end,
		P.DateOfBirth = case when isdate(U.DateOfBirth) = 0 then P.DateOfBirth else U.DateOfBirth end,
		P.Sex = case when isnull(U.Gender,'') = '' then P.Sex else U.Gender end,
		P.PrevSurname = case	when U.blnCorrect is null then 'NotUpdated'
					when U.blnCorrect = 0 then 'Rejected'
					when U.blnCorrect = 1 then 'Verified'	end
	from		IP_WEB_PERSON_DIFF U
	inner join	APTLIVE.dbo.Person P on P.PersonUID = U.PersonUID;

		select convert(varchar,@@ROWCOUNT) + ' Profund Person updates by Synch_IP_DATA';

	update	A
	set	A.Line1 = case when isnull(U.Address1,'') = '' then A.Line1 else U.Address1 end,
		A.Line2 = case when isnull(U.Address1,'') = '' then A.Line2 else U.Address2 end,
		A.Line3 = case when isnull(U.Address1,'') = '' then A.Line3 else U.Address3 end,
		A.Line4 = case when isnull(U.Address1,'') = '' then A.Line4 else U.Address4 end,
		A.TelephoneNumber = case when isnull(U.PHoneHome,'') = '' then A.TelephoneNumber else U.PhoneHome end
	from		IP_WEB_ADDRESS_DIFF U
	inner join	APTLIVE.dbo.Person P on P.PersonUID = U.PersonUID
	inner join	APTLIVE.dbo.Address A on A.ParentUID = P.PersonUID and A.CatID = 1; --and A.Enddate is null

		select convert(varchar,@@ROWCOUNT) + ' Profund Address updates by Synch_IP_DATA';

	insert into APTLIVE.dbo.Address (
		ParentUID,
		CatID,
		EffDate,
		Line1,
		Line2,
		Line3,
		Line4,
		TelephoneNumber,
		CreationStamp, WFCreatorID, CreatorStepID, WFOwnerID, OWnerStepID
	)
	select	P.PersonUID,
		1,
		getdate(),
		U.Address1,
		U.Address2,
		U.Address3,
		U.Address4,
		U.PhoneHome,
		getdate(), 1, 1, 1, 1
	from		IP_WEB_ADDRESS_DIFF U
	inner join	APTLIVE.dbo.Person P on P.PersonUID = U.PersonUID
	where	not exists (select 1 from APTLIVE.dbo.Address A where A.ParentUID = P.PersonUID and A.CatID = 1 and A.Enddate is null);

		select convert(varchar,@@ROWCOUNT) + ' Profund Address inserts by Synch_IP_DATA';

	update	C
	set	C.Value = U.Email
	from		IP_WEB_EMAIL_DIFF U
	inner join	APTLIVE.dbo.Person P on P.PersonUID = U.PersonUID
	inner join	APTLIVE.dbo.Communications C on C.ParentUID = P.PersonUID and C.CatID = 802;

		select convert(varchar,@@ROWCOUNT) + ' Profund Email updates by Synch_IP_DATA';

	insert into APTLIVE.dbo.Communications (
		ParentUID,
		CatID,
		EffDate,
		Value,
		CreationStamp, WFCreatorID, CreatorStepID, WFOwnerID, OWnerStepID
	)
	select	P.PersonUID,
		802,
		getdate(),
		U.Email,
		getdate(), 1, 1, 1, 1
	from		IP_WEB_EMAIL_DIFF U
	inner join	APTLIVE.dbo.Person P on P.PersonUID = U.PersonUID
	where	not exists (select 1 from APTLIVE.dbo.Communications where ParentUID = P.PersonUID and CatID = 802);

		select convert(varchar,@@ROWCOUNT) + ' Profund Email inserts by Synch_IP_DATA';

	update C
	set	C.Value = U.PhoneMobile
	from		IP_WEB_MOBILE_DIFF U
	inner join	APTLIVE.dbo.Person P on P.PersonUID = U.PersonUID
	inner join	APTLIVE.dbo.Communications C on C.ParentUID = P.PersonUID and C.CatID = 800;

		select convert(varchar,@@ROWCOUNT) + ' Profund Mobile updates by Synch_IP_DATA';

	insert into APTLIVE.dbo.Communications (
		ParentUID,
		CatID,
		EffDate,
		Value,
		CreationStamp, WFCreatorID, CreatorStepID, WFOwnerID, OWnerStepID
	)
	select	P.PersonUID,
		800,
		getdate(),
		U.PhoneMobile,
		getdate(), 1, 1, 1, 1
	from		IP_WEB_MOBILE_DIFF U
	inner join	APTLIVE.dbo.Person P on P.PersonUID = U.PersonUID
	where	not exists (select 1 from APTLIVE.dbo.Communications where ParentUID = P.PersonUID and CatID = 800);

		select convert(varchar,@@ROWCOUNT) + ' Profund Mobile inserts by Synch_IP_DATA';

	update	M
	set	M.Value = case U.MaritalStatus	when 'Separated'	then 'APA'
						when 'Divorced'		then 'DIV'
						when 'Married'		then 'MAR'
						when 'Single'		then 'SIN'
		else 'UNK' end
	from		IP_WEB_MARSTATUS_DIFF U
	inner join	APTLIVE.dbo.Person P on P.PersonUID = U.PersonUID
	inner join	APTLIVE.dbo.StringHistory M on M.ParentUID = P.PersonUID and M.CatID = 1200;

		select convert(varchar,@@ROWCOUNT) + ' Profund Marital Status updates by Synch_IP_DATA';

	insert into APTLIVE.dbo.StringHistory (
		ParentUID,
		CatID,
		EffDate,
		Value,
		CreationStamp, WFCreatorID, CreatorStepID, WFOwnerID, OWnerStepID
	)
	select	P.PersonUID,
		1200,
		getdate(),
		case U.MaritalStatus		when 'Separated'	then 'APA'
						when 'Divorced'		then 'DIV'
						when 'Married'		then 'MAR'
						when 'Single'		then 'SIN'
		else 'UNK' end,
		getdate(), 1, 1, 1, 1
	from		IP_WEB_MARSTATUS_DIFF U
	inner join	APTLIVE.dbo.Person P on P.PersonUID = U.PersonUID
	where	not exists (select 1 from APTLIVE.dbo.StringHistory where ParentUID = P.PersonUID and CatID = 1200);

		select convert(varchar,@@ROWCOUNT) + ' Profund Marital Status inserts by Synch_IP_DATA';

	--NEW Web Records

	insert into [10.192.23.10].IPPP.dbo.IP_WEB (
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
		U1.[Username],
		U1.[PersonUID],

		U1.[PPSN],
		U1.[Surname],
		U1.[Forename],

		U1.[Address1],
		U1.[Address2],
		U1.[Address3],
		U1.[Address4],

		U1.[PhoneHome],
		U1.[PhoneMobile],
		U1.[Email],

		U1.[DateOfBirth],
		U1.[Gender],
		U1.[MaritalStatus],

		'APT',
		getdate(),

		U2.[DateEmpStart_1],
		U2.[DateEmpCease_1],
		U2.[DateJoinedScheme_1],
		U2.[SchemeCategory_1],
		U2.[PensionableSalary_1],
		U2.[TransferIn_1],
		U2.[NormalRetDate_1],

		U2.[DateEmpStart_2],
		U2.[DateEmpCease_2],
		U2.[DateJoinedScheme_2],
		U2.[SchemeCategory_2],
		U2.[PensionableSalary_2],
		U2.[TransferIn_2],
		U2.[NormalRetDate_2],

		getdate(),

		U2.[DateEmpStart_1],
		U2.[DateEmpCease_1],
		U2.[DateJoinedScheme_1],
		U2.[SchemeCategory_1],
		U2.[PensionableSalary_1],
		U2.[TransferIn_1],
		U2.[NormalRetDate_1],

		U2.[DateEmpStart_2],
		U2.[DateEmpCease_2],
		U2.[DateJoinedScheme_2],
		U2.[SchemeCategory_2],
		U2.[PensionableSalary_2],
		U2.[TransferIn_2],
		U2.[NormalRetDate_2],

		null,
		null
	from		IP_PF_PROFILE_DIFF U1
	left outer join	IP_PF_SR_DIFF U2 on U2.UserName = U1.UserName
	where not exists (select 1 from [10.192.23.10].IPPP.dbo.IP_WEB where Username = U1.Username);

		select convert(varchar,@@ROWCOUNT) + ' "WEB" inserts by Synch_IP_DATA';

	update W
	set
		W.[PPSN] = U.PPSN,
		W.[Surname] = U.Surname,
		W.[Forename] = U.Forename,

		W.[Address1] = U.Address1,
		W.[Address2] = U.Address2,
		W.[Address3] = U.Address3,
		W.[Address4] = U.Address4,

		W.[PhoneHome] = U.PhoneHome,
		W.[PhoneMobile] = U.PhoneMobile,
		W.[Email] = U.Email,

		W.[DateOfBirth] = U.DateOfBirth,
		W.[Gender] = U.Gender,
		W.[MaritalStatus] = U.MaritalStatus,

		W.[ProfileLastUpdateBy] = 'APT',
		W.[ProfileLastUpdateAt] = getdate()

		--W.[blnCorrect] = case	when U.ServiceRecordVerified = 'NotUpdated' then null
		--			when U.ServiceRecordVerified = 'Rejected' then 0
		--			when U.ServiceRecordVerified = 'Verified' then 1	end
	from		IP_PF_PROFILE_DIFF U
	inner join	[10.192.23.10].IPPP.dbo.IP_WEB W
		on		W.UserName = U.UserName;

		select convert(varchar,@@ROWCOUNT) + ' "WEB" Profile Updates by Synch_IP_DATA';

	update W
	set
		W.[DateEmpStart_1] = U.[DateEmpStart_1],
		W.[DateEmpCease_1] = U.[DateEmpCease_1],
		W.[DateJoinedScheme_1] = U.[DateJoinedScheme_1],
		W.[SchemeCategory_1] = U.[SchemeCategory_1],
		W.[PensionableSalary_1] = U.[PensionableSalary_1],
		W.[FinalSalary_1] = U.[FinalSalary_1],
		W.[TransferIn_1] = U.[TransferIn_1],
		W.[NormalRetDate_1] = U.[NormalRetDate_1],

		W.[DateEmpStart_2] = U.[DateEmpStart_2],
		W.[DateEmpCease_2] = U.[DateEmpCease_2],
		W.[DateJoinedScheme_2] = U.[DateJoinedScheme_2],
		W.[SchemeCategory_2] = U.[SchemeCategory_2],
		W.[PensionableSalary_2] = U.[PensionableSalary_2],
		W.[FinalSalary_2] = U.[FinalSalary_2],
		W.[TransferIn_2] = U.[TransferIn_2],
		W.[NormalRetDate_2] = U.[NormalRetDate_2],

		W.[ServiceLastUpdateAt] = getdate()
	from		IP_PF_SR_DIFF U
	inner join	[10.192.23.10].IPPP.dbo.IP_WEB W
		on		W.UserName = U.UserName;

		select convert(varchar,@@ROWCOUNT) + ' "WEB" Service Record Updates by Synch_IP_DATA';
END TRY

BEGIN CATCH
	SELECT	@ErrorMessage = 'Error in procedure Synch_IP_DATA: ' + ERROR_MESSAGE(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE();

	RAISERROR (	@ErrorMessage,
			@ErrorSeverity,
			@ErrorState	);

	if @@TRANCOUNT > 0
		rollback transaction;
END CATCH


GO


