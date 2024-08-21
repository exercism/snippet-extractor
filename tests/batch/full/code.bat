@echo off
:: Disable command echoing

SET source_dir=C:\Users\Username\Documents

REM Notify start of backup
echo Starting backup...

IF NOT EXIST "%source_dir%" (
    REM Exit if source directory is missing
    echo Source not found. Exiting...
    exit /b
)