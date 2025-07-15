* This file reads raw SLP data and produce the cleaned data for the empirical analyses.

clear all

set maxvar 10000
set matsize 11000

*** read SLP raw data
use "rawdata\smu_merge0_39.dta", clear

***	merge oTree data with the SLP data
merge m:1 prim_key using "rawdata\oTree_cleaned.dta"

************************************************************************************************
/*
						Generate variables
*/
**********************************************************************************************
************************************************************************************************
*** Time
************************************************************************************************
   * wave 0 is surveyed in July, 2015)
    * Calendar year 2015
 	gen year = 1 if wv>=0 & wv<=5
	* Calendar Year 2016; Wave 16 is surveyed in November 2016; Wave 28 is surveyed in November 2017; Wave 32 is surveyed in March, 2018
 	replace year = 2 if wv>=6 & wv<=17
	* Calendar Year 2017; 
 	replace year = 3 if wv>=18 & wv <=29
	* Calendar Year 2018;
	replace year = 4 if wv>=30 & wv !=.

	tab year, gen(yr)

 	* Month
 	gen month = .
 	replace month = 7  if wv==0 | wv==12 | wv==24 | wv==36 
 	replace month = 8  if wv==1 | wv==13 | wv==25 
 	replace month = 9  if wv==2 | wv==14 | wv==26
 	replace month = 10 if wv==3 | wv==15 | wv==27
 	replace month = 11 if wv==4 | wv==16 | wv==28
 	replace month = 12 if wv==5 | wv==17 | wv==29
 	
 	replace month = 1  if wv==6 | wv==18 | wv==30
 	replace month = 2  if wv==7 | wv==19 | wv==31
 	replace month = 3  if wv==8 | wv==20 | wv==32
 	replace month = 4  if wv==9 | wv==21 | wv==33
 	replace month = 5  if wv==10 | wv==22 | wv==34
 	replace month = 6  if wv==11 | wv==23 | wv==35
	
		
	* Inflation adjustments
	gen cpi=0.995 if year==1
	replace cpi=1 if year==2
	replace cpi=1.006 if year==3
	* currently year 4 (2018) price is based on Jan-Mar. 
	replace cpi=1.009 if year==4
	
