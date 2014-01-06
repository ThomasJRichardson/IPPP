use IPPP
go

select W.Username,W.forename,M.password, M.IsLockedOut, W.Address1, W.email, W.MaritalStatus, W.dateofbirth,
M.FailedPasswordAttemptCount,
M.LastLoginDate,M.FailedPasswordAttemptWindowStart,M.LastLockoutDate
from IP_WEB_ARCHIVE W
inner join APT2012.dbo.aspnet_Users U on U.UserName = W.Username
inner join APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
--where W.Surname = 'Kerrigan'
where W.Username = 'IP-Kearney191J'

select W.Username,W.forename,M.password, M.IsLockedOut, W.Address1, W.email, W.MaritalStatus, W.dateofbirth,
M.FailedPasswordAttemptCount,
M.LastLoginDate,M.FailedPasswordAttemptWindowStart,M.LastLockoutDate
from [10.192.23.10].IPPP.dbo.IP_WEB W
inner join [10.192.23.10].APT2012.dbo.aspnet_Users U on U.UserName = W.Username
inner join [10.192.23.10].APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
where W.Username = 'IP-Kerrigan722J'

select W.username,W.forename,M.password,M.IsLockedOut,M.FailedPasswordAttemptCount,
M.LastLoginDate,M.FailedPasswordAttemptWindowStart,M.LastLockoutDate
from [10.192.23.10].ippp.dbo.IP_WEB W
inner join [10.192.23.10].APT2012.dbo.aspnet_Users U on U.UserName = W.Username
inner join [10.192.23.10].APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
where M.FailedPasswordAttemptCount > 1 or M.IsLockedOut = 1

use IPPP
go
exec dbo.spDataQueriesIP
go

use IPPP
go
exec dbo.spDataSetIP
go

use IPPP
go
exec dbo.spResponseSummaryIP
go

--Generic
select W.Username,
L.password as lp,M.password as rp,
L.PasswordFormat as lf, M.PasswordFormat as rf,
L.PasswordSalt as Ls, M.PasswordSalt as rs,
L.IsLockedOut as lx, M.IsLockedOut as rx
from [10.192.23.10].APT2012.dbo.aspnet_users W
inner join [10.192.23.10].APT2012.dbo.aspnet_Users U on U.UserID = W.UserID
inner join [10.192.23.10].APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
inner join APT2012.dbo.aspnet_Membership L on L.UserId = U.userid
where W.Username in('2000553K','7616936G','IP-ODonova69VW','IP-Coogan915M','IP-Galligan944J'
,'7640208H')