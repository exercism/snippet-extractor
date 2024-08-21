@echo off
:: Disable command echoing

SET source_dir=C:\Users\Username\Documents
SET backup_dir=D:\Backup

REM Notify start of backup
echo Starting backup...

IF NOT EXIST "%source_dir%" (
    REM Exit if source directory is missing
    echo Source not found. Exiting...
    exit /b
)

IF NOT EXIST "%backup_dir%" (
    REM Create backup directory if it does not exist
    echo Creating backup directory...
    mkdir "%backup_dir%"
)

xcopy "%source_dir%\*" "%backup_dir%\" /E /I /Y
:: Perform backup, including subdirectories

echo Backup complete.
pause
