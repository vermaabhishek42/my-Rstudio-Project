*** This file reads the World Values Survey's raw data and produce Figure A10 Panels (a) and (b)

* read WVS raw data
use "rawdata/wvs/Integrated_values_surveys_1981-2021.dta", clear


*** Generate variables 
	gen wave = S002VS if S002EVS == .
	replace wave = 1 if S002EVS == 1 & S002VS == . 
	replace wave = 2 if S002EVS == 2 & S002VS == . 
	replace wave = 4 if S002EVS == 3 & S002VS == . 
	replace wave = 5 if S002EVS == 4 & S002VS == . 
	replace wave = 7 if S002EVS == 5 & S002VS == . 
	
	lab define wave_lbl 1 "1981-1984 (EVS/WVS1)" // EVS1
	lab define wave_lbl 2 "1989-1993 (EVS/WVS2)", add // EVS2
	lab define wave_lbl 3 "1994-1998 (WVS3)", add
	lab define wave_lbl 4 "1999-2004 (EVS3, WVS4)", add // EVS3 
	lab define wave_lbl 5 "2005-2010 (EVS4, WVS5)", add // EVS4
	lab define wave_lbl 6 "2010-2014 (WVS6)", add
	lab define wave_lbl 7 "2017-2021 (EVS5, WVS7)", add // EVW5
	lab value wave wave_lbl
	
	order S002VS S002EVS wave S003 S006 
	
	gen year = S020
	gen weight = S017
	gen age = X003
	
	gen country = S003  if S003 == 276 | S003 == 410 | S003 == 702 | ///
							S003 == 840 | S003 == 392 | S003 == 752 | S003 == 36
							
	lab define country_lbl 276 "Germany"
	lab define country_lbl 410 "South Korea", add
	lab define country_lbl 702 "Singapore", add
	lab define country_lbl 840 "U.S", add
	lab define country_lbl 392 "Japan", add
	lab define country_lbl 752 "Sweden", add
	lab define country_lbl 36 "Australia", add
	lab value country country_lbl
	
	
	gen order = 1 if country == 36
	replace order = 2 if country == 276
	replace order = 3 if country == 392
	replace order = 4 if country == 702
	replace order = 5 if country == 410
	replace order = 6 if country == 752
	replace order = 7 if country == 840
	
	gen country_r = S003 if S003 == 392 | S003 == 410 | S003 == 702 | ///
							S003 == 724 | S003 == 752 | S003 == 840
							
	lab define country_r_lbl 392 "Japan"
	lab define country_r_lbl 410 "South Korea", add
	lab define country_r_lbl 702 "Singapore", add
	lab define country_r_lbl 724 "Spain", add
	lab define country_r_lbl 752 "Sweden", add
	lab define country_r_lbl 840 "US", add
	lab value country_r country_r_lbl
	
	gen order_r = 1 if country_r == 392
	replace order_r =2 if country_r == 410
	replace order_r =3 if country_r == 702
	replace order_r =4 if country_r == 724
	replace order_r =5 if country_r == 752
	replace order_r =6 if country_r == 840
	
	
	gen valchild1 = D019 // A woman has to have children to be fulfilled
	lab var valchild1 "Necessary for a woman to have children in order to be fufilled"
	
	gen valwork1 = D056 // Relationship working mother *
	lab var valwork1 "A working mother can establish just as warm and secure a relationship with her children as a mother who does not work"
	
	gen valwork2 = D057 // Being a housewife just as fulfilling *
	lab var valwork2 "Being a housewife is just as fulfilling as working to pay"
	
	gen valwork3 = D058 // Husband and wife should both contribute to income
	lab var valwork3 "Both the husband and wife should contribute to household income"
		
	gen valwork4 = D059 // Men make better political leaders than women do
	lab var valwork4 "On the whole, men make better political leaders than women do"
	
	gen valwork5 = D060 // University is more important for a boy than for a girl
	lab var valwork5 "A university education is more important for a boy than for a girl"
	
	gen valwork6 = D078 // Men make better business executives than women do
	lab var valwork6 "On the whole, men make better business executives than women do"
	
	gen valwork7 = C001 // Jobs scarce: Men should have more right to a job than women
	lab var valwork7 "When jobs are scarce, men should have more right to a job than women"
	
	gen valwork8 = D066 if wave == 3 // Problem if women have more income than husband
	replace valwork8 = D066_B if wave == 6 | wave == 7
	lab var valwork8 "If a woman earns more money than her husband, it's almost certain to cause problems"
	
	gen valwork9 = D063 if wave == 2
	replace valwork9 = D063_B if wave == 6
	lab var valwork9 "Having a job is the best way for a woman to be an independent person"
		
	gen valwork10 = D061 // Pre-school child suffers with working mother
	lab var valwork10 "When a mother works for pay, the children suffer"
	
	
* Gen % Agree
	
	gen valchild1_bin = ( valchild1 == 1 )
	replace valchild1_bin = . if valchild1 == .
	
	* valwork
	foreach x in valwork1 valwork2 valwork3 valwork4 valwork5 valwork6 valwork10 {

	gen `x'_bin = (`x' == 1 | `x' == 2)
	replace `x'_bin = . if `x' ==.

	}


	* valwork7
	foreach x in valwork7 {
	
	gen `x'_bin = (`x' == 1)
	replace `x'_bin = . if `x' ==.
	
	}
	
	*valwork8 (wave 3,6,7)
	foreach x in valwork8 {
	
	gen `x'_bin = (`x' == 1 | `x' == 2) if wave == 3
	replace `x'_bin = (`x' == 1 ) if wave == 6 | wave == 7
	
	replace `x'_bin = . if `x' ==.
	
	}
	
	*valwork9 (wave 2,6)
	foreach x in valwork9 {

	gen `x'_bin = (`x' == 1 | `x' == 2) if wave == 3
	replace `x'_bin = (`x' == 1 ) if wave == 6
	
	}
	

	
	keep if age >= 50 & age <=65 

	*** Figure A10 Panel (a). Being a housewife is just as fulfiilling as working to pay: 2010-2014 (WVS6)
	graph bar valwork2_bin if wave == 6 [aw = weight], nofill  ///
	over(country, sort(order) label(labsize(small)) relabel(`r(relabel)'))  ///
	ytitle("% Agree or Strongly Agree", size(small)) title("`:variable label valwork2'", size(medium)) ///
	subtitle("2010-2014 (WVS6)", size(small)) ///
	ylabel(0(0.2)1) blabel(bar, format(%4.2f)) graphregion(fcolor(white)) scheme(s2color)
	graph export "figures/Fig_A10A.png", replace
	
	
	*** Figure A10 Panel (b). Having a job is the best way for a woman to be an independent persion: 2010-2014 (WVS6)
	graph bar valwork9_bin if wave == 6 [aw = weight], nofill  ///
	over(country, sort(order) label(labsize(small)) relabel(`r(relabel)'))  ///
	ytitle("% Agree or Strongly Agree", size(small)) title("`:variable label valwork9'", size(medium)) ///
	subtitle("2010-2014 (WVS6)", size(small)) ///
	ylabel(0(0.2)1) blabel(bar, format(%4.2f)) graphregion(fcolor(white)) scheme(s2color)
	graph export "figures/Fig_A10B.png", replace

	
	