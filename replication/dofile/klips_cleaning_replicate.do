* This file reads KLIPS raw data and produce the analysis data (KLIPS_merged.dta). 

clear all

************************************************************************************************
/*
						Data Cleaning 
*/
************************************************************************************************

*** Household data
	local nlist "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20"
	foreach n of local nlist {
	if `n' < 20 {
		use "rawdata/klips/klips`n'h_i.dta", clear
		}
	else if `n'==20 {
		use "rawdata/klips/klips`n'h.dta", clear
		}
	
		if `n' == 1 {
			keep orghid98 hhid`n' hwave`n' hwaveent sample98 w`n'h h`n'0150 h`n'1501 h`n'1502 h`n'21** h`n'014* h`n'22** h`n'23** h`n'24** h`n'14** h`n'26**
			}
		else if `n' == 2 {
			keep orghid98 hhid`n' hwave`n' hwaveent sample98 htype`n' w`n'h h`n'0150 h`n'21** h`n'014* h`n'23** h`n'24** h`n'14** h`n'25** h`n'26** h`n'08** 
			}			
		else if `n' == 3 {
			keep orghid98 hhid`n' hwave`n' hwaveent sample98 htype`n' w`n'h h`n'0150 h`n'1501 h`n'1502 h`n'21** h`n'014* h`n'23** h`n'24** h`n'14** h`n'25** h`n'26** h`n'08** 
			}
		else if `n' == 4 | `n' == 5 {
			keep orghid98 hhid`n' hwave`n' hwaveent sample98 htype`n' w`n'h h`n'0150 h`n'1501 h`n'1502 h`n'21** h`n'014* h`n'23** h`n'24** h`n'14** h`n'25** h`n'26**
			}
		else if `n' == 6 {
			keep orghid98 hhid`n' hwave`n' hwaveent sample98 htype`n' w`n'h h`n'0150 h`n'1501 h`n'1502 h`n'21** h`n'014* h`n'23** h`n'24** h`n'14** h`n'25** h`n'26**
			}
		else if `n' <= 12 {
			keep orghid98 hhid`n' hwave`n' hwaveent sample98 htype`n' w`n'h h`n'0150 h`n'1501 h`n'1502 h`n'21** h`n'014* h`n'23** h`n'24** h`n'14** h`n'25** h`n'26**
			}
		else if `n' >= 13 {
			keep orghid98 orghid09 hhid`n' hwave`n' hwaveent sample98 sample09 htype`n' w`n'h h`n'0150 h`n'1501 h`n'1502 h`n'21** h`n'014* h`n'23** h`n'24** h`n'14** h`n'25** h`n'26** h`n'4002
			}
		
	sort hhid`n'		
	save "rawdata/klips/klips`n'h_ix.dta", replace
	}
	

*** Individual data
	foreach n of local nlist {
	
		if `n' < 20 {
			use "rawdata/klips/klips`n'p_i.dta", clear
			}
		else if `n'==20 {
		use "rawdata/klips/klips`n'p.dta", clear
		}
				
		if `n' == 1 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent w`n'p p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'0402 p`n'3121 p`n'2801-p`n'2806 p`n'3201 p`n'43** p`n'45** p`n'5501 p`n'6501-p`n'6508 p`n'9074 p`n'9075
			}
		else if `n' == 2 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'43** p`n'45** p`n'47** p`n'5501 p`n'6501-p`n'6508 p`n'9074 p`n'9075
			}
		else if `n' == 3 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'43** p`n'5501 p`n'6501-p`n'6508 p`n'9074 p`n'9075
			}
		else if `n' == 4 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent p`n'orig98 w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'2904 p`n'2905 p`n'3201 p`n'43** p`n'45** p`n'47** p`n'5501 p`n'6501-p`n'6508 p`n'9074 p`n'9075
			}
		else if `n' == 5 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent p`n'orig98 w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'2904 p`n'2905 p`n'420* p`n'43** p`n'45** p`n'47** p`n'5011-p`n'5016 p`n'51** p`n'5501 p`n'6501-p`n'6508 p`n'9074 p`n'9075
			}
		else if `n' == 6 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent p`n'orig98 w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'420* p`n'43** p`n'45** p`n'47** p`n'48** p`n'51** p`n'5501 p`n'6501-p`n'6508 p`n'9074 p`n'9075 p`n'610*
			}
		else if `n' == 7 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent p`n'orig98 w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'3201 p`n'420* p`n'43** p`n'45** p`n'47** p`n'48** p`n'51** p`n'5501 p`n'6401-p`n'6405 p`n'6501-p`n'6508 p`n'9074 p`n'9075 p`n'610*
			}
		else if `n' == 8 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent p`n'orig98 w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'3201 p`n'420* p`n'43** p`n'45** p`n'47** p`n'48** p`n'51** p`n'5501 p`n'6501-p`n'6508 p`n'9074 p`n'9075 p`n'610*
			}
		else if `n' == 9 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent p`n'orig98 w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'420* p`n'43** p`n'45** p`n'47** p`n'48** p`n'51** p`n'5501 p`n'6201 p`n'6216 p`n'6501-p`n'6508 p`n'9074 p`n'9075 p`n'610*
			}
		else if `n' == 10 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent p`n'orig98 w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'420* p`n'43** p`n'45** p`n'47** p`n'48** p`n'49** p`n'51** p`n'5501 p`n'6401-p`n'6405 p`n'6501-p`n'6508 p`n'9074 p`n'9075 p`n'610*
			}
		else if `n' == 11 {
			keep pid hhid`n' hmem`n' orghid98 sample98 hwaveent p`n'orig98 w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'420* p`n'43** p`n'45** p`n'47** p`n'48** p`n'51** p`n'5501 p`n'6501-p`n'6508 p`n'9074 p`n'9075 p`n'610*
			}
		else if `n' >= 12 {
			keep pid hhid`n' hmem`n' orghid98 orghid09 sample98 sample09 hwaveent p`n'orig98 p`n'orig09 w`n'p_c w`n'p_l p`n'0101 p`n'0102-p`n'0108 p`n'0110 p`n'0111 p`n'0201-p`n'0204 p`n'033* p`n'2801-p`n'2806 p`n'420* p`n'43** p`n'45** p`n'47** p`n'48** p`n'51** p`n'5501 p`n'6501-p`n'6508 p`n'9074 p`n'9075 p`n'610*
			}
	sort hhid`n'
	save "rawdata/klips/klips`n'p_ix.dta", replace
	}

	
*** Job history data (long type)
	use "rawdata/klips/klips20w.dta", clear
	keep pid jobwave jobclass jobtype mainjob j145 j150 j155 j2** j3** j804
	save "processed_data/klips20w_x.dta", replace

*** Additional survey
	use "rawdata/klips/klips08a.dta", clear
	keep pid a083951-a083955 a083961-a083964 /*Sence of value*/
	save "rawdata/klips/klips08a_x.dta", replace

	use "rawdata/klips/klips09a.dta", clear
	keep pid a094251-a094254 a094415 a094425 a094435 /*Middle school score and GPA*/
	save "rawdata/klips/klips09a_x.dta", replace
	
	use "rawdata/klips/klips11a.dta", clear
	keep pid a116261-a116264 a116409 /*High school score and GPA*/
	save "rawdata/klips/klips11a_x.dta", replace
	
	use "rawdata/klips/klips17a.dta", clear
	keep pid a177701-a177729 /*job stress*/
	save "rawdata/klips/klips17a_x.dta", replace
	
	use "rawdata/klips/klips18a1.dta", clear
	keep pid a1881* /*Big 5 personality traits, locus of control, risk preference, patience, impulsivity*/
	save "rawdata/klips/klips18a1_x.dta", replace
	
	use "rawdata/klips/klips18a2.dta", clear
	keep pid a188503 a188511 a188517-a188520 /*Work related skill, Ready for the life after retirement*/
	save "rawdata/klips/klips18a2_x.dta", replace

	
************************************************************************************************
/*
						Cross-sectional merging
*/
************************************************************************************************

*** Cross-sectional merge
	local nlist "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20"
	foreach n of local nlist {
	use "rawdata/klips/klips`n'p_ix.dta", clear
	merge m:m hhid`n' orghid98 sample98 hwaveent using "rawdata/klips/klips`n'h_ix.dta", nogen
	drop if pid == .
	sort pid
	save "rawdata/klips/klips`n'hp_ix.dta", replace
	}
	
*** Merge additional survey data 
	use "rawdata/klips/klips08hp_ix.dta", clear
	merge 1:1 pid using "rawdata/klips/klips08a_x.dta", nogen
	save "rawdata/klips/klips08hp_ix.dta", replace 
	
	use "rawdata/klips/klips09hp_ix.dta", clear
	merge 1:1 pid using "rawdata/klips/klips09a_x.dta", nogen
	save "rawdata/klips/klips09hp_ix.dta", replace 
	
	use "rawdata/klips/klips11hp_ix.dta", clear
	merge 1:1 pid using "rawdata/klips/klips11a_x.dta", nogen
	save "rawdata/klips/klips11hp_ix.dta", replace 

	use "rawdata/klips/klips17hp_ix.dta", clear
	merge 1:1 pid using "rawdata/klips/klips17a_x.dta", nogen
	save "rawdata/klips/klips17hp_ix.dta", replace 

	use "rawdata/klips/klips18hp_ix.dta", clear
	merge 1:1 pid using "rawdata/klips/klips18a1_x.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips18a2_x.dta", nogen
	save "rawdata/klips/klips18hp_ix.dta", replace  

	
	*** Erase old data
	foreach n of local nlist {
	erase "rawdata/klips/klips`n'h_ix.dta"
	erase "rawdata/klips/klips`n'p_ix.dta"
	}
	erase "rawdata/klips/klips08a_x.dta"
	erase "rawdata/klips/klips09a_x.dta"
	erase "rawdata/klips/klips11a_x.dta"
	erase "rawdata/klips/klips17a_x.dta"
	erase "rawdata/klips/klips18a1_x.dta"
	erase "rawdata/klips/klips18a2_x.dta"


