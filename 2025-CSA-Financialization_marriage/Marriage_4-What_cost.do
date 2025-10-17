*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 22, 2023
*-----
*Cost
*-----
*do"marriageagri"
*-------------------------





cd"C:\Users\Arnaud\Documents\MEGA\Research\2025-CSA_Marriage\Analysis"






****************************************
* Sex ratio and nb of childrens
****************************************
*** 2010
use"raw/RUME-HH", clear
fre sex
gen male=1 if sex==1
gen female=1 if sex==2
gen below18=1 if age<18
gen below15=1 if age<15
gen individual=1
collapse (sum) male female below18 below15 individual, by(villagename)
gen year=2010
rename villagename village
fre village
order year
preserve
collapse (sum) male female below18 below15 individual
gen village=11
gen year=2010
save"_temp", replace
restore
append using "_temp"
label define village 11"TOTAL", modify
save"_temp1", replace

*** 2016
use"raw/NEEMSIS1-HH", clear
drop if livinghome==3
drop if livinghome==4
/*
keep if ///
villageid_new=="ELA" | ///
villageid_new=="GOV" | ///
villageid_new=="KAR" | ///
villageid_new=="KOR" | ///
villageid_new=="KUV" | ///
villageid_new=="MAN" | ///
villageid_new=="MANAM" | ///
villageid_new=="NAT" | ///
villageid_new=="ORA" | ///
villageid_new=="SEM"
*/
fre sex
gen male=1 if sex==1
gen female=1 if sex==2
gen below18=1 if age<18
gen below15=1 if age<15
gen individual=1
collapse (sum) male female below18 below15 individual, by(villageid)
gen year=2016
rename villageid village
fre village
order year
preserve
collapse (sum) male female below18 below15 individual
gen village=11
gen year=2016
save"_temp", replace
restore
append using "_temp"
label define villageid 11"TOTAL", modify
save"_temp2", replace

*** 2020
use"raw/NEEMSIS2-HH", clear
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1
/*
keep if ///
village_new=="Elanthalmpattu" | ///
village_new=="Govulapuram" | ///
village_new=="Karumbur" | ///
village_new=="Korattore" | ///
village_new=="Kuvagam" | ///
village_new=="Manapakkam" | ///
village_new=="Manamthavizhinthaputhur" | ///
village_new=="Natham" | ///
village_new=="Oraiyure" | ///
village_new=="Semakottai"
*/
fre sex
gen male=1 if sex==1
gen female=1 if sex==2
gen below18=1 if age<18
gen below15=1 if age<15
gen individual=1
collapse (sum) male female below18 below15 individual, by(villageid)
gen year=2020
rename villageid village
fre village
order year
preserve
collapse (sum) male female below18 below15 individual
gen village=11
gen year=2020
save"_temp", replace
restore
append using "_temp"
label define villageid 11"TOTAL", modify

*
append using "_temp1"
append using "_temp2"
sort year village

gen sexratio=male/female
gen sharebelow18=below18*100/individual
gen sharebelow15=below15*100/individual

*
reshape wide male female below18 below15 individual sexratio sharebelow18 sharebelow15, i(village) j(year)
keep village sexratio* sharebelow18* sharebelow15*
order village sexratio* sharebelow18* sharebelow15*


****************************************
* END
















****************************************
* Nb of childrens by family
****************************************
*** 2010
use"raw/RUME-HH", clear
gen below18=1 if age<18
gen below15=1 if age<15
gen below14=1 if age<14
gen below6=1 if age<6
gen individual=1
collapse (sum) below18 below15 below14 below6 individual, by(HHID2010)
gen year=2010
merge 1:m HHID2010 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2010
order HHID_panel year
save"_temp1", replace

*** 2016
use"raw/NEEMSIS1-HH", clear
drop if livinghome==3
drop if livinghome==4
gen below18=1 if age<18
gen below15=1 if age<15
gen below14=1 if age<14
gen below6=1 if age<6
gen individual=1
collapse (sum) below18 below15 below14 below6 individual, by(HHID2016)
gen year=2016
merge 1:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2016
order HHID_panel year
save"_temp2", replace

