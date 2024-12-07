*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 19, 2021
*-----
*Cleaning overindebtedness
*-----
cd""
*-------------------------






****************************************
* Check panel
****************************************

* RUME
use "RUME-HH.dta", clear
bysort HHID_panel: gen n=_n
keep if n==1
rename year year2010
rename caste caste2010
rename jatis jatis2010
keep HHID_panel year2010 caste2010 jatis2010
save"_paneldata\RUME-HH.dta", replace

* NEEMSIS-1
use "NEEMSIS1-HH.dta", clear
bysort HHID_panel: gen n=_n
keep if n==1
gen year2016=2016
rename caste caste2016
rename jatis jatis2016
keep HHID_panel year2016 caste2016 jatis2016
save"_paneldata\NEEMSIS1-HH.dta", replace

* NEEMSIS-2
use "NEEMSIS2-HH.dta", clear
bysort HHID_panel: gen n=_n
keep if n==1
tab version_HH
gen year2020=2020
rename caste caste2020
rename jatis jatis2020
keep HHID_panel year2020 caste2020 jatis2020
save"_paneldata\NEEMSIS2-HH.dta", replace

* Vérification
use"_paneldata\RUME-HH.dta", clear

merge 1:1 HHID_panel using "_paneldata\NEEMSIS1-HH.dta"
rename _merge RUME_NEEMSIS1

merge 1:1 HHID_panel using "_paneldata\NEEMSIS2-HH.dta"
rename _merge RUME_NEEMSIS2

* Variable panel
gen panel_2010_2016=0
replace panel_2010_2016=1 if year2010!=. & year2016!=.
tab panel_2010_2016

gen panel_2010_2020=0
replace panel_2010_2020=1 if year2010!=. & year2020!=.
tab panel_2010_2020

gen panel_2016_2020=0
replace panel_2016_2020=1 if year2016!=. & year2020!=.
tab panel_2016_2020

gen panel_2010_2016_2020=0
replace panel_2010_2016_2020=1 if year2010!=. & year2016!=. & year2020!=.
tab panel_2010_2016_2020

drop RUME_NEEMSIS1 RUME_NEEMSIS2
drop year2010 year2016 year2020

save"_paneldata\panel_comp.dta", replace
****************************************
* END


















****************************************
* ALL LOANS in same db
****************************************

********** Cleaning loans before append
*2010
use"RUME-loans_mainloans.dta", clear
merge m:m HHID2010 using "keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename loaneffectivereason loaneffectivereason2010
rename guarantorloanrelation guarantorloanrelation2010
rename lenderrelation lenderrelation2010
tab loansettled
save"RUME-loans_new.dta", replace

*2016
use"NEEMSIS1-loans_mainloans.dta", clear
merge m:m HHID2016 using "keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename loaneffectivereason loaneffectivereason2016
rename guarantorloanrelation guarantorloanrelation2016
rename lenderrelation lenderrelation2016
tab loansettled 
save"NEEMSIS1-loans_new.dta", replace

*2020
use"NEEMSIS2-loans_mainloans.dta", clear
merge m:m HHID2020 using "keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename loaneffectivereason loaneffectivereason2020
rename guarantorloanrelation guarantorloanrelation2020
rename lenderrelation lenderrelation2020
tab loansettled 
save"NEEMSIS2-loans_new.dta", replace


********** Append
use"RUME-loans_new.dta", clear
append using "NEEMSIS1-loans_new.dta"
append using "NEEMSIS2-loans_new.dta"

tab HHID_panel, m
keep if loanamount!=.
tab loanreasongiven year, m
tab year


save"panel-all_loans.dta", replace
****************************************
* END





















****************************************
* CLEANING
****************************************
use"panel-all_loans.dta", clear

drop caste jatis

*Merge les HH en panel
merge m:1 HHID_panel using"panel_comp.dta"
drop _merge

