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

### What to put in the `zoom_reports` sub-directory

- Please place your Zoom meeting participant reports in this `zoom_reports` sub-directory. You can place multiple files.
- Please only place files with `.csv` file extensions.
- For the Zoom files, please ensure that the headers are imputed as follows:
  - `Topic`
  - `MeetingID`
  - `User_Name`
  - `User_Email_1`
  - `Department`
  - `Group`
  - `HasZoomRooms`
  - `Creation_Time`
  - `Start_Time`
  - `End_Time`
  - `Duration_Minutes_1`
  - `Participants`
  - `NameOriginalName`
  - `User_Email_2`
  - `Join_Time`
  - `Leave_Time`
  - `Duration_Minutes_2`
  - `Guest`
  - `RecordingConsent`
  - `InWaitingRoom`
  - `MarketingOptIn`

#### Example of Zoom meeting participant reports

The following is an example of the Zoom participant report, and the required header formats:

|Topic               |MeetingID    |User_Name   |User_Email_1               |Department      |Group  |HasZoomRooms|Creation_Time   |Start_Time      |End_Time        |Duration_Minutes_1|Participants|NameOriginalName|User_Email_2                   |Join_Time       |Leave_Time      |Duration_Minutes_2|Guest|RecordingConsent|InWaitingRoom|MarketingOptIn|
|--------------------|-------------|------------|---------------------------|----------------|-------|------------|----------------|----------------|----------------|------------------|------------|----------------|-------------------------------|----------------|----------------|------------------|-----|----------------|-------------|--------------|
|1:1 Matthew / James|852 1848 6288|James Warren|James.Warren@contoso.com|Customer Outcome|ABC-Org|No          |15/08/2022 01:27|01/06/2023 00:00|01/06/2023 00:21|22                |2           |Matthew Giordano|Matthew.Giordano@contoso.com|01/06/2023 00:00|01/06/2023 00:21|22                |No   |                |No           |-             |


