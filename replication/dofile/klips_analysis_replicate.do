* This do-file executes the empirical anayses using the KLIPS data

global con_exo age30s age40s age50s age60s age70s male married children 
global con_abil edu_ter risktol patience impulsivity big5_O big5_C big5_E big5_A big5_N 

use "processed_data/KLIPS_merged.dta", clear

* drop the observations with missing key covariates
qui: reg lift_most $con_exo $con_abil , robust
keep if e(sample)==1

************************************************************************************************
* Table 1 Distribution of the HOR Score
************************************************************************************************

su hor_score, detail
local pmin = r(min)
local p10 = r(p10)
local p25 = r(p25)
local p50 = r(p50)
local p75 = r(p75)
local p90 = r(p90)
local pmax = r(max)
* Export to Excel using putexcel
putexcel set "tables/Table_1_KLIPS.xlsx", replace
putexcel A1 = "Percentile" B1 = "Value"
putexcel A2 = "Min"  B2 = `pmin', nformat("0.0") 
putexcel A3 = "10th" B3 = `p10', nformat("0.0") 
putexcel A4 = "25th" B4 = `p25', nformat("0.0") 
putexcel A5 = "50th" B5 = `p50', nformat("0.0") 
putexcel A6 = "75th" B6 = `p75', nformat("0.0") 
putexcel A7 = "90th" B7 = `p90', nformat("0.0") 
putexcel A8 = "Max"  B8 = `pmax', nformat("0.0") 

************************************************************************************************
* Table 2: Distribution of the BI score
************************************************************************************************

tab lift_most, matcell(freq)

* Get the row names (BI scores) from the matrix and store in a macro
local rows = rowsof(freq)

* Create a new Excel file
putexcel set "tables/Table_2_KLIPS.xlsx", replace

* Write the headers to the Excel file
putexcel A1 = "BI Score"
putexcel B1 = "Percent"

* Write the BI scores and percentages to the Excel file
forvalues i = 1/`rows' {
    local row = `i' + 1
    putexcel A`row' = "`i'"
    putexcel B`row' = freq[`i',1]/`r(N)', nformat(percent_d2)
}

************************************************************************************************
* Table 3 (Right Panel): Correlations among strategic thinking skill measures and other skills
************************************************************************************************

eststo: estpost corr lift_most task2_payoff eye_total edu_ter risktol patience  big5_O big5_C big5_E big5_A big5_N
eststo: estpost corr task2_payoff eye_total edu_ter risktol patience  big5_O big5_C big5_E big5_A big5_N
esttab using "tables/Table_3_KLIPS.csv", replace ///
not unstack noobs nonum star(* 0.10 ** 0.05 *** 0.01) label ///
addnotes("Note: * denotes significance at 0.10; ** at 0.05; *** at 0.01.") 
est clear

************************************************************************************************
* Table A1 Distribution of the HOR Score by Gender
************************************************************************************************

su hor_score if male==1, detail
local pmin_m = r(min)
local p10_m = r(p10)
local p25_m = r(p25)
local p50_m = r(p50)
local p75_m = r(p75)
local p90_m = r(p90)
local pmax_m = r(max)

su hor_score if male==0, detail
local pmin_f = r(min)
local p10_f = r(p10)
local p25_f = r(p25)
local p50_f = r(p50)
local p75_f = r(p75)
local p90_f = r(p90)
local pmax_f = r(max)

* Export to Excel using putexcel
putexcel set "tables/Table_A1_KLIPS.xlsx", replace
putexcel A1 = "Percentile" B1 = "Male" C1 = "Female"
putexcel A2 = "Min"  B2 = `pmin_m' C2 = `pmin_f', nformat("0.0") 
putexcel A3 = "10th" B3 = `p10_m' C3 = `p10_f', nformat("0.0") 
putexcel A4 = "25th" B4 = `p25_m' C4 = `p25_f', nformat("0.0") 
putexcel A5 = "50th" B5 = `p50_m' C5 = `p50_f', nformat("0.0") 
putexcel A6 = "75th" B6 = `p75_m' C6 = `p75_f', nformat("0.0") 
putexcel A7 = "90th" B7 = `p90_m' C7 = `p90_f', nformat("0.0") 
putexcel A8 = "Max"  B8 = `pmax_m' C8 = `pmax_f', nformat("0.0") 

