*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 22, 2023
*-----
*Loans
*-----
do"marriageagri"
*-------------------------









****************************************
* Loan level
****************************************

***** 2016-17
use"raw/NEEMSIS1-loans_mainloans_new", clear

keep HHID2016 INDID2016 loanid loanreasongiven loanamount2 loanbalance2 loan_database
gen year=2016
*
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

save"_temploan2016", replace

bysort HHID2016: egen balance_total_HH=sum(loanbalance2)
fre loanreasongiven
gen balance_marr=0
replace balance_marr=loanbalance2 if loanreasongiven==8
bysort HHID2016: egen balance_marr_HH=sum(balance_marr)

keep HHID2016 balance_marr_HH balance_total_HH
duplicates drop
save"_temp2016", replace



***** 2020-21
use"raw/NEEMSIS2-loans_mainloans_new", clear

keep HHID2020 INDID2020 loanid loanreasongiven loanamount2 loanbalance2 loan_database
gen year=2020
*
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

save"_temploan2020", replace

bysort HHID2020: egen balance_total_HH=sum(loanbalance2)
fre loanreasongiven
gen balance_marr=0
replace balance_marr=loanbalance2 if loanreasongiven==8
bysort HHID2020: egen balance_marr_HH=sum(balance_marr)

keep HHID2020 balance_marr_HH balance_total_HH
duplicates drop
save"_temp2020", replace



***** Pooled
use"_temploan2016", clear
append using "_temploan2020"

replace loanamount2=loanamount2*(100/116) if year==2020



***** Dummy marriage
preserve
use"NEEMSIS-marriage.dta", clear
keep HHID_panel INDID_panel year sex
ta year sex
gen marriage_male=1 if sex==1
gen marriage_fema=1 if sex==2
bysort HHID_panel year: egen marriage_male_HH=sum(marriage_male)
bysort HHID_panel year: egen marriage_fema_HH=sum(marriage_fema)
drop INDID_panel sex marriage_male marriage_fema
duplicates drop
ta year
rename marriage_male_HH marriage_male
rename marriage_fema_HH marriage_fema
save"_temp", replace
restore

merge m:1 HHID_panel year using "_temp"
drop if _merge==2
drop _merge

gen dummymarr_male=0
replace dummymarr_male=1 if marriage_male>0 & marriage_male!=.

gen dummymarr_fema=0
replace dummymarr_fema=1 if marriage_fema>0 & marriage_fema!=.

gen dummymarr_both=0
replace dummymarr_both=1 if dummymarr_fema==1 & dummymarr_male==1

gen dummymarr_cat=.
replace dummymarr_cat=1 if dummymarr_male==1 & dummymarr_both==0
replace dummymarr_cat=2 if dummymarr_fema==1 & dummymarr_both==0
replace dummymarr_cat=3 if dummymarr_both==1

label define dummymarr_cat 1"Male only" 2"Female only" 3"Both"
label values dummymarr_cat dummymarr_cat

ta dummymarr_cat

save"pooledloans", replace
****************************************
* END











****************************************
* HH level
****************************************

***** 2016-17
use"raw/NEEMSIS1-HH", clear

keep HHID2016 dummymarriage
duplicates drop
merge 1:1 HHID2016 using "_temp2016"
drop _merge
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(annualincome_HH)
drop _merge
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH", keepusing(nbHH_given_marr dumHH_given_marr nbHH_effective_marr dumHH_effective_marr totHH_givenamt_marr totHH_effectiveamt_marr nbloans_HH loanamount_HH)
drop _merge
merge 1:m HHID2016 using "raw/NEEMSIS1-caste", keepusing(caste)
drop _merge
duplicates drop
merge 1:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
gen year=2016
drop _merge HHID2016
order HHID_panel year caste dummymarriage

save"_tempdebtmar2016", replace


***** HH level
use"raw/NEEMSIS2-HH", clear

keep HHID2020 dummymarriage
duplicates drop
merge 1:1 HHID2020 using "_temp2020"
drop _merge
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(annualincome_HH)
drop _merge
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(nbHH_given_marr dumHH_given_marr nbHH_effective_marr dumHH_effective_marr totHH_givenamt_marr totHH_effectiveamt_marr nbloans_HH loanamount_HH)
drop _merge
merge 1:m HHID2020 using "raw/NEEMSIS2-caste", keepusing(caste)
drop _merge
duplicates drop
merge 1:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
gen year=2020
drop _merge HHID2020
order HHID_panel year caste dummymarriage

save"_tempdebtmar2020", replace


***** Pooled
use"_tempdebtmar2016", clear

append using "_tempdebtmar2020"
sort HHID_panel year

gen sharedebtgivenmarr=totHH_givenamt_marr*100/loanamount_HH
gen sharedebteffecmarr=totHH_effectiveamt_marr*100/loanamount_HH
gen shareincogivenmarr=totHH_givenamt_marr*100/annualincome_HH
gen shareincoeffecmarr=totHH_effectiveamt_marr*100/annualincome_HH

gen sharebaldebtmarr=balance_marr_HH*100/balance_total_HH
gen sharebalincomarr=balance_marr_HH*100/annualincome_HH

foreach x in annualincome_HH loanamount_HH totHH_givenamt_marr totHH_effectiveamt_marr {
replace `x'=`x'*(100/116) if year==2020
}

save"pooleddebtmar", replace
****************************************
* END













****************************************
* Stat
****************************************

********** Loan
use"pooledloans", clear

ta loanreasongiven
ta loanreasongiven dummymarr_cat, col nofreq
*
drop if dummymarr_cat==.
drop if dummymarr_cat==3
keep if marriage_male==1 | marriage_fema==1
*
ta loan_database dummymarr_cat, col nofreq

*
ta loanreasongiven dummymarr_cat, col nofreq

tabstat loanamount2, stat(n mean q) by(loanreasongiven)
tabstat loanamount2 , stat(n mean q) by(loanreasongiven)

/*
In pooled setting:
- 13% of loans are for marriage.
- Average amount of INR 80k.
*/




********** HH
use"pooleddebtmar", clear


tabstat sharedebtgivenmarr sharedebteffecmarr shareincogivenmarr shareincoeffecmarr sharebaldebtmarr sharebalincomarr totHH_givenamt_marr totHH_effectiveamt_marr annualincome_HH balance_total_HH loanamount_HH, stat(n mean q) by(dummymarriage) long

tabstat sharebalincomarr if dummymarriage==1, stat(n mean q p90 p95 p99 max) long

tabstat sharebalincomarr if dummymarriage==1 & sharebalincomarr<1000, stat(n mean q p90 p95 p99 max) long



reg loanamount_HH i.dummymarriage

/*
In pooled setting:
- Marriage debt represents 32% of household total debt for household who experienced a marriage of one of their member, while it represents less than 5% for other households.
- Marriage debt represents 147% of household total income for household who experienced a marriage of one of their member.
*/
****************************************
* END
