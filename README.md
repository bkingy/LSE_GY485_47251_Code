# Repository Structure
- This repository contains all the cleaned dataset, code, and replicable outputs used in the dissertation: Evaluating the Poverty Reduction Effects of London’s Opportunity Areas Policy.
- All scripts assume file paths are locally defined. Please update all `/yourpath` references (e.g., in .do or .Rmd files) to match your local machine before running any code.

### cleaned complete dataset can be used directly
- `df_long1.csv`: contains `MSOA11CD` (Area code); `Year` (2011 and 2021); DVs: `income` (Net annual household income), `imd` (IMD income score); IV: `oa` (OA policy dummy 0/1); CVs: `pop` (population), `unem` (unemployment rate), `edu`: % with Level 4+ qualifications, `mig` (migration rate).

### 4.Methodology/
- `Table2.do`: STATA .do file to replicate Table 2.

### 5.Results/
- `Table3&4.do`; `Table5.do`; `Table6.do`: STATA .do file to replicate Table 3-6.

### 6.Discussion/
- `Table7-10;Figure8.do`: STATA .do file to replicate Table 7-10 and Figure 8.
- `MSOA shapefile`: geospatial boundary shapefile for 2011 London MSOAs used in spatial join and mapping.
- `OA.gpkg`:
    - `Opportunity_Areas.gpkg`: Opportunity Areas boundaries and administrative zones.
    - `gadm41_CHN_shp`: GADM administrative boundaries for spatial reference.
- `Table11&Figure11/12.Rmd`: .Rmd file replicate Table 11 and Figure 11-12.
- `Table11-Figure11-12.html`: corresponding rendered HTML files included Figure 11-12.
- `SDM.docx`: Full SDM regression outputs for DVs.
