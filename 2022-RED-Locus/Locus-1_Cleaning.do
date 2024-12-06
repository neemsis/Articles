*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*July 22, 2022
*-----
*Locus cleaning
*-----
cd""
*-------------------------







****************************************
* Variables
****************************************


********** Locus of control
use"NEEMSIS2-ego", clear

/*
1. I like taking responsibility.
2. I find it best to make decisions by myself rather than to rely on fate.
3. When I encounter problems or opposition, I usually find ways and means to overcome them.
4. Success often depends more on luck than on effort.
5. I often have the feeling that I have little influence over what happens to me.
6. When I make important decisions, I often look at what others have done.
*/

global locus locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4 locuscontrol5 locuscontrol6
fre $locus

omegacoef locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4 locuscontrol5 locuscontrol6, reverse(locuscontrol4 locuscontrol5 locuscontrol6) noreverse(locuscontrol1 locuscontrol2 locuscontrol3)


***** Reverse locuscontrol4 5 6 for min=intern and max=extern as locuscontrol1 2 3
forvalues i=4(1)6 {
vreverse locuscontrol`i', gen(locuscontrol`i'_rv)
rename locuscontrol`i' locuscontrol`i'_original
rename locuscontrol`i'_rv locuscontrol`i'
}

global locus locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4 locuscontrol5 locuscontrol6
fre $locus


***** Internal consistency
omegacoef $locus  // .81


* Score
egen locus=rowmean($locus)
replace locus=round(locus, .01)
label var locus "intern --> extern"

tabstat locus, stat(n mean sd p50) by(sex)
ta locus
gen locuscat=.
replace locuscat=1 if locus<3
replace locuscat=2 if locus==3
replace locuscat=3 if locus>3

label define locuscast 1"Intern" 2"Mid" 3"Extern"
label values locuscat locuscat

ta locus locuscat

********** Locus and income
*intern --> extern
tabstat locus, stat(n mean sd p50) by(caste)
tabstat locus, stat(min p1 p5 p10 q p90 p95 p99 max) by(caste)

ta locus caste
ta locuscat caste, col nofreq
ta locuscat caste, chi2 cchi2 exp
*Ok, upper castes are over rep among intern


***** Save
save"$wave3~_ego_v2_RED.dta", replace

****************************************
* END














****************************************
* Prepa 2020
****************************************

********** 
use"NEEMSIS2-HH", clear
*HH size
drop if INDID_left!=.
keep if livinghome==1 | livinghome==2
bysort HHID_panel: gen hhsize=_N

*
sum loanamount_indiv


*Nb children
gen child=0
replace child=1 if age<=14
bysort HHID_panel: egen nbchild=sum(child)

*Sex ratio
gen female=0
gen male=0
replace female=1 if sex==2
replace male=1 if sex==1
bysort HHID_panel: egen nbfemale=sum(female)
bysort HHID_panel: egen nbmale=sum(male)


********** New HH level var: savings, chitfunds, lending, gold, insurance, land purchased, livestockexpenses (livestockspent), equipmentyear 
sort HHID_panel INDID_panel

/*
*Savings
egen savingsamount_temp_HH=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID_panel: egen savingsamount_HH=sum(savingsamount_temp_HH)
*/

*Expenses
bysort HHID_panel: egen educationexpenses_HH=sum(educationexpenses)
egen productexpenses_HH=rowtotal(productexpenses9 productexpenses5 productexpenses4 productexpenses3 productexpenses2 productexpenses14 productexpenses12 productexpenses11 productexpenses1)
bysort HHID_panel: egen businessexpenses_HH=sum(businessexpenses)
gen foodexpenses_HH=foodexpenses*52
gen healthexpenses_HH=healthexpenses
gen ceremoniesexpenses_HH=ceremoniesexpenses
gen deathexpenses_HH=deathexpenses


*Land purchased as investment
tab landpurchased
tab landpurchasedacres
tab landpurchasedamount
tab landpurchasedhowbuy

