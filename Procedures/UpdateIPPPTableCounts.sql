USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[UpdateIPPPTableCounts]    Script Date: 12/09/2013 11:42:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateIPPPTableCounts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateIPPPTableCounts]
GO

USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[UpdateIPPPTableCounts]    Script Date: 12/09/2013 11:42:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[UpdateIPPPTableCounts]
@UpdateOrCompare	char(1) = 'C'
AS
set nocount on

/* Declare constants */
declare	@SUCCESS    integer,
		@FAILURE    integer

/* Initialise constants */
select	@SUCCESS = 0,
		@FAILURE = 1

/* Declare variables */
declare	@errorMessage           varchar(255),
		@errorAdditionalInfo    varchar(255)
declare @x varchar(100), @sql varchar(2000)

if (select count(1) from dbo.IPPP_TABLE_COUNTS) = 0
begin
	insert into dbo.IPPP_TABLE_COUNTS (
		table_name
	)
	SELECT [name] FROM sys.objects WHERE type in (N'U')
end

update dbo.IPPP_TABLE_COUNTS set new_count = null

/* find new records */
if @UpdateOrCompare in('U','C')
begin
	select @x = min(table_name) from dbo.IPPP_TABLE_COUNTS

	while @x is not null
	begin
		--select @x as table_to_be_updated

		select @sql = 'declare @myCount integer; select @myCount = count(1) from IPPP.dbo.' + @x +
		'; update dbo.IPPP_TABLE_COUNTS set new_count = @myCount where table_name=' +
		CHAR(39) + @x + CHAR(39) + ';'

		exec (@sql)

		select @x = min(table_name) from dbo.IPPP_TABLE_COUNTS where table_name > @x
	end

	if @UpdateOrCompare = 'C'
		select	table_name,
				record_count,
				new_count,
				new_count - record_count as difference
		from dbo.IPPP_TABLE_COUNTS
		where isnull(new_count,0) <> isnull(record_count,0)
		order by table_name
end

/* update record counts */
if @UpdateOrCompare = 'U'
begin
	update	dbo.IPPP_TABLE_COUNTS
	set		record_count = new_count
	where		isnull(record_count,0) <> isnull(new_count,0)

	select	table_name,
			record_count
	from dbo.IPPP_TABLE_COUNTS
	where record_count <> 0
	order by table_name
end

/* Error handler */
if @@error = 0
begin
	return @SUCCESS
end

select	@errorMessage = 'SYBASE : Failed Stored Procedure [dbo].UpdateIPPPTableCounts'
select	@errorAdditionalInfo = 'SYBASE : Failed Stored Procedure [dbo].UpdateIPPPTableCounts'

ErrorHandler:
	select	@errorMessage as result
	raiserror	65505	@errorMessage
    
	return	@FAILURE


GO


