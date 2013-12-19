USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[Synch_IP_CONTROL]    Script Date: 12/19/2013 10:51:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Synch_IP_CONTROL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Synch_IP_CONTROL]
GO

USE [IPPP]
GO

/****** Object:  StoredProcedure [dbo].[Synch_IP_CONTROL]    Script Date: 12/19/2013 10:51:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Synch_IP_CONTROL]
AS

DECLARE	@ErrorMessage NVARCHAR(4000),
	@ErrorSeverity INT,
	@ErrorState INT;

BEGIN TRY
	--exec UpdateIPPPTableCounts 'U';
	exec Synch_IP_PREP;
	exec Synch_IP_DATA;
	exec Synch_IP_TIDYUP;
	--exec UpdateIPPPTableCounts 'C';
END TRY

BEGIN CATCH
	SELECT	@ErrorMessage = 'Error in procedure Synch_IP_CONTROL: ' + ERROR_MESSAGE(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE();

	RAISERROR (	@ErrorMessage,
			@ErrorSeverity,
			@ErrorState	);

	if @@TRANCOUNT > 0
		rollback transaction;
END CATCH

GO


