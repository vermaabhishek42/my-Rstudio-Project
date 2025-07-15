************************************************************************************************
* This do-file executes the empirical anayses using the SLP data
************************************************************************************************

use "processed_data/SLP_cleaned.dta", clear

global con_exo i.age_grp chinese marst nliving sp_age2 sp_age99
global con_cog edu_ter ist eye_normal
global con_add fp_long risk_general self_efficacy optimism

global random_order1 i.race_seq1 i.race_seq2
global random_order2 i.rubin_position_1 i.rubin_position_2

* Keep the data from the experiment wave
keep if wv==25
* Drop the sample with key missing covariates including the Eyes test (which drops non-participants automatically)
qui: reg hln_r_laborinc_ann age male chinese marst nliving  edu_ter ist eye_normal fp_long risk_general self_efficacy optimism
gen no_missing=e(sample)


************************************************************************************************
*	Table A3: SLP sample characteristics by participation status
************************************************************************************************

local sum_var age male chinese marst nliving edu_ter ist fp_long risk_general self_efficacy optimism r_poslinc r_laborinc_pos r_laborinc_ann s_poslinc s_laborinc_pos s_laborinc_ann
	
eststo : estpost sum `sum_var' if partic==1 & no_missing==1
eststo : estpost sum `sum_var' if partic==2 
eststo : estpost sum `sum_var' if partic==3
esttab using "tables/Table_A3.csv", replace ///
cells("mean(fmt(2))" "sd(par fmt(2))") label ///
collabels("Mean (SD)")  ///
mgroups("Participants" "Dropouts" "Non-participants"  , pattern(1 1 1)) ///
notes addnotes("Notes: This table is statistics based on crosssectional data of different waves but mainly on Wave 25 (August 2017)")
est clear

* Keep only those who completed the module
keep if partic==1  & no_missing==1

************************************************************************************************
*	Table 1  Distribution of the HOR scores 
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
putexcel set "tables/Table_1_SLP.xlsx", replace
putexcel A1 = "Percentile" B1 = "Value"
putexcel A2 = "Min"  B2 = `pmin', nformat("0.0") 
putexcel A3 = "10th" B3 = `p10', nformat("0.0") 
putexcel A4 = "25th" B4 = `p25', nformat("0.0") 
putexcel A5 = "50th" B5 = `p50', nformat("0.0") 
putexcel A6 = "75th" B6 = `p75', nformat("0.0") 
putexcel A7 = "90th" B7 = `p90', nformat("0.0") 
putexcel A8 = "Max"  B8 = `pmax', nformat("0.0") 

************************************************************************************************
*	Table 2 Classification and distribution of the BI score
************************************************************************************************

tab lift_most, matcell(freq)

* Get the row names (BI scores) from the matrix and store in a macro
local rows = rowsof(freq)

* Create a new Excel file
putexcel set "tables/Table_2_SLP.xlsx", replace

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
*	Table 3 Correlations among strategic thinking skill measures and other skills (left panel)
************************************************************************************************
eststo: estpost corr lift_most hor_score eye_total edu_ter ist fp_long risk_general self_efficacy optimism 
eststo: estpost corr hor_score eye_total edu_ter ist fp_long risk_general self_efficacy optimism 
esttab using "tables/Table_3_SLP.csv", replace ///
not unstack noobs nonum star(* 0.10 ** 0.05 *** 0.01) label ///
addnotes("Note: * denotes significance at 0.10; ** at 0.05; *** at 0.01.") 
est clear
 
**********************************************************************************************************************************************
*	Table 4 Panel A Regression of individual labor income on strategic thinking skills for male respondents
**********************************************************************************************************************************************

* Baseline controls
* Column (1) 
reg hln_r_laborinc_ann lift_most $con_exo if male==1, robust
outreg2 using "tables/Table_4A.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No, Gender, Male)
* Column (2) 
reg hln_r_laborinc_ann hor_pay_normal $con_exo if male==1, robust
outreg2 using "tables/Table_4A.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No, Gender, Male)

* + Education, IST, and Eyes Test Score
* Column (3) 
reg hln_r_laborinc_ann lift_most $con_exo $con_cog if male==1, robust
outreg2 using "tables/Table_4A.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No, Gender, Male)
* Column (4) 
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog if male==1, robust
outreg2 using "tables/Table_4A.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No, Gender, Male)

* + Non-cognitive traits, random order, and time taken
* Column (5)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1, robust
outreg2 using "tables/Table_4A.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (6)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1, robust
outreg2 using "tables/Table_4A.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)

************************************************************************************************************************************************
*	Table 4 Panel B Regression of individual labor income on strategic thinking skills for female respondents
************************************************************************************************************************************************

* Baseline controls
* Column (1) 
reg hln_r_laborinc_ann lift_most $con_exo if male==0, robust
outreg2 using "tables/Table_4B.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No, Gender, Female)
* Column (2) 
reg hln_r_laborinc_ann hor_pay_normal $con_exo if male==0, robust
outreg2 using "tables/Table_4B.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No, Gender, Female)

* + Education, IST, and Eyes Test Score
* Column (3) 
reg hln_r_laborinc_ann lift_most $con_exo $con_cog if male==0, robust
outreg2 using "tables/Table_4B.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No, Gender, Female)
* Column (4) 
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog if male==0, robust
outreg2 using "tables/Table_4B.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No, Gender, Female)

* + Non-cognitive traits, random order, and time taken
* Column (5)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0, robust
outreg2 using "tables/Table_4B.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (6)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0, robust
outreg2 using "tables/Table_4B.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)

************************************************************************************************
*	Table 5 Regression results for the extensive margin of labor supply by gender
************************************************************************************************

* Column (1)
reg r_poslinc lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1, robust
outreg2 using "tables/Table_5.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (2)
reg r_poslinc hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1, robust
outreg2 using "tables/Table_5.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (3)
reg r_poslinc lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0, robust
outreg2 using "tables/Table_5.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (4)
reg r_poslinc hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0, robust
outreg2 using "tables/Table_5.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (5)
reg retuemp lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1, robust
outreg2 using "tables/Table_5.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (6)
reg retuemp hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1, robust
outreg2 using "tables/Table_5.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (7)
reg rlfhmemak lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0 & marst==1, robust
outreg2 using "tables/Table_5.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (8)
reg rlfhmemak hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0 & marst==1, robust
outreg2 using "tables/Table_5.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)

************************************************************************************************
*	Table 6 Regression of household labor income on married respondents' strategic thinking skills
************************************************************************************************

* Column (1)
reg hln_h_labinc lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1 & marst==1, robust
outreg2 using "tables/Table_6.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (2)
reg hln_h_labinc hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1 & marst==1, robust
outreg2 using "tables/Table_6.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (3)
reg hln_h_labinc lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0 & marst==1, robust
outreg2 using "tables/Table_6.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (4)
reg hln_h_labinc hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0 & marst==1, robust
outreg2 using "tables/Table_6.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (5)
reg hln_h_labinc lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0 & marst==1 & r_poslinc==0, robust
outreg2 using "tables/Table_6.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Non-working Female)
* Column (6)
reg hln_h_labinc hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0 & marst==1 & r_poslinc==0, robust
outreg2 using "tables/Table_6.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Non-working  Female)