************************************************************************************************
*** Demographics and Socio-Economics Status
************************************************************************************************
  * Age; age_ultfinal is a cleaned version of biological age by the SLP team
	gen age = age_ultfinal
	gen age_sq = (age^2)/100
	gen age60 = (age >= 60)
	
	gen age_grp=0
	replace age_grp=1 if age > 50 & age <= 55
	replace age_grp=2 if age > 55 & age <= 60
	replace age_grp=3 if age > 60 & age <= 65.3
	
	
	drop sp_age
	gen sp_age = spage_ultfinal
	gen sp_age_sq = (sp_age^2)/100
  * 
  * Gender
	gen male = (gender==1) if gender~=.

  * Race (Chinese, Malay, Indian, etc.)
  	tab race, gen(race)

  * Education
	gen edu_prim = (highest_edz==2) if highest_edz~=.
	gen edu_sec  = (highest_edz==3) if highest_edz~=.
	gen edu_ter  = (highest_edz==4) if highest_edz~=.
	
  * Marital status
	rename d005cat marst 
	gen divorced = (d005==4) if d005~=.
	bysort prim_key: egen ever_divorced = max(divorced)
	gen separated = (d005==3) if d005~=.
	bysort prim_key: egen ever_separated = max(separated)	
	gen ever_div_sep = (ever_divorced==1 | ever_separated==1)
	
  * Number of children
  	gen nliving2 = num_living_child
  	replace nliving2 = num_living_child_other if num_living_child==9
  	replace nliving2 = 8 if num_living_child==9 & num_living_child_other==.

  	gen nstep2 = num_step_child
  	replace nstep2 = num_step_child_other if num_step_child==9
  	replace nstep2 = 8 if num_step_child==9 & num_step_child_other==.

  	egen nchildren = rowtotal(nliving nstep) if nliving~=.|nstep~=.
  	bysort prim_key : egen nchild = total(nchildren)
	bysort prim_key : egen nliving = total(nliving2)
	bysort prim_key : egen nstep = total(nstep2)

	
	* Individual Annual  Income 

	bysort prim_key year: egen r_wageinc_ann = max(riwagew)
	bysort prim_key year: egen s_wageinc_ann = max(siwagew)
	bysort prim_key year: egen r_selfinc_ann = max(risemp)
	bysort prim_key year: egen s_selfinc_ann = max(sisemp)
	bysort prim_key year: gen r_laborinc_ann = r_wageinc_ann + r_selfinc_ann
	bysort prim_key year: gen s_laborinc_ann = s_wageinc_ann + s_selfinc_ann

	foreach var of varlist r_wageinc_ann s_wageinc_ann r_selfinc_ann s_selfinc_ann r_laborinc_ann s_laborinc_ann  {
		gen `var'2=`var' 
		replace `var'2=. if `var'==0
	}
	

  * Household annual income 
	bysort prim_key year: egen h_income = total(hitotlcyw)
	tempvar labinc
	egen  `labinc'= rowtotal(hiwagew hisempw) if hiwagew~=. | hisempw~=.
	bysort prim_key year: egen h_labinc = max(`labinc')
	bysort prim_key year: egen h_wageinc = max(hiwagew)
	bysort prim_key year: egen h_selfinc = max(hisempw)
	
		
	* average annual income over 3 years
	bysort prim_key: egen avg_h_income=mean(hitotlcyw)
	bysort prim_key: egen avg_h_labinc=mean(`labinc')	
	gen avg_h_nonlab = avg_h_income - avg_h_labinc


	gen hoho=hitotlcy if wv==6
	bysort prim_key: egen base_hinc = max(hoho)
	drop hoho
	
	foreach var of varlist h_income h_labinc {
		gen `var'2=`var' 
		replace `var'2=. if `var'==0
	}


*** Employment
  * working for pay only  rlfwork slfwork *
	gen workhour35 = (e002==2) if e002~=.
	
	gen empstat100 = rlfwork*100
	gen selfemp100 = rlfsemp*100

	gen emp=empstat100/100
	gen selfemp=selfemp100/100
	gen retired=rlfret
	bysort prim_key: egen unemp_ever = max(rlfunemp)

* Spouse labor supply
	gen sworkhour35 = (e004==2) if e004~=.
	gen semp=slfwork
	gen sselfemp=slfsemp
	gen sretired=slfret

	
* inflation adjustment and log transformations	
	foreach var of varlist  r_wageinc_ann s_wageinc_ann r_selfinc_ann s_selfinc_ann h_income h_labinc h_wageinc h_selfinc ///
	r_laborinc_ann s_laborinc_ann r_wageinc_ann2 s_wageinc_ann2 r_selfinc_ann2 s_selfinc_ann2 r_laborinc_ann2 s_laborinc_ann2  {
		replace `var'=`var'/cpi
		gen ln_`var' = ln(`var') 
		replace ln_`var' = ln(0.00001) if `var'==0
		gen hln_`var'= ln(`var' + (`var'^2+1)^0.5)
	
	}
	
	
	
* financial planning horizon
bysort prim_key: egen fin_horizon = max(s02120)
* risk-loving attitudes
bysort prim_key: egen risk_general = max(s02130)
bysort prim_key: egen risk_finance = max(s02140)



** Create ration of # of participated waves / total waves conducted 
tempvar yoyo
bysort prim_key: gen `yoyo'=_N
gen survey_ratio = `yoyo'/36

bysort prim_key year: gen ann_wavenum=_N


************************************************************************************************
* IST
************************************************************************************************
 
