*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 23, 2021
*-----
*Formation debt at indiv level
*-----
do "psychodebt"
*-------------------------






****************************************
* Formation var debt 2020
****************************************
use"raw\NEEMSIS2-loans_mainloans_new", clear

keep HHID2020 INDID2020 loanamount2 lenderscaste lendersex dummyproblemtorepay borrservices_none lenderfirsttime loanduration_month loan_database
ta loanduration_month

rename loanamount2 loanamount
replace loanamount=loanamount/1000

* Id ML
gen dummyml=0
replace dummyml=1 if lenderfirsttime!=.
ta dummyml

* Selection
drop if loanduration_month>48

* Merge charact
merge m:1 HHID2020 INDID2020 using "raw\NEEMSIS2-HH", keepusing(name age sex caste egoid)
drop _merge
rename egoid egoid2020

* Merge covid
merge m:1 HHID2020 using "raw\NEEMSIS2-covid", keepusing(dummyexposure secondlockdownexposure dummysell)
drop _merge

* Same caste, same sex
fre lendersex
gen dummyssex=0
replace dummyssex=1 if lendersex==1 & sex==1
replace dummyssex=1 if lendersex==2 & sex==2

* Caste
fre lenderscaste
rename lenderscaste lendersjatis
gen lenderscaste=.
replace lenderscaste=2 if lendersjatis==1
replace lenderscaste=1 if lendersjatis==2
replace lenderscaste=3 if lendersjatis==4
replace lenderscaste=2 if lendersjatis==5
replace lenderscaste=3 if lendersjatis==6
replace lenderscaste=3 if lendersjatis==9
replace lenderscaste=2 if lendersjatis==10
replace lenderscaste=3 if lendersjatis==11
replace lenderscaste=2 if lendersjatis==12
replace lenderscaste=3 if lendersjatis==13
replace lenderscaste=3 if lendersjatis==14
replace lenderscaste=2 if lendersjatis==15
replace lenderscaste=2 if lendersjatis==16
replace lenderscaste=88 if lendersjatis==88

gen dummyscaste=0
replace dummyscaste=1 if caste==1 & lenderscaste==1
replace dummyscaste=1 if caste==2 & lenderscaste==2
replace dummyscaste=1 if caste==3 & lenderscaste==3


* Indiv scale
gen indebt=1 if loanamount!=0 & loanamount!=.

foreach x in indebt dummyproblemtorepay borrservices_none dummyscaste dummyssex dummyml {
bysort HHID2020 INDID2020: egen s_`x'=sum(`x')
}

* Recode var
gen nb_loans=s_indebt
foreach x in s_indebt s_borrservices_none s_dummyproblemtorepay s_dummyml {
replace `x'=1 if `x'>1
}
foreach x in s_borrservices_none s_dummyproblemtorepay {
replace `x'=. if s_dummyml==0
}

* Share sex/caste
gen sharesex=s_dummyssex/nb_loans
gen sharecaste=s_dummyscaste/nb_loans
ta sharesex
ta sharecaste

* Amount
bysort HHID2020 INDID2020: egen s_loanamount=sum(loanamount)

* Indiv level
drop loanamount dummyproblemtorepay lendersjatis lendersex borrservices_none dummyssex lenderscaste dummyscaste indebt loanduration_month loan_database lenderfirsttime dummyml
duplicates drop


* Merge ID
merge m:m HHID2020 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw\keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Clean
drop name sex age caste HHID2020 INDID2020
foreach x in s_indebt s_dummyproblemtorepay s_borrservices_none s_dummyscaste s_dummyssex nb_loans s_dummyml {
rename `x' `x'2020
}

*** Gen FE
* Indiv
egen HHINDID=concat(HHID_panel INDID_panel)
order HHID_panel INDID_panel HHINDID
encode HHINDID, gen(INDID)
drop HHINDID
order HHID_panel INDID_panel INDID
preserve
duplicates drop INDID, force
count
restore

* HH
encode HHID_panel, gen(HHID)
preserve
duplicates drop HHID, force
count
restore


*** Gestion intra-ménage de la dette
/*
diviser le montant de la dette de l’individu par celle du ménage pour avoir cette part
*/
*gen gimd=


