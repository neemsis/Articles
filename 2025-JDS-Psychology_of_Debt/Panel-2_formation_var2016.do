*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 23, 2021
*-----
*Creation var 2016
*-----
do "psychodebt"
*-------------------------







****************************************
* EFA 2016
**************************************** 
use"raw\NEEMSIS1-HH", clear

* Indiv
*tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using "panel_indiv"
keep if _merge==3
drop _merge

*keep if panel_indiv==1
keep if egoid>0
*keep if egoid2020>0

* Merge ego
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-PTCS"
keep if _merge==3
drop _merge

* Merge caste
merge m:m HHID2016 using "raw\Panel-Caste_HH", keepusing(caste2016)
keep if _merge==3
drop _merge
rename caste2016 caste

********** Imputation for non corrected one
global big5cr cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

foreach x in $big5cr{
gen im`x'=`x'
}


forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5cr{
qui sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if im`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}


global imcor imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm 



********** Without grit
minap $imcor
factor $imcor, pcf fa(5) 
rotate, quartimin
putexcel set "EFA_2016.xlsx", modify sheet(imcor)
putexcel (E2)=matrix(e(r_L))


********** Omega with Laajaj approach for factor analysis and Cobb Clark
** F1
*global f1 imcr_easilyupset imcr_nervous imcr_worryalot imcr_feeldepressed imcr_changemood imcr_easilydistracted imcr_shywithpeople imcr_putoffduties imcr_rudetoother imcr_repetitivetasks
global f1 imcr_easilyupset imcr_nervous imcr_worryalot imcr_feeldepressed imcr_changemood imcr_easilydistracted imcr_shywithpeople imcr_trustingofother imcr_putoffduties imcr_rudetoother imcr_repetitivetasks
** F2
*global f2 imcr_makeplans imcr_appointmentontime imcr_completeduties imcr_enthusiastic imcr_organized imcr_workhard imcr_workwithother
global f2 imcr_makeplans imcr_appointmentontime imcr_completeduties imcr_enthusiastic imcr_organized imcr_workhard imcr_workwithother
** F3
*global f3 imcr_liketothink imcr_activeimagination imcr_expressingthoughts imcr_sharefeelings imcr_newideas imcr_inventive imcr_curious imcr_talktomanypeople imcr_talkative imcr_interestedbyart imcr_understandotherfeeling
global f3 imcr_liketothink imcr_activeimagination imcr_expressingthoughts imcr_sharefeelings imcr_newideas imcr_inventive imcr_curious imcr_talktomanypeople imcr_talkative imcr_interestedbyart imcr_understandotherfeeling
** F4
*global f4 imcr_staycalm imcr_managestress
global f4 imcr_staycalm imcr_managestress
** F5
*global f5 imcr_forgiveother imcr_toleratefaults imcr_trustingofother imcr_enjoypeople imcr_helpfulwithothers
global f5 imcr_forgiveother imcr_toleratefaults imcr_trustingofother imcr_enjoypeople imcr_helpfulwithothers

/*
*** Omega
omega $f1
omega $f2
omega $f3
alpha $f4
omega $f5
*/

*** Score
egen f1_2016=rowmean($f1)
egen f2_2016=rowmean($f2)
egen f3_2016=rowmean($f3)
egen f4_2016=rowmean($f4)
egen f5_2016=rowmean($f5)

egen OP_2016 = rowmean(imcr_curious imcr_interested~t   imcr_repetitive~s imcr_inventive imcr_liketothink imcr_newideas imcr_activeimag~n)
egen CO_2016 = rowmean(imcr_organized  imcr_makeplans imcr_workhard imcr_appointmen~e imcr_putoffduties imcr_easilydist~d imcr_completedu~s) 
egen EX_2016 = rowmean(imcr_enjoypeople imcr_sharefeeli~s imcr_shywithpeo~e  imcr_enthusiastic  imcr_talktomany~e  imcr_talkative imcr_expressing~s ) 
egen AG_2016 = rowmean(imcr_workwithot~r imcr_understand~g imcr_trustingof~r imcr_rudetoother imcr_toleratefa~s imcr_forgiveother imcr_helpfulwit~s) 
egen ES_2016 = rowmean(imcr_managestress imcr_nervous imcr_changemood imcr_feeldepres~d imcr_easilyupset imcr_worryalot imcr_staycalm) 
egen Grit_2016 = rowmean(imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking)

keep $imcorwith HHID_panel INDID_panel f1_2016 f2_2016 f3_2016 f4_2016 f5_2016 lit_tt raven_tt num_tt OP_2016 CO_2016 EX_2016 AG_2016 ES_2016 Grit_2016

save"NEEMSIS1-HH~_ego.dta", replace
****************************************
* END













****************************************
* Control var 2016
****************************************
use"raw\NEEMSIS1-HH", clear



********** To keep
keep HHID2016 INDID2016 egoid name age sex livinghome dummymarriage dummydemonetisation relationshiptohead maritalstatus villageid



********** Indiv
*tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using "panel_indiv", keepusing(HHID_panel INDID_panel panel_indiv)
keep if _merge==3
drop _merge
order HHID_panel HHID2016 INDID_panel INDID2016
*destring INDID2016, replace

* Caste / jatis
merge m:m HHID2016 using "raw\Panel-Caste_HH", keepusing(caste2016)
rename caste2016 caste
keep if _merge==3
drop _merge

* Education
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-education"
drop _merge

* Occupation
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv", keepusing(mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv)
drop _merge

* Indiv debt
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-loans_indiv", keepusing(nbloans_indiv loanamount_indiv)
drop _merge



********** HH
* Debt
merge m:1 HHID2016 using "raw\NEEMSIS1-loans_HH", keepusing(loanamount_HH)
drop _merge

* Assets
merge m:1 HHID2016 using "raw\NEEMSIS1-assets", keepusing(assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop)
drop _merge

* Income
merge m:1 HHID2016 using "raw\NEEMSIS1-occup_HH", keepusing(incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH nbworker_HH nbnonworker_HH)
drop _merge

* Family
merge m:1 HHID2016 using "raw\NEEMSIS1-family", keepusing(nbmale nbfemale age_group HHsize typeoffamily waystem dummypolygamous)
drop _merge

* Villages
*merge m:1 HHID2016 using "raw\NEEMSIS1-villages", keepusing(livingarea villagename2016_club)
*drop _merge
*rename villagename2016_club villageid2016



********** Factor
* Only ego
fre egoid
drop if egoid==0
*keep if panel_indiv==1

* Merge factor
merge 1:1 HHID_panel INDID_panel using "NEEMSIS1-HH~_ego.dta"
keep if _merge==3
drop _merge

foreach x in f1 f2 f3 f4 f5 {
rename `x'_2016 base_`x'
}