gen jatis=.
replace jatis=jatis2010 if jatis2010!=.
replace jatis=jatis2016 if jatis2016!=.
replace jatis=jatis2020 if jatis2020!=.

gen caste=.
replace caste=caste2010 if caste2010!=.
replace caste=caste2016 if caste2016!=.
replace caste=caste2020 if caste2020!=.


drop jatis2010 jatis2016 jatis2020
drop caste2010 caste2016 caste2020 


save"panel-all_loans_v2.dta", replace
****************************************
* END



















****************************************
* Preli
****************************************
use"_paneldata\RUME-NEEMSIS-HH.dta", clear
foreach x in 2010 2016 2020 {
gen DAR_`x'=loanamount_HH_`x'*100/assets_`x'
gen DSR_`x'=imp1_ds_tot_HH_`x'*100/annualincome_HH_`x'
gen ISR_`x'=imp1_is_tot_HH_`x'*100/annualincome_HH_`x'
}

gen DAR_as2010_2016=loanamount_HH_2016*100/assets_as2010_2016

fsum DAR_2010 DAR_2016 DAR_2020, stat(p1 p5 p10 p25 p50 p75 p90 p95 p99)
fsum DSR_2010 DSR_2016 DSR_2020, stat(p1 p5 p10 p25 p50 p75 p90 p95 p99)
fsum ISR_2010 ISR_2016 ISR_2020, stat(p1 p5 p10 p25 p50 p75 p90 p95 p99)


