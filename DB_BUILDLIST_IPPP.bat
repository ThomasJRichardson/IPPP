REM %1 is app
REM %2 is environment- DEV SIT QA PROD
REM %3 is version e.g. 2.1 used as a subdirectory for DEV SIT and QA environments
REM %4 is server
REM %5 is database
REM %6 is source location

set app=%1
set envir=%2
set version=%3
set server=%4
set db=%5
set sqldir=%6

set dbcmd=sqlcmd -S %server% -d %db% -E -i %sqldir%

echo %DATE% %TIME%

echo App: %app% %envir% %version%
echo Db: %server%.%db%
echo Source: %sqldir%
echo Cmd: %dbcmd%
echo.

%dbcmd%\Tables\_IP_WEB.sql
%dbcmd%\Tables\IP_PF_ARC.sql
%dbcmd%\Tables\IP_PF_LOCAL.sql
%dbcmd%\Tables\IP_PF_PROFILE_DIFF.sql
%dbcmd%\Tables\IP_PF_PROFILE_LOG.sql
%dbcmd%\Tables\IP_PF_SR_DIFF.sql
%dbcmd%\Tables\IP_PF_SR_LOG.sql
%dbcmd%\Tables\IP_WEB.sql
%dbcmd%\Tables\IP_WEB_ADDRESS_DIFF.sql
%dbcmd%\Tables\IP_WEB_ADDRESS_LOG.sql
%dbcmd%\Tables\IP_WEB_ARCHIVE.sql
%dbcmd%\Tables\IP_WEB_EMAIL_DIFF.sql
%dbcmd%\Tables\IP_WEB_EMAIL_LOG.sql
%dbcmd%\Tables\IP_WEB_LOCAL.sql
%dbcmd%\Tables\IP_WEB_MARSTATUS_DIFF.sql
%dbcmd%\Tables\IP_WEB_MARSTATUS_LOG.sql
%dbcmd%\Tables\IP_WEB_MOBILE_DIFF.sql
%dbcmd%\Tables\IP_WEB_MOBILE_LOG.sql
%dbcmd%\Tables\IP_WEB_PERSON_DIFF.sql
%dbcmd%\Tables\IP_WEB_PERSON_LOG.sql
%dbcmd%\Tables\IP_WEB_SR_DIFF.sql
%dbcmd%\Tables\IP_WEB_SR_LOG.sql

%dbcmd%\Triggers\IP_WEB_TR.sql

%dbcmd%\Procedures\%2\Synch_IP_DATA.sql
%dbcmd%\Procedures\%2\Synch_IP_PREP.sql
%dbcmd%\Procedures\Synch_IP_Control.sql
%dbcmd%\Procedures\UpdateIPPPTableCounts.sql

echo ==============Done!=======================

