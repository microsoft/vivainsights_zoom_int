# README - Administrator

## Pre-requisites 

- Please place only your HashID Mapping File in this directory. Make sure that your filename contains "mapping file" text. An example could be `VI Zoom mapping file.csv`. It should have the following columns in the file:
    - `PersonID`
    - `HashID`

- Place your zoom extract reports in the `zoom_reports` folder.
- Ensure that R is installed on your machine.

## Details

The **Zoom Administrator** should run `AdminAction.bat` once the above pre-requisites are satisfied. 

`AdminAction.bat` performs the following: 

- Opens up a selection window for the user to select the location for their R installation. 
- Once selected, the `AdminBindandHash.R` script is run. This script reads in all files saved under `Admin/input/zoom_reports`, binds them, and attaches a hash key to the output file. This hash key is given in the mapping file that should be saved in the root of the `input` subdirectory.

