use IPPP
go


select * from IPPP.dbo.IP_WEB_ARCHIVE where Username = 'IP-Adamson214A'
select * from [10.192.23.11].IPPP.dbo.IP_WEB where Username = 'IP-Adamson214A'

select P.Forename, P.Surname, P.DateOfBirth, A.*
from APTLive.dbo.Person P
inner join APTLive.dbo.Address A on A.ParentUID = P.PersonUID
where P.Reference = 'IP-Adamson214A'

select P.Forename, P.Surname, C.*
from APTLive.dbo.Person P
inner join APTLive.dbo.Communications C on C.ParentUID = P.PersonUID
where P.Reference = 'IP-Adamson214A'

select P.* from APT2012.dbo.aspnet_Users U
inner join APT2012.dbo.aspnet_Profile P
on P.UserId = U.userid
where U.Username = 'IP-Adamson214A'