*** 2020
use"raw/NEEMSIS2-HH", clear
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1
gen below18=1 if age<18
gen below15=1 if age<15
gen below14=1 if age<14
gen below6=1 if age<6
gen individual=1
collapse (sum) below18 below15 below14 below6 individual, by(HHID2020)
gen year=2020
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"
drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef"
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4"
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7" 
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409"
drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"
merge 1:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2020
order HHID_panel year

*
append using "_temp1"
append using "_temp2"
sort year 

foreach i in 18 15 14 6 {
gen sharebelow`i'=below`i'*100/individual
}

*
tabstat sharebelow18, stat(n mean q) by(year)
tabstat sharebelow15, stat(n mean q) by(year)
tabstat sharebelow14, stat(n mean q) by(year)
tabstat sharebelow6, stat(n mean q) by(year)


****************************************
* END

















****************************************
* Dowry to day worked
****************************************
*
use"NEEMSIS-marriage.dta", clear
keep HHID_panel year marriagedowry
sum marriagedowry if year==2020
replace marriagedowry=marriagedowry*1.16 if year==2020
sum marriagedowry if year==2020
replace marriagedowry=marriagedowry*(100/116) if year==2020
sum marriagedowry if year==2020
replace marriagedowry=marriagedowry*1.16 if year==2020
sum marriagedowry if year==2020

*
use"raw/NEEMSIS1-occupations", clear
gen daysayear=daysamonth*monthsayear
gen dailyincome=annualincome/daysayear
tabstat dailyincome, stat(mean q)
bysort HHID2016: egen dailyincome_mean=mean(dailyincome)
keep HHID2016 dailyincome_mean
duplicates drop
sum dailyincome_mean
merge 1:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2016
gen year=2016
order HHID_panel year
save"_temp", replace

*
use"raw/NEEMSIS2-occupations", clear
gen daysayear=daysamonth*monthsayear
gen dailyincome=annualincome/daysayear
tabstat dailyincome, stat(mean q)
bysort HHID2020: egen dailyincome_mean=mean(dailyincome)
keep HHID2020 dailyincome_mean
duplicates drop
sum dailyincome_mean
merge 1:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2020
gen year=2020
order HHID_panel year
replace dailyincome_mean=dailyincome_mean*(100/116)
append using "_temp"
ta year
save"_temp", replace

*
use"NEEMSIS-marriage.dta", clear
merge m:1 HHID_panel year using "_temp"
keep if _merge==3
drop _merge
gen dowrytodayworked=marriagedowry/dailyincome_mean
sum dailyincome_mean
tabstat dowrytodayworked if sex==2, stat(n mean q) by(year)
tabstat marriagedowry1000 if sex==2, stat(n mean q) by(year)
reg dowrytodayworked i.year if sex==2

xtile terinc=annualincome_HH if sex==2, n(3)
xtile terass=assets_total if sex==2, n(3)

tabstat marriagedowry1000 if sex==2 & year==2016, stat(n mean q) by(terinc)
tabstat marriagedowry1000 if sex==2 & year==2020, stat(n mean q) by(terinc)

tabstat marriagedowry1000 if sex==2 & year==2016, stat(n mean q) by(terass)
tabstat marriagedowry1000 if sex==2 & year==2020, stat(n mean q) by(terass)



tabstat marriagedowry1000 if sex==2, stat(n mean q max) by(ownland)
tabstat marriagedowry1000 if sex==2 & year==2016, stat(n mean q max) by(ownland)
tabstat marriagedowry1000 if sex==2 & year==2020, stat(n mean q max) by(ownland)


****************************************
* END

















****************************************
* Dowry from male side
****************************************

********** NEEMSIS-1
*
use"NEEMSIS-marriage.dta", clear
keep if year==2016

gen marriagemale=1 if sex==1
gen marriagefema=1 if sex==2

bysort HHID2016: egen marriagemale_HH=sum(marriagemale)
bysort HHID2016: egen marriagefema_HH=sum(marriagefema)
drop if marriagemale_HH>0 & marriagefema_HH>0

keep if sex==1
ta relationshiptohead year
fre relationshiptohead
keep if relationshiptohead==5