************************************************************************************************
/*
						Generate variables
*/
************************************************************************************************

	local nlist "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20"
	foreach n of local nlist {
	
		if `n' < 10 {
			local i = substr("`n'",2,2)
			}
		else if `n' >= 10 {
			local i = "`n'" 
			}
		
	use "rawdata/klips/klips`n'hp_ix.dta", clear

*** Identification variables

	* Unique family ID
	rename hhid`n' hhid`i' 
	rename hmem`n' hmem`i'
	rename hwave`n' hwave`i'
	if `n' == 1 {
		gen htype`n' = 1
		}
	rename htype`n' htype`i'
	
	* Year
	g year`i' = 1998 + `i' - 1

*** Demographic variables

	* Gender(male)
 	rename p`n'0101 gender`i'
	gen male`i' = (gender`i'==1) if gender`i' ~=.
	drop gender`i'
  
  	* Relationship to household head
	rename p`n'0102 relation`i'
	
	* Birth year
	gen byear`i' = p`n'0104 if p`n'0104 ~= -1

	* Birth month
	gen bmonth`i' = p`n'0105 if p`n'0105 ~= -1
	
	* Birth day
	gen bday`i' = p`n'0106 if p`n'0106 ~= -1
	
	* Age
	gen age`i' = p`n'0107 if p`n'0107 ~= -1
	
	* Whether living in household
	rename p`n'0108 livein`i'
	replace livein`i' = 0 if livein`i' == 2
	
	* Years of schooling; 1 to 9
	gen edu`i' = p`n'0110 if p`n'0110 ~= -1
	
	* Years of schooling - completion status; 1 to 5
	gen edu_c`i' = p`n'0111 if p`n'0111 ~= -1
	
	* Marital Status
	gen marital`i' = p`n'5501 if p`n'5501 ~= -1
	gen married`i' = (marital`i' >= 2) if marital`i' ~= .
	
	* Number of household members
	rename h`n'0150 nmem`i'

	* Number of children in household
	gen children`i' = .
	if `n' ~= 2 {
		replace children`i' = 0 if h`n'1501 == 2
		replace children`i' = h`n'1502 if h`n'1501 == 1
		}
		
	* Province of residence
	rename h`n'0141 province`i'
  
	* City of residence
	gen city`i' = h`n'0142 if h`n'0142 ~= -1
	

*** Work related variables

	* Labor Force Status
	gen LFS`i' = 0
	replace LFS`i' = 1 if p`n'0201 == 1
	replace LFS`i' = 2 if p`n'2801 == 1 & p`n'2806 == 1 /*ILO standard unemployment*/

	* Employed 
	gen employed`i' = (LFS`i' == 1)
	
	* Unemployed 
	gen unemployed`i' = .
	replace unemployed`i' = 1 if LFS`i' == 2
	replace unemployed`i' = 0 if LFS`i' == 1
	
	* Industry(Business) code, Occupation code
	gen businesscode_old`i' = p`n'0330
	gen businesscode_new`i' = .
	gen occupationcode_old`i' = p`n'0332
	gen occupationcode_new`i' = p`n'0332
	if `n' >= 12 {
		replace businesscode_new`i' = p`n'0331
		replace occupationcode_new`i' = p`n'0333
		}
	
*** Big 5 personality traits surveyed in wave 18; score 1 to 7
	gen personality_a`i' = .
	gen personality_b`i' = .
	gen personality_c`i' = .
	gen personality_d`i' = .
	gen personality_e`i' = .
	gen personality_f`i' = .
	gen personality_g`i' = .
	gen personality_h`i' = .
	gen personality_i`i' = .
	gen personality_j`i' = .
	gen personality_k`i' = .
	gen personality_l`i' = .
	gen personality_m`i' = .
	gen personality_n`i' = .
	gen personality_o`i' = .
	if `n' == 18 {
		replace personality_a`i' = a188101 if a188101 ~= -1
		replace personality_b`i' = a188102 if a188102 ~= -1
		replace personality_c`i' = a188103 if a188103 ~= -1
		replace personality_d`i' = a188104 if a188104 ~= -1
		replace personality_e`i' = a188105 if a188105 ~= -1
		replace personality_f`i' = a188106 if a188106 ~= -1
		replace personality_g`i' = a188107 if a188107 ~= -1
		replace personality_h`i' = a188108 if a188108 ~= -1
		replace personality_i`i' = a188109 if a188109 ~= -1
		replace personality_j`i' = a188110 if a188110 ~= -1
		replace personality_k`i' = a188111 if a188111 ~= -1
		replace personality_l`i' = a188112 if a188112 ~= -1
		replace personality_m`i' = a188113 if a188113 ~= -1
		replace personality_n`i' = a188114 if a188114 ~= -1
		replace personality_o`i' = a188115 if a188115 ~= -1
		}
	gen big5_O`i' = personality_d`i' + personality_i`i' + personality_n`i'
	gen big5_C`i' = personality_a`i' - personality_g`i' + personality_k`i'
	gen big5_E`i' = personality_b`i' + personality_h`i' - personality_l`i'
	gen big5_A`i' = -personality_c`i' + personality_f`i' + personality_m`i'
	gen big5_N`i' = personality_e`i' + personality_j`i' + personality_o`i'
	
*** Locus of control surveyed in wave 18; score 1 to 7
	gen locus_a`i' = .
	gen locus_b`i' = .
	gen locus_c`i' = .
	gen locus_d`i' = .
	gen locus_e`i' = .
	gen locus_f`i' = .
	gen locus_g`i' = .
	gen locus_h`i' = .
	gen locus_i`i' = .
	gen locus_j`i' = .
	if `n' == 18 {
		replace locus_a`i' = a188116 if a188116 ~= -1
		replace locus_b`i' = a188117 if a188117 ~= -1
		replace locus_c`i' = a188118 if a188118 ~= -1
		replace locus_d`i' = a188119 if a188119 ~= -1
		replace locus_e`i' = a188120 if a188120 ~= -1
		replace locus_f`i' = a188121 if a188121 ~= -1
		replace locus_g`i' = a188122 if a188122 ~= -1
		replace locus_h`i' = a188123 if a188123 ~= -1
		replace locus_i`i' = a188124 if a188124 ~= -1
		replace locus_j`i' = a188125 if a188125 ~= -1
		}
	gen locus_internal`i' = locus_a`i' + locus_d`i' + locus_f`i' - locus_g`i'
	gen locus_external`i' = locus_b`i' + locus_c`i' + locus_e`i' + locus_h`i' + locus_i`i' + locus_j`i'
		
*** Reciprocity surveyed in wave 18; score 1 to 7
	gen reciprocity_a`i' = .
	gen reciprocity_b`i' = .
	gen reciprocity_c`i' = .
	gen reciprocity_d`i' = .
	gen reciprocity_e`i' = .
	gen reciprocity_f`i' = .
	if `n' == 18 {
		replace reciprocity_a`i' = a188126 if a188126 ~= -1
		replace reciprocity_b`i' = a188127 if a188127 ~= -1
		replace reciprocity_c`i' = a188128 if a188128 ~= -1
		replace reciprocity_d`i' = a188129 if a188129 ~= -1
		replace reciprocity_e`i' = a188130 if a188130 ~= -1
		replace reciprocity_f`i' = a188131 if a188131 ~= -1
		}

*** Trust surveyed in wave 18; score 1 to 7
	gen trust_a`i' = .
	gen trust_b`i' = .
	gen trust_c`i' = .
	if `n' == 18 {
		replace trust_a`i' = a188132 if a188132 ~= -1
		replace trust_b`i' = a188133 if a188133 ~= -1
		replace trust_c`i' = a188134 if a188134 ~= -1
		}

*** Preferences surveyed in wave 18; score 1 to 7
	gen risktol`i' = .
	gen patience`i' = .
	gen impulsivity`i' = .
	if `n' == 18 {
		replace risktol`i' = a188135 if a188135 ~= -1
		replace patience`i' = a188136 if a188136 ~= -1
		replace impulsivity`i' = a188137 if a188137 ~= -1
		}
			
