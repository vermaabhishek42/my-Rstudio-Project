*** This file reads the World Bank's raw data on GDP per capita and female labor force participation and produce Figures A11 Panels (a) and (b)

* read raw data
import delimited "rawdata/worldbank/world_bank_raw.csv"

* reshape the wide form to the long form
reshape long flfp gdp, i(country_code) j(year)

gen ID=1 if country_code=="AUS"
replace ID=2 if country_code=="DEU"
replace ID=3 if country_code=="JPN"
replace ID=4 if country_code=="SGP"
replace ID=5 if country_code=="KOR"
replace ID=6 if country_code=="SWE"
replace ID=7 if country_code=="USA"

save "processed_data/worldbank_processed.dta", replace

* declare the panel variables
sort ID year
xtset ID year, yearly

* plot Figure A11 panel (a)
twoway (connected gdp year if ID==1, lcolor(navy) mcolor(navy) msymbol(circle_hollow)) ///
(connected gdp year if ID==2, lcolor(maroon) mcolor(maroon) msymbol(triangle)) ///
(connected gdp year if ID==3, lcolor(forest_green) mcolor(forest_green) msymbol(square_hollow)) ///
(connected gdp year if ID==4, lcolor(orange) mcolor(orange) msymbol(lgx)) ///
(connected gdp year if ID==5, lcolor(eltgreen) mcolor(eltgreen) msymbol(diamond_hollow)) ///
(connected gdp year if ID==6, lcolor(red) mcolor(red) msymbol(circle)) ///
(connected gdp year if ID==7, lcolor(lavender) mcolor(lavender) msymbol(triangle)), ///
title("GDP per capita (constant 2015 US$)") xtitle("year") ///
ytitle(, size(zero)) ylabel(, glwidth(vthin) glcolor(ltblue%50) glpattern(solid)) ///
ttitle("year") tlabel(2000(1)2020, angle(forty_five) nogrid glcolor())  ///
legend(on order(1 "Australia" 2 "Germany" 3 "Japan" 4 "Singapore" 5 "South Korea" 6 "Sweden" 7 "U.S.") row(4) region(lcolor(black) lwidth(vthin) lpattern(solid)) position(6)) scheme(stcolor)

cap erase "figures/Fig_A11A.gph"
cap erase "figures/Fig_A11A.png"
graph save Graph "figures/Fig_A11A.gph", replace
graph export "figures/Fig_A11A.png", replace

* plot Figure A11 panel (b)
twoway (connected flfp year if ID==1, lcolor(navy) mcolor(navy) msymbol(circle_hollow)) ///
(connected flfp year if ID==2, lcolor(maroon) mcolor(maroon) msymbol(triangle)) ///
(connected flfp year if ID==3, lcolor(forest_green) mcolor(forest_green) msymbol(square_hollow)) ///
(connected flfp year if ID==4, lcolor(orange) mcolor(orange) msymbol(lgx)) ///
(connected flfp year if ID==5, lcolor(eltgreen) mcolor(eltgreen) msymbol(diamond_hollow)) ///
(connected flfp year if ID==6, lcolor(red) mcolor(red) msymbol(circle)) ///
(connected flfp year if ID==7, lcolor(lavender) mcolor(lavender) msymbol(triangle)), ///
title("Labor force participation rate (%), female") xtitle("year") ///
ytitle(, size(zero)) ylabel(, glwidth(vthin) glcolor(ltblue%50) glpattern(solid)) ///
ttitle("year") tlabel(2000(1)2020, angle(forty_five) nogrid glcolor())  ///
legend(on order(1 "Australia" 2 "Germany" 3 "Japan" 4 "Singapore" 5 "South Korea" 6 "Sweden" 7 "U.S.") row(4) region(lcolor(black) lwidth(vthin) lpattern(solid)) position(6)) scheme(stcolor)

cap erase "figures/Fig_A11B.gph"
cap erase "figures/Fig_A11B.png"
graph save Graph "figures/Fig_A11B.gph", replace
graph export "figures/Fig_A11B.png", replace

clear

