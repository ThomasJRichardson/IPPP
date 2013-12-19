use IPPP
go

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

where P.Reference like 'IP-%'

order by P.PersonUID desc