************************************************************************************************
*	Table 7 ORIV estimation of labor income on strategic thinking skills
************************************************************************************************

preserve

**duplicate the dataset for stacked regression
expand 2, gen(newdata)
gen strategic=lift_normal if newdata==1
replace strategic=hor_pay_normal if newdata==0
gen iv_strategic=hor_pay_normal if newdata==1
replace iv_strategic=lift_normal if newdata==0
lab var strategic "Strategic thinking skill"
* Column (1)
ivreg2 hln_r_laborinc_ann (strategic = iv_strategic) newdata $con_exo $con_cog $con_add time1 $random_order1 time2 $random_order2 if male==1, cluster(prim_key)
outreg2 using "tables/Table_7.xls", dec(3) label excel replace nocons keep(strategic) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (2)
ivreg2 hln_r_laborinc_ann (strategic = iv_strategic) newdata $con_exo $con_cog $con_add time1 $random_order1 time2 $random_order2 if male==0, cluster(prim_key)
outreg2 using "tables/Table_7.xls", dec(3) label excel append nocons keep(strategic) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (3)
ivreg2 hln_h_labinc (strategic = iv_strategic) newdata  $con_exo $con_cog $con_add time1 $random_order1 time2 $random_order2 if male==1 & marst==1, cluster(prim_key)
outreg2 using "tables/Table_7.xls", dec(3) label excel append nocons keep(strategic) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (4)
ivreg2 hln_h_labinc (strategic = iv_strategic) newdata  $con_exo $con_cog $con_add time1 $random_order1 time2 $random_order2 if male==0 & marst==1, cluster(prim_key)
outreg2 using "tables/Table_7.xls", dec(3) label excel append nocons keep(strategic) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)

restore

************************************************************************************************
*	Table A1 Distribution of the HOR scores by gender 
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
putexcel set "tables/Table_A1_SLP.xlsx", replace
putexcel A1 = "Percentile" B1 = "Male" C1 = "Female"
putexcel A2 = "Min"  B2 = `pmin_m' C2 = `pmin_f', nformat("0.0") 
putexcel A3 = "10th" B3 = `p10_m' C3 = `p10_f', nformat("0.0") 
putexcel A4 = "25th" B4 = `p25_m' C4 = `p25_f', nformat("0.0") 
putexcel A5 = "50th" B5 = `p50_m' C5 = `p50_f', nformat("0.0") 
putexcel A6 = "75th" B6 = `p75_m' C6 = `p75_f', nformat("0.0") 
putexcel A7 = "90th" B7 = `p90_m' C7 = `p90_f', nformat("0.0") 
putexcel A8 = "Max"  B8 = `pmax_m' C8 = `pmax_f', nformat("0.0") 

************************************************************************************************
*	Table A2: Distribution of the BI score by gender 
************************************************************************************************

tab lift_most if male==1, matcell(freq_m)
local total_m = `r(N)'
tab lift_most if male==0, matcell(freq_f)
local total_f = `r(N)'

* Get the row names (BI scores) from the matrix and store in a macro
local rows = rowsof(freq_m)

* Create a new Excel file
putexcel set "tables/Table_A2_SLP.xlsx", replace

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
*	Table A4: Distribution of the Eyes Test score
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
putexcel set "tables/Table_A4_SLP.xlsx", replace
putexcel A1 = "Percentile" B1 = "Value"
putexcel A2 = "Min"  B2 = `pmin'
putexcel A3 = "10th" B3 = `p10'
putexcel A4 = "25th" B4 = `p25'
putexcel A5 = "50th" B5 = `p50'
putexcel A6 = "75th" B6 = `p75'
putexcel A7 = "90th" B7 = `p90'
putexcel A8 = "Max"  B8 = `pmax'

**********************************************************************************************************************************************
*	Table A6 Full regression results of individual labor income on strategic thinking skills for male respondents
**********************************************************************************************************************************************

* Baseline controls
* Column (1) 
reg hln_r_laborinc_ann lift_most $con_exo if male==1, robust
outreg2 using "tables/Table_A6.xls", dec(3) label excel replace sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male)   addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No, Gender, Male)
* Column (2) 
reg hln_r_laborinc_ann hor_pay_normal $con_exo if male==1, robust
outreg2 using "tables/Table_A6.xls", dec(3) label excel append sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male)   addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No, Gender, Male)

* + Education, IST, and Eyes Test Score
* Column (3) 
reg hln_r_laborinc_ann lift_most $con_exo $con_cog if male==1, robust
outreg2 using "tables/Table_A6.xls", dec(3) label excel append sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male)   addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No, Gender, Male)
* Column (4) 
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog if male==1, robust
outreg2 using "tables/Table_A6.xls", dec(3) label excel append sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male)   addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No, Gender, Male)

* + Non-cognitive traits, random order, and time taken
* Column (5)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1, robust
outreg2 using "tables/Table_A6.xls", dec(3) label excel append sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male i.race_seq1 i.race_seq2 i.rubin_position_1 i.rubin_position_2 time1)  addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (6)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1, robust
outreg2 using "tables/Table_A6.xls", dec(3) label excel append sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male i.race_seq1 i.race_seq2 i.rubin_position_1 i.rubin_position_2 time1)   addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)

************************************************************************************************************************************************
*	Table A7 Full regression results  of individual labor income on strategic thinking skills for female respondents
************************************************************************************************************************************************

* Baseline controls
* Column (1) 
reg hln_r_laborinc_ann lift_most $con_exo if male==0, robust
outreg2 using "tables/Table_A7.xls", dec(3) label excel replace sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male) addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No, Gender, Female)
* Column (2) 
reg hln_r_laborinc_ann hor_pay_normal $con_exo if male==0, robust
outreg2 using "tables/Table_A7.xls", dec(3) label excel append sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male) addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No, Gender, Female)

* + Education, IST, and Eyes Test Score
* Column (3) 
reg hln_r_laborinc_ann lift_most $con_exo $con_cog if male==0, robust
outreg2 using "tables/Table_A7.xls", dec(3) label excel append sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No, Gender, Female)
* Column (4) 
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog if male==0, robust
outreg2 using "tables/Table_A7.xls", dec(3) label excel append sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male)  addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No, Gender, Female)

* + Non-cognitive traits, random order, and time taken
* Column (5)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0, robust
outreg2 using "tables/Table_A7.xls", dec(3) label excel append sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (6)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0, robust
outreg2 using "tables/Table_A7.xls", dec(3) label excel append sortvar(lift_most hor_pay_normal 2.age_grp 3.age_grp chinese marst nliving sp_age2 sp_age99 edu_ter ist eye_normal fp_long risk_general self_efficacy optimism) drop(male) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)

************************************************************************************************
*	Table A8 Panel A (male): Regression of individual labor income on both BI and HOR measures of strategic thinking skills
************************************************************************************************
* Column (1)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1, robust
outreg2 using "tables/Table_A8A.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (2)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1, robust
outreg2 using "tables/Table_A8A.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (3)
reg hln_r_laborinc_ann lift_most  hor_pay_normal $con_exo $con_cog $con_add time1 $random_order1 time2 $random_order2 if male==1, robust
outreg2 using "tables/Table_A8A.xls", dec(3) label excel append nocons keep(lift_most hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)

************************************************************************************************
*	Table A8 Panel B (female): Regression of individual labor income on both BI and HOR measures of strategic thinking skills
************************************************************************************************
* Column (1)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0, robust
outreg2 using "tables/Table_A8B.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (2)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0, robust
outreg2 using "tables/Table_A8B.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (3)
reg hln_r_laborinc_ann lift_most  hor_pay_normal $con_exo $con_cog $con_add time1 $random_order1 time2 $random_order2 if male==0, robust
outreg2 using "tables/Table_A8B.xls", dec(3) label excel append nocons keep(lift_most hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)


************************************************************************************************
*	Table A9: Quantile regression results of male labor income
************************************************************************************************

* 10th percentile omitted (due to non-convergence)
local yoyo "replace"
forval i=2/9 {
	
qreg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1,  q(0.`i') vce(robust)
outreg2 using "tables/Table_A9A.xls", dec(3) label  excel `yoyo' nocons keep(lift_most) addstat(Pseudo R2, `e(r2_p)') addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Quantile, 0.`i')