gen ist1= 0 if s04130 !=.
replace ist1= 1 if s04130==3

gen ist2= 0 if s04140 !=.
replace ist2= 1 if s04140==3

gen ist3= 0 if s04150 !=.
replace ist3= 1 if s04150==3

gen ist4= 0 if s04160 !=.
replace ist4= 1 if s04160==2

gen ist5= 0 if s04170 !=.
replace ist5= 1 if s04170==2

gen ist6= 0 if s04180 !=.
replace ist6= 1 if s04180==2

gen ist7= 0 if s04190 !=.
replace ist7= 1 if s04190==1

gen ist8= 0 if s04200 !=.
replace ist8= 1 if s04200==1

gen ist9= 0 if s04210 !=.
replace ist9= 1 if s04210==5

gen ist10= 0 if s04220 !=.
replace ist10= 1 if s04220==1

gen ist11= 0 if s04230 !=.
replace ist11= 1 if s04230==2

gen ist12= 0 if s04240 !=.
replace ist12= 1 if s04240==3

gen ist13= 0 if s04250 !=.
replace ist13= 1 if s04250==4

gen ist14= 0 if s04260 !=.
replace ist14= 1 if s04260==2

gen ist15= 0 if s04270 !=.
replace ist15= 1 if s04270==5

gen ist16= 0 if s04280 !=.
replace ist16= 1 if s04280==2

gen ist17= 0 if s04290 !=.
replace ist17= 1 if s04290==5

gen ist18= 0 if s04300 !=.
replace ist18= 1 if s04300==2

gen ist19= 0 if s04310 !=.
replace ist19= 1 if s04310==4

gen ist20= 0 if s04320 !=.
replace ist20= 1 if s04320==5