keep HHID2016 INDID2016 marriagedowry1000
gen marriage=1
save"_temp", replace

*
use"raw/NEEMSIS1-HH", clear
merge 1:1 HHID2016 INDID2016 using "_temp"
drop _merge
bysort HHID2016: egen marriage_HH=sum(marriage)
ta marriage_HH
drop if marriage_HH==0
drop marriage_HH
keep HHID2016 INDID2016 name age sex relationshiptohead marriage marriagedowry1000 livinghome maritalstatus
ta marriage relationshiptohead
fre relationshiptohead
fre maritalstatus

gen unmarrieddaughter=.
replace unmarrieddaughter=1 if relationshiptohead==6 & maritalstatus==2
replace unmarrieddaughter=1 if relationshiptohead==6 & maritalstatus==5

bysort HHID2016: egen unmarrieddaughter_HH=sum(unmarrieddaughter)
replace unmarrieddaughter_HH=1 if unmarrieddaughter_HH>1
drop unmarrieddaughter
rename unmarrieddaughter_HH unmarrieddaughter_HH

*
keep if marriage==1

*
tabstat marriagedowry1000, stat(n mean q) by(unmarrieddaughter)

*
keep HHID2016 INDID2016 name age sex relationshiptohead marriagedowry1000 marriage unmarrieddaughter

*
save"_tempN1", replace



********** NEEMSIS-2
*
use"NEEMSIS-marriage.dta", clear
keep if year==2020

gen marriagemale=1 if sex==1
gen marriagefema=1 if sex==2

bysort HHID2020: egen marriagemale_HH=sum(marriagemale)
bysort HHID2020: egen marriagefema_HH=sum(marriagefema)
drop if marriagemale_HH>0 & marriagefema_HH>0

keep if sex==1
ta relationshiptohead year
fre relationshiptohead
keep if relationshiptohead==5

keep HHID2020 INDID2020 marriagedowry1000
gen marriage=1
save"_temp", replace

*
use"raw/NEEMSIS2-HH", clear
merge 1:1 HHID2020 INDID2020 using "_temp"
drop _merge
bysort HHID2020: egen marriage_HH=sum(marriage)
ta marriage_HH
drop if marriage_HH==0
drop marriage_HH
keep HHID2020 INDID2020 name age sex relationshiptohead marriage marriagedowry1000 livinghome maritalstatus dummylefthousehold
ta marriage relationshiptohead
fre relationshiptohead
fre maritalstatus

gen unmarrieddaughter=.
replace unmarrieddaughter=1 if relationshiptohead==6 & maritalstatus==2
replace unmarrieddaughter=1 if relationshiptohead==6 & maritalstatus==5

bysort HHID2020: egen unmarrieddaughter_HH=sum(unmarrieddaughter)
replace unmarrieddaughter_HH=1 if unmarrieddaughter_HH>1
drop unmarrieddaughter
rename unmarrieddaughter_HH unmarrieddaughter_HH

*
keep if marriage==1

*
tabstat marriagedowry1000, stat(n mean q) by(unmarrieddaughter)

*
keep HHID2020 INDID2020 name age sex relationshiptohead marriagedowry1000 marriage unmarrieddaughter

*
save"_tempN2", replace



********** Append
use"_tempN1", clear

append using "_tempN2"

ta unmarrieddaughter

tabstat marriagedowry1000, stat(n mean q) by(unmarrieddaughter)

reg marriagedowry1000 i.unmarrieddaughter



****************************************
* END




















****************************************
* How pay marriage?
****************************************
use"NEEMSIS-marriage.dta", clear

********** Total
cls
ta year
* Loan
ta howpaymarriage_loan year, col nofreq
ta howpaymarriage_loan sex, col nofreq
* Capital
ta howpaymarriage_capi year, col nofreq
* Gift
ta howpaymarriage_gift year, col nofreq


********** Dalits
cls
ta year if caste==1
* Loan
ta howpaymarriage_loan year if caste==1, col nofreq
* Capital
ta howpaymarriage_capi year if caste==1, col nofreq
* Gift
ta howpaymarriage_gift year if caste==1, col nofreq