*** Household variables

	* Household income - earned income
	gen i_earned`i' = h`n'2102 if h`n'2102 ~= -1
	
	* Household income - financial income
	if `n' == 1 {
		gen i_financial`i' = h`n'2112 if h`n'2112 ~= -1
		}
	else if `n' >= 2 {
		gen temp1 = h`n'2112 if h`n'2112 ~= -1
		gen temp2 = h`n'2113 if h`n'2113 ~= -1
		gen temp3 = h`n'2114 if h`n'2114 ~= -1
		gen temp4 = h`n'2115 if h`n'2115 ~= -1
		gen temp5 = h`n'2116 if h`n'2116 ~= -1
		egen i_financial`i' = rowtotal(temp1-temp5), missing
		drop temp*
		}
	
	* Household income - real-estate income
	if `n' == 1 {
		gen i_realestate`i' = h`n'2121 if h`n'2121 ~= -1
		}
	else if `n' >= 2 {
		gen temp1 = h`n'2122 if h`n'2122 ~= -1 
		gen temp2 = h`n'2123 if h`n'2123 ~= -1 
		gen temp5 = h`n'2126 if h`n'2126 ~= -1 
		egen i_realestate`i' = rowtotal(temp1-temp5), missing
		drop temp*
		}
	else if `n' >= 3 {
		gen temp1 = h`n'2122 if h`n'2122 ~= -1 
		gen temp2 = h`n'2123 if h`n'2123 ~= -1 
		gen temp3 = h`n'2124 if h`n'2124 ~= -1 /*observed from wave 3~*/
		gen temp5 = h`n'2126 if h`n'2126 ~= -1 
		egen i_realestate`i' = rowtotal(temp1-temp5), missing
		drop temp*
		}
	else if `n' >= 4 {
		gen temp1 = h`n'2122 if h`n'2122 ~= -1 
		gen temp2 = h`n'2123 if h`n'2123 ~= -1 
		gen temp3 = h`n'2124 if h`n'2124 ~= -1 
		gen temp4 = h`n'2125 if h`n'2125 ~= -1 /*observed from wave 4~*/
		gen temp5 = h`n'2126 if h`n'2126 ~= -1 
		egen i_realestate`i' = rowtotal(temp1-temp5), missing
		drop temp*
		}	
	
	* Household income - social insurance
	if `n' == 1 {
		gen temp1 = h`n'2270 if h`n'2270 ~= -1
		gen temp2 = h`n'2271 if h`n'2271 ~= -1
		gen temp3 = h`n'2272 if h`n'2272 ~= -1
		gen temp4 = h`n'2276 if h`n'2276 ~= -1
		egen i_social`i' = rowtotal(temp1-temp4), missing
		drop temp*
		}
	else if `n' == 2 | `n' == 3 {
		gen temp1 = h`n'2134 if h`n'2134 ~= -1
		gen temp2 = h`n'2136 if h`n'2136 ~= -1
		gen temp3 = h`n'2138 if h`n'2138 ~= -1
		egen i_social`i' = rowtotal(temp1-temp3), missing
		drop temp*
		}
	else if `n' == 4 | `n' == 5 {
		gen temp1 = h`n'2134 if h`n'2134 ~= -1
		gen temp2 = h`n'2136 if h`n'2136 ~= -1
		gen temp3 = h`n'2138 if h`n'2138 ~= -1
		gen temp4 = h`n'2140 if h`n'2140 ~= -1
		egen i_social`i' = rowtotal(temp1-temp4), missing
		drop temp*
		}
	else if `n' >= 6 {
		gen temp1 = h`n'2134 if h`n'2134 ~= -1
		gen temp2 = h`n'2136 if h`n'2136 ~= -1
		gen temp3 = h`n'2138 if h`n'2138 ~= -1
		gen temp4 = h`n'2140 if h`n'2140 ~= -1
		gen temp5 = h`n'2142 if h`n'2142 ~= -1
		egen i_social`i' = rowtotal(temp1-temp5), missing
		drop temp*
		}
	
	* Household income - Basic livelihood 
	if `n' == 1 {
		gen i_basic`i' = h`n'2152 if h`n'2152 ~= -1
		replace i_basic`i' = i_basic`i'*12 
		}
	else if `n' >= 2 {
		gen i_basic`i' = h`n'2152 if h`n'2152 ~= -1
		}
	
	* Household income - Public transfer income /*1차년도는 공적이전, 사적이전 구분 없이 이전소득이 월평균 금액으로 조사됨*/
	if `n' == 1 {
		gen i_publictrans`i' = h`n'2152 if h`n'2152 ~= -1
		replace i_publictrans`i' = i_publictrans`i'*12 
		}
	else if `n' >= 2 {
		gen i_publictrans`i' = h`n'2152 if h`n'2152 ~= -1
		}
	else if `n' >= 6 {
		gen temp1 = h`n'2152 if h`n'2152 ~= -1
		gen temp2 = h`n'2153 if h`n'2153 ~= -1
		egen i_publictrans`i' = rowtotal(temp1-temp2), missing
		drop temp*
		}
	
	* Household income - Private and other transfer income
	if `n' == 1 {
		gen i_privatetrans`i' = .
		}
	else if `n' >= 2 & `n' < 9 {
		gen temp1 = h`n'2155 if h`n'2155 ~= -1
		gen temp2 = h`n'2156 if h`n'2156 ~= -1
		gen temp3 = h`n'2160 if h`n'2160 ~= -1
		egen i_privatetrans`i' = rowtotal(temp1-temp3), missing
		drop temp*
		}
	else if `n' >= 9 & `n' < 13 {
		gen temp1 = h`n'2155 if h`n'2155 ~= -1
		gen temp2 = h`n'2157 if h`n'2157 ~= -1
		gen temp3 = h`n'2158 if h`n'2158 ~= -1
		gen temp4 = h`n'2159 if h`n'2159 ~= -1
		gen temp5 = h`n'2160 if h`n'2160 ~= -1
		egen i_privatetrans`i' = rowtotal(temp1-temp5), missing
		drop temp*
		}
	else if `n' >= 13 {
		gen temp1 = h`n'2155 if h`n'2155 ~= -1
		gen temp2 = h`n'2157 if h`n'2157 ~= -1
		gen temp3 = h`n'2158 if h`n'2158 ~= -1
		gen temp4 = h`n'2159 if h`n'2159 ~= -1
		gen temp5 = h`n'2160 if h`n'2160 ~= -1
		gen temp6 = h`n'4002 if h`n'4002 ~= -1
		egen i_privatetrans`i' = rowtotal(temp1-temp6), missing
		drop temp*
		}
	
	* Household income - Other income 
	gen i_other_a`i' = . /*insurance payments*/
	gen i_other_b`i' = . /*damage insurance payments*/
	gen i_other_c`i' = . /*savings-type insurance payments*/
	gen i_other_d`i' = . /*life insurance payments*/
	gen i_other_e`i' = . /*severance allowances*/
	gen i_other_f`i' = . /*gifts or inheritances*/
	gen i_other_g`i' = . /*celebration/consolidation money*/
	gen i_other_h`i' = . /*lottery winnings*/
	gen i_other_i`i' = . /*traffic accident, disaster compensation*/
	gen i_other_j`i' = . /*other*/
	if `n' == 1 {
		replace i_other_j`i' = h`n'2182 if h`n'2182 ~= -1 
		replace i_other_j`i' = i_other_j`i'*12 /*1차년도는 기타소득이 세부항목 구분 없이 월평균 금액으로 조사됨*/
		}
	if `n' >= 2 & `n' <= 8 {
		replace i_other_a`i' = h`n'2191 if h`n'2191 ~= -1
		}
	if `n' >= 2 {
		replace i_other_g`i' = h`n'2186 if h`n'2186 ~= -1
		replace i_other_j`i' = h`n'2191 if h`n'2191 ~= -1
		}
	if `n' >= 4 {
		replace i_other_f`i' = h`n'2186 if h`n'2186 ~= -1
		}
	if `n' >= 9 {	
		replace i_other_b`i' = h`n'2191 if h`n'2191 ~= -1
		replace i_other_c`i' = h`n'2183 if h`n'2183 ~= -1
		replace i_other_d`i' = h`n'2184 if h`n'2184 ~= -1
		replace i_other_e`i' = h`n'2185 if h`n'2185 ~= -1
		replace i_other_g`i' = h`n'2186 if h`n'2186 ~= -1
		replace i_other_h`i' = h`n'2188 if h`n'2188 ~= -1
		replace i_other_i`i' = h`n'2189 if h`n'2189 ~= -1
		}
		
	egen i_total_m`i' = rowtotal(i_earned-i_other_j), missing
	egen i_total_z`i' = rowtotal(i_earned-i_other_j)
		
			
*** Sample weight offered in raw data
	rename w`n'h wh`i' 			/*household level weight*/
	if `n' == 1 {				
		g wpl`i' = w`n'p		/*individual level weight - l stands for londitudinal*/
		g wpc`i' = w`n'p		/*individual level weight - c stands for cross-sectional*/
		drop w`n'p
		}
	else if `n' >= 2 {
		rename w`n'p_l wpl`i'
		rename w`n'p_c wpc`i'
		}


	drop h`n'* p`n'* 
	save "rawdata/klips/klips`n'hp_ivar.dta", replace
	
	}	
	
	
*** Job history data (long type)
	use "processed_data/klips20w_x.dta", clear
	keep pid job* mainjob j145 j150 j155 j2** j316 j322 j323 j325 j804

		* Keep only one job for each wave
		replace mainjob = 2 if mainjob == 0
		sort pid jobwave mainjob
		by pid: gen n = _n
		gen twojob = jobwave == jobwave[_n-1]
		drop if twojob == 1
		drop n twojob
		replace mainjob = 0 if mainjob == 2
				
	gen worktype1 = j150 if j150 ~= -1		/*type of work status*/
	gen worktype2 = j145 if j145 ~= -1		/*type of employment*/
	gen worktype3= j155 if j155 ~= -1		/*type of work hours for wage earners*/
	gen selfemployed = (worktype1 == 4) if worktype1 ~= .
		
	*gen officialhour = j202 if j202 ~= -1	
	gen overtimeunit = j804 if j804 ~= -1

	*Work hours of wage workers (per week)
	gen workhour = .
	gen workhour_ov = .
	replace workhour = j203 if j202 == 2 & j203 ~= -1
	replace workhour = j205 if j202 == 1 & j205 ~= -1
	replace workhour_ov = j208 if j202 == 1 & j208 ~= -1	
	
	*Work days of wage workers (Wave 1, 2: monthly average, Wave 3~: weekly average)
	gen workday = .
	gen workday_ov = .
	replace workday = j204 if j202 == 2 & j204 ~= -1
	replace workday = j206 if j202 == 1 & j206 ~= -1
	replace workday_ov = j209 if j202 == 1 & j209 ~= -1
	
	*Monthly wage of wage workers
	gen monthlywage = j316 if j316 ~= -1
	gen monthlywage_ov = j212 if j212 ~= -1
	
	*Work hours of non-wage workers (per week)
	gen workhour_nw = .
	replace workhour_nw = j213 if jobtype == 2 & j213 ~= -1	
	
	*Work days of non-wage workers (Wave 1, 2: monthly average, Wave 3~: weekly average)	
	gen workday_nw = .
	replace workday_nw = j214 if jobtype == 2 & j214 ~= -1

	*Annual sales and monthly profit of non-wage workers
	gen annualsales = j322 if j322 ~= -1
	gen annualsales_c = j323 if j323 ~= -1
	gen monthlyprofit = j325 if j325 ~= -1
	