********** Cleaning
* 2010
rename landowndry_2010 sizedryownland_2010
rename landownwet_2010 sizewetownland_2010
gen sizeownland_2010=sizedryownland_2010+sizewetownland_2010
*1000 var
foreach x in assets assets_noland loanamount_HH annualincome_HH amountownland housevalue imp1_ds_tot_HH imp1_is_tot_HH {
foreach i in 2010 2016 2020 {
gen `x'1000_`i'=`x'_`i'/1000
}
}

gen amountownlandwet1000_as2010_2016=amountownlandwet_as2010_2016/1000
gen amountownland1000_as2010_2016=amountownland_as2010_2016/1000
gen assets1000_as2010_2016=assets_as2010_2016/1000


*dummyownland
tab sizeownland_2010
gen dummyownland_2010=0 if assets_2010!=.
replace dummyownland_2010=1 if sizeownland_2010>0 & sizeownland_2010!=. & assets_2010!=.
tab dummyownland_2010
recode sizeownland_2010 (0=.)
tab sizeownland_2010

tab sizeownland_2016
gen dummyownland_2016=0 if assets_2016!=.
replace dummyownland_2016=1 if sizeownland_2016>0 & sizeownland_2016!=. & assets_2016!=.
tab dummyownland_2016
recode sizeownland_2016 (0=.)
tab sizeownland_2016

tab sizeownland_2020
gen dummyownland_2020=0 if assets_2020!=.
replace dummyownland_2020=1 if sizeownland_2020>0 & sizeownland_2020!=. & assets_2020!=.
tab dummyownland_2020
recode sizeownland_2020 (0=.)
tab sizeownland_2020

drop ownland_2016 ownland_2020

*panel
gen panel_comp=panel_2010_2016_2020_2010
replace panel_comp=panel_2010_2016_2020_2016 if panel_comp==.
replace panel_comp=panel_2010_2016_2020_2020 if panel_comp==.
tab panel_comp

gen panel_1620=panel_2016_2020_2016
replace panel_1620=panel_2016_2020_2020 if panel_1620==.

gen panel_1016=panel_2010_2016_2010
replace panel_1016=panel_2010_2016_2016 if panel_1016

gen panel_1020=panel_2010_2020_2010
replace panel_1020=panel_2010_2020_2020 if panel_1020

recode panel_comp panel_1620 panel_1016 panel_1020 (.=0)

drop panel_2010_2016_2010 panel_2010_2020_2010 panel_2016_2020_2010 panel_2010_2016_2020_2010 panel_2010_2016_2016 panel_2010_2020_2016 panel_2016_2020_2016 panel_2010_2016_2020_2016 panel_2010_2016_2020 panel_2010_2020_2020 panel_2016_2020_2020 panel_2010_2016_2020_2020

tab1 panel_comp panel_1620 panel_1016 panel_1020

*house
replace housevalue_2010=. if house_2010>=3
replace housevalue1000_2010=. if house_2010>=3
tabstat housevalue_2010, stat(n mean sd p50) by(caste)

*HH in debt
foreach x in 2010 2016 2020 {
gen debt_HH_`x'=0 if assets_`x'!=.
}
foreach x in 2010 2016 2020 {
replace debt_HH_`x'=1 if loanamount_HH_`x'!=. & loanamount_HH_`x'>0 & loanamount_HH_`x'!=0
}


*Deflateur
foreach x in housevalue_2010 annualincome_HH_2010 goldquantityamount_2010 amountownlanddry_2010 amountownlandwet_2010 amountownland_2010 assets_2010 assets_noland_2010 imp1_ds_tot_HH_2010 imp1_is_tot_HH_2010 economic_amount_HH_2010 current_amount_HH_2010 humancap_amount_HH_2010 social_amount_HH_2010 house_amount_HH_2010 incomegen_amount_HH_2010 noincomegen_amount_HH_2010 informal_amount_HH_2010 formal_amount_HH_2010 semiformal_amount_HH_2010 marriageloanamount_HH_2010 loanamount_HH_2010 loanbalance_HH_2010 assets1000_2010 assets_noland1000_2010 loanamount_HH1000_2010 annualincome_HH1000_2010 amountownland1000_2010 housevalue1000_2010 imp1_ds_tot_HH1000_2010 imp1_is_tot_HH1000_2010 li_indiv_agri_2010 li_indiv_coolie_2010 li_indiv_agricoolie_2010 li_indiv_nregs_2010 li_indiv_investment_2010 li_indiv_employee_2010 li_indiv_selfemp_2010 li_indiv_pension_2010 li_indiv_nooccup_2010 li_HH_agri_2010 li_HH_coolie_2010 li_HH_agricoolie_2010 li_HH_nregs_2010 li_HH_investment_2010 li_HH_employee_2010 li_HH_selfemp_2010 li_HH_pension_2010 li_HH_nooccup_2010 {
gen def_`x'=`x'*1
}

foreach x in housevalue_2016 annualincome_HH_2016 goldquantityamount_2016 amountownlanddry_2016 amountownlandwet_2016 amountownland_2016 assets_2016 assets_noland_2016 imp1_ds_tot_HH_2016 imp1_is_tot_HH_2016 economic_amount_HH_2016 current_amount_HH_2016 humancap_amount_HH_2016 social_amount_HH_2016 house_amount_HH_2016 incomegen_amount_HH_2016 noincomegen_amount_HH_2016 informal_amount_HH_2016 formal_amount_HH_2016 semiformal_amount_HH_2016 marriageloanamount_HH_2016 loanamount_HH_2016 loanbalance_HH_2016 loanamount_wm_HH_2016 assets1000_2016 assets_noland1000_2016 loanamount_HH1000_2016 annualincome_HH1000_2016 amountownland1000_2016 housevalue1000_2016 imp1_ds_tot_HH1000_2016 imp1_is_tot_HH1000_2016 li_indiv_agri_2016 li_indiv_selfemp_2016 li_indiv_sjagri_2016 li_indiv_sjnonagri_2016 li_indiv_uwhhnonagri_2016 li_indiv_uwnonagri_2016 li_indiv_uwhhagri_2016 li_indiv_uwagri_2016 li_HH_agri_2016 li_HH_selfemp_2016 li_HH_sjagri_2016 li_HH_sjnonagri_2016 li_HH_uwhhnonagri_2016 li_HH_uwnonagri_2016 li_HH_uwhhagri_2016 li_HH_uwagri_2016 amountownlandwet_a_2016 amountownland_a_2016 assets_a_2016 amountownlandwet1000_a_2016 amountownland1000_a_2016 assets1000_a_2016 {
gen def_`x'=`x'*(100/155)
}
foreach x in housevalue_2020 annualincome_HH_2020 goldquantityamount_2020 amountownlanddry_2020 amountownlandwet_2020 amountownland_2020 assets_2020 assets_noland_2020 imp1_ds_tot_HH_2020 imp1_is_tot_HH_2020 economic_amount_HH_2020 current_amount_HH_2020 humancap_amount_HH_2020 social_amount_HH_2020 house_amount_HH_2020 incomegen_amount_HH_2020 noincomegen_amount_HH_2020 informal_amount_HH_2020 formal_amount_HH_2020 semiformal_amount_HH_2020 marriageloanamount_HH_2020 loanamount_HH_2020 loanbalance_HH_2020 assets1000_2020 assets_noland1000_2020 loanamount_HH1000_2020 annualincome_HH1000_2020 amountownland1000_2020 housevalue1000_2020 imp1_ds_tot_HH1000_2020 imp1_is_tot_HH1000_2020 li_indiv_agri_2020 li_indiv_selfemp_2020 li_indiv_sjagri_2020 li_indiv_sjnonagri_2020 li_indiv_uwhhnonagri_2020 li_indiv_uwnonagri_2020 li_indiv_uwhhagri_2020 li_indiv_uwagri_2020 li_HH_agri_2020 li_HH_selfemp_2020 li_HH_sjagri_2020 li_HH_sjnonagri_2020 li_HH_uwhhnonagri_2020 li_HH_uwnonagri_2020 li_HH_uwhhagri_2020 li_HH_uwagri_2020{
gen def_`x'=`x'*(100/180)
}



********** Income agri vs income non agri?
egen def_incomeagri_HH_2010=rowtotal(def_li_HH_agri_2010 def_li_HH_agricoolie_2010)
egen def_incomenonagri_HH_2010=rowtotal(def_li_HH_coolie_2010 def_li_HH_nregs_2010 def_li_HH_investment_2010 def_li_HH_employee_2010 def_li_HH_selfemp_2010 def_li_HH_pension_2010 def_li_HH_nooccup_2010)

egen def_incomeonlyagri_HH_2010=rowtotal(def_li_HH_agri_2010)
egen def_incomenononlyagri_HH_2010=rowtotal(def_li_HH_coolie_2010 def_li_HH_agricoolie_2010 def_li_HH_nregs_2010 def_li_HH_investment_2010 def_li_HH_employee_2010 def_li_HH_selfemp_2010 def_li_HH_pension_2010 def_li_HH_nooccup_2010)


egen def_incomeagri_HH_2016=rowtotal(def_li_HH_agri_2016 def_li_HH_sjagri_2016 def_li_HH_uwhhagri_2016 def_li_HH_uwagri_2016)
egen def_incomenonagri_HH_2016=rowtotal(def_li_HH_selfemp_2016 def_li_HH_sjnonagri_2016 def_li_HH_uwhhnonagri_2016 def_li_HH_uwnonagri_2016)

egen def_incomeonlyagri_HH_2016=rowtotal(def_li_HH_agri_2016)
egen def_incomenononlyagri_HH_2016=rowtotal(def_li_HH_sjagri_2016 def_li_HH_uwhhagri_2016 def_li_HH_uwagri_2016 def_li_HH_selfemp_2016 def_li_HH_sjnonagri_2016 def_li_HH_uwhhnonagri_2016 def_li_HH_uwnonagri_2016)


egen def_incomeagri_HH_2020=rowtotal(def_li_HH_agri_2020 def_li_HH_sjagri_2020 def_li_HH_uwhhagri_2020 def_li_HH_uwagri_2020)
egen def_incomenonagri_HH_2020=rowtotal(def_li_HH_selfemp_2020 def_li_HH_sjnonagri_2020 def_li_HH_uwhhnonagri_2020 def_li_HH_uwnonagri_2020)

egen def_incomeonlyagri_HH_2020=rowtotal(def_li_HH_agri_2020)
egen def_incomenononlyagri_HH_2020=rowtotal(def_li_HH_sjagri_2020 def_li_HH_uwhhagri_2020 def_li_HH_uwagri_2020 def_li_HH_selfemp_2020 def_li_HH_sjnonagri_2020 def_li_HH_uwhhnonagri_2020 def_li_HH_uwnonagri_2020)

gen test1_10=(def_incomeagri_HH_2010+def_incomenonagri_HH_2010)-def_annualincome_HH_2010
gen test2_10=(def_incomeonlyagri_HH_2010+def_incomenononlyagri_HH_2010)-def_annualincome_HH_2010

gen test1_16=(def_incomeagri_HH_2016+def_incomenonagri_HH_2016)-def_annualincome_HH_2016
gen test2_16=(def_incomeonlyagri_HH_2016+def_incomenononlyagri_HH_2016)-def_annualincome_HH_2016

gen test1_20=(def_incomeagri_HH_2020+def_incomenonagri_HH_2020)-def_annualincome_HH_2020
gen test2_20=(def_incomeonlyagri_HH_2020+def_incomenononlyagri_HH_2020)-def_annualincome_HH_2020

tab1 test1_10 test2_10 test1_16 test2_16 test1_20 test2_20  // ok
drop test1_10 test2_10 test1_16 test2_16 test1_20 test2_20

*Delta
foreach x in DAR DSR ISR  loans_HH nboccupation_HH sizeownland  {
gen d1_`x'=(`x'_2016-`x'_2010)*100/`x'_2010
gen d2_`x'=(`x'_2020-`x'_2016)*100/`x'_2016
gen dg_`x'=(`x'_2020-`x'_2010)*100/`x'_2010
}

foreach x in def_loanamount_HH def_imp1_ds_tot_HH def_imp1_is_tot_HH def_annualincome_HH def_assets def_assets_noland def_amountownland def_amountownlanddry def_amountownlandwet {
gen d1_`x'=(`x'_2016-`x'_2010)*100/`x'_2010
gen d2_`x'=(`x'_2020-`x'_2016)*100/`x'_2016
gen dg_`x'=(`x'_2020-`x'_2010)*100/`x'_2010
}

