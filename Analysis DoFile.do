cd "D:\DISSERTATION (DO NOT DELETE THIS FOLDER)\Chapter 1 Rework"
use "Chapter 1 Updated Data (1-8-2026).dta", clear

**** GOOD COMPARISON
* Chinese goods which were actively exported to the US
preserve
keep if ChinaUS > 0
collapse (count) ChinaUS, by (DATE)
save temp_count_china, replace
restore

* Vietnamese goods which were actively exported to the US
preserve
keep if VietnamUS > 0
collapse (count) VietnamUS, by (DATE)
save temp_count_Vietnam, replace
restore

* Combine the two graphs 
preserve
use temp_count_china, clear
joinby DATE using temp_count_Vietnam
twoway (connected ChinaUS DATE) (connected VietnamUS DATE, yaxis(2)), xlabel(, labels)
restore

**** Export in LOG USD
* CHINA
preserve
collapse (mean) LogChinaUS, by (DATE)
save temp_export_china, replace
restore

* VIETNAM
preserve
collapse (mean) LogVietnamUS, by (DATE)
save temp_export_Vietnam, replace
restore

* Combine the two graphs 
preserve
use temp_export_china, clear
joinby DATE using temp_export_Vietnam
twoway (connected LogChinaUS DATE) (connected LogVietnamUS DATE, yaxis(2)), xlabel(, labels)
restore

* SUMMARY
xtsum LogChinaUS LogVietnamUS if DATE < 7
xtsum LogChinaUS LogVietnamUS if DATE >= 7
xtsum ChinaWorldRCA VietnamWorldRCA MNC_Dummy

****** Export trend table
preserve
keep if DATE >= 1 & DATE <= 4
collapse (sum) ChinaUS VietnamUS, by(HITS8)
count if ChinaUS > 0 & VietnamUS > 0
count if ChinaUS > 0 & VietnamUS == 0
count if ChinaUS == 0 & VietnamUS > 0
count if ChinaUS == 0 & VietnamUS == 0
restore

preserve
keep if DATE >= 5 & DATE <= 8
collapse (sum) ChinaUS VietnamUS, by(HITS8)
count if ChinaUS > 0 & VietnamUS > 0
count if ChinaUS > 0 & VietnamUS == 0
count if ChinaUS == 0 & VietnamUS > 0
count if ChinaUS == 0 & VietnamUS == 0
restore

preserve
keep if DATE >= 9 & DATE <= 12
collapse (sum) ChinaUS VietnamUS, by(HITS8)
count if ChinaUS > 0 & VietnamUS > 0
count if ChinaUS > 0 & VietnamUS == 0
count if ChinaUS == 0 & VietnamUS > 0
count if ChinaUS == 0 & VietnamUS == 0
restore

preserve
keep if DATE >= 13 & DATE <= 16
collapse (sum) ChinaUS VietnamUS, by(HITS8)
count if ChinaUS > 0 & VietnamUS > 0
count if ChinaUS > 0 & VietnamUS == 0
count if ChinaUS == 0 & VietnamUS > 0
count if ChinaUS == 0 & VietnamUS == 0
restore

* AVERAGE TREATMENT EFFECT
xtreg LogChinaUS DID i.DATE, fe r 
did_imputation LogChinaUS ID DATE DIDImpute_Treat
xtreg LogVietnamUS DID i.DATE, fe r 
did_imputation LogVietnamUS ID DATE DIDImpute_Treat

* EVENT STUDY PLOTS
did_imputation LogChinaUS ID DATE DIDImpute_Treat, allhorizons pretrend(6) autosample 
event_plot, default_look together plottype(scatter) graph_opt(title(Event Study Plot of China's US Exports))

did_imputation LogVietnamUS ID DATE DIDImpute_Treat, allhorizons pretrend(6) autosample 
event_plot, default_look together plottype(scatter) graph_opt(title(Event Study Plot of Vietnam's US Exports))

* REGRESSION
xtreg LogVietnamUS DID i.DATE, fe r
xtreg LogVietnamUS DID DIDChinaWorldRCA DIDVietnamWorldRCA DIDChiVietIntRCA  i.DATE, fe r
xtreg LogVietnamUS DID DIDMNC_Dummy i.DATE, fe r 
xtreg LogVietnamUS DID DIDChinaWorldRCA DIDVietnamWorldRCA DIDChiVietIntRCA DIDMNC_Dummy i.DATE, fe r

** RESTRICTION 
preserve
keep if SUBCHAPTER !="9903.88.15" & DATE <= 12
xtreg LogVietnamUS DID i.DATE, fe r
xtreg LogVietnamUS DID DIDChinaWorldRCA DIDVietnamWorldRCA DIDChiVietIntRCA i.DATE, fe r
xtreg LogVietnamUS DID DIDMNC_Dummy i.DATE, fe r 
xtreg LogVietnamUS DID DIDChinaWorldRCA DIDVietnamWorldRCA DIDChiVietIntRCA DIDMNC_Dummy i.DATE, fe r
restore

*** Rest of the world analysis
xtreg LogROWUS DID i.DATE, fe r
xtreg LogROWUS DID i.DATE if SUBCHAPTER !="9903.88.15" & DATE <= 12, fe r
did_imputation LogROWUS ID DATE DIDImpute_Treat