*** Calculating annual salary and hourly wage of wage workers
	gen annualsalary = monthlywage * 12
	gen annualsalary_ov = monthlywage_ov * 12
	egen annualsalary_total = rowtotal(annualsalary annualsalary_ov), missing
	gen hourlywage = annualsalary / (workhour * 52)
	gen hourlywage_ov = annualsalary_ov / (workhour_ov * 52)
	egen temp = rowtotal(workhour workhour_ov), missing
	gen hourlywage_total = annualsalary_total / (temp * 52)
	drop temp	
	
	rename jobwave wave
	drop j1* j2* j3* j8*
	
	save "processed_data/klips20w_var.dta", replace

	
************************************************************************************************
/*
						Longitudinal merging
*/
************************************************************************************************

*** Longitudinal merge
	use "rawdata/klips/klips01hp_ivar.dta", clear
	merge 1:1 pid using "rawdata/klips/klips02hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips03hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips04hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips05hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips06hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips07hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips08hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips09hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips10hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips11hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips12hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips13hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips14hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips15hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips16hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips17hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips18hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips19hp_ivar.dta", nogen
	merge 1:1 pid using "rawdata/klips/klips20hp_ivar.dta", nogen
	save "processed_data/klips_imerge.dta", replace

*** Reshape to long type
	use "processed_data/klips_imerge.dta", clear
	#delimit;
		reshape long hhid hmem htype hwave year
		nmem male edu edu_c province city relation byear bmonth bday age livein marital married children 
		LFS employed unemployed businesscode_old businesscode_new occupationcode_old occupationcode_new
		risktol patience impulsivity 
		i_total_m i_total_z i_earned i_financial i_realestate i_social i_basic i_publictrans i_privatetrans 
		i_other_a i_other_b i_other_c i_other_d i_other_e i_other_f i_other_g i_other_h i_other_i i_other_j
		wh wpl wpc
		personality_a personality_b personality_c personality_d personality_e personality_f personality_g
		personality_h personality_i personality_j personality_k personality_l personality_m personality_n personality_o
		big5_O big5_C big5_E big5_A big5_N
		locus_a locus_b locus_c locus_d locus_e locus_f locus_g locus_h locus_i locus_j
		locus_internal locus_external
		reciprocity_a reciprocity_b reciprocity_c reciprocity_d reciprocity_e reciprocity_f trust_a trust_b trust_c
			, i(pid orghid98 orghid09 sample98 sample09 hwaveent) j(wave) ;
	#delimit cr
	save "processed_data/klips_imerge_long.dta", replace

*** Merge job history data (long type)
	use "processed_data/klips_imerge_long.dta", replace
	merge 1:m pid wave using "processed_data/klips20w_var.dta", nogen
	save "processed_data/klips_imerge_long1.dta", replace

************************************************************************************************
/*
						Outliers in job related variables
*/
************************************************************************************************
use "processed_data/klips_imerge_long1.dta", clear

*** Drop outliers in work status variable
	drop if unemployed == 1 & jobclass == 1
	drop if unemployed == 1 & jobclass == 3
	drop if unemployed == 1 & jobclass == 5
	drop if unemployed == 1 & jobclass == 7
	drop if employed == 1 & jobclass == 2
	drop if employed == 1 & jobclass == 4
	drop if employed == 1 & jobclass == 6
	drop if employed == 1 & jobclass == 8
	drop if jobtype == 3

*** Hourly wage
	*Replace to missing if hourly wage is less than half of the national minimum wage of each year
	replace hourlywage = . if year == 1998 & hourlywage < (1400+1485)/40000
	replace hourlywage = . if year == 1999 & hourlywage < (1485+1525)/40000
	replace hourlywage = . if year == 2000 & hourlywage < (1525+1600)/40000
	replace hourlywage = . if year == 2001 & hourlywage < (1600+1865)/40000
	replace hourlywage = . if year == 2002 & hourlywage < (1865+2100)/40000
	replace hourlywage = . if year == 2003 & hourlywage < (2100+2275)/40000
	replace hourlywage = . if year == 2004 & hourlywage < (2275+2510)/40000
	replace hourlywage = . if year == 2005 & hourlywage < (2510+2840)/40000
	replace hourlywage = . if year == 2006 & hourlywage < (2840+3100)/40000
	replace hourlywage = . if year == 2007 & hourlywage < 3100/20000
	replace hourlywage = . if year == 2008 & hourlywage < 3480/20000
	replace hourlywage = . if year == 2009 & hourlywage < 3770/20000
	replace hourlywage = . if year == 2010 & hourlywage < 4000/20000
	replace hourlywage = . if year == 2011 & hourlywage < 4110/20000
	replace hourlywage = . if year == 2012 & hourlywage < 4320/20000
	replace hourlywage = . if year == 2013 & hourlywage < 4580/20000
	replace hourlywage = . if year == 2014 & hourlywage < 4860/20000
	replace hourlywage = . if year == 2015 & hourlywage < 5210/20000
	
	replace hourlywage_ov = . if year == 1998 & hourlywage_ov < (1400+1485)/40000
	replace hourlywage_ov = . if year == 1999 & hourlywage_ov < (1485+1525)/40000
	replace hourlywage_ov = . if year == 2000 & hourlywage_ov < (1525+1600)/40000
	replace hourlywage_ov = . if year == 2001 & hourlywage_ov < (1600+1865)/40000
	replace hourlywage_ov = . if year == 2002 & hourlywage_ov < (1865+2100)/40000
	replace hourlywage_ov = . if year == 2003 & hourlywage_ov < (2100+2275)/40000
	replace hourlywage_ov = . if year == 2004 & hourlywage_ov < (2275+2510)/40000
	replace hourlywage_ov = . if year == 2005 & hourlywage_ov < (2510+2840)/40000
	replace hourlywage_ov = . if year == 2006 & hourlywage_ov < (2840+3100)/40000
	replace hourlywage_ov = . if year == 2007 & hourlywage_ov < 3100/20000
	replace hourlywage_ov = . if year == 2008 & hourlywage_ov < 3480/20000
	replace hourlywage_ov = . if year == 2009 & hourlywage_ov < 3770/20000
	replace hourlywage_ov = . if year == 2010 & hourlywage_ov < 4000/20000
	replace hourlywage_ov = . if year == 2011 & hourlywage_ov < 4110/20000
	replace hourlywage_ov = . if year == 2012 & hourlywage_ov < 4320/20000
	replace hourlywage_ov = . if year == 2013 & hourlywage_ov < 4580/20000
	replace hourlywage_ov = . if year == 2014 & hourlywage_ov < 4860/20000
	replace hourlywage_ov = . if year == 2015 & hourlywage_ov < 5210/20000
	
	replace hourlywage_total = . if year == 1998 & hourlywage_total < (1400+1485)/40000
	replace hourlywage_total = . if year == 1999 & hourlywage_total < (1485+1525)/40000
	replace hourlywage_total = . if year == 2000 & hourlywage_total < (1525+1600)/40000
	replace hourlywage_total = . if year == 2001 & hourlywage_total < (1600+1865)/40000
	replace hourlywage_total = . if year == 2002 & hourlywage_total < (1865+2100)/40000
	replace hourlywage_total = . if year == 2003 & hourlywage_total < (2100+2275)/40000
	replace hourlywage_total = . if year == 2004 & hourlywage_total < (2275+2510)/40000
	replace hourlywage_total = . if year == 2005 & hourlywage_total < (2510+2840)/40000
	replace hourlywage_total = . if year == 2006 & hourlywage_total < (2840+3100)/40000
	replace hourlywage_total = . if year == 2007 & hourlywage_total < 3100/20000
	replace hourlywage_total = . if year == 2008 & hourlywage_total < 3480/20000
	replace hourlywage_total = . if year == 2009 & hourlywage_total < 3770/20000
	replace hourlywage_total = . if year == 2010 & hourlywage_total < 4000/20000
	replace hourlywage_total = . if year == 2011 & hourlywage_total < 4110/20000
	replace hourlywage_total = . if year == 2012 & hourlywage_total < 4320/20000
	replace hourlywage_total = . if year == 2013 & hourlywage_total < 4580/20000
	replace hourlywage_total = . if year == 2014 & hourlywage_total < 4860/20000
	replace hourlywage_total = . if year == 2015 & hourlywage_total < 5210/20000

save "processed_data/klips_imerge_long1.dta", replace

************************************************************************************************
/*
						CPI adjustment 
*/
************************************************************************************************	
*** CPI raw data
	clear
	import excel "rawdata/klips/CPI_updated.xlsx", sheet("Sheet1") firstrow
	forval i=1/18 {
	replace CPI`i'="" if CPI`i'=="-"
		}
	destring, replace
	reshape long CPI, i(province) j(wave)
	drop if province == 0
	save "rawdata/klips/CPI.dta", replace

	use "processed_data/klips_imerge_long1.dta", clear
	merge m:m province wave using "rawdata/klips/CPI.dta", nogen
	sort pid wave
	save "processed_data/klips_imerge_long1.dta", replace

	* CPI adjustment
	replace annualsales = annualsales / CPI * 100
	replace monthlyprofit = monthlyprofit / CPI * 100
	
	replace annualsalary = annualsalary / CPI * 100
	replace annualsalary_ov = annualsalary_ov / CPI * 100
	replace annualsalary_total = annualsalary_total / CPI * 100
	replace hourlywage = hourlywage / CPI * 100
	replace hourlywage_ov = hourlywage_ov / CPI * 100
	replace hourlywage_total= hourlywage_total / CPI * 100
	
	replace i_total_m = i_total_m / CPI * 100
	replace i_total_z = i_total_z / CPI * 100
	replace i_earned = i_earned / CPI * 100
	replace i_financial = i_financial / CPI * 100
	replace i_realestate = i_realestate / CPI * 100
	replace i_social = i_social / CPI * 100
	replace i_basic = i_basic / CPI * 100
	replace i_publictrans = i_publictrans / CPI * 100
	replace i_privatetrans = i_privatetrans / CPI * 100
	replace i_other_a = i_other_a / CPI * 100
	replace i_other_b = i_other_b / CPI * 100
	replace i_other_c = i_other_c / CPI * 100
	replace i_other_d = i_other_d / CPI * 100
	replace i_other_e = i_other_e / CPI * 100
	replace i_other_f = i_other_f / CPI * 100
	replace i_other_g = i_other_g / CPI * 100
	replace i_other_h = i_other_h / CPI * 100
	replace i_other_i = i_other_i / CPI * 100
	replace i_other_j = i_other_j / CPI * 100
	

	save "processed_data/klips_imerge_long2.dta", replace

