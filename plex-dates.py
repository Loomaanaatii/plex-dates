import os
from datetime import date
import time

print("".ljust(65, "="))
print("")
print("https://github.com/Loomaanaatii/plex-dates")
print("")
print("This script fixes the common error where media is added in the future upon library rescans")
print("")
print("".ljust(65, "="))
print("")
print("")
print("By using this script, you are taking ful responsibility of the outcomes.")
print("Never run a script you haven't checked! Look first.")
input("Press enter to continue...")


print("This script requires you have the sqlite3.exe tool added to Windows PATH.")
print("You can download this from https://sqlite.org/download.html and selecting the \"sqlite-tools-win32-x86-xxxxx.zip\"")
print("")
print("Detailed instructions to add sqlite3.exe to path are on the wiki:")
print("")
print("https://github.com/Loomaanaatii/plex-dates/wiki/How-to-add-sqlite3.exe-to-path")
print("")
print("")
input("Press enter to continue...")


if (input("Do you have sqlite3 in path? (y/n)").lower() != 'y'):
    print("Please re-run script when sqlite3.exe has been added to path. ")
    print("")
    print("https://github.com/Loomaanaatii/plex-dates/wiki/How-to-add-sqlite3.exe-to-path")
    print("")
    exit()

print("Sqlite3 is installed, executing script...")

today = date.today()
day = today.day
month = today.month
year = today.year

print("Killing Plex Media Server.exe")
os.system("taskkill /f /im \"Plex Media Server.exe\"")

print("Pausing for 2 seconds before starting database backup...")
time.sleep(2)

plexDbPath = os.path.join('C:\\', 'Users', os.path.expandvars("%USERNAME%"), 'AppData', 'Local', 'Plex Media Server', 'Plug-in Support', 'Databases', 'com.plexapp.plugins.library.db')
backupPath = os.path.join('C:\\', 'Users', os.path.expandvars("%USERNAME%"), 'Documents', 'PlexDB Backups')
backupFileName = os.path.join(backupPath, 'com.plexapp.plugins.library.db - ' + str(year) + '-' + str(month) + '-' + str(day))

print("Backing Up Database to", backupFileName)
if not os.path.exists(backupPath):
    os.makedirs(backupPath)

os.system("copy \"{plexDb}\" \"{backupName}\"".format(plexDb=plexDbPath, backupName= backupFileName))

os.system("sqlite3 \"{plexDb}\" \"UPDATE metadata_items SET added_at = originally_available_at WHERE DATETIME(added_at) > DATETIME('now');\"".format(plexDb = plexDbPath))
os.system("sqlite3 \"{plexDb}\" \"UPDATE metadata_items SET added_at = originally_available_at WHERE DATETIME(added_at) > DATETIME('now');\"".format(plexDb = plexDbPath))

print("Completed! :)")
print("Restarting Plex...")

os.popen("START \"C:\\Program Files (x86)\\Plex\\Plex Media Server\\Plex Media Server.exe\"")
