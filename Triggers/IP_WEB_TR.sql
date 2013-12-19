USE [IPPP]
GO

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_TR]'))
begin
	DROP TRIGGER [dbo].[IP_WEB_TR]
	
	IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_TR]'))
		PRINT '*** UNABLE to Drop Trigger: IP_WEB_TR'
	ELSE
		PRINT 'DROPPED Trigger: IP_WEB_TR'
end
GO

USE [IPPP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create trigger [dbo].[IP_WEB_TR]
on [dbo].[IP_WEB]
for insert, update, delete
AS

if (select count(1) from inserted) = 0
and (select count(1) from deleted) = 0
	return;

DECLARE	@ErrorMessage	NVARCHAR(4000),
	@ErrorSeverity	INT,
	@ErrorState	INT,
	@triggerTime	datetime;

BEGIN TRY
	select @triggerTime = getdate();

	if (select count(1) from deleted) > 0
	insert into [dbo].[_IP_WEB] (
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
		[MemberServiceUpdateAt],

		_CreatedWhy,
		_CreatedWhen,
		_CreatedBy,
		_CreatedOn,
		_CreatedIn
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
		[MemberServiceUpdateAt],

		case when (select count(1) from inserted) = 0 then 'Delete' else 'Update-Del' end,
		@triggerTime,
		suser_name(),
		@@Servername,
		db_name()
	from		deleted D;

	if (select count(1) from inserted) > 0
	insert into [dbo].[_IP_WEB] (
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
		[MemberServiceUpdateAt],

		_CreatedWhy,
		_CreatedWhen,
		_CreatedBy,
		_CreatedOn,
		_CreatedIn
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
		[MemberServiceUpdateAt],

		case when (select count(1) from deleted) = 0 then 'Insert' else 'Update-Ins' end,
		@triggerTime,
		suser_name(),
		@@Servername,
		db_name()
	from		inserted I;
END TRY

BEGIN CATCH
	SELECT	@ErrorMessage = 'Error in IP_WEB_TR: ' + ERROR_MESSAGE(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE();

	RAISERROR (	@ErrorMessage,
			@ErrorSeverity,
			@ErrorState	);

	if @@TRANCOUNT > 0
		rollback transaction;
END CATCH
GO

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[IP_WEB_TR]'))
	PRINT 'CREATED Trigger: IP_WEB_TR'
ELSE
	PRINT '*** UNABLE to create Trigger: IP_WEB_TR'
GO