foreach x in def_incomeagri_HH def_incomenonagri_HH def_incomeonlyagri_HH def_incomenononlyagri_HH {
gen d1_`x'=(`x'_2016-`x'_2010)*100/`x'_2010
gen d2_`x'=(`x'_2020-`x'_2016)*100/`x'_2016
gen dg_`x'=(`x'_2020-`x'_2010)*100/`x'_2010
}

foreach x in sizedryownland sizewetownland {
gen dg_`x'=(`x'_2020-`x'_2010)*100/`x'_2010
}




*Recoder augmentation
label define cat 1"Decrease" 2"Stable" 3"Increase"
foreach x in d1_def_loanamount_HH d1_def_imp1_ds_tot_HH d1_def_imp1_is_tot_HH d1_def_annualincome_HH d1_def_assets d1_def_assets_noland d1_def_amountownland d2_def_loanamount_HH d2_def_imp1_ds_tot_HH d2_def_imp1_is_tot_HH d2_def_annualincome_HH d2_def_assets d2_def_assets_noland d2_def_amountownland dg_def_loanamount_HH dg_def_imp1_ds_tot_HH dg_def_imp1_is_tot_HH dg_def_annualincome_HH dg_def_assets dg_def_assets_noland dg_def_amountownland d1_DAR d1_DSR d2_DAR d2_DSR dg_DAR dg_DSR{
gen cat_`x'=.
}

foreach x in d1_def_incomeagri_HH d2_def_incomeagri_HH dg_def_incomeagri_HH d1_def_incomenonagri_HH d2_def_incomenonagri_HH dg_def_incomenonagri_HH d1_def_incomeonlyagri_HH d2_def_incomeonlyagri_HH dg_def_incomeonlyagri_HH d1_def_incomenononlyagri_HH d2_def_incomenononlyagri_HH dg_def_incomenononlyagri_HH{
gen cat_`x'=.
}


