# Replication Package for Ramos (2026)

**Title:** Too Little, Too Weak? Paid Parental Leaves in Philippine Collective Bargaining Agreements 

**Journal:** British Journal of Industrial Relations

**Author:** Vincent Jerald Ramos  

**Date:** April 2026  

## Overview
This repository contains the data and Stata scripts needed to replicate the descriptive statistics, regressions, and Regression Discontinuity in Time (RDiT) estimates found in both the main text and the appendix of the paper.

## Data Availability Statement
The replication relies on the following primary dataset:
- `ph_cbas_bjir.dta`: The main analytical dataset containing collective bargaining agreements (CBAs) from 2016-2021, firm characteristics, union characteristics, and parental leave provisions.

*(Note: This is an abridged and anonymized version of the dataset without any identifying information.)*

## Computational Requirements

### Software
- **Stata**: The code requires **Stata 17.0 or higher**. The appendix script utilizes the modern `table` and `collect` command syntax introduced in Stata 17 for generating summary statistics. 

### Required Stata Packages
You will need to install the following user-written commands before running the scripts. You can install them by running the following in your Stata command window:
```stata
ssc install coefplot, replace
ssc install estout, replace
net install grc1leg2, from(http://www.stata.com/users/vwiggins) replace
```

## Directory Structure
To run the code without errors, ensure your project folder has the following directory structure:

```text
Project_Folder/
├── Data/
│   └── ph_cbas_bjir.dta              <- Ensure the data file is placed here (or adjust the global paths)
├── Scripts/
│   ├── bjir_1_main.do                <- Main text replication script
│   └── bjir_2_appendix.do            <- Appendix replication script
├── Tables/                           <- Output folder for tables
└── Figures_BJIR_newoutcome/          <- Output folder for figures
```

## Instructions to Replicators

1. **Set Working Directory:** Open both `bjir_1_main.do` and `bjir_2_appendix.do`. At the top of each file, it is highly recommended to add a `cd` command to set your root directory.
   ```stata
   cd "C:/Path/To/Your/Project_Folder"
   ```
2. **Verify Macros:** Ensure the global macros for the output directories match the folders you created:
   ```stata
   global WRITE "Tables"
   global WRITEFIG "Figures_BJIR_newoutcome"
   ```
3. **Run Main Analysis:** Execute `bjir_1_main.do` to generate all figures in the paper:
   - Descriptive Figure 1
   - Regression Results Figures 2-3
   - Multi-plant UPE estimator Figure 4
   - RDiT estimates Figures 5-6
     
4. **Run Appendix Analysis:** Execute `bjir_2_appendix.do` to generate all figures and tables in the Appendix

## List of Code and Outputs

| Code File | Primary Outputs Generated |
| :--- | :--- |
| `bjir_1_main.do` | Main Text Figures, Main Text Tables |
| `bjir_2_appendix.do` | Table A.1 (Descriptives), Appendix RDiT Figures (`rdd_estimates_cutoff1_all_p1.png`, etc.) |

## Contact
*For any queries or clarifications, or ideas for future research using this data, please do not hesitate to reach out to [vrramos@up.edu.ph](mailto:vrramos@up.edu.ph) or [v.ramos@southampton.ac.uk](mailto:v.ramos@southampton.ac.uk)*

## Acknowledgements / Funding
*This research benefitted from funding from the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation) – 390285477/GRK 2458, the Economic and Social Research Council as part of the Centre for Population Change: Connecting Generations Centre grant ES/W002116/1, and the Philippine Competition Commission's 2022 Long-Term Research Program Grant. .*