*** Erase old data
	local nlist "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20"
	foreach n of local nlist {
	erase "rawdata/klips/klips`n'hp_ix.dta"
	erase "rawdata/klips/klips`n'hp_ivar.dta"
	}
	erase "processed_data/klips20w_x.dta"
	erase "processed_data/klips20w_var.dta"
	erase "processed_data/klips_imerge.dta"
	erase "processed_data/klips_imerge_long.dta"
	erase "processed_data/klips_imerge_long1.dta"

***********************************************************************************************
/*
						Variable names
*/
************************************************************************************************
	
	
*** Order variables

	#delimit;
		order pid hhid hmem hwave htype wave year
		orghid98 orghid09 sample98 sample09 hwaveent
		nmem male edu edu_c province city relation byear bmonth bday age livein marital married children 
		LFS employed unemployed businesscode_old businesscode_new occupationcode_old occupationcode_new
		jobtype jobclass mainjob worktype1 worktype2 worktype3 selfemployed
		overtimeunit workhour workhour_ov workday workday_ov monthlywage monthlywage_ov
		workhour_nw workday_nw annualsales annualsales_c monthlyprofit
		annualsalary annualsalary_ov annualsalary_total hourlywage hourlywage_ov hourlywage_total
		risktol patience impulsivity
		i_total_m i_total_z i_earned i_financial i_realestate i_social i_basic i_publictrans i_privatetrans 
		i_other_a i_other_b i_other_c i_other_d i_other_e i_other_f i_other_g i_other_h i_other_i i_other_j
		CPI
		wh wpl wpc
		personality_a personality_b personality_c personality_d personality_e personality_f personality_g
		personality_h personality_i personality_j personality_k personality_l personality_m personality_n personality_o
		big5_O big5_C big5_E big5_A big5_N
		locus_a locus_b locus_c locus_d locus_e locus_f locus_g locus_h locus_i locus_j
		locus_internal locus_external
		reciprocity_a reciprocity_b reciprocity_c reciprocity_d reciprocity_e reciprocity_f trust_a trust_b trust_c
		;
	#delimit cr

*** Label variables
	lab var pid "Unique individual ID"
	lab var hhid "Household ID in each wave"
	lab var hmem "Household member ID in each wave"
	lab var hwave "Response status in each wave"
	lab var htype "Household type in each wave" 
	lab var wave "Wave of survey"
	lab var year "Year of survey"
	lab var orghid98 "Original household ID(98 sample)"
	lab var orghid09 "Original household ID(consolidated sample)"
	lab var sample98 "Original household indicator(98 sample)"
	lab var sample09 "Original household indicator(consolidated sample)"
	lab var hwaveent "Wave first entered"
	
	lab var male "Male"
	lab var relation "Relation to household head"
	lab var byear "Birth year"
	lab var bmonth "Birth month"
	lab var bday "Birth day"
	lab var age "Age"
	lab var livein "Whether living in household"
	lab var edu "Education status"
	lab var edu_c "Education completion status"
	lab var marital "Marital status"
	lab var married "Married or not"
	lab var nmem "Number of household members"
	lab var children "Number of children in household"
	
	lab var province "Province of residence"
	lab var city "City of residence"
	
	lab var LFS "Labor Force Status"
	lab var employed "Employed"
	lab var unemployed "Unemployed"
	lab var businesscode_old "Business classification code"
	lab var businesscode_new "Business classification code"
	lab var occupationcode_old "Occupation classification code"
	lab var occupationcode_new "Occupation classification code"
	lab var jobtype "Job type"
	lab var jobclass "Job classification"
	lab var mainjob "Mainjob"
	lab var worktype1 "Type of work status"
	lab var worktype2 "Type of employment"
	lab var worktype3 "Type of work hours"
	lab var selfemployed "Employer/Self-employed"
		
	lab var overtimeunit "Overtime work unit(monthly or weekly)"
	lab var workhour "Work hours of wage workers(weekly)"
	lab var workhour_ov "Work hours of wage workers_overtime"
	lab var workday "Work days of wage workers(wave 1,2: monthly/ wave 3~: weekly)"
	lab var workday_ov "Work days of wage workers_overtime"
	lab var monthlywage "Monthly wage of wage workers"
	lab var monthlywage_ov "Monthly wage of wage workers_overtime"
	
	lab var workhour_nw "Work hours of non-wage workers(weekly)"
	lab var workday_nw "Work days of non-wage workers(wave 1,2: monthly/ wave 3~: weekly)"
	lab var annualsales "Annual sales of non-wage workers"
	lab var annualsales_c "Annual sales of non-wage workers_category"
	lab var monthlyprofit "Monthly profit of non-wage workers"
	
	lab var annualsalary "Annual salary of wage workers"
	lab var annualsalary_ov "Annual salary of wage workers_overtime"
	lab var annualsalary_total "Annual salary of wage workers_total"
	lab var hourlywage "Hourly wage of wage workers"
	lab var hourlywage_ov "Hourly wage of wage workers_overtime"
	lab var hourlywage_total "Hourly wage of wage workers_total"

	
	lab var i_total_m "Total household income treated as missing"
	lab var i_total_z "Total household income treated as zero"
	lab var i_earned "i_earned"
	lab var i_financial "i_financial"
	lab var i_realestate "i_real-estate"
	lab var i_social "i_social insurance"
	lab var i_basic "i_basic livelihood transfer"
	lab var i_publictrans "i_public transfer"
	lab var i_privatetrans "i_private transfer"
	
	lab var i_other_a "i_insurance"
	lab var i_other_b "i_damage insurance"
	lab var i_other_c "i_savings-type insurance"
	lab var i_other_d "i_life insurance"
	lab var i_other_e "i_severance allowances"
	lab var i_other_f "i_gifts or inheritances"
	lab var i_other_g "i_celebration/consolidation"
	lab var i_other_h "i_lottery winnings"
	lab var i_other_i "i_traffic/disaster"
	lab var i_other_j "i_other"
	
	
	lab var wh "weight_household"
	lab var wpl "weight_idv_long"
	lab var wpc "weight_idv_cross"
	
	lab var CPI "CPI(2015=100)"
	
	rename personality_a personality1
	rename personality_b personality2
	rename personality_c personality3
	rename personality_d personality4
	rename personality_e personality5
	rename personality_f personality6
	rename personality_g personality7
	rename personality_h personality8
	rename personality_i personality9
	rename personality_j personality10
	rename personality_k personality11
	rename personality_l personality12
	rename personality_m personality13
	rename personality_n personality14
	rename personality_o personality15
	lab var personality1 "Big 5 personality traits 1(a18)"
	lab var personality2 "Big 5 personality traits 2(a18)"
	lab var personality3 "Big 5 personality traits 3(a18)"
	lab var personality4 "Big 5 personality traits 4(a18)"
	lab var personality5 "Big 5 personality traits 5(a18)"
	lab var personality6 "Big 5 personality traits 6(a18)"
	lab var personality7 "Big 5 personality traits 7(a18)"
	lab var personality8 "Big 5 personality traits 8(a18)"
	lab var personality9 "Big 5 personality traits 9(a18)"
	lab var personality10 "Big 5 personality traits 10(a18)"
	lab var personality11 "Big 5 personality traits 11(a18)"
	lab var personality12 "Big 5 personality traits 12(a18)"
	lab var personality13 "Big 5 personality traits 13(a18)"
	lab var personality14 "Big 5 personality traits 14(a18)"
	lab var personality15 "Big 5 personality traits 15(a18)"
	
	rename locus_a locus1
	rename locus_b locus2
	rename locus_c locus3
	rename locus_d locus4
	rename locus_e locus5
	rename locus_f locus6
	rename locus_g locus7
	rename locus_h locus8
	rename locus_i locus9
	rename locus_j locus10
	lab var locus1 "Locus of control 1(a18)"
	lab var locus2 "Locus of control 2(a18)"
	lab var locus3 "Locus of control 3(a18)"
	lab var locus4 "Locus of control 4(a18)"
	lab var locus5 "Locus of control 5(a18)"
	lab var locus6 "Locus of control 6(a18)"
	lab var locus7 "Locus of control 7(a18)"
	lab var locus8 "Locus of control 8(a18)"
	lab var locus9 "Locus of control 9(a18)"
	lab var locus10 "Locus of control 10(a18)"
	
	lab var locus_internal "Locus of control Internal(a18)"
	lab var locus_external "Locus of control External(a18)"
	
	rename reciprocity_a reciprocity1
	rename reciprocity_b reciprocity2
	rename reciprocity_c reciprocity3
	rename reciprocity_d reciprocity4
	rename reciprocity_e reciprocity5
	rename reciprocity_f reciprocity6
	lab var reciprocity1 "Reciprocity 1(a18)"
	lab var reciprocity2 "Reciprocity 2(a18)"
	lab var reciprocity3 "Reciprocity 3(a18)"
	lab var reciprocity4 "Reciprocity 4(a18)"
	lab var reciprocity5 "Reciprocity 5(a18)"
	lab var reciprocity6 "Reciprocity 6(a18)"
	
	rename trust_a trust1
	rename trust_b trust2
	rename trust_c trust3
	lab var trust1 "Trust 1(a18)"
	lab var trust2 "Trust 2(a18)"
	lab var trust3 "Trust 3(a18)"
	