rename num_tt base_num_tt
rename lit_tt base_lit_tt
rename raven_tt base_raven_tt

gen indebt_indiv=0
replace indebt_indiv=1 if loanamount_indiv>0 & loanamount_indiv!=.
drop nbloans_indiv loanamount_indiv

* Standardiser personality traits
cls
foreach x in base_f1 base_f2 base_f3 base_f4 base_f5 {
qui reg `x' age
predict res_`x', residuals
egen `x'_std=std(res_`x')
}

label var base_f1_std "ES (std)"
label var base_f2_std "CO (std)"
label var base_f3_std "OP-EX (std)"
label var base_f4_std "weak ES (std)"
label var base_f5_std "AG (std)"

* Standardiser les compétences cognitives
foreach x in base_raven_tt base_num_tt base_lit_tt {
qui reg `x' age
predict res_`x', residuals
egen `x'_std=std(res_`x')
}

label var base_raven_tt_std "Raven (std)"
label var base_lit_tt_std "Literacy (std)"
label var base_num_tt_std "Numeracy (std)"



********** Var creation
* Groups social identity
gen female=0 if sex==1
replace female=1 if sex==2
label var female "Female (=1)"

gen segmana=.
replace segmana=1 if caste==1 & female==1  // female dalits (DJ)
replace segmana=2 if caste==1 & female==0  // male dalits
replace segmana=3 if (caste==2 | caste==3) & female==1  // female midup
replace segmana=4 if (caste==2 | caste==3) & female==0  // male midup

label define segmana 1"Dalit women" 2"Dalit men" 3"MU caste women" 4"MU caste men"
label values segmana segmana

tab segmana

* Dalits vs non-Dalits
clonevar caste2=caste
recode caste2 (3=2)

tab caste2 female