*** Label
label var sharesex "\% debt same sex"
label var sharecaste "\% debt same caste"
label var s_loanamount "Total amount of debt (\rupee)"

save"$wave3~debt", replace
****************************************
* END









****************************************
* Formation var debt 2016
****************************************
use"raw\NEEMSIS1-loans_mainloans_new", clear

keep HHID2016 INDID2016 loanamount2 lenderscaste lendersex dummyproblemtorepay borrservices_none lendername loanduration_month loan_database
ta loanduration_month

rename loanamount2 loanamount
replace loanamount=loanamount/1000

* Id ML
gen dummyml=0
replace dummyml=1 if lendername!=""
ta dummyml

* Selection
*drop if loanduration_month>48

* Merge charact
merge m:1 HHID2016 INDID2016 using "raw\NEEMSIS1-HH", keepusing(name age sex egoid)
keep if _merge==3
drop _merge
rename egoid egoid2016

merge m:1 HHID2016 INDID2016 using "raw\NEEMSIS1-caste", keepusing(caste)
keep if _merge==3
drop _merge


* Same caste, same sex
fre lendersex
gen dummyssex=0
replace dummyssex=1 if lendersex==1 & sex==1
replace dummyssex=1 if lendersex==2 & sex==2

* Caste
fre lenderscaste
rename lenderscaste lendersjatis
gen lenderscaste=.
replace lenderscaste=2 if lendersjatis==1
replace lenderscaste=1 if lendersjatis==2
replace lenderscaste=3 if lendersjatis==4
replace lenderscaste=2 if lendersjatis==5
replace lenderscaste=3 if lendersjatis==6
replace lenderscaste=3 if lendersjatis==9
replace lenderscaste=2 if lendersjatis==10
replace lenderscaste=3 if lendersjatis==11
replace lenderscaste=2 if lendersjatis==12
replace lenderscaste=3 if lendersjatis==13
replace lenderscaste=3 if lendersjatis==14
replace lenderscaste=2 if lendersjatis==15
replace lenderscaste=2 if lendersjatis==16
replace lenderscaste=88 if lendersjatis==88

gen dummyscaste=0
replace dummyscaste=1 if caste==1 & lenderscaste==1
replace dummyscaste=1 if caste==2 & lenderscaste==2
replace dummyscaste=1 if caste==3 & lenderscaste==3


* Indiv scale
gen indebt=1 if loanamount!=0 & loanamount!=.

foreach x in indebt dummyproblemtorepay borrservices_none dummyscaste dummyssex dummyml {
bysort HHID2016 INDID2016: egen s_`x'=sum(`x')
}

* Recode var
gen nb_loans=s_indebt
foreach x in s_indebt s_borrservices_none s_dummyproblemtorepay s_dummyml {
replace `x'=1 if `x'>1
}
foreach x in s_borrservices_none s_dummyproblemtorepay {
replace `x'=. if s_dummyml==0
}

* Share sex/caste
gen sharesex=s_dummyssex/nb_loans
gen sharecaste=s_dummyscaste/nb_loans
ta sharesex
ta sharecaste

* Amount
bysort HHID2016 INDID2016: egen s_loanamount=sum(loanamount)

* Indiv level
drop loanamount dummyproblemtorepay lendersjatis lendersex borrservices_none dummyssex lenderscaste dummyscaste indebt loanduration_month loan_database dummyml lendername
duplicates drop


* Merge ID
merge m:m HHID2016 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw\keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Clean
drop name sex age caste HHID2016 INDID2016
foreach x in s_indebt s_dummyproblemtorepay s_borrservices_none s_dummyscaste s_dummyssex nb_loans s_dummyml {
rename `x' `x'2016
}

*** Gen FE
* Indiv
egen HHINDID=concat(HHID_panel INDID_panel)
order HHID_panel INDID_panel HHINDID
encode HHINDID, gen(INDID)
drop HHINDID
order HHID_panel INDID_panel INDID
preserve
duplicates drop INDID, force
count
restore

* HH
encode HHID_panel, gen(HHID)
preserve
duplicates drop HHID, force
count
restore


*** Label
label var sharesex "\% debt same sex"
label var sharecaste "\% debt same caste"
label var s_loanamount "Total amount of debt (\rupee)"

save"$wave2~debt", replace
****************************************
* END