*** Label values
	lab define sample98_lbl 1 "original"
	lab define sample98_lbl 2 "branched", add
	lab define sample98_lbl 3 "not target", add
	lab value sample98 sample98_lbl
	
	lab define sample09_lbl 1 "original"
	lab define sample09_lbl 2 "branched", add
	lab define sample09_lbl 3 "not target", add
	lab value sample09 sample09_lbl
		
	lab define htype_lbl 1 "existing"
	lab define htype_lbl 2 "missing", add
	lab define htype_lbl 3 "branched", add
	lab define htype_lbl 4 "additional", add
	lab value htype htype_lbl
	
	lab define male_lbl 1 "Male"
	lab define male_lbl 0 "Female", add
	lab value male male_lbl
	
	lab define edu_lbl 1 "preschool"
	lab define edu_lbl 2 "noschool", add
	lab define edu_lbl 3 "elementary", add
	lab define edu_lbl 4 "middle", add
	lab define edu_lbl 5 "high", add
	lab define edu_lbl 6 "college", add
	lab define edu_lbl 7 "university", add
	lab define edu_lbl 8 "master", add
	lab define edu_lbl 9 "doctor", add
	lab value edu edu_lbl
	
	lab define edu_c_lbl 1 "graduated"
	lab define edu_c_lbl 2 "completed", add
	lab define edu_c_lbl 3 "dropped out" , add
	lab define edu_c_lbl 4 "enrolled", add
	lab define edu_c_lbl 5 "left of absence", add
	lab value edu_c edu_c_lbl
	
	lab define livein_lbl 0 "not live in"
	lab define livein_lbl 1 "live in", add
	lab value livein livein_lbl
	
	lab define marital_lbl 1 "single"
	lab define marital_lbl 2 "married", add
	lab define marital_lbl 3 "separated", add
	lab define marital_lbl 4 "divorced", add
	lab define marital_lbl 5 "widowed", add
	lab value marital marital_lbl
	
	lab define married_lbl 1 "married"
	lab define married_lbl 0 "single", add
	lab value married married_lbl
	

	
	lab define LFS_lbl 0 "inactive"
	lab define LFS_lbl 1 "employed", add
	lab define LFS_lbl 2 "unemployed", add
	lab value LFS LFS_lbl
	
	lab define employed_lbl 1 "employed"
	lab define employed_lbl 0 "others", modify
	lab value employed employed_lbl
	
	lab define unemployed_lbl 1 "unemployed"
	lab define unemployed_lbl 0 "others", modify
	lab value unemployed unemployed_lbl
	
	lab define jobtype_lbl 1 "wage worker"
	lab define jobtype_lbl 2 "non-wage worker", add
	lab define jobtype_lbl 3 "dk/no", add
	lab value jobtype jobtype_lbl
	
	lab define jobclass_lbl 1 "Still working the previous wage work"
	lab define jobclass_lbl 2 "Stopped working the previous wage work", add
	lab define jobclass_lbl 3 "Still working the previous non-wage work", add
	lab define jobclass_lbl 4 "Stopped working the previous non-wage work", add
	lab define jobclass_lbl 5 "Still working a new wage work", add
	lab define jobclass_lbl 6 "Stopped working a new wage work", add
	lab define jobclass_lbl 7 "Still working a new non-wage work", add
	lab define jobclass_lbl 8 "Stopped working a new non-wage work", add
	lab value jobclass jobclass_lbl
	
	lab define mainjob_lbl 1 "mainjob"
	lab define mainjob_lbl 0 "otherwise", add
	lab value mainjob mainjob_lbl
	
	lab define worktype1_lbl 1 "permanent"
	lab define worktype1_lbl 2 "temporary", add
	lab define worktype1_lbl 3 "daily", add
	lab define worktype1_lbl 4 "employer/self-employed", add
	lab define worktype1_lbl 5 "unpaid family worker", add
	lab value worktype1 worktype1_lbl
	
	lab define worktype2_lbl 1 "regular"
	lab define worktype2_lbl 2 "irregular", add
	lab value worktype2 worktype2_lbl
	
	lab define worktype3_lbl 1 "part-time"
	lab define worktype3_lbl 2 "full-time", add
	lab value worktype3 worktype3_lbl
	
	lab define overtimeunit_lbl 1 "Weekly"
	lab define overtimeunit_lbl 2 "Monthly", add
	lab value overtimeunit overtimeunit_lbl
	
	lab define annualsales_c_lbl 1 "Under 10m"
	lab define annualsales_c_lbl 2 "10m~30m", add
	lab define annualsales_c_lbl 3 "30m~50m", add
	lab define annualsales_c_lbl 4 "50m~80m", add
	lab define annualsales_c_lbl 5 "80m~100m", add
	lab define annualsales_c_lbl 6 "100m~300m", add
	lab define annualsales_c_lbl 7 "300m~500m", add
	lab define annualsales_c_lbl 8 "500m~1b", add
	lab define annualsales_c_lbl 9 "1b~3b", add
	lab define annualsales_c_lbl 10 "3b~10b", add
	lab define annualsales_c_lbl 11 "10b~50b", add
	lab define annualsales_c_lbl 12 "50b~100b", add
	lab define annualsales_c_lbl 13 "Over 100b", add
	lab define annualsales_c_lbl 14 "dk", add
	lab value annualsales_c annualsales_c_lbl	

	* Reverse scale
	lab define reversescale 5 "Very good"
	lab define reversescale 4 "Good", add
	lab define reversescale 3 "Moderate", add
	lab define reversescale 2 "Bad", add
	lab define reversescale 1 "Very bad",add
		
	
	lab define likert7scale 1 "Strongly disagree"
	lab define likert7scale 2 "Mostly disagree", add
	lab define likert7scale 3 "Somewhat disagree", add
	lab define likert7scale 4 "Neigher agree nor disagree", add
	lab define likert7scale 5 "Somewhat agree", add
	lab define likert7scale 6 "Mostly agree", add
	lab define likert7scale 7 "Strongly agree", add
	lab value personality1 likert7scale
	lab value personality2 likert7scale
	lab value personality3 likert7scale
	lab value personality4 likert7scale
	lab value personality5 likert7scale
	lab value personality6 likert7scale
	lab value personality7 likert7scale
	lab value personality8 likert7scale
	lab value personality9 likert7scale
	lab value personality10 likert7scale
	lab value personality11 likert7scale
	lab value personality12 likert7scale
	lab value personality13 likert7scale
	lab value personality14 likert7scale
	lab value personality15 likert7scale
	lab value locus1 likert7scale
	lab value locus2 likert7scale
	lab value locus3 likert7scale
	lab value locus4 likert7scale
	lab value locus5 likert7scale
	lab value locus6 likert7scale
	lab value locus7 likert7scale
	lab value locus8 likert7scale
	lab value locus9 likert7scale
	lab value locus10 likert7scale
	lab value reciprocity1 likert7scale
	lab value reciprocity2 likert7scale
	lab value reciprocity3 likert7scale
	lab value reciprocity4 likert7scale
	lab value reciprocity5 likert7scale
	lab value reciprocity6 likert7scale
	lab value trust1 likert7scale
	lab value trust2 likert7scale
	lab value trust3 likert7scale
	
	
************************************************************************************************
/*
						Generating useful variables
*/
************************************************************************************************


*** Fill in data
	replace year = wave + 1998 - 1
	egen temp = mean(male), by(pid)
	replace male = temp
	drop temp
	egen temp = mean(byear), by(pid)
	replace byear = temp
	drop temp
	egen temp = mean(bmonth), by(pid)
	replace bmonth = temp
	drop temp
	egen temp = mean(bday), by(pid)
	replace bday = temp
	drop temp

