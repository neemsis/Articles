*-------------------------
cls
*XXXX XXXX
*XXXX@XXXX
*March 19, 2024
*-----
gl link = "stabpsycho"
*-----
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------









****************************************
* Sample size check
****************************************

********** NEEMSIS-2
use"raw/NEEMSIS2-HH", clear

keep HHID2020 INDID2020 egoid livinghome dummylefthousehold reasonlefthome reasonlefthomeother maritalstatus
*
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2020
*
tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge INDID2020
*
order HHID_panel INDID_panel
*
foreach x in egoid dummylefthousehold reasonlefthome reasonlefthomeother livinghome maritalstatus {
rename `x' `x'2020
}

save"_temp", replace


********** NEEMSIS-1
use"raw/NEEMSIS1-HH", clear

keep HHID2016 INDID2016 egoid livinghome name sex maritalstatus
*
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2016
*
tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge INDID2016
*
order HHID_panel INDID_panel
*
drop if egoid==0
*
merge 1:1 HHID_panel INDID_panel using "_temp"
drop if _merge==2
*
count
*
drop if egoid2020>0 & egoid2020!=.

* Reason left home
fre reasonlefthome2020
ta reasonlefthomeother2020
replace reasonlefthome2020=2 if  reasonlefthomeother2020=="Following Jayaraman"
replace reasonlefthome2020=2 if  reasonlefthomeother2020=="Following her husband"
replace reasonlefthome2020=2 if  reasonlefthomeother2020=="Following her husband"
replace reasonlefthome2020=3 if  reasonlefthomeother2020=="To start nuclear family"
fre reasonlefthome2020


* Others
ta livinghome2020
fre livinghome2020

* Var global
sort _merge HHID_panel INDID_panel
gen reason=""
replace reason="Permanent migration (job)" if reasonlefthome2020==2
replace reason="Marriage" if reasonlefthome2020==3
replace reason="Died" if reasonlefthome2020==4
replace reason="Other" if reasonlefthome2020==77
replace reason="Temporarily migration" if livinghome2020==2
replace reason="Marriage" if livinghome2020==3
replace reason="Attrition HH" if _merge==1
replace reason="Indisponible to answer ego" if livinghome2020==1

ta reason, sort

****************************************
* END





















****************************************
* PREPA 2016-17
****************************************
use"$directory\raw\NEEMSIS1-HH.dta", clear

keep HHID2016 INDID2016 egoid name age sex dummydemonetisation submissiondate villageid relationshiptohead maritalstatus username
rename submissiondate submissiondate2016 

gen year=2016

* Caste
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-caste.dta", keepusing(jatiscorr caste)
drop _merge

* Education
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-education.dta", keepusing(edulevel)
drop _merge

* Occupations
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv.dta", keepusing(mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_occupationname_indiv annualincome_indiv)
drop _merge

* Occupations HH
merge m:1 HHID2016 using "raw\NEEMSIS1-occup_HH.dta", keepusing(annualincome_HH)
drop _merge

* Assets
merge m:1 HHID2016 using "raw\NEEMSIS1-assets.dta", keepusing(assets_total1000 assets_totalnoland1000 assets_sizeownland expenses_heal shareexpenses_heal)
drop _merge

* Family
merge m:1 HHID2016 using "raw\NEEMSIS1-family.dta", keepusing(HHsize typeoffamily)
drop _merge

* Villages
merge m:1 HHID2016 using "raw\NEEMSIS1-villages.dta", keepusing(villagename2016 villagename2016_club)
drop _merge
rename villagename2016 villagename

* Debt
merge m:1 HHID2016 using "raw\NEEMSIS1-loans_HH", keepusing(loanamount_HH imp1_ds_tot_HH)
drop _merge

* Panel HH
merge m:m HHID2016 using "raw\keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Panel Indiv
tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw\keypanel-indiv_wide.dta", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2016, replace

* PTCS
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-PTCS.dta", keepusing(ra1 rab1 rb1 ra2 rab2 rb2 ra3 rab3 rb3 ra4 rab4 rb4 ra5 rab5 rb5 ra6 rab6 rb6 ra7 rab7 rb7 ra8 rab8 rb8 ra9 rab9 rb9 ra10 rab10 rb10 ra11 rab11 rb11 ra12 rab12 rb12 set_a set_ab set_b raven_tt refuse num_tt lit_tt)
drop _merge

