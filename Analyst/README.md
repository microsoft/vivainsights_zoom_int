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