********** Middle
cls
ta year if caste==2
* Loan
ta howpaymarriage_loan year if caste==2, col nofreq
* Capital
ta howpaymarriage_capi year if caste==2, col nofreq
* Gift
ta howpaymarriage_gift year if caste==2, col nofreq


********** Upper
cls
ta year if caste==3
* Loan
ta howpaymarriage_loan year if caste==3, col nofreq
* Capital
ta howpaymarriage_capi year if caste==3, col nofreq
* Gift
ta howpaymarriage_gift year if caste==3, col nofreq


********** Males
cls
fre sex
ta year if sex==1
* Loan
ta howpaymarriage_loan year if sex==1, col nofreq
* Capital
ta howpaymarriage_capi year if sex==1, col nofreq
* Gift
ta howpaymarriage_gift year if sex==1, col nofreq


********** Females
cls
fre sex
ta year if sex==2
* Loan
ta howpaymarriage_loan year if sex==2, col nofreq
* Capital
ta howpaymarriage_capi year if sex==2, col nofreq
* Gift
ta howpaymarriage_gift year if sex==2, col nofreq

****************************************
* END


















****************************************
* At what cost?
****************************************
/*
- What is the price of the marriage?
- What are the expenses of the marriage?
- Is the cost of marriage different depending on the agricultural status?
- Is the cost of marriage different depending on the agricultural status of the wife's family?
- Is the cost of marriage different depending on the agricultural status of the husband's family?
- Does the cost of the marriage depend on the number of children still to be married?
*/

cls
********** Total cost and expenses of the marriage
use"NEEMSIS-marriage.dta", clear

* Total cost
tabstat marriagetotalcost1000, stat(n mean cv q) by(year) long

tabstat marriagetotalcost1000 if year==2016, stat(n mean cv q) by(intercaste) long
tabstat marriagetotalcost1000 if year==2016, stat(n mean cv q) by(marrtype) long
tabstat marriagetotalcost1000 if year==2016, stat(n mean cv q) by(sex) long

tabstat marriagetotalcost1000 if year==2020, stat(n mean cv q) by(intercaste) long
tabstat marriagetotalcost1000 if year==2020, stat(n mean cv q) by(marrtype) long
tabstat marriagetotalcost1000 if year==2020, stat(n mean cv q) by(sex) long


* Cost to income to have an idea
cls
tabstat CTI, stat(n mean cv q) by(year) long

tabstat CTI if year==2016, stat(n mean cv q) by(intercaste) long
tabstat CTI if year==2016, stat(n mean cv q) by(marrtype) long
tabstat CTI if year==2016, stat(n mean cv q) by(sex) long

tabstat CTI if year==2020, stat(n mean cv q) by(intercaste) long
tabstat CTI if year==2020, stat(n mean cv q) by(marrtype) long
tabstat CTI if year==2020, stat(n mean cv q) by(sex) long


* Total expenses
cls
foreach x in marriageexpenses1000 MEIR MEAR {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2016, stat(n mean cv q) by(sex) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
tabstat `x' if year==2020, stat(n mean cv q) by(sex) long

tabstat `x', stat(n mean cv q) by(sex) long
}





cls
********** Cost of the marriage and agricultural status
use"NEEMSIS-marriage.dta", clear

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriageexpenses1000 MEIR MEAR, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriageexpenses1000 MEIR MEAR \ incomenonagri_HH shareincomeagri_HH





cls
********** Cost of the marriage and agricultural status of the male's family
use"NEEMSIS-marriage.dta", clear
keep if sex==1

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriageexpenses1000 MEIR MEAR, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriageexpenses1000 MEIR MEAR \ incomenonagri_HH shareincomeagri_HH





cls
********** Cost of the marriage and agricultural status of the female's family
use"NEEMSIS-marriage.dta", clear
keep if sex==2

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriageexpenses1000 MEIR MEAR, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriageexpenses1000 MEIR MEAR \ incomenonagri_HH shareincomeagri_HH






cls
********** Cost of the marriage and number of children still to be married
use"NEEMSIS-marriage.dta", clear