foreach x in d1_def_loanamount_HH d1_def_imp1_ds_tot_HH d1_def_imp1_is_tot_HH d1_def_annualincome_HH d1_def_assets d1_def_assets_noland d1_def_amountownland d2_def_loanamount_HH d2_def_imp1_ds_tot_HH d2_def_imp1_is_tot_HH d2_def_annualincome_HH d2_def_assets d2_def_assets_noland d2_def_amountownland dg_def_loanamount_HH dg_def_imp1_ds_tot_HH dg_def_imp1_is_tot_HH dg_def_annualincome_HH dg_def_assets dg_def_assets_noland dg_def_amountownland d1_DAR d1_DSR d2_DAR d2_DSR dg_DAR dg_DSR{
replace cat_`x'=1 if `x'<=-5 & `x'!=.
replace cat_`x'=2 if `x'>-5 & `x'<5 & `x'!=. 
replace cat_`x'=3 if `x'>=5 & `x'!=.
label values cat_`x' cat
}

foreach x in d1_def_incomeagri_HH d2_def_incomeagri_HH dg_def_incomeagri_HH d1_def_incomenonagri_HH d2_def_incomenonagri_HH dg_def_incomenonagri_HH d1_def_incomeonlyagri_HH d2_def_incomeonlyagri_HH dg_def_incomeonlyagri_HH d1_def_incomenononlyagri_HH d2_def_incomenononlyagri_HH dg_def_incomenononlyagri_HH{
replace cat_`x'=1 if `x'<=-5 & `x'!=.
replace cat_`x'=2 if `x'>-5 & `x'<5 & `x'!=. 
replace cat_`x'=3 if `x'>=5 & `x'!=.
label values cat_`x' cat
}


