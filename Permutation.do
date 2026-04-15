cd "D:\DISSERTATION (DO NOT DELETE THIS FOLDER)\Chapter 1 Rework"
use "Chapter 1 Updated Data (1-8-2026).dta", clear

* Permuting Treatment for Vietnam
local i=1

forvalues i=1(1)1000 {

contract HITS8
gen Placebo_Treat_2018_`i' = runiform() < 0.56236080178173719376391982182628  
gen Placebo_Treat_2019_`i' = runiform() < 0.6544529262086513994910941475827 if Placebo_Treat_2018_`i' == 0

gen DID_IMPUTE_PLACEBO_`i' = .
replace DID_IMPUTE_PLACEBO_`i' = 7 if Placebo_Treat_2018_`i' == 1
replace DID_IMPUTE_PLACEBO_`i' = 11 if Placebo_Treat_2019_`i' == 1

joinby HITS8 using "Chapter 1 Updated Data (1-8-2026).dta",
drop _freq 

did_imputation LogVietnamUS ID DATE DID_IMPUTE_PLACEBO_`i' 
scalar b`i' = _b[tau]
scalar se`i' = _se[tau]
local ++i	
}

file open myfile using "did_impute_att_se.txt", write replace

forvalues i=1(1)1000 {
	file write myfile ("`i'") _tab (b`i') _tab (se`i')  _n
}

file close myfile
clear all