USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[spResponseSummaryIP]    Script Date: 01/02/2014 14:22:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spResponseSummaryIP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spResponseSummaryIP]
GO

USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[spResponseSummaryIP]    Script Date: 01/02/2014 14:22:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create procedure
[dbo].[spResponseSummaryIP]
AS
select case blnCorrect
when null then 'No Response'
when 0 then 'Rejected'
when 1 then 'Confirmed'
end as Status,
count(1) as member_count
from IP_WEB_ARCHIVE
group by blnCorrect
GO

exec [spResponseSummaryIP]