gen ist_score=ist1
forvalues i=2/20 {
	replace ist_score=ist_score + ist`i'
}
gen ist_temp=ist1+ist2+ist3+ist4+ist5+ist6+ist7+ist8+ist9+ist10+ist11+ist12+ist13+ist14+ist15+ist16+ist17+ist18+ist19+ist20

bysort prim_key: egen ist=total(ist_score)
bysort prim_key: egen ist_min = min(ist_score)
replace ist=. if ist_min==.

egen eye_normal=std(eye_total)


gen chinese=(race==1)
gen malay=(race==2)
gen indian=(race==3)

gen fp_long=1 if fin_horizon==4 | fin_horizon==5
replace fp_long=0 if fin_horizon==1 | fin_horizon==2 | fin_horizon==3


************************************************************************************************
* POSO-E Personality Optimism Scale (abridged version by Gavrilov-Jerkovic, Jovanovic, Zuljevic & Brdaric (2013) 
************************************************************************************************

tempvar opt1
gen `opt1' = s03270s1+s03270s2+s03270s5+s03270s7
bysort prim_key: egen self_efficacy=max(`opt1')

tempvar opt2
gen `opt2' = s03270s3+(6-s03270s4)+(6-s03270s6)+(6-s03270s8)
bysort prim_key: egen optimism=max(`opt2')


bysort prim_key: egen trust_careful = max(s03111)
bysort prim_key: egen trust_people = max(s03112)


   ** Patience "People should do what they like today rather than waiting until tomorrow"
   bysort prim_key: egen impatience=max(s06110s3)

   destring hhid, replace

gen time1 = Time_Spent1/10000
gen time2 = Time_Spent2/10000

 
** Construct the occupation and sector variables
sort prim_key wv

gen e01130z=e01130
format e01130z %05.0f 
gen e02130z=e02130
format e02130z %05.0f 
gen e03130z=e03130
format e03130z %05.0f 


*Occupation*********************************************************************
**Current Occupation************************************************************
gen current_occ_1=substr(e01160,1,1)
replace current_occ_1="." if current_occ_1=="X"
destring current_occ_1, replace
label variable current_occ_1 "Current Job - Occupation 1digit"
label values current_occ_1 current_occ_1
label define current_occ_1 1 "1 LEGISLATORS, SENIOR OFFICIALS AND MANAGERS" 2 "2 PROFESSIONALS" 3 "3 ASSOCIATE PROFESSIONALS AND TECHNICIANS" 4 "4 CLERICAL SUPPORT WORKERS" 5 "5 SERVICE AND SALES WORKERS" 6 "6 AGRICULTURAL AND FISHERY WORKERS" 7 "7 CRAFTSMEN AND RELATED TRADES WORKERS" 8 "8 PLANT AND MACHINE OPERATORS AND ASSEMBLERS" 9 "9 CLEANERS, LABOURERS AND RELATED WORKERS"

by prim_key: egen current_occ_1_all=max(current_occ_1)
label variable current_occ_1_all "Current Job - Occupation 1digit"
label values current_occ_1_all current_occ_1_all
label define current_occ_1_all 1 "1 LEGISLATORS, SENIOR OFFICIALS AND MANAGERS" 2 "2 PROFESSIONALS" 3 "3 ASSOCIATE PROFESSIONALS AND TECHNICIANS" 4 "4 CLERICAL SUPPORT WORKERS" 5 "5 SERVICE AND SALES WORKERS" 6 "6 AGRICULTURAL AND FISHERY WORKERS" 7 "7 CRAFTSMEN AND RELATED TRADES WORKERS" 8 "8 PLANT AND MACHINE OPERATORS AND ASSEMBLERS" 9 "9 CLEANERS, LABOURERS AND RELATED WORKERS"

gen current_occ_2=substr(e01160,1,2)
replace current_occ_2="." if current_occ_1==.
destring current_occ_2, replace
label variable current_occ_2 "Current Job - Occupation 2 digits"

by prim_key: egen current_occ_2_all=max(current_occ_2)
label variable current_occ_2_all "Current Job - Occupation 2 digits"
label values current_occ_2_all current_occ_2_all

gen current_occ_4=substr(e01160,1,4)
replace current_occ_4="." if current_occ_1==.
destring current_occ_4, replace
label variable current_occ_4 "Current Job - Occupation 4 digits"

by prim_key: egen current_occ_4_all=max(current_occ_4)
label variable current_occ_4_all "Current Job - Occupation 4 digits"
label values current_occ_4_all current_occ_4_all



**Most Recent Occupation********************************************************
gen recent_occ_1=substr(e02160,1,1)
replace recent_occ_1="." if recent_occ_1=="X"
destring recent_occ_1, replace
label variable recent_occ_1 "Recent Job - Occupation 1digit"
label values recent_occ_1 recent_occ_1
label define recent_occ_1 1 "1 LEGISLATORS, SENIOR OFFICIALS AND MANAGERS" 2 "2 PROFESSIONALS" 3 "3 ASSOCIATE PROFESSIONALS AND TECHNICIANS" 4 "4 CLERICAL SUPPORT WORKERS" 5 "5 SERVICE AND SALES WORKERS" 6 "6 AGRICULTURAL AND FISHERY WORKERS" 7 "7 CRAFTSMEN AND RELATED TRADES WORKERS" 8 "8 PLANT AND MACHINE OPERATORS AND ASSEMBLERS" 9 "9 CLEANERS, LABOURERS AND RELATED WORKERS"

by prim_key: egen recent_occ_1_all=max(recent_occ_1)

gen recent_occ_2=substr(e02160,1,2)
replace recent_occ_2="." if recent_occ_1==.
destring recent_occ_2, replace
label variable recent_occ_2 "Recent Job - Occupation 2 digits"
label values recent_occ_2 recent_occ_2

by prim_key: egen recent_occ_2_all=max(recent_occ_2)

gen recent_occ_4=substr(e02160,1,4)
replace recent_occ_4="." if recent_occ_1==.
destring recent_occ_4, replace
label variable recent_occ_4 "Recent Job - Occupation 4 digits"
label values recent_occ_4 recent_occ_4

by prim_key: egen recent_occ_4_all=max(recent_occ_4)



**Last Occupation***************************************************************
gen last_occ_1=current_occ_1
replace last_occ_1=recent_occ_1 if e02000z==1
label variable last_occ_1 "Last Job (Working=Current, Not-Working=Most Recent) - Occupation 1digit"
label define last_occ_1 1 "1 LEGISLATORS, SENIOR OFFICIALS AND MANAGERS" 2 "2 PROFESSIONALS" 3 "3 ASSOCIATE PROFESSIONALS AND TECHNICIANS" 4 "4 CLERICAL SUPPORT WORKERS" 5 "5 SERVICE AND SALES WORKERS" 6 "6 AGRICULTURAL AND FISHERY WORKERS" 7 "7 CRAFTSMEN AND RELATED TRADES WORKERS" 8 "8 PLANT AND MACHINE OPERATORS AND ASSEMBLERS" 9 "9 CLEANERS, LABOURERS AND RELATED WORKERS"
label values last_occ_1 last_occ_1

by prim_key: egen last_occ_1_all=max(last_occ_1)

gen last_occ_2=current_occ_2
replace last_occ_2=recent_occ_2 if e02000z==1
label variable last_occ_2 "Last Job (Working=Current, Not-Working=Most Recent) - Occupation 2 digits"

by prim_key: egen last_occ_2_all=max(last_occ_2)

gen last_occ_4=current_occ_4
replace last_occ_4=recent_occ_4 if e02000z==1
label variable last_occ_4 "Last Job (Working=Current, Not-Working=Most Recent) - Occupation 4 digits"

by prim_key: egen last_occ_4_all=max(last_occ_4)


**Longest Occupation************************************************************
gen temp=substr(e03160,1,1)
replace temp="." if temp=="X"
destring temp, replace

gen longest_occ_1=temp
replace longest_occ_1=current_occ_1 if e01090z==1
replace longest_occ_1=recent_occ_1 if e02090z==1
label variable longest_occ_1 "Longest Job (if Current==Longest then Current, if Recent==Lognest then Longest, else Longest) - Occupation 1digit"
label values longest_occ_1 longest_occ_1
label define longest_occ_1 1 "1 LEGISLATORS, SENIOR OFFICIALS AND MANAGERS" 2 "2 PROFESSIONALS" 3 "3 ASSOCIATE PROFESSIONALS AND TECHNICIANS" 4 "4 CLERICAL SUPPORT WORKERS" 5 "5 SERVICE AND SALES WORKERS" 6 "6 AGRICULTURAL AND FISHERY WORKERS" 7 "7 CRAFTSMEN AND RELATED TRADES WORKERS" 8 "8 PLANT AND MACHINE OPERATORS AND ASSEMBLERS" 9 "9 CLEANERS, LABOURERS AND RELATED WORKERS"
drop temp

by prim_key: egen longest_occ_1_all=max(longest_occ_1)

gen temp=substr(e03160,1,2)
replace temp="." if temp=="X1" | temp=="X2" | temp=="X3"
destring temp, replace

gen longest_occ_2=temp
replace longest_occ_2=current_occ_2 if e01090z==1
replace longest_occ_2=recent_occ_2 if e02090z==1
label variable longest_occ_2 "Longest Job (if Current==Longest then Current, if Recent==Lognest then Longest, else Longest) - Occupation 2 digits"
drop temp

by prim_key: egen longest_occ_2_all=max(longest_occ_2)

gen temp=substr(e03160,1,4)
replace temp="." if temp=="X100" | temp=="X200" | temp=="X300"
destring temp, replace

gen longest_occ_4=temp
replace longest_occ_4=current_occ_4 if e01090z==1
replace longest_occ_4=recent_occ_4 if e02090z==1
label variable longest_occ_4 "Longest Job (if Current==Longest then Current, if Recent==Lognest then Longest, else Longest) - Occupation 4 digits"
drop temp

by prim_key: egen longest_occ_4_all=max(longest_occ_4)


cap drop _merge

forval q = 1/4 {
	local j: word `q' of "current" "recent" "last" "longest" 
	gen `j'_prof =0 if `j'_occ_2_all !=.
	replace `j'_prof =1 if `j'_occ_2_all == 11 
	gen `j'_prof2 =0 if `j'_occ_2_all !=.
	replace `j'_prof2 =1 if `j'_occ_2_all == 11 | `j'_occ_2_all == 12 
	gen `j'_serv =0 if `j'_occ_2_all !=.
	replace `j'_serv =1 if `j'_occ_2_all == 5 
	
	*** merge with the O*NET data ***
	merge m:1 `j'_occ_4_all using "rawdata/ssoc2015_skills.dta", keepusing(social)
	ren social social_skill_`j'
	drop _merge
}




keep prim_key sp_prim_key hhid  wv year yr* month cpi ///
male age* sp_age* edu_* marst divorced* separated* nchild nliving nstep race* chinese malay indian income_*  *_ann h_* base_hinc   ///
 ln_* hln* workhour35 emp* self* unemp* retire rlf*  ///
 fin_* risk_*  ever_* current* ///
 ist ann_* age_grp fp_long optimism self_efficacy ///
trust_*  current_* recent_* last_* longest_* current_* recent_*  ///
partic finish lift* race* task2* rubin* eye* htr* time* s_laborinc_ann*  social* ///
highest* avg*  impatience sworkhour35 semp sselfemp sretired i001 i003

compress

************************************************************************************************
/*
						Variable and label assignment
*/
************************************************************************************************

*** Label variables
lab var male "Male"
lab var marst "Married"
lab var nchild "Number of children"
lab var chinese "Chinese"

lab var edu_prim "Primary education or below"
lab var edu_sec "Secondary education"
lab var edu_ter "Tertiary education"

lab var retired "Retired"
lab var selfemp  "Self-employed"


lab var ist "IST score"
lab var impatience "People should do what they like today rather than waiting until tomorrow"

lab var fin_horizon "Financial Planning Horizon"
lab var risk_general "Risk tolerance"
lab var risk_finance "Risk-tasking attidue: financial"

lab var h_income "Annul household income"
lab var h_labinc "Annul household labor income"
lab var ln_h_income "Log annul total household income"
lab var ln_h_labinc "Log annul household labor income"
lab var hln_h_income "IHS of  annul total household income"
lab var hln_h_labinc "IHS of  annul household labor income"


lab var ln_r_laborinc_ann "Log annual own labor income"
lab var ln_r_laborinc_ann2 "Log annual own labor income (excl. 0s)"
lab var r_laborinc_ann "Annual Own Labor Income (level)"
lab var hln_r_laborinc_ann "Inverse hyperbolic sine transformation of annual own labor income"


lab var ln_s_laborinc_ann "Log annual spouse labor income"
lab var ln_s_laborinc_ann2 "Log annual spouse labor income (excl. 0s)"
lab var s_laborinc_ann "Annual spouse Labor Income (level)"
lab var hln_s_laborinc_ann "Inverse hyperbolic sine transformation of annual spouse labor income"

lab var workhour35 "Worked more than 35 hours last week"

lab var ever_divorced "Divorced ever since July 2015"
lab var ever_div_sep "Divorced or seperated ever since July 2015"
lab var unemp_ever "Unemployed ever since July 2015"

lab var lift_least "BI: Least Conservative Measure"
lab var race_total "# of Rounds won in the Lift Game "
lab var lift_most "BI Score"
lab var lift_numwins "BI counting score"
lab var lift_step "BI Thinking Step-adjusted Score"


lab var eye_total "Eyes Test Score"


lab var task2_level "HOR Level"
lab var task2_quiz "HOR quiz score"
lab var task2_total "HOR # of Rational Choices"
lab var task2_payoff "HOR Expected Payments"
lab var task2_step "HOR Thinking Step-adjusted Scores"
lab var task2_3type "HOR 3 Type Classification (using choices at A & B only)"
lab var task2_54 "A Binary Indicator of AB_54"
lab var task2_54321 "A Binary Indicator of ABCDE_54321"



lab var yrschoolz "Years of Completed Schooling"

lab var fp_long "Financial Planning Horizon"


lab var optimism "Personal Optimism "
lab var self_efficacy "Self-efficacy "


lab var trust_careful "Need to be careful when dealing with people"
lab var trust_people "Trust in people in general"


lab var current_prof "Current occupation is legislators senior officials and managers"
lab var last_prof "Current or most recent occupation is legislators senior officials and managers"
lab var longest_prof "Longest occupation is legislators senior officials and managers"

lab var current_prof "Current occupation is legislators senior officials and managers professional"
lab var last_prof "Current or most recent occupation is legislators senior officials and managers professional"
lab var longest_prof "Longest occupation is legislators senior officials and managers professional"

lab var current_serv "Current occupation is sales and service workers"
lab var last_serv "Current or most recent occupation is sales and service workers"
lab var longest_serv "Longest occupation is sales and service workers"


lab var avg_h_income "Average Annul household income"
lab var avg_h_labinc "Average Annul household labor income"
lab var avg_h_nonlab "Average Annul household non-labor income"


	label define ag_lbl 1 "Age 50-54"
	label define ag_lbl 2 "Age 55-59", add
	label define ag_lbl 3 "Age 60-65", add
	label define ag_lbl 0 "Age -49, or 66- ", add

	label define male_lbl 0 "Female"
	label define male_lbl 1 "Male", add

	label define redu_lbl 1 "Primary"
	label define redu_lbl 2 "Secondary", add
	label define redu_lbl 3 "Tertiary", add

	label define hh_lbl 1 "Married"
	label define hh_lbl 2 "Have children", add

	label define race_lbl 1 "Chinese"
	label define race_lbl 2 "Malay", add
	label define race_lbl 3 "Indian", add
	label define race_lbl 4 "Other", add
	
	label define lift_lbl 0 "BI Level 0"
	label define lift_lbl 1 "BI Level 1", add
	label define lift_lbl 2 "BI Level 2", add
	label define lift_lbl 3 "BI Level 3", add
	label define lift_lbl 4 "BI Level 4", add
	
	label define mq_lbl 0 "HOR Level 0"
	label define mq_lbl 1 "HOR Level 1", add
	label define mq_lbl 2 "HOR Level 2", add
	label define mq_lbl 3 "HOR Level 3", add
	label define mq_lbl 4 "HOR Level 4", add
	label define mq_lbl 5 "HOR Level 5", add

	label define fincon_lbl 1 "Very confidence"
	label define fincon_lbl 2 "Confidence", add
	label define fincon_lbl 3 "Somewhat confidence", add
	label define fincon_lbl 4 "Not confident", add
	
	label define horizon_lbl 1 "The next few months"
	label define horizon_lbl 2 "The next year", add
	label define horizon_lbl 3 "The next few year", add
	label define horizon_lbl 4 "The next 5-10 years", add
	label define horizon_lbl 5 "Longer than 10 years", add
	

	label value age_grp ag_lbl
	label value fin_horizon horizon_lbl
	
	label value race race_lbl	
	label value male male_lbl
	
	label value lift_most lift_lbl
	label value task2_level mq_lbl
	
	
* drop responses who are not husband or wife
gen line=prim_key - hhid*100
drop if line==3 | line==4

gen workforpay=emp
replace emp=1 if selfemp==1
lab var emp "working for pay or self-employed"
lab var workforpay "working for pay"

gen sworkforpay=semp
replace semp=1 if sselfemp==1
lab var semp "spouse is working for pay or self-employed"
lab var sworkforpay "spouse is working for pay"

lab var sworkhour35 "spouse worked more than 35 hours last week"

lab var sselfemp "spouse is self-employed"
lab var sretired "spouse is retired"

gen hh_bothemp = (emp==1 & semp==1)
gen hh_eitheremp = (emp==1 | semp==1)
gen hh_bothret = (retired==1 & sretired==1)

lab var hh_bothemp "both myself and spouse are working"
lab var hh_eitheremp "either myself or spouse is working"
lab var hh_bothret "both myself and spouse are retired"


gen r_labor_nozero=r_laborinc_ann
replace r_labor_nozero=. if r_laborinc_ann==0
lab var r_labor_nozero "annual own labor income excl. zero's"

* drop if the wave information is missing
drop if wv==.

* impute the missing spouse age and create the missing dummy
gen sp_age2=sp_age
replace sp_age2=99 if sp_age==.
gen sp_age99=(sp_age2==99)

gen h_poslinc=(h_labinc > 0)
gen r_poslinc=(r_laborinc_ann > 0)
gen s_poslinc=(s_laborinc_ann > 0)

gen rlfolf=1
replace rlfolf=0 if rlfwork==1 | rlfsemp==1 | rlfunemp==1 

lab var rlfolf "I(Out of labor force)"


gen r_laborinc_pos = r_laborinc_ann if r_laborinc_ann > 0
gen r_laborinc_anypos = (r_laborinc_ann > 0)
replace r_laborinc_anypos=. if r_laborinc_ann==.

replace s_laborinc_ann=. if marst==0
gen s_laborinc_pos = s_laborinc_ann if s_laborinc_ann > 0
replace s_laborinc_pos =. if marst==0
gen s_laborinc_anypos = (s_laborinc_ann > 0)
replace s_laborinc_anypos=. if s_laborinc_ann==. | marst==0

bysort male: su task2_payoff, detail
bysort male: tab lift_most

gen hor_score=task2_payoff/5
su hor_score, detail
lab var hor_score "HOR Score"


egen hor_pay_normal_male=std(task2_payoff) if male==1
egen hor_pay_normal_female=std(task2_payoff) if male==0
egen eye_normal_male=std(eye_total) if male==1
egen eye_normal_female=std(eye_total) if male==0

gen hor_pay_normal=hor_pay_normal_male if male==1
replace hor_pay_normal=hor_pay_normal_female if male==0
lab var hor_pay_normal "HOR Score (standardized)"

* Need to create the normalized BI score measure for the consistency between the two IVs for the ORIV analysis. 
egen lift_normal_male = std(lift_most) if male==1
egen lift_normal_female = std(lift_most) if male==0
gen lift_normal = lift_normal_male if male==1
replace lift_normal = lift_normal_female if male==0

replace rlfunemp=1 if rlftunemp==1
gen rlf_other=(rlfwork==1 | rlfsicklv==1 | rlfdisab==1 | rlfsemp==1 | rlfstud==1) 
* either retired or unemployed
gen retuemp=(retired==1 | rlfunemp==1)

gen social_job=(longest_occ_1_all==1 | longest_occ_1_all==2 | longest_occ_1_all==5)
replace social_job=. if longest_occ_1_all==.


* 0-8 account up to 1/3 in each gender

lab var sp_age "Age of spouse"
lab var nliving "Number of Children"

lab var sp_age2 "Spouse's age"
lab var sp_age99 "Missing spouse's age or non-married"

lab var h_poslinc "I(Household labor income > 0)"
lab var r_poslinc "I(own labor income > 0)"
lab var s_poslinc "I(spouse labor income> 0)"

lab var time1 "Time taken to complete Lift Game"
lab var time2 "Time taken to complete Money Request Game"


save "processed_data/SLP_cleaned.dta", replace