*** Generating useful indicator variables

	*Education	
	gen edu_cx = .
	replace edu_cx = 1 if edu == 1 | edu == 2 | edu == 3
	replace edu_cx = 1 if edu == 4 & edu_c >= 2 & edu_c ~= .
	replace edu_cx = 2 if edu == 4 & edu_c == 1
	replace edu_cx = 2 if edu == 5 & edu_c >= 2 & edu_c ~= .
	replace edu_cx = 3 if edu == 5 & edu_c == 1
	replace edu_cx = 3 if edu == 6 & edu_c >= 2 & edu_c ~= .
	replace edu_cx = 3 if edu == 7 & edu_c >= 2 & edu_c ~= .
	replace edu_cx = 4 if edu == 6 & edu_c == 1
	replace edu_cx = 5 if edu == 7 & edu_c == 1 
	replace edu_cx = 5 if edu == 8 & edu_c >= 2 & edu_c ~= .
	replace edu_cx = 6 if edu == 8 & edu_c == 1
	replace edu_cx = 6 if edu == 9 & edu_c >= 2 & edu_c ~= .
	replace edu_cx = 7 if edu == 9 & edu_c == 1
	order edu_cx, after(edu_c)	
	lab var edu_cx "Highest education attainment by wave"
	lab define edu_cx_lbl 1 "elementary school graduate and below"
	lab define edu_cx_lbl 2 "middle school graduate", add
	lab define edu_cx_lbl 3 "high school graduate", add
	lab define edu_cx_lbl 4 "college graduate", add
	lab define edu_cx_lbl 5 "university graduate", add
	lab define edu_cx_lbl 6 "master graduate", add
	lab define edu_cx_lbl 7 "doctor graduate", add
	lab value edu_cx edu_cx_lbl
	
	bysort pid: egen max_educ = max(edu_cx)
	order max_educ, after(edu_cx)
	label variable max_educ "Highest education attainment"
	lab value max_educ edu_cx_lbl
	
	gen collegegrad = (max_educ >=4) if max_educ ~= .
	order collegegrad, after(max_educ)
	lab var collegegrad "college graduate"
	lab define collegegrad_lbl 1 "college graduate and above"
	lab define collegegrad_lbl 0 "high school graduate and below", add
	lab value collegegrad collegegrad_lbl

	gen maxed=1 if max_educ==1
	replace maxed=2 if max_educ==2 | max_educ==3 
	replace maxed=3 if max_educ==4 | max_educ==5 | max_educ==6 | max_educ==7
	lab var maxed "Completed Educational Attainment"
	label define ed_lbl 1 "Primary Education"
	label define ed_lbl 2 "Secondary Education", add 
	label define ed_lbl 3 "Tertiary Education", add
	label value maxed ed_lbl
	
	gen edu_prim = (maxed == 1)
	gen edu_sec = (maxed == 2)
	gen edu_ter = (maxed == 3)
	lab var edu_prim "Primary education"
	lab var edu_sec "Secondary education"
	lab var edu_ter "Postseondary education"
	
	gen yrschoolz = .
	replace yrschoolz = 0 if edu == 1 | edu == 2
	replace yrschoolz = 6 if edu_cx == 1
	replace yrschoolz = 9 if edu_cx == 2
	replace yrschoolz = 12 if edu_cx == 3
	replace yrschoolz = 14 if edu_cx == 4
	replace yrschoolz = 16 if edu_cx == 5
	replace yrschoolz = 18 if edu_cx == 6
	replace yrschoolz = 20 if edu_cx == 7
	lab var yrschoolz "Years of Completed Schooling"
	
	*Age group
	gen agegroup = .
	gen age10s = (age >= 10 & age < 20) if age ~= .
	gen age20s = (age >= 20 & age < 30) if age ~= .
	gen age30s = (age >= 30 & age < 40) if age ~= .
	gen age40s = (age >= 40 & age < 50) if age ~= .
	gen age50s = (age >= 50 & age < 60) if age ~= .
	gen age60s = (age >= 60 & age < 70) if age ~= .
	gen age70s = (age >= 70 & age < 80) if age ~= .
	replace agegroup = 1 if age10s == 1
	replace agegroup = 2 if age20s == 1
	replace agegroup = 3 if age30s == 1
	replace agegroup = 4 if age40s == 1
	replace agegroup = 5 if age50s == 1
	replace agegroup = 6 if age60s == 1
	replace agegroup = 7 if age70s == 1
	
	gen byear40 = (byear >= 1940 & byear < 1950)
	gen byear50 = (byear >= 1950 & byear < 1960)
	gen byear60 = (byear >= 1960 & byear < 1970)
	gen byear70 = (byear >= 1970 & byear < 1980)
	gen byear80 = (byear >= 1980 & byear < 1990)
	gen byear90 = (byear >= 1990 & byear < 2000)
	
	lab var agegroup "Age group"
	lab var age30s "Age 30~39"
	lab var age40s "Age 40~49"
	lab var age50s "Age 50~59"
	lab var age60s "Age 60~69"
	lab var age70s "Age 70~79"
	
	lab define agegroup_lbl 1 "Age 10~19"
	lab define agegroup_lbl 2 "Age 20~29", add
	lab define agegroup_lbl 3 "Age 30~39", add
	lab define agegroup_lbl 4 "Age 40~49", add
	lab define agegroup_lbl 5 "Age 50~59", add
	lab define agegroup_lbl 6 "Age 60~69", add
	lab define agegroup_lbl 7 "Age 70+", add
	lab value agegroup agegroup_lbl

	lab var byear40 "Born 1940s"
	lab var byear50 "Born 1950s"
	lab var byear60 "Born 1960s"
	lab var byear70 "Born 1970s"
	lab var byear80 "Born 1980s"
	lab var byear90 "Born 1990s"

	*Marital and employment status
	gen divorced = (marital == 4) if marital ~= .
	
	gen paidworker = (worktype1 == 1 | worktype1 == 2 | worktype1 == 3) if worktype1 ~= .
	gen regular = (worktype2 == 1) if worktype2 ~= .
	gen irregular = (worktype2 == 2) if worktype2 ~= .
	
	gen code_spouse = .
	replace code_spouse = relation + 10 if relation >= 10 & relation <= 19 & relation ~= .
	replace code_spouse = relation - 10 if relation >= 20 & relation <= 29 & relation ~= .
	replace code_spouse = relation + 20 if relation >= 31 & relation <= 49 & relation ~= .
	replace code_spouse = relation - 10 if relation >= 51 & relation <= 69 & relation ~= .
	replace code_spouse = relation + 100 if relation >= 111 & relation <= 199 & relation ~= .
	replace code_spouse = relation - 100 if relation >= 211 & relation <= 299 & relation ~= .

	preserve
	keep hhid year code_spouse hourlywage_total annualsalary_total annualsales
	rename code_spouse relation
	rename hourlywage_total spouse_hourlywage
	rename annualsalary_total spouse_annualsalary
	rename annualsales spouse_annualsales
	save "processed_data/spouse.dta", replace
	restore

	merge m:m hhid year relation using "processed_data/spouse.dta"
	drop if _merge == 2
	drop _merge
	drop if pid == .
	
	gen temp1 = LFS if male == 1 & (relation == 10 | relation == 20)
	gen temp2 = LFS if male == 0 & (relation == 10 | relation == 20)
	bysort hhid year: egen LFS_h = total(temp1), missing
	bysort hhid year: egen LFS_w = total(temp2), missing
	drop temp*
	
	lab var married "Married"
	lab var divorced "Divorced"
	lab var paidworker "Paid worker"
	lab var regular "Regular work"
	lab var irregular "Irregular work"
	lab var spouse_hourlywage "Spouse's hourly wage"
	lab var spouse_annualsalary "Spouse's annual salary"
	lab var LFS_h "LFS of husband"
	lab var LFS_w "LFS of wife"
	
save "processed_data/klips_imerge_long3.dta", replace

*** Erase old data
	erase "processed_data/spouse.dta"
	erase "processed_data/klips_imerge_long2.dta"

************************************************************************************************
/*
						Sample selection
*/
************************************************************************************************

use "processed_data/klips_imerge_long3.dta", clear

*** Winsorize aggregated variables 

	
	qui: su i_total_z, d
	gen temp1 = r(p99)
	qui: su i_total_z, d
	gen temp2 = r(p1)
	gen i_total_t = i_total_z if i_total_z < temp1 & i_total_z > temp2 & i_total_z ~= .
	replace i_total_t = temp1 if i_total_z >= temp1 & i_total_z ~= .
	replace i_total_t = temp2 if i_total_z <= temp2 & i_total_z ~= .
	drop temp*
	order i_total_t, after(i_total_z)
	lab var i_total_t "Total household income winsorized"

**** Additional variable construction 
	
	gen highgrad = (collegegrad == 0) if collegegrad ~= .
	gen seoul = (province == 1) if province ~= .
	
	* annual consumption
	
	gen i_total_t_100 = i_total_t / 100

	
	lab var highgrad "high school graduate"
	lab var seoul "living in Seoul"
	lab var LFS_h "LFS of husband"
	lab var LFS_w "LFS of wife"
	
	lab var i_total_t_100 "Total household income winsorized in million"
	
	tab year, gen(yrd)			/*year dummies*/
	tab byear, gen(ybd)			/*year of birth dummies*/
	tab male, gen(gender)		/*gender dummies*/
	tab max_educ, gen(edd)		/*education dummies*/
	tab nmem, gen(fd)			/*# of family member dummies*/
	tab children, gen(chd)		/*# of kids dummies*/
	tab employed, gen(emp)		/*empl. status dummies*/
	tab unemployed, gen(une)	/*umempl. status dummies*/
	tab province, gen(regd)		/*region dummies*/
	
	
	egen earning = rowtotal(annualsales annualsalary_total)
	egen spouse_earning = rowtotal(spouse_annualsales spouse_annualsalary)
	gen husband_earning = .
	replace husband_earning = earning if male == 1
	replace husband_earning = spouse_earning if male == 0
	
	lab var earning "Individual annual labor income"
	lab var spouse_earning "Spouse's annual labor income"
	lab var husband_earning "Husband's annual labor income"
	
	
	* make preference variables from Wave 18 available to all waves assuming them being time-invariant
	foreach var of varlist risktol patience impulsivity big5_O big5_C big5_E big5_A big5_N  {
		bysort pid: egen `var'_temp=max(`var')
		drop `var'
		rename `var'_temp `var'
		}
		
		
	lab define risktol_lbl 1 "Extremely risk averse"
	lab define risktol_lbl 2 "Very risk averse", add
	lab define risktol_lbl 3 "Moderately risk averse", add
	lab define risktol_lbl 4 "Neutral", add
	lab define risktol_lbl 5 "Moderately risk seeking",add
	lab define risktol_lbl 6 "Very risk seeking", add
	lab define risktol_lbl 7 "Extremely risk seeking",add
	lab value risktol risktol_lbl
	
	lab define patience_lbl 1 "Extremely impatient"
	lab define patience_lbl 2 "Very impatient", add
	lab define patience_lbl 3 "Moderately impatient", add
	lab define patience_lbl 4 "Neutral", add
	lab define patience_lbl 5 "Moderately patient",add
	lab define patience_lbl 6 "Very patient", add
	lab define patience_lbl 7 "Extremely patient",add
	lab value patience patience_lbl
	
	lab define impulsivity_lbl 1 "Extremely considerate"
	lab define impulsivity_lbl 2 "Very considerate", add
	lab define impulsivity_lbl 3 "Moderately considerate", add
	lab define impulsivity_lbl 4 "Neutral", add
	lab define impulsivity_lbl 5 "Moderately impulsive",add
	lab define impulsivity_lbl 6 "Very impulsive", add
	lab define impulsivity_lbl 7 "Extremely impulsive",add
	lab value impulsivity impulsivity_lbl
	
	lab var risktol "Risk Tolerance"
	lab var patience "Patience"
	lab var impulsivity "Impulsivity(a18)"
	
	lab var big5_O "Openness"
	lab var big5_C "Conscientiousness"
	lab var big5_E "Extraversion"
	lab var big5_A "Agreeableness"
	lab var big5_N "Neuroticism"
	
	lab var i_earned "Household Labor Income"
	
	
	