* Ego
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-ego.dta", keepusing(aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 enjoypeople curious organized managestress interestedbyart tryhard workwithother makeplans sharefeelings nervous stickwithgoals repetitivetasks shywithpeople workhard changemood understandotherfeeling inventive enthusiastic feeldepressed appointmentontime goaftergoal easilyupset talktomanypeople liketothink finishwhatbegin putoffduties rudetoother finishtasks toleratefaults worryalot easilydistracted keepworking completeduties talkative trustingofother newideas staycalm forgiveother activeimagination expressingthoughts helpfulwithothers canreadcard1a canreadcard1b canreadcard1c canreadcard2 numeracy1 numeracy2 numeracy3 numeracy4 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 ab1 ab2 ab3 ab4 ab5 ab6 ab7 ab8 ab9 ab10 ab11 ab12 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12)
drop _merge

* Username
replace username="Antoni" if username=="1"
replace username="Antoni - Vivek Radja" if username=="1 2"
replace username="Antoni - Raja Annamalai" if username=="1 6"
replace username="Vivek Radja" if username=="2"
replace username="Vivek Radja - Mayan" if username=="2 5"
replace username="Vivek Radja - Raja Annamalai" if username=="2 6"
replace username="Kumaresh" if username=="3"
replace username="Kumaresh - Sithanantham" if username=="3 4"
replace username="Kumaresh - Raja Annamalai" if username=="3 6"
replace username="Sithanantham" if username=="4"
replace username="Sithanantham - Raja Annamalai" if username=="4 6"
replace username="Mayan" if username=="5"
replace username="Mayan - Raja Annamalai" if username=="5 6"
replace username="Raja Annamalai" if username=="6"
replace username="Raja Annamalai - Pazhani" if username=="6 7"
replace username="Pazhani" if username=="7"

* Recode for refuse
fre canreadcard1a canreadcard1b canreadcard1c canreadcard2
fre lit_tt
recode lit_tt (.=0)

* To keep
keep if egoid>0
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
duplicates tag HHINDID, gen(tag)
tab tag
drop tag

* Rename
/*
foreach x in $tokeep dummydemonetisation {
rename `x' `x'_2016
}
*/


save"wave2-_ego", replace
****************************************
* END











****************************************
* PREPA 2020-21
****************************************
use"$directory\raw\NEEMSIS2-HH.dta", clear

keep HHID2020 INDID2020 egoid name age sex submissiondate villageid relationshiptohead maritalstatus username dummymarriage dummy_marriedlist
rename submissiondate submissiondate2020

gen year=2020

* COVID
merge m:1 HHID2020 using "raw\NEEMSIS2-covid.dta", keepusing(dummyexposure dummysell secondlockdownexposure)
keep if _merge==3
drop _merge
/*
ERREUR
. ta dummyexposure

dummyexposu |
         re |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |      2,328       79.95       79.95
        Yes |        584       20.05      100.00
------------+-----------------------------------
      Total |      2,912      100.00



GOOD
. ta dummyexposure

dummyexposu |
         re |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |      2,328       76.00       76.00
        Yes |        735       24.00      100.00
------------+-----------------------------------
      Total |      3,063      100.00
  
*/


* Caste
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-caste.dta", keepusing(jatiscorr caste)
keep if _merge==3
drop _merge

* Education
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-education.dta", keepusing(edulevel)
keep if _merge==3
drop _merge

* Occupations
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv.dta", keepusing(mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_occupationname_indiv annualincome_indiv)
keep if _merge==3
drop _merge

* Occupations HH
merge m:1 HHID2020 using "raw\NEEMSIS2-occup_HH.dta", keepusing(annualincome_HH)
keep if _merge==3
drop _merge

* Assets
merge m:1 HHID2020 using "raw\NEEMSIS2-assets.dta", keepusing(assets_total1000 assets_totalnoland1000 assets_sizeownland expenses_heal shareexpenses_heal)
keep if _merge==3
drop _merge

* Family
merge m:1 HHID2020 using "raw\NEEMSIS2-family.dta", keepusing(HHsize typeoffamily)
keep if _merge==3
drop _merge

* Villages
merge m:1 HHID2020 using "raw\NEEMSIS2-villages.dta", keepusing(village_new)
keep if _merge==3
rename village_new villagename
drop _merge

