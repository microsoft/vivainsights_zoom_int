# README - Analyst

## Pre-requisites 

- Please place only your HashID Mapping File in this directory. Make sure that your filename contains "mapping file" text. An example could be `VI Zoom mapping file.csv`.
- Place your zoom extract reports in the `zoom_reports` folder.
- Ensure that R is installed on your machine.

Also, place the following inputs in the `input` sub-directory:
  - Ways of Working Assessment query (`.csv`), with the hash key added as organizational data. File name must contain the string "Ways of working assessment" or "WOWA"
  - Standard meeting query (`.csv`). File name must contain the string "Standard meeting query".
  - Hashed Zoom File received from the Zoom Administrator (`.csv`). File name must contain the string "Hashed Zoom File from Zoom Admin"

## Details

The **Viva Insights Analyst** should run `script/AnalystAction.bat` once the above pre-requisites are satisfied. 

`AnalystAction.bat` performs the following: 

- Opens up a selection window for the user to select the location for their R installation. 
- Once selected, the `ImportandTransform.R` script is run.

### `config.csv`

Use the CSV to specify the following configurations:
- The column name corresponding to `hash_id` in the mapping file.
- The UTC offset based on the timezone of the Zoom Administrator.
- Enter the Outlook Start and End Times override for the Zoom population.

### `ImportandTransform.R`

`ImportandTransform.R` is an R script that imports and transforms data from Zoom reports. The script reads in CSV files containing data on Zoom meetings and participants, and performs various data cleaning and transformation operations to prepare the data for analysis.

The script uses the `tidyverse`` package to perform data manipulation tasks such as filtering, grouping, and summarizing data. 

Some of the specific tasks performed by the script include:

- Reading in CSV files containing Zoom meeting and participant data
- Cleaning up column names and data types
- Calculating various metrics such as meeting duration, number of participants, and participant engagement
- Converting date and time data to the appropriate time zone
- Merging data from multiple CSV files into a single data frame
- Writing the cleaned and transformed data to a new CSV file for further analysis

The script also includes a configuration file (`config.csv`) that allows users to customize certain aspects of the data transformation process, such as the time zone offset and the file paths for the input and output files.

### Columns created from Zoom data

The following columns are created from the Zoom meeting participants data:

- `Zoom_Unscheduled_call_hours`
- `Zoom_Scheduled_call_hours`
- `Zoom_Total_call_hours`
- `Zoom_Unscheduled_call_hours_30_mins_or_less`
- `Zoom_Unscheduled_call_hours_31_to_59_mins`
- `Zoom_Unscheduled_call_hours_1_hour`
- `Zoom_Unscheduled_call_hours_1_to_2_hours`
- `Zoom_Unscheduled_call_hours_more_than_2_hours`
- `Zoom_Unscheduled_call_hours_2_attendees`
- `Zoom_Unscheduled_call_hours_3_to_8_attendees`
- `Zoom_Unscheduled_call_hours_9_to_18_attendees`
- `Zoom_Unscheduled_call_hours_19_or_more_attendees`
- `Zoom_Meetings`
- `Zoom_Unscheduled_Meetings`
- `Zoom_Scheduled_Meetings`
- `Zoom_After_hours_in_unscheduled_calls`
- `Zoom_After_hours_in_scheduled_calls`