compress
save "processed_data/klips_imerge_long4.dta", replace
erase "processed_data/klips_imerge_long3.dta"

*********** End of preparing the KLIPS baseline data


*********** Processing the KLIPS's oTree special module data
*read KLIPS otree data
use "rawdata/klips/KLIPS_otree.dta", clear 

* drop errorneous cases to be dropped; requested by the KLI
drop if pid==151001 | pid==211303 | pid==480901 | pid==113605 | pid==672005 ///
	| pid==672006 | pid==10111104

* Lift Game

	* Least Conservative Measure 
	gen lift_highest=0
	replace lift_highest=5 if race_5_win==1
	replace lift_highest=11 if race_11_win==1
	replace lift_highest=14 if race_14_win==1
	replace lift_highest=17 if race_17_win==1

	gen lift_least = 0 if lift_highest==0
	replace lift_least = 1 if lift_highest==5
	replace lift_least = 2 if lift_highest==11
	replace lift_least = 3 if lift_highest==14
	replace lift_least = 4 if lift_highest==17

	* Most Conservative Meausre
	gen lift_most = 0 if race_5_win==0
	replace lift_most = 1 if race_5_win==1 & race_11_win==0 
	replace lift_most = 2 if race_5_win==1 & race_11_win==1 & race_14_win==0 
	replace lift_most = 3 if race_5_win==1 & race_11_win==1 & race_14_win==1 & race_17_win==0 
	replace lift_most = 4 if race_total==4
	
	* Monotonic
	gen lift_monoton = 0 if race_total==0
	replace lift_monoton = 1 if race_5_win==1 & race_11_win==0 & race_14_win==0  & race_17_win==0 
	replace lift_monoton = 2 if race_5_win==1 & race_11_win==1 & race_14_win==0  & race_17_win==0 
	replace lift_monoton = 3 if race_5_win==1 & race_11_win==1 & race_14_win==1 & race_17_win==0 
	replace lift_monoton = 4 if race_total==4

	* Number of wins
	gen lift_numwins = race_5_win+race_11_win+race_14_win+race_17_win
	
	* Thinking step-adjusted measures
	gen lift_step = 0
	replace lift_step = lift_step + 1 if race_5_win == 1
	replace lift_step = lift_step + 2 if race_11_win == 1
	replace lift_step = lift_step + 3 if race_14_win == 1
	replace lift_step = lift_step + 4 if race_17_win == 1
		
	
* Money Request Game
gen task2_rational_A=(task2_choice_A==50)
gen task2_rational_B=(task2_choice_B==40)
gen task2_rational_C=(task2_choice_C==30)
gen task2_rational_D=(task2_choice_D==20)
gen task2_rational_E=(task2_choice_E==10)

gen task2_total=task2_rational_A+task2_rational_B+task2_rational_C+task2_rational_D+task2_rational_E

gen task2_type1 = (task2_choice_A==50 & task2_choice_B==40 & task2_choice_C==30 & task2_choice_D==20 & task2_choice_E==50)
gen task2_type2 = (task2_choice_A==50 & task2_choice_B==40 & task2_choice_C==30 & task2_choice_D==50 & task2_choice_E==50)
gen task2_type3 = (task2_choice_A==50 & task2_choice_B==40 & task2_choice_C==50 & task2_choice_D==50 & task2_choice_E==50)
gen task2_type4 = (task2_choice_A==50 & task2_choice_B==50 & task2_choice_C==50 & task2_choice_D==50 & task2_choice_E==50)

gen task2_54= (task2_choice_A==50 & task2_choice_B==40)
gen task2_5455= ((task2_choice_A==50 & task2_choice_B==40) | (task2_choice_A==50 & task2_choice_B==50))
gen task2_54321= (task2_choice_A==50 & task2_choice_B==40 & task2_choice_C==30 & task2_choice_D==20 & task2_choice_E==10)

gen task2_level = 0 if task2_choice_A !=50
replace task2_level = 1 if task2_choice_A ==50 & task2_choice_B !=40
replace task2_level = 2 if task2_choice_A ==50 & task2_choice_B==40 & task2_choice_C !=30
replace task2_level = 3 if task2_choice_A==50 & task2_choice_B==40 & task2_choice_C==30 & task2_choice_D !=20
replace task2_level = 4 if task2_choice_A==50 & task2_choice_B==40 & task2_choice_C==30 & task2_choice_D==20 & task2_choice_E !=10
replace task2_level = 5 if task2_choice_A==50 & task2_choice_B==40 & task2_choice_C==30 & task2_choice_D==20 & task2_choice_E==10

* Monotonic
gen task2_monoton = 0     if task2_choice_A !=50 & task2_choice_B !=40 & task2_choice_C !=30 & task2_choice_D !=20 & task2_choice_E !=10
replace task2_monoton = 1 if task2_choice_A ==50 & task2_choice_B !=40 & task2_choice_C !=30 & task2_choice_D !=20 & task2_choice_E !=10
replace task2_monoton = 2 if task2_choice_A ==50 & task2_choice_B ==40 & task2_choice_C !=30 & task2_choice_D !=20 & task2_choice_E !=10
replace task2_monoton = 3 if task2_choice_A ==50 & task2_choice_B ==40 & task2_choice_C ==30 & task2_choice_D !=20 & task2_choice_E !=10
replace task2_monoton = 4 if task2_choice_A ==50 & task2_choice_B ==40 & task2_choice_C ==30 & task2_choice_D ==20 & task2_choice_E !=10
replace task2_monoton = 5 if task2_choice_A ==50 & task2_choice_B ==40 & task2_choice_C ==30 & task2_choice_D ==20 & task2_choice_E ==10


* drop the HOR payoff variable based on the conceptual opponent choice to recreate it based on the actual choice distribution 
drop task2_payoff

* create Task 2 choice probabilities by position
gen temp_A_50 = (task2_choice_A==50)
replace temp_A_50 =. if task2_choice_A==0 
su temp_A_50 
gen pr_A_50=`r(mean)' 
drop temp_A_50

forval i = 1/4 {
	local j: word `i' of B C D E
	forval k=1/5 {
		local l: word `k' of 10 20 30 40 50
		gen temp_`j'_`l' = (task2_choice_`j'==`l')
		su temp_`j'_`l' 
		gen pr_`j'_`l'=`r(mean)' 
		drop temp_`j'_`l'
		}
}

* add the position A reward
gen task2_payoff = task2_choice_A 
forval i = 1/4 {
	local j: word `i' of B C D E	
	local k: word `i' of A B C D	

	* add the reward for the number they chose at each position
	replace task2_payoff = task2_payoff + task2_choice_`j'
	* add the weighted reward at each position conditional on the choice
	if `i' != 1 {
	replace task2_payoff = task2_payoff + 100*pr_`k'_20 if task2_choice_`j'==10 
	replace task2_payoff = task2_payoff + 100*pr_`k'_30 if task2_choice_`j'==20 
	replace task2_payoff = task2_payoff + 100*pr_`k'_40 if task2_choice_`j'==30
	}
	* the above 3 lines has "`i' !=1' because the position A has only 10 or 50 as a choice. 
	replace task2_payoff = task2_payoff + 100*pr_`k'_50 if task2_choice_`j'==40 
}

* Task 2 payment assuming the rational choices by the opponent
gen task2_pay = task2_choice_A
replace task2_pay = task2_pay + task2_choice_B 
replace task2_pay = task2_pay + 100 if task2_choice_B==40
replace task2_pay = task2_pay + task2_choice_C 
replace task2_pay = task2_pay + 100 if task2_choice_C==30
replace task2_pay = task2_pay + task2_choice_D 
replace task2_pay = task2_pay + 100 if task2_choice_D==20
replace task2_pay = task2_pay + task2_choice_E 
replace task2_pay = task2_pay + 100 if task2_choice_E==10


* Task 2 thinking step-adjusted measures
gen task2_step = 0
replace task2_step = task2_step + 1 if task2_rational_A==1
replace task2_step = task2_step + 2 if task2_rational_B==1
replace task2_step = task2_step + 3 if task2_rational_C==1
replace task2_step = task2_step + 4 if task2_rational_D==1
replace task2_step = task2_step + 5 if task2_rational_E==1

gen task2_3type=0 if task2_choice_A==10
replace task2_3type=1 if task2_choice_A==50 & (task2_choice_B==10 | task2_choice_B==20 | task2_choice_B==30)
replace task2_3type=2 if task2_choice_A==50 & (task2_choice_B==50 | task2_choice_B==40)


* define the HOR score as the average payoff of the line game per round
gen hor_score= task2_payoff/5

** Eyes Test

lab var lift_most "BI Score"
lab var task2_level "BI counting score"
lab var task2_payoff "HOR Score"

lab var eye_total "Eyes Test Score"

keep pid lift_most lift_numwins lift_step hor_score task2_level task2_total task2_payoff  ///
task2_pay task2_step task2_3type eye_total task2_choice_*

cap drop _merge
merge 1:m pid using "processed_data/klips_imerge_long4.dta"
keep if _merge==3
drop _merge


* keep the cross-sectional data when the strategic thinking skills were measured
keep if wave==20


save "processed_data/KLIPS_merged.dta", replace
erase "processed_data/klips_imerge_long4.dta"