* Debt
merge m:1 HHID2020 using "raw\NEEMSIS2-loans_HH", keepusing(loanamount_HH imp1_ds_tot_HH)
drop if _merge==2
drop _merge

* Panel HH
merge m:m HHID2020 using "raw\keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Panel Indiv
tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw\keypanel-indiv_wide.dta", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2020, replace

* PTCS
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-PTCS.dta", keepusing(ra1 rab1 rb1 ra2 rab2 rb2 ra3 rab3 rb3 ra4 rab4 rb4 ra5 rab5 rb5 ra6 rab6 rb6 ra7 rab7 rb7 ra8 rab8 rb8 ra9 rab9 rb9 ra10 rab10 rb10 ra11 rab11 rb11 ra12 rab12 rb12 set_a set_ab set_b raven_tt refuse num_tt lit_tt)
drop if _merge==2
drop _merge

* Ego
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-ego.dta", keepusing(aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 enjoypeople curious organized managestress interestedbyart tryhard workwithother makeplans sharefeelings nervous stickwithgoals repetitivetasks shywithpeople workhard changemood understandotherfeeling inventive enthusiastic feeldepressed appointmentontime goaftergoal easilyupset talktomanypeople liketothink finishwhatbegin putoffduties rudetoother finishtasks toleratefaults worryalot easilydistracted keepworking completeduties talkative trustingofother newideas staycalm forgiveother activeimagination expressingthoughts helpfulwithothers canreadcard1a canreadcard1b canreadcard1c canreadcard2 numeracy1 numeracy2 numeracy3 numeracy4 numeracy5 numeracy6 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 ab1 ab2 ab3 ab4 ab5 ab6 ab7 ab8 ab9 ab10 ab11 ab12 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12)
drop _merge

* Recode for refuse
fre canreadcard1a canreadcard1b canreadcard1c canreadcard2
fre lit_tt
recode lit_tt (.=0)

* To keep
keep if egoid>0
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
duplicates tag HHINDID, gen(tag)
tab tag
drop tag

* Rename
/*
foreach x in $tokeep dummydemonetisation {
rename `x' `x'_2020
}
*/

save"wave3-_ego", replace
****************************************
* END













****************************************
* Panel
****************************************
use"wave2-_ego", replace

* Append
keep HHID_panel INDID_panel egoid year name age sex edulevel mainocc_occupation_indiv
append using "wave3-_ego", keep(HHID_panel INDID_panel egoid year name age sex edulevel mainocc_occupation_indiv)
order HHID_panel INDID_panel year egoid name age sex edulevel mainocc_occupation_indiv

duplicates tag HHID_panel INDID_panel year, gen(tag)
ta tag

* Reshape
reshape wide egoid name age sex edulevel mainocc_occupation_indiv, i(HHID_panel INDID_panel) j(year)

* Panel
gen panel=0
replace panel=1 if name2016!="" & name2020!=""
ta panel

* Clear
keep HHID_panel INDID_panel panel


save"panel", replace
****************************************
* END














****************************************
* Panel 2016 2020
****************************************
use"wave2-_ego", clear

* Append
append using "wave3-_ego"

* Merge panel
merge m:1 HHID_panel INDID_panel using "panel"
drop _merge
tab panel

* Clean
order HHINDID HHID_panel INDID_panel year egoid name sex age jatis caste edulevel villageid username panel

order curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking, after(panel)

sort HHID_panel INDID_panel year

*Clean year
clonevar time=year
recode time (2016=1) (2020=2)
label define time 1"2016" 2"2020"
label values time time


***** Change date format
ta submissiondate2016

gen submissiondate=.
replace submissiondate=submissiondate2016 if year==2016
replace submissiondate=submissiondate2020 if year==2020

gen tos=dofc(submissiondate)
format tos %td
drop submissiondate2016 submissiondate2020 submissiondate
rename tos submissiondate

*** 
recode mainocc_occupation_indiv (.=0)



*** Ownland
ta assets_sizeownland
recode assets_sizeownland (.=0)
ta assets_sizeownland
gen ownland=.
replace ownland=0 if assets_sizeownland==0
replace ownland=1 if assets_sizeownland>0
label define ownland 0"No land" 1"Land owner"
label values ownland ownland
order ownland, after(assets_sizeownland)


save"panel_stab_v1", replace
****************************************
* END