*Equipment
foreach x in tractor bullockcart plowingmach {
gen investequip_`x'=.
}
replace investequip_tractor=equipmentcost_tractor if equipementyear1>="2016"
replace investequip_bullockcart=equipmentcost_bullockcart if equipementyear2>="2016"
replace investequip_plowingmach=equipmentcost_plowingmach if equipementyear4>="2016"

egen investequiptot_HH=rowtotal(investequip_tractor investequip_bullockcart investequip_plowingmach)


*** Dependency ratio :
* Debt
gen debtor=0
replace debtor=1 if loanamount_indiv>0 & loanamount_indiv!=.
gen nondebtor=0
replace nondebtor=1 if debtor==0 & debtor!=.

* Worker
gen nonworker=0
replace nonworker=1 if worker==0 & worker!=.

* HH level
foreach x in debtor nondebtor worker nonworker {
bysort HHID_panel: egen `x'_HH=sum(`x')
}
gen debtorratio=debtor_HH/nondebtor_HH
clonevar debtorratio2=debtorratio
replace debtorratio2=debtor_HH if debtorratio==.

gen workerratio=worker_HH/nonworker_HH
clonevar workerratio2=workerratio
replace workerratio2=worker_HH if workerratio==.

preserve
duplicates drop HHID_panel, force
fre debtorratio debtorratio2
fre workerratio workerratio2
restore

*Only ego
fre egoid
drop if egoid==0
rename amoutlent amountlent


********** cov
fre covsellland covselllivestock_none covsellequipment_none covsellgoods_none covsellhouse covsellplot
destring covsellland covsellhouse covsellplot, replace
recode covsellland covsellhouse covsellplot (66=0) (2=0)
recode covselllivestock_none covsellequipment_none covsellgoods_none (0=1) (1=0)
egen covsell=rowtotal(covsellland covselllivestock_none covsellequipment_none covsellgoods_none covsellhouse covsellplot)
replace covsell=1 if covsell>=1 & covsell!=.
ta covsell


*Macro for rename
global charactindiv maritalstatus edulevel relationshiptohead sex age readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 name
 
global characthh villageid assets assets_noland sizeownland ownland house jatis caste dummymarriage hhsize nbchild nbfemale nbmale interviewplace address religion dummyeverhadland

global wealthindiv annualincome_indiv totalincome_indiv mainocc_kindofwork_indiv mainocc_profession_indiv mainocc_occupation_indiv mainocc_annualincome_indiv nboccupation_indiv loanamount_indiv

global wealthhh annualincome_HH totalincome_HH nboccupation_HH foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses businessexpenses 

global expenses educationexpenses_HH productexpenses_HH businessexpenses_HH foodexpenses_HH healthexpenses_HH ceremoniesexpenses_HH deathexpenses_HH  landpurchased investequiptot_HH 

global all $charactindiv $characthh $wealthindiv $wealthhh $debtindiv $debthh $perso $expenses nbercontactphone networkhelpkinmember

keep $all HHID_panel INDID_panel egoid covsell

order HHID_panel INDID_panel



********** Merge locus
merge 1:1 HHID_panel INDID_panel using "$wave3~_ego_v2_RED.dta"
keep if _merge==3
drop _merge


********** Merge debt
merge 1:1 HHID_panel INDID_panel using "NEEMSIS2_newvar.dta"
drop if _merge==2
drop _merge


***** Recourse
g debt_reco_indiv=.
replace debt_reco_indiv=1 if loanamount_indiv!=.
replace debt_reco_indiv=0 if loanamount_indiv==.
label define reco 0"No" 1"Yes"
label values debt_reco_indiv reco
fre debt_reco_indiv

***** Negotiation
g debt_nego_indiv=borrowerservices_none
recode debt_nego_indiv (0=1) (1=0)
label define nego 0"Good" 1"Not good"
label values debt_nego_indiv nego
fre debt_nego_indiv



********** Std var
foreach x in locus raven_tt lit_tt num_tt f1_2020 {
egen std_`x'=std(`x')
}


********** Social identity
fre caste
gen dalit=.
replace dalit=1 if caste==1
replace dalit=0 if caste==2
replace dalit=0 if caste==3

fre sex
gen female=.
replace female=1 if sex==2
replace female=0 if sex==1


save"$wave3~_RED", replace
****************************************
* END
