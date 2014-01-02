use IPPP
go

select W.Username,M.password, M.IsLockedOut, W.Address1, W.email, W.MaritalStatus,
M.LastPasswordChangedDate
from IP_WEB_ARCHIVE W
inner join APT2012.dbo.aspnet_Users U on U.UserName = W.Username
inner join APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
where W.Surname = 'Whelan' and W.Forename = 'Eric'
--where W.Username = 'IP-OReilly571B'

select W.username,W.forename,M.password,M.IsLockedOut,M.FailedPasswordAttemptCount,
M.LastLoginDate,M.FailedPasswordAttemptWindowStart,M.LastLockoutDate
from [10.192.23.10].ippp.dbo.IP_WEB W
inner join [10.192.23.10].APT2012.dbo.aspnet_Users U on U.UserName = W.Username
inner join [10.192.23.10].APT2012.dbo.aspnet_Membership M on M.UserId = U.userid
where M.FailedPasswordAttemptCount > 1 or M.IsLockedOut = 1

exec dbo.spDataQueriesIP