foreach x in 2010 2016 2020 {
gen share_agri_`x'=def_incomeagri_HH_`x'*100/def_annualincome_HH_`x'
gen share_nonagri_`x'=def_incomenonagri_HH_`x'*100/def_annualincome_HH_`x'
gen share_onlyagri_`x'=def_incomeonlyagri_HH_`x'*100/def_annualincome_HH_`x'
gen share_nononlyagri_`x'=def_incomenononlyagri_HH_`x'*100/def_annualincome_HH_`x'
}


********** Increasing in share?

foreach x in share_agri share_nonagri share_onlyagri share_nononlyagri {
gen d1_`x'=(`x'_2016-`x'_2010)*100/`x'_2010
gen d2_`x'=(`x'_2020-`x'_2016)*100/`x'_2016
gen dg_`x'=(`x'_2020-`x'_2010)*100/`x'_2010
}


foreach x in d1_share_agri d2_share_agri dg_share_agri d1_share_nonagri d2_share_nonagri dg_share_nonagri d1_share_onlyagri d2_share_onlyagri dg_share_onlyagri d1_share_nononlyagri d2_share_nononlyagri dg_share_nononlyagri {
gen cat_`x'=.
}


foreach x in d1_share_agri d2_share_agri dg_share_agri d1_share_nonagri d2_share_nonagri dg_share_nonagri d1_share_onlyagri d2_share_onlyagri dg_share_onlyagri d1_share_nononlyagri d2_share_nononlyagri dg_share_nononlyagri {
replace cat_`x'=1 if `x'<=-5 & `x'!=.
replace cat_`x'=2 if `x'>-5 & `x'<5 & `x'!=. 
replace cat_`x'=3 if `x'>=5 & `x'!=.
label values cat_`x' cat
}


save"$directory\_paneldata\RUME-NEEMSIS-HH_v2.dta", replace
****************************************
* END
