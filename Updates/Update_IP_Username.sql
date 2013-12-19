use APT2012
go
begin tran

declare @oldUname varchar(20), @newUname varchar(20)

select @oldUname = 'IP-Whiteable'
select @newUname = 'IP-White666P'

update APTLive.dbo.Person
set Reference = @newUname
where Reference = @oldUname

update APT2012.dbo.aspnet_users
set UserName = @newUname
where UserName = @oldUname

update IPPP.dbo.IP_WEB
set UserName = @newUname
where UserName = @oldUname

update IPPP.dbo.IP_WEB_ARCHIVE
set UserName = @newUname
where UserName = @oldUname

--update [10.192.23.11].IPPP.dbo.IP_WEB
--set UserName = @newUname
--where UserName = @oldUname

--update [10.192.23.11].IPPP.dbo.IP_WEB_ARCHIVE
--set UserName = @newUname
--where UserName = @oldUname

--update [10.192.23.10].IPPP.dbo.IP_WEB
--set UserName = @newUname
--where UserName = @oldUname

--update [10.192.23.10].IPPP.dbo.IP_WEB_ARCHIVE
--set UserName = @newUname
--where UserName = @oldUname
select * from IPPP.dbo.IP_WEB where Username = @newUname
rollback tran

select * from IPPP.dbo.IP_WEB where Username = @newUname