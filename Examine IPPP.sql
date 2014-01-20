use IPPP
go

select W.Username,W.surname,W.forename,M.password, M.IsLockedOut, W.Address1, W.email, W.MaritalStatus, W.dateofbirth,
M.FailedPasswordAttemptCount,
M.LastLoginDate,M.FailedPasswordAttemptWindowStart,M.LastLockoutDate, W.*
from IP_WEB_ARCHIVE W
inner join APT2012.dbo.aspnet_Users U on U.UserName = W.Username
inner join APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
--where W.Username in('IP-Campbell754D','IP-McCarth944T','IP-Singleto51PW','IP-McGinn021T')
where W.Username = 'IP-Carney003L'
order by W.Surname,W.Forename

select W.Username,W.forename,M.password, M.IsLockedOut, W.Address1, W.email, W.MaritalStatus, W.dateofbirth,
M.FailedPasswordAttemptCount,
M.LastLoginDate,M.FailedPasswordAttemptWindowStart,M.LastLockoutDate,
W.*
from [10.192.23.10].IPPP.dbo.IP_WEB W
inner join [10.192.23.10].APT2012.dbo.aspnet_Users U on U.UserName = W.Username
inner join [10.192.23.10].APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
where W.Username = 'IP-Carney003L'

select W.username,W.forename,M.password,M.IsLockedOut,M.FailedPasswordAttemptCount,
M.LastLoginDate,M.FailedPasswordAttemptWindowStart,M.LastLockoutDate
from [10.192.23.10].ippp.dbo.IP_WEB W
inner join [10.192.23.10].APT2012.dbo.aspnet_Users U on U.UserName = W.Username
inner join [10.192.23.10].APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
where M.FailedPasswordAttemptCount > 1 or M.IsLockedOut = 1

use IPPP
go
select W.username,W.forename,M.password,M.IsLockedOut,M.FailedPasswordAttemptCount,
M.LastLoginDate,M.FailedPasswordAttemptWindowStart,M.LastLockoutDate
from ippp.dbo.IP_WEB W
inner join APT2012.dbo.aspnet_Users U on U.UserName = W.Username
inner join APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
where M.FailedPasswordAttemptCount > 1 or M.IsLockedOut = 1

--Generic
select W.Username,
L.password as lp,M.password as rp,
L.PasswordFormat as lf, M.PasswordFormat as rf,
L.PasswordSalt as Ls, M.PasswordSalt as rs,
L.IsLockedOut as lx, M.IsLockedOut as rx,M.Email,
P.*
from [10.192.23.10].APT2012.dbo.aspnet_users W
inner join [10.192.23.10].APT2012.dbo.aspnet_Users U on U.UserID = W.UserID
inner join [10.192.23.10].APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
inner join [10.192.23.10].APT2012.dbo.aspnet_Profile P on P.UserId = U.userid
inner join APT2012.dbo.aspnet_Membership L on L.UserId = U.userid
where W.Username in('749257')
--where P.SchemeId = 17105163 and M.PasswordFormat = 0
