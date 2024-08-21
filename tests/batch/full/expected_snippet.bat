@echo off

SET source_dir=C:\Users\Username\Documents
SET backup_dir=D:\Backup

echo Starting backup...

IF NOT EXIST "%source_dir%" (
    echo Source not found. Exiting...
    exit /b
)

IF NOT EXIST "%backup_dir%" (
    echo Creating backup directory...
    mkdir "%backup_dir%"
)

xcopy "%source_dir%\*" "%backup_dir%\" /E /I /Y

echo Backup complete.
pause
