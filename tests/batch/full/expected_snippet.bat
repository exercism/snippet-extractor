@echo off

SET source_dir=C:\Users\Username\Documents

echo Starting backup...

IF NOT EXIST "%source_dir%" (
    echo Source not found. Exiting...
    exit /b
)