@echo off
setlocal EnableDelayedExpansion
(set \n=^
%=This is Mandatory Space=%
)

echo !n! ##################################################################
echo !n! Microsoft Viva Insights - Zoom Data Integration
echo !n! Role: Analyst
echo.
echo !n! NOTE:
echo !n! Please make sure the input directory has the Ways of Working Assessment Query and the Hashed Zoom File from Zoom Admin and UTC_offset.rds.
echo !n! Check that your file names are updated as per the format specified in the documentation before proceeding.
echo.
echo !n! ACTION REQUIRED:
echo !n! Please choose the path to 'Rscript.exe' for your R installation.
echo !n! For example: "C:\Program Files\R\R-4.0.5\bin\Rscript.exe".
echo.
echo !n! FINDING YOUR R INSTALLATION:
echo !n! If you are unsure where to find 'Rscript.exe', you may run the following in a separate command prompt:
echo !n! PowerShell ^	get-childitem -Recurse -Name rscript.exe -path C:\
echo.
echo !n! NOTE:
echo !n! If you have performed a custom installation of R in a drive other than C:\, be sure to replace C:\ with appropriate drive name (e.g., D:\) 
echo.
echo !n! ##################################################################

rem preparation command
set pwshcmd=powershell -noprofile -command "&{[System.Reflection.Assembly]::LoadWithPartialName('System.windows.forms') | Out-Null;$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog; $OpenFileDialog.ShowDialog()|out-null; $OpenFileDialog.FileName}"

rem exec commands powershell and get result in FileName variable
for /f "delims=" %%I in ('%pwshcmd%') do set "FileName=%%I"

echo You have chosen %FileName%.

"%FileName%" ImportandTransform.R

echo !n! ##################################################################
echo !n! You may now close this window now.
echo !n! ##################################################################
PAUSE
