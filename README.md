# Viva Insights Zoom Data Integration

The Zoom Collaboration analysis provides analysts with an opportunity to derive meaningful additional collaboration metrics from Zoom meeting reports that complement existing metrics provided by Workplace Analytics. 

Analysts can use this to understand collaboration that occurs on Zoom with a primary focus on unscheduled collaboration. Analysts can download the output either as a standalone .csv file with collaboration metrics for unscheduled Zoom calls or as a Ways of working assessment input file (with Zoom collaboration metrics) and the modified Ways of working assessment Power BI template.

This analysis will help leaders & analysts get a richer and more complete picture of the collaboration patterns of their organization.

## Usage

There are three roles or actors required in this integration solution: 

1. Zoom Administrator
2. Viva Insights Administrator
3. Viva Insights Analyst

These roles should be assigned to different individuals in order to safeguard the privacy of the analyzed population. 

### 1. Setup

This step will take ~20 minutes per actor and an elapsed time of ~2 days. 

#### 1.1 Install R 

- Actor(s): Zoom Administrator, Viva Insights Analyst
- Both the Zoom Administrator and the Viva Insights Analyst will need to download and install R on their machines. Instructions for installation are [here](https://cran.r-project.org/bin/windows/base/).

#### 1.2 Download the VI-Zoom Analyst Package

Actor(s): Viva Insights Analyst

- This can be downloaded via this [link](https://github.com/microsoft/vivainsights_zoom_int/archive/refs/heads/main/Admin.zip). 
- Only the 'Analyst' sub-directory would be relevant for the Analyst. 

#### 1.3 Download the VI-Zoom Administrator Package

Actor(s): Zoom Administrator

- This can be downloaded via this [link](https://github.com/microsoft/vivainsights_zoom_int/archive/refs/heads/main/Admin.zip). 
- Only the 'Administrator' sub-directory would be relevant for the Administrator. 

#### 1.4 Prepare a mapping file and insert key into the organizational data

Actor(s): Viva Insights Administrator

In this step, the Viva Insights Administrator has to create a mapping file `<email_id, hash_id>` to deidentify Zoom data. 
The `hash_id` then needs to be inserted into the VI organizational data file. 

### 2. Download Input Files

This step will take ~3 minutes per actor and an elapsed time of ~3-4 hours. 

#### 2.1 Download the Zoom report

Actor(s): Zoom Administrator

The Zoom Administrator has to: 

1. Download the Generate Details report from Zoom Admin portal by navigating to:
	`Admin -> Account Management -> Reports -> Usage Reports -> Active Hosts`
2. Save the mapping file from WpA Admin and Generate Details report(s) in "Input" folder

#### 2.2 Download the Ways of Working Assessment and Meeting Queries

Actor(s): Viva Insights Analyst

The Analyst has to run the Ways of Working Assessment, Meeting Queries and save the csv output in "Input" folder.

### 3. Prepare Zoom files

This step will take ~1 minute per actor and an elapsed time of ~3 minutes. 

Prior to running the following scripts, the Zoom Administrator has to: 

1. Confirm the Input directory has the required files
	- Output from Generate Meeting Details
	- Mapping file from Admin
2. Navigate to "Script" folder 
3. Run AdminActions.bat 
4. Point the explorer to "Rscript.exe"
5. Share the output with Viva Insights Analyst

### 4. Ingest / Display

Actor(s): Viva Insights Analyst

This step will take ~1 minute per actor and an elapsed time of ~4 minutes. 

The Viva Insights Analyst will have to: 
1. Confirm the Input directory has the required files
  - Output from Zoom Admin <combined_hashed_output>
  - Ways of Working Assessment
  - Standard Meeting Query
2. Navigate to “script” folder and run AnalystActions.bat 
3. Point the explorer to “Rscript.exe” 
4. Locate the transformed Zoom file in “output” folder
5. Launch the WOW-Zoom.pbit
6. Provide the csv links to the PBIT from the output folder

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
