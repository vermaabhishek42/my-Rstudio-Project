* This do file runs every sub-dofile in the strategic sophistication project.

* The flow of the work is as follows:
* 1. World Bank data
* 2. World Value Survey (WVS) data
* 3. Korean Labor Income and Panel Study (KLIPS) data 
* 4. SLP data; as the SLP data is stored on the server and can be only accessible within the virtual desktop where there is no internet access, we run the SLP code separately. 

clear all

* This do file runs every sub-dofile in the strategic sophistication project. Note that the #4 can be only run on the SLP server so run #1-#3 and #4 separately. 

* Please change the working directory based on your computer's file location.

*cd "your_path" WHEN you run #1, #2, and #3 on the local machine
cd "/Users/seonghoonkim/Library/CloudStorage/Dropbox/ongoing research/slp/strategic sophistication/Paper-Draft/Submission/AEJ-Micro/Final_Submission/replication"

* run a configuration program that install packages 
do "dofile/config_stata.do"

* 1. World Bank data
do "dofile/worldbank.do"

* 2. World Value Survey data
do "dofile/wvs.do"

* 3. KLIPS data
* reads KLIPS' raw data and produce the KLIPS analysis data
do "dofile/klips_cleaning_replicate.do"
* conducts the empirical analyses using the KLIPS data
do "dofile/klips_analysis_replicate.do"

*cd "your_path" WHEN you run #4 on the SLP server
cd "F:\ROSA Researchers\Seonghoon Kim\replication"

* 4. SLP data
* these two files can't be run on a local computer because data is accessible only from the limited-access SLP server. But, I am listing them here for the replicator's information

do "dofile/slp_cleaning_replicate.do"
do "dofile/slp_analysis_replicate.do"

clear all

* After running "dofile/slp_analysis_replicate.do", please also run "FigA6_A7_A8.R" using R to produce Figures A6, A7, and A8. This R file consumes the CSV files produced from "dofile/slp_analysis_replicate.do". See the README file's list of table and figures for the detail. 