qreg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1,  q(0.`i') vce(robust)
outreg2 using "tables/Table_A9B.xls", dec(3) label  excel `yoyo' nocons keep(hor_pay_normal) addstat(Pseudo R2, `e(r2_p)')  addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Quantile, 0.`i')

local yoyo "append"
}

************************************************************************************************
*	Table A10: Quantile regression results of female labor income
************************************************************************************************

* 10th and 20th percentiles omitted (due to non-convergence)
local yoyo "replace"
forval i=3/9 {
	
qreg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0,  q(0.`i') vce(robust)
outreg2 using "tables/Table_A10A.xls", dec(3) label  excel `yoyo' nocons keep(lift_most) addstat(Pseudo R2, `e(r2_p)') addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Quantile, 0.`i')

qreg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0,  q(0.`i') vce(robust)
outreg2 using "tables/Table_A10B.xls", dec(3) label  excel `yoyo' nocons keep(hor_pay_normal) addstat(Pseudo R2, `e(r2_p)') addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Quantile, 0.`i')

local yoyo "append"
}

************************************************************************************************
*	Table A11: Regression of annual labor income (excl. 0s)
************************************************************************************************

* Column (1)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1 & r_poslinc==1, robust
outreg2 using "tables/Table_A11.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (2)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1 & r_poslinc==1, robust
outreg2 using "tables/Table_A11.xls", dec(3) label excel append nocons keep(hor_pay_normal)addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (3)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0 & r_poslinc==1, robust
outreg2 using "tables/Table_A11.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (4)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0 & r_poslinc==1, robust
outreg2 using "tables/Table_A11.xls", dec(3) label excel append nocons keep(hor_pay_normal)addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)

************************************************************************************************
*	Table A12: Regression of household labor income on alternative strategic thinking skills
************************************************************************************************

* Construct tercile dummies
* Gender-specific BI  distribution is the same so I don't differentiate them
gen bi_trio = 0 if lift_most==0
replace bi_trio = 1 if lift_most==1
replace bi_trio = 2 if lift_most==2 | lift_most==3 | lift_most==4 

bysort male: egen temp1=pctile(hor_pay_normal), p(33)
bysort male: egen temp2=pctile(hor_pay_normal), p(66)
bysort male: gen hor_pay_trio=0 if hor_pay_normal < temp1
bysort male: replace hor_pay_trio=1 if hor_pay_normal >= temp1 & hor_pay_normal < temp2
bysort male: replace hor_pay_trio=2 if hor_pay_normal >= temp2 & hor_pay_normal !=.

lab var hor_pay_trio "3 equal-sized group of HOR Expected Payoff"
lab var bi_trio "3 equal-sized group of BI Level"

label define trio_lbl 0 "Bottom 1/3"
label define trio_lbl 1 "Middle 1/3", add
label define trio_lbl 2 "Top 1/3", add

label define bitrio_lbl 0 "BI score = 0"
label define bitrio_lbl 1 "BI score = 1", add
label define bitrio_lbl 2 "BI score = 2+", add

label value hor_pay_trio trio_lbl
label value bi_trio bitrio_lbl

* Column (1)
reg hln_h_labinc i.bi_trio $con_exo $con_cog $con_add time1 $random_order1 if male==1 & marst==1, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel replace nocons keep(1.bi_trio 2.bi_trio) cttop(male)
* Column (2)
reg hln_h_labinc lift_numwins $con_exo $con_cog $con_add time1 $random_order1 if male==1 & marst==1, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append nocons keep(lift_numwins) cttop(male)
* Column (3)
reg hln_h_labinc i.hor_pay_trio $con_exo $con_cog $con_add time2 $random_order2 if male==1 & marst==1, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append  nocons keep(1.hor_pay_trio 2.hor_pay_trio) cttop(male)
* Column (4)
reg hln_h_labinc task2_level $con_exo $con_cog $con_add time2 $random_order2 if male==1 & marst==1, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append  nocons keep(task2_level) cttop(male)
* Column (5)
reg hln_h_labinc i.bi_trio $con_exo $con_cog $con_add time1 $random_order1 if male==0 & marst==1, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append nocons keep(1.bi_trio 2.bi_trio) cttop(female)
* Column (6)
reg hln_h_labinc lift_numwins $con_exo $con_cog $con_add time1 $random_order1 if male==0 & marst==1, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append nocons keep(lift_numwins) cttop(female)
* Column (7)
reg hln_h_labinc i.hor_pay_trio $con_exo $con_cog $con_add time2 $random_order2 if male==0 & marst==1, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append  nocons keep(1.hor_pay_trio 2.hor_pay_trio) cttop(female)  
* Column (8)
reg hln_h_labinc task2_level $con_exo $con_cog $con_add time2 $random_order2 if male==0 & marst==1, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append  nocons keep(task2_level) cttop(female)
* Column (9)
reg hln_h_labinc i.bi_trio $con_exo $con_cog $con_add time1 $random_order1 if male==0 & marst==1 & r_poslinc==0, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append nocons keep(1.bi_trio 2.bi_trio) cttop(male) cttop(nonworking_female)
* Column (10)
reg hln_h_labinc lift_numwins $con_exo $con_cog $con_add time1 $random_order1 if male==0 & marst==1 & r_poslinc==0, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append nocons keep(lift_numwins) cttop(nonworking_female)
* Column (11)
reg hln_h_labinc i.hor_pay_trio $con_exo $con_cog $con_add time2 $random_order2 if male==0 & marst==1 & r_poslinc==0, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append  nocons keep(1.hor_pay_trio 2.hor_pay_trio) cttop(nonworking_female)
* Column (12)
reg hln_h_labinc task2_level $con_exo $con_cog $con_add time2 $random_order2 if male==0 & marst==1 & r_poslinc==0, robust
outreg2 using "tables/Table_A12.xls", dec(3) label excel append  nocons keep(task2_level) cttop(nonworking_female)

************************************************************************************************
*	Table A13: Pooled regression of individual labor income on strategic thinking skills
************************************************************************************************
preserve

use "processed_data/SLP_cleaned.dta", clear

* Keep the data from the three annual waves when the annual income was surveyed and those who completed the experimental module
keep if partic==1 & (wv==6 | wv==18 | wv==30)

* Drop the sample with key missing covariates including the Eyes test (which drops non-participants automatically)
qui: reg hln_r_laborinc_ann age male chinese marst nliving  edu_ter ist eye_normal fp_long risk_general self_efficacy optimism
keep if e(sample)==1
* Column (1)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 i.wv if male==1, cluster(prim_key)
outreg2 using "tables/Table_A13.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes) cttop(male)
* Column (2)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 i.wv if male==1, cluster(prim_key)
outreg2 using "tables/Table_A13.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes) cttop(male)
* Column (3)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 i.wv if male==0, cluster(prim_key)
outreg2 using "tables/Table_A13.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes) cttop(female)
* Column (4)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 i.wv if male==0, cluster(prim_key)
outreg2 using "tables/Table_A13.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes) cttop(female)

************************************************************************************************
*	Table A14: Pooled regression of household labor income on married respondents' strategic thinking skills
************************************************************************************************

* Column (1)
reg hln_h_labinc lift_most $con_exo $con_cog $con_add time1 $random_order1 i.wv if male==1 & marst==1, cluster(prim_key)
outreg2 using "tables/Table_A14.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes) cttop(male)
* Column (2)
reg hln_h_labinc hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 i.wv if male==1 & marst==1, cluster(prim_key)
outreg2 using "tables/Table_A14.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes) cttop(male)
* Column (3)
reg hln_h_labinc lift_most $con_exo $con_cog $con_add time1 $random_order1 i.wv if male==0 & marst==1, cluster(prim_key)
outreg2 using "tables/Table_A14.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes) cttop(female)
* Column (4)
reg hln_h_labinc hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 i.wv if male==0 & marst==1, cluster(prim_key)
outreg2 using "tables/Table_A14.xls", dec(3) label excel append nocons keep(hor_pay_normal)addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes) cttop(female)
* Column (5)
reg hln_h_labinc lift_most $con_exo $con_cog $con_add time1 $random_order1 i.wv if male==0 & marst==1 & r_poslinc==0, cluster(prim_key)
outreg2 using "tables/Table_A14.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes) cttop(nonworking_female)
* Column (6)
reg hln_h_labinc hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 i.wv if male==0 & marst==1 & r_poslinc==0, cluster(prim_key)
outreg2 using "tables/Table_A14.xls", dec(3) label excel append nocons keep(hor_pay_normal)addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes) cttop(nonworking_female)

************************************************************************************************
*	Table A15: Pooled regression results for multiyear annual labor income (intensive margin and extensive magin)
************************************************************************************************

* Column (1)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 i.wv if male==1 & r_poslinc==1, cluster(prim_key)
outreg2 using "tables/Table_A15.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (2)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 i.wv if male==1 & r_poslinc==1, cluster(prim_key)
outreg2 using "tables/Table_A15.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (3)
reg hln_r_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 i.wv if male==0 & r_poslinc==1, cluster(prim_key)
outreg2 using "tables/Table_A15.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (4)
reg hln_r_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 i.wv if male==0 & r_poslinc==1, cluster(prim_key)
outreg2 using "tables/Table_A15.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (5)
reg r_poslinc lift_most $con_exo $con_cog $con_add time1 $random_order1 i.wv if male==1, cluster(prim_key)
outreg2 using "tables/Table_A15.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (6)
reg r_poslinc hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 i.wv if male==1, cluster(prim_key)
outreg2 using "tables/Table_A15.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Male)
* Column (7)
reg r_poslinc lift_most $con_exo $con_cog $con_add time1 $random_order1 i.wv if male==0, cluster(prim_key)
outreg2 using "tables/Table_A15.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)
* Column (8)
reg r_poslinc hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 i.wv if male==0, cluster(prim_key)
outreg2 using "tables/Table_A15.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes, Gender, Female)

restore 

************************************************************************************************
*	Table A16: Regression of male labor income based on their wife's strategic thinking skills
************************************************************************************************

* Column (1)
reg hln_s_laborinc_ann lift_most $con_exo if male==0 & marst==1, robust
outreg2 using "tables/Table_A16.xls", dec(3) label excel replace  nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No)
* Column (2)
reg hln_s_laborinc_ann hor_pay_normal $con_exo if male==0 & marst==1, robust
outreg2 using "tables/Table_A16.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No)
* Column (3)
reg hln_s_laborinc_ann lift_most $con_exo $con_cog if male==0 & marst==1, robust
outreg2 using "tables/Table_A16.xls", dec(3) label excel append nocons drop(male  marst $con_exo $con_cog) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No)
* Column (4)
reg hln_s_laborinc_ann hor_pay_normal $con_exo $con_cog if male==0 & marst==1, robust
outreg2 using "tables/Table_A16.xls", dec(3) label excel append nocons keep(hor_pay_normal)  addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No)
* Column (5)
reg hln_s_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0 & marst==1, robust
outreg2 using "tables/Table_A16.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (6)
reg hln_s_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0 & marst==1, robust
outreg2 using "tables/Table_A16.xls", dec(3) label excel append nocons keep(hor_pay_normal)  addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)

************************************************************************************************
*	Table A17: Regression of female labor income based on their husband's strategic thinking skills
************************************************************************************************

* Column (1)
reg hln_s_laborinc_ann lift_most $con_exo if male==1 & marst==1, robust
outreg2 using "tables/Table_A17.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No)
* Column (2)
reg hln_s_laborinc_ann hor_pay_normal $con_exo if male==1 & marst==1, robust
outreg2 using "tables/Table_A17.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, No, NonCog and Pref, No)
* Column (3)
reg hln_s_laborinc_ann lift_most $con_exo $con_cog if male==1 & marst==1, robust
outreg2 using "tables/Table_A17.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No)
* Column (4)
reg hln_s_laborinc_ann hor_pay_normal $con_exo $con_cog if male==1 & marst==1, robust
outreg2 using "tables/Table_A17.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, No)
* Column (5)
reg hln_s_laborinc_ann lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1 & marst==1, robust
outreg2 using "tables/Table_A17.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (6)
reg hln_s_laborinc_ann hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1 & marst==1, robust
outreg2 using "tables/Table_A17.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)

************************************************************************************************
*	Table A18: Regression results for the spouse's labor supply by gender
************************************************************************************************

* Column (1)
reg s_laborinc_anypos lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1 & marst==1, robust
outreg2 using "tables/Table_A18.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (2)
reg s_laborinc_anypos hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1 & marst==1, robust
outreg2 using "tables/Table_A18.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (3)
reg s_laborinc_anypos lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0 & marst==1, robust
outreg2 using "tables/Table_A18.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (4)
reg s_laborinc_anypos hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0 & marst==1, robust
outreg2 using "tables/Table_A18.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)

************************************************************************************************
*	Table A19: Regression results for the occupation choice and social skill requirement
************************************************************************************************

* Column (1)
reg social_skill_longest lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1, robust
outreg2 using "tables/Table_A19.xls", dec(3) label excel replace nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (2)
reg social_skill_longest hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1, robust
outreg2 using "tables/Table_A19.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (3)
reg social_skill_longest lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0, robust
outreg2 using "tables/Table_A19.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (4)
reg social_skill_longest hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0, robust
outreg2 using "tables/Table_A19.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (5)
reg social_job lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==1, robust
outreg2 using "tables/Table_A19.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (6)
reg social_job hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==1, robust
outreg2 using "tables/Table_A19.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (7)
reg social_job lift_most $con_exo $con_cog $con_add time1 $random_order1 if male==0, robust
outreg2 using "tables/Table_A19.xls", dec(3) label excel append nocons keep(lift_most) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)
* Column (8)
reg social_job hor_pay_normal $con_exo $con_cog $con_add time2 $random_order2 if male==0, robust
outreg2 using "tables/Table_A19.xls", dec(3) label excel append nocons keep(hor_pay_normal) addtext(Demog, Yes, Cog and Edu, Yes, NonCog and Pref, Yes)

************************************************************************************************
*	Table A20: Regression results for household income on the couple's strategic thinking skills
************************************************************************************************

* construct the temporary couples sample data (working husband and non-working wife)
preserve

use "processed_data/SLP_cleaned.dta", clear
* Keep only those who completed the module
keep if partic==1 & wv==25 & marst==1

tempvar hlift
gen `hlift'=lift_most if male==1
tempvar wlift
gen `wlift'=lift_most if male==0
bysort hhid: egen hubby_lift = max(`hlift')
bysort hhid: egen wife_lift = max(`wlift')

tempvar hmq
gen `hmq'=task2_level if male==1
tempvar wmq
gen `wmq'=task2_level if male==0
bysort hhid: egen hubby_mq = max(`hmq')
bysort hhid: egen wife_mq = max(`wmq')

tempvar hmq2
gen `hmq2'=hor_pay_normal if male==1
tempvar wmq2
gen `wmq2'=hor_pay_normal if male==0
bysort hhid: egen hubby_hor = max(`hmq2')
bysort hhid: egen wife_hor = max(`wmq2')

lab var wife_lift "Wife's BI score"
lab var wife_hor "Wife's HOR score (standardized)"

* Column (1)
reg hln_h_labinc hubby_lift wife_lift $con_exo $con_cog $con_add time1 $random_order1 if male==1 & r_poslinc==1 & s_laborinc_ann==0, robust
outreg2 using "tables/Table_A20.xls", dec(3) label excel replace nocons keep(wife_lift) addtext(R Working, Yes, SP Working, No)
* Column (2)
reg hln_h_labinc hubby_hor wife_hor $con_exo $con_cog $con_add time2 $random_order2 if male==1 & r_poslinc==1 & s_laborinc_ann==0, robust
outreg2 using "tables/Table_A20.xls", dec(3) label excel append nocons keep(wife_hor) addtext(R Working, Yes, SP Working, No)
* Column (3)
*reg hln_h_labinc hubby_lift wife_lift $con_exo $con_cog $con_add time1 $random_order1 if male==0 & s_laborinc_ann > 0 & r_poslinc==0, robust
*outreg2 using "tables/Table_A20.xls", dec(3) label excel replace nocons keep(wife_lift) addtext(R Working, Yes, SP Working, No)
* Column (4)
*reg hln_h_labinc hubby_hor wife_hor $con_exo $con_cog $con_add time2 $random_order2 if male==0 & s_laborinc_ann > 0 & r_poslinc==0, robust
*outreg2 using "tables/Table_A20.xls", dec(3) label excel append nocons keep(wife_hor) addtext(R Working, Yes, SP Working, No)


tempvar heye
gen `heye'=eye_total if male==1
tempvar weye
gen `weye'=eye_total if male==0
bysort hhid: egen hubby_eye = max(`heye')
bysort hhid: egen wife_eye = max(`weye')

tempvar heye
gen `heye'=edu_ter if male==1
tempvar weye
gen `weye'=edu_ter if male==0
bysort hhid: egen hubby_edu_ter = max(`heye')
bysort hhid: egen wife_edu_ter = max(`weye')

tempvar hist
gen `hist'=ist if male==1
tempvar wist
gen `wist'=ist if male==0
bysort hhid: egen hubby_ist = max(`hist')
bysort hhid: egen wife_ist = max(`wist')

tempvar heye
gen `heye'=risk_general if male==1
tempvar weye
gen `weye'=risk_general if male==0
bysort hhid: egen hubby_risk = max(`heye')
bysort hhid: egen wife_risk = max(`weye')


tempvar heye
gen `heye'=self_efficacy if male==1
tempvar weye
gen `weye'=self_efficacy if male==0
bysort hhid: egen hubby_self_eff = max(`heye')
bysort hhid: egen wife_self_eff = max(`weye')

* married couple's correlation (last paragraph of Section 2)
corr hubby_lift wife_lift if male==1
corr hubby_hor wife_hor if male==1
corr hubby_edu_ter wife_edu_ter if male==1
corr hubby_ist wife_ist if male==1
corr hubby_eye wife_eye if male==1
corr hubby_risk wife_risk if male==1
corr hubby_self_eff wife_self_eff if male==1

restore

************************************************************************************************
*	Table A21 HOR order classifications and empirical distributions )
************************************************************************************************

tab task2_level, matcell(freq)

* Get the row names (BI scores) from the matrix and store in a macro
local rows = rowsof(freq)

* Create a new Excel file
putexcel set "tables/Table_A21_SLP.xlsx", replace

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
*	Table A22 Distribution of the BI counting scores 
************************************************************************************************

tab lift_numwins, matcell(freq)

* Get the row names (BI scores) from the matrix and store in a macro
local rows = rowsof(freq)

* Create a new Excel file
putexcel set "tables/Table_A22_SLP.xlsx", replace

* Write the headers to the Excel file
putexcel A1 = "BI Counting Score"
putexcel B1 = "Percent"

* Write the BI scores and percentages to the Excel file
forvalues i = 1/`rows' {
    local row = `i' + 1
    putexcel A`row' = "`i'"
    putexcel B`row' = freq[`i',1]/`r(N)', nformat(percent_d2)
}

************************************************************************************************
*	Table A23: Regression of labor income on alternative strategic thinking skills
************************************************************************************************

* Column (1)
reg hln_r_laborinc_ann i.bi_trio $con_exo $con_cog $con_add time1 $random_order1 if male==1, robust
outreg2 using "tables/Table_A23.xls", dec(3) label excel replace nocons keep(1.bi_trio 2.bi_trio) cttop(male)
* Column (2)
reg hln_r_laborinc_ann lift_numwins $con_exo $con_cog $con_add time1 $random_order1 if male==1, robust
outreg2 using "tables/Table_A23.xls", dec(3) label excel append nocons keep(lift_numwins) cttop(male)
* Column (3)
reg hln_r_laborinc_ann i.hor_pay_trio $con_exo $con_cog $con_add time2 $random_order2 if male==1, robust
outreg2 using "tables/Table_A23.xls", dec(3) label excel append  nocons keep(1.hor_pay_trio 2.hor_pay_trio) cttop(male)
* Column (4)
reg hln_r_laborinc_ann task2_level $con_exo $con_cog $con_add time2 $random_order2 if male==1, robust
outreg2 using "tables/Table_A23.xls", dec(3) label excel append  nocons keep(task2_level) cttop(male)
* Column (5)
reg hln_r_laborinc_ann i.bi_trio $con_exo $con_cog $con_add time1 $random_order1 if male==0, robust
outreg2 using "tables/Table_A23.xls", dec(3) label excel append nocons keep(1.bi_trio 2.bi_trio) cttop(female)
* Column (6)
reg hln_r_laborinc_ann lift_numwins $con_exo $con_cog $con_add time1 $random_order1 if male==0, robust
outreg2 using "tables/Table_A23.xls", dec(3) label excel append nocons keep(lift_numwins) cttop(female)
* Column (7)
reg hln_r_laborinc_ann i.hor_pay_trio $con_exo $con_cog $con_add time2 $random_order2 if male==0, robust
outreg2 using "tables/Table_A23.xls", dec(3) label excel append  nocons keep(1.hor_pay_trio 2.hor_pay_trio) cttop(female)
* Column (8)
reg hln_r_laborinc_ann task2_level $con_exo $con_cog $con_add time2 $random_order2 if male==0, robust
outreg2 using "tables/Table_A23.xls", dec(3) label excel append  nocons keep(task2_level) cttop(female)


							
************************************************************************************************
*	Figure 1 Labor status composition of participants with zero labor income
************************************************************************************************
graph bar (mean) rlfret (mean) rlfunemp (mean) rlfhmemak  (mean) rlf_other if r_poslinc==0, over(male, descending) legend(order( 1 "Retired" 2 "Unemployed" 3 "Home-maker"  4 "Others" )) scheme(s2mono) graphregion(color(white)) ytitle("Proportion")
graph save Graph "figures/Fig_1.gph", replace
cap erase "figures/Fig_1.png"
graph export "figures/Fig_1.png", replace

************************************************************************************************
*	Figure A5: Comparing explanatory power for individual labor market outcomes
************************************************************************************************

preserve
 
* Relative Explanatory Power
pcorr hln_r_laborinc_ann lift_most hor_pay_normal eye_normal ist age chinese marst nliving edu_ter fp_long risk_general self_efficacy optimism if male==1
matrix a1=r(p_corr)
pcorr hln_r_laborinc_ann lift_most hor_pay_normal eye_normal ist age chinese marst nliving edu_ter fp_long risk_general self_efficacy optimism if male==0
matrix a2=r(p_corr)
 
pcorr hln_r_laborinc_ann lift_most hor_pay_normal eye_normal ist age chinese marst nliving edu_ter fp_long risk_general self_efficacy optimism if male==1 & r_laborinc_anypos==1
matrix a3=r(p_corr)
 pcorr hln_r_laborinc_ann lift_most hor_pay_normal eye_normal ist age chinese marst nliving edu_ter fp_long risk_general self_efficacy optimism if male==0 & r_laborinc_anypos==1
matrix a4=r(p_corr)
 
pcorr r_laborinc_anypos lift_most hor_pay_normal eye_normal ist age chinese marst nliving edu_ter fp_long risk_general self_efficacy optimism if male==1
matrix a5=r(p_corr)
pcorr r_laborinc_anypos lift_most hor_pay_normal eye_normal ist age chinese marst nliving edu_ter fp_long risk_general self_efficacy optimism if male==0
matrix a6=r(p_corr)
 
matrix coljoin total = a1 a2 a3 a4 a5 a6

clear
 
svmat total, names(par_coef)
 
gen par_a1_r2=par_coef1*par_coef1
egen total_a1=total(par_a1_r2)
gen rel_exp_a1=par_a1_r2/total_a1
 
gen par_a2_r2=par_coef2*par_coef2
egen total_a2=total(par_a2_r2)
gen rel_exp_a2=par_a2_r2/total_a2
 
gen par_b1_r2=par_coef3*par_coef3
egen total_b1=total(par_b1_r2)
gen rel_exp_b1=par_b1_r2/total_b1
 
gen par_b2_r2=par_coef4*par_coef4
egen total_b2=total(par_b2_r2)
gen rel_exp_b2=par_b2_r2/total_b2
  
gen par_c1_r1=par_coef5*par_coef5
egen total_c1=total(par_c1_r1)
gen rel_exp_c1=par_c1_r1/total_c1
 
gen par_c2_r2=par_coef6*par_coef6
egen total_c2=total(par_c2_r2)
gen rel_exp_c2=par_c2_r2/total_c2
 
gen var=_n
  
drop if var > 4

label define ss_lbl 1 "BI Score"
label define ss_lbl 2 "HOR Score", add
label define ss_lbl 3 "Eyes Test Score", add
label define ss_lbl 4 "IST Score", add
label value var ss_lbl	

keep rel* var

reshape long rel_exp_a rel_exp_b rel_exp_c, i(var) j(male)
 
lab var male "Male"
label define male_lbl 1 "Male"
label define male_lbl 2 "Female", add
label value male male_lbl	
lab var rel_exp_a "Annual own labor income (incl. 0s)"
lab var rel_exp_b "Annual own labor income (excl. 0s)"
lab var rel_exp_c "1{labor income > 0}"

* Panel A
graph bar (asis)  rel_exp_a, over(var, label(labsize(small)))  ylabel(0(0.03)0.15) by(male, note("") graphregion(fcolor(white))) ytitle(Percent) asyvars subtitle(, fcolor(white) lcolor(white)) note("") scheme(s2mono)
graph save Graph "figures/Fig_A5A.gph", replace
graph export "figures/Fig_A5A.png", replace
* Panel B
graph bar (asis)  rel_exp_b, over(var, label(labsize(small)))  ylabel(0(0.03)0.15) by(male, note("") graphregion(fcolor(white))) ytitle(Percent) asyvars subtitle(, fcolor(white) lcolor(white)) note("") scheme(s2mono)
graph save Graph "figures/Fig_A5B.gph", replace
graph export "figures/Fig_A5B.png", replace
* Panel C
graph bar (asis)  rel_exp_c, over(var, label(labsize(small)))  ylabel(0(0.03)0.15) by(male, note("") graphregion(fcolor(white))) ytitle(Percent) asyvars subtitle(, fcolor(white) lcolor(white)) note("") scheme(s2mono)
graph save Graph "figures/Fig_A5C.gph", replace
graph export "figures/Fig_A5C.png", replace
  
restore

************************************************************************************************
*	Figure A6: Annual labor income by strategic thinking skills
************************************************************************************************

* create gender-specific eye test score tercile dummies (turns out to be gender-independent)
bysort male: tab eye_total 
gen eye_trio = 0 if eye_total <= 18 & male==1
replace eye_trio = 0 if eye_total <= 18 & male==0
replace eye_trio = 1 if eye_total >= 19 & eye_total <= 21 & male==1
replace eye_trio = 1 if eye_total >= 19 & eye_total <= 21 & male==0
replace eye_trio = 2 if eye_total >= 22 & male==1
replace eye_trio = 2 if eye_total >= 22 & male==0

* create gender-specific IST score tercile dummies 
bysort male: tab ist, m
gen ist_trio = 0 if ist <= 8 & male==0
replace ist_trio = 0 if ist <= 9 & male==1
replace ist_trio = 1 if ist >= 9 & ist < 13 & male==0
replace ist_trio = 1 if ist >= 10 & ist < 14 & male==1
replace ist_trio = 2 if ist >= 13 & male==0
replace ist_trio = 2 if ist >= 14 & male==1

lab var eye_trio "3 equal-sized group of RMET Score"
lab var ist_trio "3 equal-sized group of IST (gender-specific)"

label define ist_trio_lbl 0 "IST Bottom 1/3"
label define ist_trio_lbl 1 "IST Middle 1/3", add
label define ist_trio_lbl 2 "IST Top 1/3", add

label value ist_trio ist_trio_lbl	
label value eye_trio trio_lbl	

preserve

 * compute statistics (mean, lower bound, upper bound) 
 
  * Panel (a) inputs
 mean r_laborinc_ann if male==1, over(bi_trio)
 matrix a1=r(table)'
 mean r_laborinc_ann if male==1, over(hor_pay_trio)
 matrix a2=r(table)'
 mean r_laborinc_ann if male==1, over(eye_trio)
 matrix a3=r(table)'
 mean r_laborinc_ann if male==1, over(ist_trio)
 matrix a4=r(table)'
 * Panel (b) inputs
 mean r_laborinc_ann if male==0, over(bi_trio)
 matrix a5=r(table)'
 mean r_laborinc_ann if male==0, over(hor_pay_trio)
 matrix a6=r(table)'
 mean r_laborinc_ann if male==0, over(eye_trio)
 matrix a7=r(table)'
 mean r_laborinc_ann if male==0, over(ist_trio)
 matrix a8=r(table)'
 
 matrix rowjoin total_a6 = a1 a2 a3 a4 a5 a6 a7 a8
 
 clear
 svmat total_a6 
 
 ren total_a61 mean
 ren total_a65 lb
 ren total_a66 ub
 
 keep mean lb ub
 
 gen obs=_n
 
 gen male=(obs <13)
 gen gender="male" if male==1
 replace gender="female" if male==0
 
 gen measure = "BI score" if (obs==1 | obs==2 | obs==3) | (obs==13 | obs==14 | obs==15)
 replace measure="HOR score" if (obs==4 | obs==5 | obs==6) | (obs==16 | obs==17 | obs==18)
 replace measure="Eyes Test score" if (obs==7 | obs==8 | obs==9) | (obs==19 | obs==20 | obs==21)
 replace measure="IST Score" if (obs==10 | obs==11 | obs==12) | (obs==22 | obs==23 | obs==24)
 
 gen level= "0" if obs==1 | obs==13
 replace level= "1" if obs==2 | obs==14
 replace level= "2+" if obs==3 | obs==15
 replace level= "Bottom 1/3" if obs==4 | obs==16
 replace level= "Middle 1/3" if obs==5 | obs==17
 replace level= "Top 1/3" if obs==6 | obs==18
 replace level= "Bottom 1/3" if obs==7 | obs==19
 replace level= "Middle 1/3" if obs==8 | obs==20
 replace level= "Top 1/3" if obs==9 | obs==21
 replace level= "Bottom 1/3" if obs==10 | obs==22
 replace level= "Middle 1/3" if obs==11 | obs==23
 replace level= "Top 1/3" if obs==12 | obs==24

 drop obs male
 
 order gender measure level lb mean ub
 
 export delimited using "processed_data/Fig_A6_input.csv", replace
 
 restore
 
************************************************************************************************
*	Figure A7: Extensive margin labor supply by strategic thinking skills
************************************************************************************************

preserve

  * Panel (a) inputs
 mean r_laborinc_anypos if male==1, over(bi_trio)
 matrix a1=r(table)'
 mean r_laborinc_anypos if male==1, over(hor_pay_trio)
 matrix a2=r(table)'
 mean r_laborinc_anypos if male==1, over(eye_trio)
 matrix a3=r(table)'
 mean r_laborinc_anypos if male==1, over(ist_trio)
 matrix a4=r(table)'
 * Panel (b) inputs
 mean r_laborinc_anypos if male==0, over(bi_trio)
 matrix a5=r(table)'
 mean r_laborinc_anypos if male==0, over(hor_pay_trio)
 matrix a6=r(table)'
 mean r_laborinc_anypos if male==0, over(eye_trio)
 matrix a7=r(table)'
 mean r_laborinc_anypos if male==0, over(ist_trio)
 matrix a8=r(table)'
 
 matrix rowjoin total_a6 = a1 a2 a3 a4 a5 a6 a7 a8
 
 clear
 svmat total_a6 
 
 ren total_a61 mean
 ren total_a65 lb
 ren total_a66 ub
 
 keep mean lb ub
 
 gen obs=_n
 
 gen male=(obs <13)
 gen gender="male" if male==1
 replace gender="female" if male==0
 
 gen measure = "BI score" if (obs==1 | obs==2 | obs==3) | (obs==13 | obs==14 | obs==15)
 replace measure="HOR score" if (obs==4 | obs==5 | obs==6) | (obs==16 | obs==17 | obs==18)
 replace measure="Eyes Test score" if (obs==7 | obs==8 | obs==9) | (obs==19 | obs==20 | obs==21)
 replace measure="IST Score" if (obs==10 | obs==11 | obs==12) | (obs==22 | obs==23 | obs==24)
 
 gen level= "0" if obs==1 | obs==13
 replace level= "1" if obs==2 | obs==14
 replace level= "2+" if obs==3 | obs==15
 replace level= "Bottom 1/3" if obs==4 | obs==16
 replace level= "Middle 1/3" if obs==5 | obs==17
 replace level= "Top 1/3" if obs==6 | obs==18
 replace level= "Bottom 1/3" if obs==7 | obs==19
 replace level= "Middle 1/3" if obs==8 | obs==20
 replace level= "Top 1/3" if obs==9 | obs==21
 replace level= "Bottom 1/3" if obs==10 | obs==22
 replace level= "Middle 1/3" if obs==11 | obs==23
 replace level= "Top 1/3" if obs==12 | obs==24

 drop obs male
 
 order gender measure level lb mean ub
 
 export delimited using "processed_data/Fig_A7_input.csv", replace
 
restore 
   
************************************************************************************************
*	Figure A8: Labor income (excluding 0s) by strategic thinking skill measures
************************************************************************************************

preserve

* Panel (a) inputs
 mean r_laborinc_ann if male==1 & r_laborinc_anypos==1, over(bi_trio)
 matrix a1=r(table)'
 mean r_laborinc_ann if male==1 & r_laborinc_anypos==1, over(hor_pay_trio)
 matrix a2=r(table)'
 mean r_laborinc_ann if male==1 & r_laborinc_anypos==1, over(eye_trio)
 matrix a3=r(table)'
 mean r_laborinc_ann if male==1 & r_laborinc_anypos==1, over(ist_trio)
 matrix a4=r(table)'
 * Panel (b) inputs
 mean r_laborinc_ann if male==0 & r_laborinc_anypos==1, over(bi_trio)
 matrix a5=r(table)'
 mean r_laborinc_ann if male==0 & r_laborinc_anypos==1, over(hor_pay_trio)
 matrix a6=r(table)'
 mean r_laborinc_ann if male==0 & r_laborinc_anypos==1, over(eye_trio)
 matrix a7=r(table)'
 mean r_laborinc_ann if male==0 & r_laborinc_anypos==1, over(ist_trio)
 matrix a8=r(table)'
 
 matrix rowjoin total_a6 = a1 a2 a3 a4 a5 a6 a7 a8
 
 clear
 svmat total_a6 
 
 ren total_a61 mean
 ren total_a65 lb
 ren total_a66 ub
 
 keep mean lb ub
 
 gen obs=_n
 
 gen male=(obs <13)
 gen gender="male" if male==1
 replace gender="female" if male==0
 
 gen measure = "BI score" if (obs==1 | obs==2 | obs==3) | (obs==13 | obs==14 | obs==15)
 replace measure="HOR score" if (obs==4 | obs==5 | obs==6) | (obs==16 | obs==17 | obs==18)
 replace measure="Eyes Test score" if (obs==7 | obs==8 | obs==9) | (obs==19 | obs==20 | obs==21)
 replace measure="IST Score" if (obs==10 | obs==11 | obs==12) | (obs==22 | obs==23 | obs==24)
 
 gen level= "0" if obs==1 | obs==13
 replace level= "1" if obs==2 | obs==14
 replace level= "2+" if obs==3 | obs==15
 replace level= "Bottom 1/3" if obs==4 | obs==16
 replace level= "Middle 1/3" if obs==5 | obs==17
 replace level= "Top 1/3" if obs==6 | obs==18
 replace level= "Bottom 1/3" if obs==7 | obs==19
 replace level= "Middle 1/3" if obs==8 | obs==20
 replace level= "Top 1/3" if obs==9 | obs==21
 replace level= "Bottom 1/3" if obs==10 | obs==22
 replace level= "Middle 1/3" if obs==11 | obs==23
 replace level= "Top 1/3" if obs==12 | obs==24

 drop obs male
 
 order gender measure level lb mean ub
 
 export delimited using "processed_data/Fig_A8_input.csv", replace
 
restore 
 
************************************************************************************************
*	Figure A9: Changes in R2 by the choice of regressors
************************************************************************************************

preserve

reg hln_r_laborinc_ann  $con_exo  time1 $random_order1 if male==1, robust
gen var1=e(r2) 
reg hln_r_laborinc_ann  $con_cog $con_exo  time1 $random_order1 if male==1, robust
gen var2=e(r2) 
reg hln_r_laborinc_ann  $con_add $con_cog $con_exo  time1 $random_order1 if male==1, robust
gen var3=e(r2) 
reg hln_r_laborinc_ann  lift_most $con_add $con_cog $con_exo  time1 $random_order1 if male==1, robust
gen var4=e(r2) 
reg hln_r_laborinc_ann hor_pay_normal $con_add $con_cog $con_exo  time1 $random_order1 if male==1, robust
gen var5=e(r2) 
reg hln_r_laborinc_ann  lift_most hor_pay_normal $con_add $con_cog $con_exo  time1 $random_order1 if male==1, robust
gen var6=e(r2) 

reg hln_r_laborinc_ann  $con_exo  time1 $random_order1 if male==0, robust
gen var7=e(r2) 
reg hln_r_laborinc_ann  $con_cog $con_exo  time1 $random_order1 if male==0, robust
gen var8=e(r2) 
reg hln_r_laborinc_ann  $con_add $con_cog $con_exo  time1 $random_order1 if male==0, robust
gen var9=e(r2) 
reg hln_r_laborinc_ann  lift_most $con_add $con_cog $con_exo  time1 $random_order1 if male==0, robust
gen var10=e(r2) 
reg hln_r_laborinc_ann hor_pay_normal $con_add $con_cog $con_exo  time1 $random_order1 if male==0, robust
gen var11=e(r2) 
reg hln_r_laborinc_ann  lift_most hor_pay_normal $con_add $con_cog $con_exo  time1 $random_order1 if male==0, robust
gen var12=e(r2) 


keep if _n==1
label var var1 "Socio-Demographics(A)"
label var var2 "A & Educ, IST, and Eyes Test(B)"
label var var3 "A, B & Non-cognitive Traits(C)"
label var var4 "A, B, C & BI"
label var var5 "A, B, C & HOR"
label var var6 "A, B, C, BI & HOR"
label var var7 "Socio-Demographics(A)"
label var var8 "A & Educ, IST, and Eyes Test(B)"
label var var9 "A, B & Non-cognitive Traits(C)"
label var var10 "A, B, C & BI"
label var var11 "A, B, C & HOR"
label var var12 "A, B, C, BI & HOR"

* Panel A: Male
graph bar (asis) var1-var6, blabel(bar, format(%4.3f)) legend(on) title (Changes in R square for males) scheme(s2mono)
graph save Graph "figures/Fig_A9A.gph", replace
graph export "figures/Fig_A9A.png", replace
* Panel B: Female
graph bar (asis) var7-var12, blabel(bar, format(%4.3f)) legend(on) title (Changes in R square for females) scheme(s2mono)
graph save Graph "figures/Fig_A9B.gph", replace
graph export "figures/Fig_A9B.png", replace


restore


