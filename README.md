# Viva Insights Zoom Data Integration

v0.2.0

## Summary

The Zoom Collaboration analysis provides analysts with an opportunity to derive meaningful additional collaboration metrics from Zoom meeting reports that complement existing metrics provided by Workplace Analytics. 

Analysts can use this to understand collaboration that occurs on Zoom with a primary focus on unscheduled collaboration. Analysts can download the output either as a standalone .csv file with collaboration metrics for unscheduled Zoom calls or as a Ways of working assessment input file (with Zoom collaboration metrics). A modified Ways of working assessment Power BI template can also be used, but is no longer supported as of `v0.2.0`

This analysis will help leaders & analysts get a richer and more complete picture of the collaboration patterns of their organization.

---

## Instructions by role - Summary

There are three roles or actors required in this integration solution: 

1. **Zoom Administrator**
2. **Viva Insights Administrator**
3. **Viva Insights Analyst**

These roles should be assigned to different individuals in order to safeguard the privacy of the analyzed population. 

### Zoom Administrator

1. Install R on your machine. Instructions for installation are [here](https://cran.r-project.org/bin/windows/base/).
2. Download the VI-Zoom Administrator Package via this [link](https://github.com/microsoft/vivainsights_zoom_int/archive/refs/heads/main/Admin.zip). 
3. Save the downloaded package in the root directory.
4. Confirm that the Input directory has the required files:
  - Output from "Generate Meeting Details"
  - Mapping file received from the Viva Insights Administrator.
5. Navigate to `Admin > script` folder.
6. Run `AdminAction.bat`.
7. Point the explorer to `Rscript.exe`.
8. Share the output with Viva Insights Analyst.

### Viva Insights Administrator

1. Create a mapping file `<email_id, hash_id>` to deidentify Zoom data, in `csv` format. This should be saved in the root of the `input` folder, and the file name should have the literal string `mapping file` in the name. 
2. Insert the `hash_id` into the VI organizational data file.

### Viva Insights Analyst

1. Install R on your machine. Instructions for installation are [here](https://cran.r-project.org/bin/windows/base/).
2. Download the VI-Zoom Analyst Package via this [link](https://github.com/microsoft/vivainsights_zoom_int/archive/refs/heads/main/Admin.zip). 
3. Save the downloaded package in the root directory.
4. Run the Ways of Working Assessment query, and save the csv output in the `Analyst > input`.
5. Confirm that the `Analyst > input` directory has the required files:
  - Output from Zoom Admin <combined_hashed_output>
  - Ways of Working Assessment query (`csv` file)
6. Navigate to `Analyst > script` folder and run `AnalystActions.bat`.
7. Point the explorer to `Rscript.exe`.
8. Locate the transformed Zoom file in `Analyst > output` folder.
---

## Detailed Usage

### 1. Setup

This step will take ~20 minutes per actor and an elapsed time of ~2 days. 

Both the **Zoom Administrator** and the **Viva Insights Analyst** will need to download and install R on their machines. Instructions for installation are [here](https://cran.r-project.org/bin/windows/base/).

The **Zoom Administrator** and the **Viva Insights Analyst** will both have to download the repo via [here](https://github.com/microsoft/vivainsights_zoom_int/archive/refs/heads/main/Admin.zip). Only the 'Analyst' sub-directory would be relevant for the Analyst, and only the 'Admin' sub-directory would be relevant for the Zoom Administrator. 

The **Viva Insights Administrator** has to create a mapping file `<email_id, hash_id>` to deidentify Zoom data, in `csv` format. This should be saved in the root of the `input` folder, and the file name should have the literal string `mapping file` in the name. 
- The `hash_id` then needs to be inserted into the VI organizational data file. 

### 2. Download Input Files

This step will take ~3 minutes per actor and an elapsed time of ~3-4 hours. 

The **Zoom Administrator** has to: 

1. Download the Generate Details report from Zoom Admin portal by navigating to:
	`Admin -> Account Management -> Reports -> Usage Reports -> Active Hosts`
2. Save the mapping file from the Viva Insights Administrator as well the output of the Generate Details report(s) in the `input` folder.

The **Viva Insights Analyst** has to run the following Ways of Working Assessment query, and save the csv output in the `Analyst > input`.

### 3. Process Zoom files to generate weekly metrics

After the above is done, the **Zoom Administrator** can proceed to set up the Zoom files so that the processing scripts can be run. The **Zoom Administrator** has to: 

1. Confirm the Input directory has the required files
	- Output from "Generate Meeting Details"
	- Mapping file received from the Viva Insights Administrator
2. Navigate to `Admin > script` folder 
3. Run `AdminAction.bat`
4. Point the explorer to `Rscript.exe`

Once the scripts has completed running, the **Zoom Administrator** can then share the output with the **Viva Insights Analyst**.

### 4. Ingestion

This step will take ~1 minute to run and an elapsed time of ~4 minutes. This step joins the output dataset created by the **Zoom Administrator** with the _Ways of Working Assessment query_ downloaded by the **Viva Insights Analyst**.

The **Viva Insights Analyst** will have to: 
1. Confirm the `Analyst > input` directory has the required files
  - Output from Zoom Admin <combined_hashed_output>
  - Ways of Working Assessment
2. Navigate to `Analyst > script` folder and run `AnalystActions.bat`
3. Point the explorer to `Rscript.exe`
4. Locate the transformed Zoom file in `Analyst > output` folder
5. Launch the `WOW-Zoom.pbit`*
6. Provide the csv links to the PBIT from the output folder*

*These steps are only relevant for running a Power BI template. This is no longer supported in the new version of Viva Insights.


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