* Macro var
global var unmarried_female_1824 unmarried_female_2530 unmarried_female unmarried_daughter unmarried_male_1824 unmarried_male_2530 unmarried_male unmarried_son

* Total
cpcorr $var \ marriageexpenses1000 MEIR MEAR

foreach x in $var {
tabstat marriageexpenses1000 MEIR MEAR, stat(n mean) by(cat_`x')
}


cls
* Males
preserve
keep if sex==1
cpcorr $var \ marriageexpenses1000 MEIR MEAR
cpcorr $var \ marriagehusbandcost

foreach x in $var {
tabstat marriageexpenses1000 MEIR MEAR marriagehusbandcost, stat(n mean) by(cat_`x')
}
restore


cls
* Females
preserve
keep if sex==2
cpcorr $var \ marriageexpenses1000 MEIR MEAR
cpcorr $var \ marriagewifecost2

foreach x in $var {
tabstat marriageexpenses1000 MEIR MEAR marriagewifecost2, stat(n mean) by(cat_`x')
}
restore


****************************************
* END
















****************************************
* How much gifts?
****************************************
/*
- What are the amount of gifts?
- What are the characteristics of low gift group?
- What are the affects of marriage cost on gift received?
- Does the amount of gifts received depend on the number of children still to be married?
*/

cls
********** Amount of gifts
use"NEEMSIS-marriage.dta", clear

replace totalmarriagegiftamount_alt=totalmarriagegiftamount_alt/1000

********** Desc

tab caste abs_lowgift, col nofreq chi2
ta educ_attainment2 abs_lowgift, col nofreq chi2
ta sex abs_lowgift, col nofreq chi2
ta working_pop abs_lowgift, col nofreq chi2
ta mainocc_occupation_indiv abs_lowgift, col nofreq chi2


tab caste rel_lowgift, col nofreq chi2
ta educ_attainment2 rel_lowgift, col nofreq chi2
ta sex rel_lowgift, col nofreq chi2
ta working_pop rel_lowgift, col nofreq chi2
ta mainocc_occupation_indiv rel_lowgift, col nofreq chi2


tabstat totalmarriagegiftamount_alt, stat(n mean) by(assets_q)
tabstat totalmarriagegiftamount_alt, stat(n mean) by(caste)


********** OLS

*** Absolut
reg abs_lowgift i.caste i.educ_attainment2 i.sex i.working_pop i.assets_q i.ownland i.divHH10, baselevel
reg totalmarriagegiftamount_alt i.caste i.educ_attainment2 i.sex i.working_pop i.assets_q i.ownland i.divHH10, baselevel


*** Relative to cost
reg rel_lowgift i.caste i.educ_attainment2 i.sex i.working_pop i.assets_q i.ownland i.divHH10, baselevel
reg gifttocost i.caste i.educ_attainment2 i.sex i.working_pop i.assets_q i.ownland i.divHH10, baselevel











********** Effects of costs on gift
* Selection
gen selection=marriagehusbandcost+marriagewifecost
drop if selection==.
drop if totalmarriagegiftamount_alt==.

* Stat gift and cost
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost if sex==2, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2, star(0.05)

* By the level of wealth
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & status==1, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & status==2, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & status==3, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & status==1, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & status==2, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & status==3, star(0.05)



* By the family composition
cls
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_female==0, star(0.01)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_female==1, star(0.01)

pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_daughter==0, star(0.01)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_daughter==1, star(0.01)

pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_male==0, star(0.01)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_male==1, star(0.01)

pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_son==0, star(0.01)
pwcorr totalmarriagegiftamount_alt marriagehusbandcost if sex==1 & cat_unmarried_son==1, star(0.01)


cls
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_female==0, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_female==1, star(0.05)

pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_daughter==0, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_daughter==1, star(0.05)

pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_male==0, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_male==1, star(0.05)

pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_son==0, star(0.05)
pwcorr totalmarriagegiftamount_alt marriagewifecost2 if sex==2 & cat_unmarried_son==1, star(0.05)






cls
********** Amount of the gifts received and number of children still to be married
use"NEEMSIS-marriage.dta", clear

* Macro var
global var unmarried_female_1824 unmarried_female_2530 unmarried_female unmarried_daughter unmarried_male_1824 unmarried_male_2530 unmarried_male unmarried_son

* Total
cpcorr $var \ totalmarriagegiftamount_alt

foreach x in $var {
tabstat totalmarriagegiftamount_alt, stat(n mean q) by(cat_`x')
}


cls
* Males
preserve
keep if sex==1
cpcorr $var \ totalmarriagegiftamount_alt

foreach x in $var {
tabstat totalmarriagegiftamount_alt, stat(n mean q) by(cat_`x')
}
restore


cls
* Females
preserve
keep if sex==2
cpcorr $var \ totalmarriagegiftamount_alt

foreach x in $var {
tabstat totalmarriagegiftamount_alt, stat(n mean q) by(cat_`x')
}
restore




****************************************
* END















****************************************
* Dowry
****************************************
/*
- What are the amount of dowry?
- What are the determinants of the dowry paid? 
- What are the determinants of the dowry received?
- Does the dowry asked by the male's family depend on the family's education expenses?
- Does the dowry sent differ according to the agricultural status of the wife's family?
- Does the dowry received differ according to the agricultural status of the husband's family?
- Does the amount of the dowry sent depend on the number of children still to be married?
- Does the amount of the dowry received depend on the number of children still to be married?
*/


cls
********** Amount
use"NEEMSIS-marriage.dta", clear



* Total
cls
foreach x in marriagedowry1000 DAIR DAAR DMC {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
}


* Males
preserve
keep if sex==1
cls
foreach x in marriagedowry DAIR DAAR DMC {
tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
}
restore


* Females
preserve
keep if sex==2
cls
foreach x in marriagedowry DAIR DAAR DMC {
tabstat `x', stat(n mean cv q) by(year) long

tabstat `x' if year==2016, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2016, stat(n mean cv q) by(marrtype) long

tabstat `x' if year==2020, stat(n mean cv q) by(intercaste) long
tabstat `x' if year==2020, stat(n mean cv q) by(marrtype) long
}
restore







cls
********** Determinants of absolut dowry from the female side
use"NEEMSIS-marriage.dta", clear

* Selection
keep if sex==2

* Reg
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH, baselevel
est store reg1

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH, baselevel
est store reg2

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH i.marriagespousefamily, baselevel
est store reg3

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH i.marriagespousefamily, baselevel
est store reg4

esttab reg1 reg2 reg3 reg4 using "_reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
	
	
	
	

cls
********** Determinants of the relative dowry from the female side
use"NEEMSIS-marriage.dta", clear

* Selection
keep if sex==2

* Reg
reg DAIR i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH, baselevel
est store reg1

reg DAIR i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH, baselevel
est store reg2

reg DAIR i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH i.marriagespousefamily, baselevel
est store reg3

reg DAIR i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH i.marriagespousefamily, baselevel
est store reg4

esttab reg1 reg2 reg3 reg4 using "_reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


	
	
cls
********** Determinants of absolut dowry from the male side
use"NEEMSIS-marriage.dta", clear

* Selection
keep if sex==1

pwcorr marriagedowry1000 educexp_female_HH, sig
pwcorr marriagedowry1000 educexp_male_HH, sig
pwcorr marriagedowry1000 educexp_female_HH if caste==1
pwcorr marriagedowry1000 educexp_female_HH if caste==2
pwcorr marriagedowry1000 educexp_female_HH if caste==3

ta educexp_female_HH
ta educexp_male_HH
ta educexp_HH
foreach x in educexp_female_HH educexp_male_HH educexp_HH {
replace `x'=`x'/1000
}

* Reg
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_HH, baselevel

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH educexp_male_HH, baselevel
est store reg1

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH educexp_male_HH, baselevel
est store reg2

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH educexp_male_HH i.marriagespousefamily, baselevel
est store reg3

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH educexp_male_HH i.marriagespousefamily, baselevel
est store reg4

esttab reg1 reg2 reg3 reg4 using "_reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

esttab reg1 reg2 reg3 reg4, ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	keep(educexp_female_HH educexp_male_HH) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


	

	
cls
********** Determinants of absolut dowry from the male side STD
use"NEEMSIS-marriage.dta", clear

* Selection
keep if sex==1

* Std assets et educ pour comparer les coefficients
ta educexp_female_HH
replace educexp_female_HH=educexp_female_HH/1000

* Ajout de l'éducation, le r2 passe de 15.9 à 19.9
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female i.ownland, baselevel
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female i.ownland c.educexp_female_HH, baselevel

* Ajout de la terre, le r2 passe de 17.7 à 19.9
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH, baselevel
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female i.ownland c.educexp_female_HH, baselevel

/*
Donc:
Ajouter l'éducation augmente le r2 de 4pp
Ajouter la terre augmente le r2 de 2.2pp
*/


cls 
********** Quel est la corrélation entre la dette en t et la dot demandée en t+1
use"NEEMSIS-marriage.dta", clear

keep if sex==1

*
preserve
use"raw/RUME-loans_mainloans", clear
bysort HHID2010: egen loanamount_HH=sum(loanamount)
keep HHID2010 loanamount_HH
duplicates drop
merge m:m HHID2010 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2010
order HHID_panel
rename loanamount_HH debt2010
replace debt2010=debt2010/1000
replace debt2010=debt2010*(100/63)
rename debt2010 lag_debt
gen year=2016
order HHID_panel year lag_debt
save"_temp", replace
restore

*
preserve
use"raw/NEEMSIS1-loans_mainloans", clear
bysort HHID2016: egen loanamount_HH=sum(loanamount)
keep HHID2016 loanamount_HH
duplicates drop
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge HHID2016
order HHID_panel
rename loanamount_HH debt2016
replace debt2016=debt2016/1000
rename debt2016 lag_debt
gen year=2020
order HHID_panel year lag_debt
ta year
append using "_temp"
ta year
save"_temp", replace
restore

merge m:1 HHID_panel year using "_temp"
drop if _merge==2
ta _merge year

keep if _merge==3
drop _merge
*
pwcorr marriagedowry1000 lag_debt, sig
spearman marriagedowry1000 lag_debt, stats(rho)
twoway (scatter marriagedowry1000 lag_debt)

*
reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.intercaste c.nbmarr_male c.nbmarr_female c.educexp_female_HH c.lag_debt, baselevel
est store reg1

reg marriagedowry1000 i.year i.edulevel i.working_pop i.caste i.ownland c.assets_totalnoland c.annualincome_HH c.shareincomeagri_HH i.interjatis c.nbmarr_male c.nbmarr_female c.educexp_female_HH c.lag_debt, baselevel
est store reg2

	
	
	
	





cls
********** Dowry asked and education expenses
use"panel_HH.dta", clear

* Selection
drop if marrdow_male_HH==0
drop if marrdow_male_HH==.
fre caste
ta year


* Total expenses
pwcorr educexp_HH marrdow_male_HH, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==1, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==2, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==3, star(0.05)
pwcorr educexp_HH marrdow_male_HH if caste==1 | caste==2, star(0.05)

* Expenses in education of males
pwcorr educexp_male_HH marrdow_male_HH, star(0.05)
pwcorr educexp_male_HH marrdow_male_HH if caste==1, star(0.05)
pwcorr educexp_male_HH marrdow_male_HH if caste==2, star(0.05)
pwcorr educexp_male_HH marrdow_male_HH if caste==3, star(0.05)
pwcorr educexp_male_HH marrdow_male_HH if caste==1 | caste==2, star(0.05)

* Expenses in education of females
pwcorr educexp_female_HH marrdow_male_HH, star(0.01)
pwcorr educexp_female_HH marrdow_male_HH if caste==1, star(0.05)
pwcorr educexp_female_HH marrdow_male_HH if caste==2, star(0.05)
pwcorr educexp_female_HH marrdow_male_HH if caste==3, star(0.05)
pwcorr educexp_female_HH marrdow_male_HH if caste==1 | caste==2, star(0.05)





cls
********** Dowry asked and housing expenditures
use"panel_HH.dta", clear

* Selection
drop if marrdow_male_HH==0
drop if marrdow_male_HH==.
fre caste
ta year

* Credit reason given
pwcorr totHH_givenamt_hous marrdow_male_HH, star(0.05)
pwcorr totHH_givenamt_hous marrdow_male_HH if caste==1, star(0.05)
pwcorr totHH_givenamt_hous marrdow_male_HH if caste==2, star(0.05)
pwcorr totHH_givenamt_hous marrdow_male_HH if caste==3, star(0.05)
pwcorr totHH_givenamt_hous marrdow_male_HH if caste==1 | caste==2, star(0.05)


* Credit effective reason)
pwcorr totHH_effectiveamt_hous marrdow_male_HH, star(0.05)
pwcorr totHH_effectiveamt_hous marrdow_male_HH if caste==1, star(0.05)
pwcorr totHH_effectiveamt_hous marrdow_male_HH if caste==2, star(0.05)
pwcorr totHH_effectiveamt_hous marrdow_male_HH if caste==3, star(0.05)
pwcorr totHH_effectiveamt_hous marrdow_male_HH if caste==1 | caste==2, star(0.05)







cls
********** Agricultural status and dowry sent
use"NEEMSIS-marriage.dta", clear

* Prepa
fre sex
keep if sex==2

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriagedowry1000 DAIR DAAR DMC, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriagedowry1000 DAIR DAAR DMC \ incomenonagri_HH shareincomeagri_HH







cls
********** Agricultural status and dowry received
use"NEEMSIS-marriage.dta", clear

* Prepa
fre sex
keep if sex==1

* Agricultural status
foreach x in ownland divHH10 {
tabstat marriagedowry1000, stat(n mean q) by(`x') long
}

* Share agri
cpcorr marriagedowry \ incomenonagri_HH shareincomeagri_HH





cls
********** Amount of the dowry sent and number of children still to be married
use"NEEMSIS-marriage.dta", clear

* Macro var
global var unmarried_female_1824 unmarried_female_2530 unmarried_female unmarried_daughter unmarried_male_1824 unmarried_male_2530 unmarried_male unmarried_son

fre sex
keep if sex==2
cpcorr $var \ marriagedowry1000

foreach x in $var {
tabstat marriagedowry1000, stat(n mean q) by(cat_`x')
}


/*
- La dot moyenne versé par les familles des épouses pour lesquelles il reste des femmes/filles célibataires/à marier est plus élevée que celle versé par les familles pour lesquelles il ne reste pas de célibataires.
- Les familles où il reste des fils non mariés versent une dot plus élevée que les familles où il ne reste pas de fils non mariés.
*/










cls
********** Amount of the dowry received and number of children still to be married
use"NEEMSIS-marriage.dta", clear

* Macro var
global var unmarried_female_1824 unmarried_female_2530 unmarried_female unmarried_daughter unmarried_male_1824 unmarried_male_2530 unmarried_male unmarried_son

fre sex
keep if sex==1
cpcorr $var \ marriagedowry1000

foreach x in $var {
tabstat marriagedowry1000, stat(n mean q) by(cat_`x')
}

/*
- Les familles où il reste des fils non mariés recoivent une dot plus élevée que les familles où il ne reste pas de fils non mariés.
*/



****************************************
* END















****************************************
* Marriage net cost (expenses + dowry)
****************************************
/*
- What is the net cost of the marriage? (expenses and dowry together)
*/

cls
use"NEEMSIS-marriage.dta", clear

* By sex
tabstat marriagenetcost1000 MNCI, stat(n mean) by(sex)

* By sex and status
tabstat marriagenetcost1000 MNCI if sex==1, stat(n mean) by(cat_cost)
tabstat marriagenetcost1000 MNCI if sex==2, stat(n mean) by(cat_cost)

cls
* By sex, status and land
ta cat_cost sex if year==2020, col

tabstat marriagenetcost1000 MNCI if sex==1 & cat_cost==1, stat(n mean) by(ownland)

tabstat marriagenetcost1000 MNCI if sex==2 & cat_cost==3, stat(n mean) by(ownland)


ta MNCI if sex==2 & cat_cost==3 & year==2020

****************************************
* END





