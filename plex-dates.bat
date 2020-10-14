@ECHO OFF
setlocal
ECHO ========================================================
echo.
ECHO plex-dates.bat
echo.
ECHO https://github.com/Loomaanaatii/plex-dates
echo.
ECHO This script fixes the common error where media is added in the future upon library rescans
echo.
ECHO ========================================================
echo.
echo.
ECHO NOTICE:
ECHO By using this script, you are taking full responsibility of the outcomes. 
ECHO Never run a script you havent checked! Look first. 
PAUSE
echo.
echo.
ECHO This script requires you have the sqlite3.exe tool added to Windows PATH.
ECHO You can download this from https://sqlite.org/download.html and selecting the "sqlite-tools-win32-x86-xxxxx.zip" 
echo.
ECHO Detailed instructions to add sqlite3.exe to path are on the wiki:
echo.
ECHO https://github.com/Loomaanaatii/plex-dates/wiki/How-to-add-sqlite3.exe-to-path
echo.
echo.
PAUSE

:ask
ECHO Do you have sqlite3 in path? (y/n)
set INPUT= 
set /p INPUT= %=%
If /I "%INPUT%"=="y" goto yes 
If /I "%INPUT%"=="n" goto no
goto ask

:yes

ECHO Sqlite3 is installed, executing script...

for /f "tokens=1-4 delims=/ " %%i in ("%date%") do (
set day=%%j
set month=%%k
set year=%%l
)

ECHO Killing Plex Media Server.exe
taskkill /f /im "Plex Media Server.exe"

ECHO Pausing for 2 seconds before starting database backup....
timeout /t 2

ECHO Backing Up Database to "C:\Users\%USERNAME%\Documents\PlexDB Backups"
mkdir "C:\Users\%USERNAME%\Documents\PlexDB Backups"
copy "C:\Users\%USERNAME%\AppData\Local\Plex Media Server\Plug-in Support\Databases\com.plexapp.plugins.library.db" "C:\Users\%USERNAME%\Documents\PlexDB Backups\com.plexapp.plugins.library.db - %year%-%month%-%day%"

ECHO Fixing DB Dates
sqlite3 "C:\Users\%USERNAME%\AppData\Local\Plex Media Server\Plug-in Support\Databases\com.plexapp.plugins.library.db" "UPDATE metadata_items SET added_at = originally_available_at WHERE DATETIME(added_at) > DATETIME('now');"
sqlite3 "C:\Users\%USERNAME%\AppData\Local\Plex Media Server\Plug-in Support\Databases\com.plexapp.plugins.library.db" "UPDATE metadata_items SET added_at = originally_available_at WHERE DATETIME(added_at) > DATETIME('now');"

ECHO Completed! :)

ECHO Restarting Plex...
START "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe"

goto exit

:no
ECHO Please re-run script when sqlite3.exe has been added to path. 
echo.
ECHO https://github.com/Loomaanaatii/plex-dates/wiki/How-to-add-sqlite3.exe-to-path
echo.

:exit
PAUSE
ECHO Exiting...
EXIT