************************************************************************************************
* Table A2: Distribution of the BI score by Gender
************************************************************************************************

tab lift_most if male==1, matcell(freq_m)
local total_m = `r(N)'
tab lift_most if male==0, matcell(freq_f)
local total_f = `r(N)'

* Get the row names (BI scores) from the matrix and store in a macro
local rows = rowsof(freq_m)

* Create a new Excel file
putexcel set "tables/Table_A2_KLIPS.xlsx", replace

* Write the headers to the Excel file
putexcel A1 = "BI Score"
putexcel B1 = "Male (percent)"
putexcel C1 = "Female (percent)"

* Write the BI scores and percentages to the Excel file
forvalues i = 1/`rows' {
    local row = `i' + 1
    putexcel A`row' = "`i'"
    putexcel B`row' = freq_m[`i',1]/`total_m', nformat(percent_d2)
	putexcel C`row' = freq_f[`i',1]/`total_f', nformat(percent_d2)
}

************************************************************************************************
* Table A4: Distribution of the Reading the Mind in the Eyes Test Score
************************************************************************************************

su eye_total, detail
local pmin = r(min)
local p10 = r(p10)
local p25 = r(p25)
local p50 = r(p50)
local p75 = r(p75)
local p90 = r(p90)
local pmax = r(max)
* Export to Excel using putexcel
putexcel set "tables/Table_A4_KLIPS.xlsx", replace
putexcel A1 = "Percentile" B1 = "Value"
putexcel A2 = "Min"  B2 = `pmin'
putexcel A3 = "10th" B3 = `p10'
putexcel A4 = "25th" B4 = `p25'
putexcel A5 = "50th" B5 = `p50'
putexcel A6 = "75th" B6 = `p75'
putexcel A7 = "90th" B7 = `p90'
putexcel A8 = "Max"  B8 = `pmax'

************************************************************************************************
* Table A5: Sample Characteristics of the KLIPS Participants
************************************************************************************************
eststo : estpost sum age30s age40s age50s age60s age70s male married children ///
	edu_ter risktol impulsivity big5_O big5_C big5_E big5_A big5_N ///
	earning spouse_earning workhour hourlywage_total 
esttab using "tables/Table_A5.csv", replace ///
cells("mean(fmt(2))" "sd(par fmt(2))") label ///
collabels("Mean (SD)")  
est clear

************************************************************************************************
* Table A21: HOR order classifications and empirical distributions
************************************************************************************************

tab task2_level, matcell(freq)

* Get the row names (BI scores) from the matrix and store in a macro
local rows = rowsof(freq)

* Create a new Excel file
putexcel set "tables/Table_A21_KLIPS.xlsx", replace

* Write the headers to the Excel file
putexcel A1 = "HOR Order"
putexcel B1 = "Percent"

* Write the BI scores and percentages to the Excel file
forvalues i = 1/`rows' {
    local row = `i' + 1
	local j = `i'-1
    putexcel A`row' = "`j'"
    putexcel B`row' = freq[`i',1]/`r(N)', nformat(percent_d2)
}


************************************************************************************************
* Table A22: Distribution of the BI counting scores
************************************************************************************************

tab lift_numwins, matcell(freq)

* Get the row names (BI scores) from the matrix and store in a macro
local rows = rowsof(freq)

* Create a new Excel file
putexcel set "tables/Table_A22_KLIPS.xlsx", replace

* Write the headers to the Excel file
putexcel A1 = "BI Counting Score"
putexcel B1 = "Percent"

* Write the BI scores and percentages to the Excel file
forvalues i = 1/`rows' {
    local row = `i' + 1
    putexcel A`row' = "`i'"
    putexcel B`row' = freq[`i',1]/`r(N)', nformat(percent_d2)
}