* Dummy for multiple occupation
fre nboccupation_indiv
gen dummymultipleoccupation_indiv=0 if nboccupation_indiv==1
replace dummymultipleoccupation_indiv=1 if nboccupation_indiv>1 & nboccupation_indiv!=.
recode dummymultipleoccupation_indiv (.=0)
label var dummymultipleoccupation_indiv "Multiple occupation (=1)"

* Interaction variables
fre caste2
gen dalits=0 if caste2==2
replace dalits=1 if caste2==1
tab dalits female
label var dalits "Dalits (=1)"

global cogperso base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_lit_tt_std base_num_tt_std 

foreach x in $cogperso {
gen fem_`x'=`x'*female
gen dal_`x'=`x'*dalits
gen thr_`x'=`x'*female*dalits
}
gen femXdal=female*dalits

* Shock
gen shock=0
replace shock=1 if dummymarriage==1 | dummydemonetisation==1



********** Label 
*
label define castenew 1"C: Dalits" 2"C: Middle" 3"C: Upper"
label values caste castenew

*
label var HHsize "Household size"

*
gen agesq=age*age
label var age "Age"
label var agesq "Age square"

*
tab caste, gen(caste_)
label var caste "C: Dalits"
label var caste_2 "C: Middle"
label var caste_3 "C: Upper"

*
fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (5=4)
recode mainocc_occupation_indiv (.=0)
tab mainocc_occupation_indiv,gen(cat_mainocc_occupation_indiv_)
label var cat_mainocc_occupation_indiv_1 "Occ: No occ"
label var cat_mainocc_occupation_indiv_2 "Occ: Agri"
label var cat_mainocc_occupation_indiv_3 "Occ: Agri coolie"
label var cat_mainocc_occupation_indiv_4 "Occ: Coolie"
label var cat_mainocc_occupation_indiv_5 "Occ: Regular"
label var cat_mainocc_occupation_indiv_6 "Occ: SE"
label var cat_mainocc_occupation_indiv_7 "Occ: MGNREGA"

*
fre relationshiptohead
gen dummyhead=0
replace dummyhead=1 if relationshiptohead==1
label var dummyhead "HH head (=1)"

*
fre maritalstatus 
gen maritalstatus2=1 if maritalstatus==1
recode maritalstatus2 (.=0)
label define marital 0"Other (un, wid, sep)" 1"Married (=1)"
label values maritalstatus2 marital
label var maritalstatus2 "Married (=1)"
fre maritalstatus2

*
ta villageid, gen(villageid_)

*
gen nboccupation=2 if nboccupation_indiv==1
replace nboccupation=3 if nboccupation_indiv==2
replace nboccupation=4 if nboccupation_indiv>2
replace nboccupation=1 if nboccupation_indiv==.
tab nboccupation
label define occ 1"Nb occ: 0" 2"Nb occ: 1" 3"Nb occ: 2" 4"Nb occ: 3 or more"
label values nboccupation occ
tab nboccupation, gen(nboccupation_)
label var nboccupation "Nb occ: 0"
label var nboccupation_2 "Nb occ: 1"
label var nboccupation_3 "Nb occ: 2"
label var nboccupation_4 "Nb occ: 3 or more"
tab1 nboccupation nboccupation_2 nboccupation_3 nboccupation_4

*
fre edulevel
gen dummyedulevel=0
replace dummyedulevel=1 if edulevel>=1
ta dummyedulevel
label var dummyedulevel "School educ (=1)"

*
label var shock "Shock (=1)"

*
gen assets1000=assets_total/1000
label var assets1000 "Assets (\rupee1k)"

*
gen incomeHH1000=annualincome_HH/1000
label var incomeHH1000 "Total income (\rupee1k)"

*
gen year=2016

save"NEEMSIS1-HH~panel", replace
****************************************
* END





















****************************************
* Attrition
****************************************
use"NEEMSIS1-HH~panel", clear

/*
Once the 2020 base is ready, launch this for attrition
*/


keep HHID_panel INDID_panel female dalits base_raven_tt_std base_num_tt_std base_lit_tt_std base_f1_std base_f2_std base_f3_std base_f5_std

merge 1:1 HHID_panel INDID_panel using "NEEMSIS2-HH~panel", keepusing(year)
drop if _merge==2
drop year


*****
cls
foreach y in base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std {
reg `y' i._merge i.female i.dalits
}




****************************************
* END


