use ippp
go

exec UpdateIPPPTableCounts 'U'
go
exec Synch_IP_PREP
go
exec UpdateIPPPTableCounts 'C'
go
exec Synch_IP_DATA
go
exec UpdateIPPPTableCounts 'C'
go
exec Synch_IP_TIDYUP
go
exec UpdateIPPPTableCounts 'C'
go

select * from _ip_web where username in ('IP-Blaney135W','IP-Dineen184J')
order by username,_createdwhen desc,_createdwhy desc
go
