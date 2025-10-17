*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 23, 2021
*-----
*Econometrics loan level
*-----
do "psychodebt"
*-------------------------






*************************************
* Negotiation
*************************************
use"base_loanlevel_lag", clear

*** How many indiv? How many HH? How many loans?

count
* A total of 1084 main loans

preserve
keep HHID_panel INDID_panel
duplicates drop
count
restore
* From 488 egos

preserve
keep HHID_panel
duplicates drop
count
restore
* From 413 households


*** Services
ta dummyinterest
ta borrservices_none
ta dummyinterest borrservices_none


*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH log_assets_total HHsize log_annualincome_HH

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock dummysell

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits

global contloan ib(1).lender_cat dummyinterest ib(2).reason_cat c.log_loanamount ib(1).dummyssex ib(1).dummyscaste

fre lender_cat dummyinterest reason_cat dummyssex dummyscaste


********** Analysis

probit borrservices_none indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr0

qui probit borrservices_none indebt_indiv $PTCS $XIndiv $XHH $Xrest $contloan, cluster(INDID) 
est store pr1
qui margins, dydx($PTCSma) atmeans post
est store marg1

qui probit borrservices_none indebt_indiv $intfem $XIndiv $XHH $Xrest $contloan, cluster(INDID) 
est store pr2
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2

qui probit borrservices_none indebt_indiv $intdal $XIndiv $XHH $Xrest $contloan, cluster(INDID) 
est store pr3
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3

qui probit borrservices_none indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr4
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4

********** Overfit
*overfit: probit borrservices_none indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(INDID)


********** Format

esttab pr0 pr1 pr2 pr3 pr4 using "Nego_loan.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p r2, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
	
esttab marg1 marg2 marg3 marg4 using "Nego_margin_loan.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		

est clear
*************************************
* END














*************************************
* Management
*************************************
use"base_loanlevel_lag", clear


*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH log_assets_total HHsize log_annualincome_HH

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock dummysell

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits

*global contloan i.lender_cat i.dummyinterest i.reason_cat c.log_loanamount i.dummyssex i.dummyscaste

global contloan ib(1).lender_cat dummyinterest ib(2).reason_cat c.log_loanamount c.log_sloanamount



********** Analysis
probit dummyproblemtorepay indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest $contloan, cluster(INDID)
est store pr0

qui probit dummyproblemtorepay indebt_indiv $PTCS $XIndiv $XHH $Xrest $contloan, cluster(INDID) 
est store pr1
qui margins, dydx($PTCSma) atmeans post
est store marg1

qui probit dummyproblemtorepay indebt_indiv $intfem $XIndiv $XHH $Xrest $contloan, cluster(INDID) 
est store pr2
qui margins, dydx($PTCSma) at(female=(0 1)) atmeans post
est store marg2

qui probit dummyproblemtorepay indebt_indiv $intdal $XIndiv $XHH $Xrest $contloan, cluster(INDID) 
est store pr3
qui margins, dydx($PTCSma) at(dalits=(0 1)) atmeans post
est store marg3

qui probit dummyproblemtorepay indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(INDID) baselevel
est store pr4
margins, dydx($PTCSma) at(dalits=(0 1) female=(0 1)) atmeans post
est store marg4


********** Overfit
*overfit: probit dummyproblemtorepay indebt_indiv $inttot $XIndiv $XHH $Xrest $contloan, cluster(INDID)


********** Format
esttab pr0 pr1 pr2 pr3 pr4 using "Mana_loan.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop($Xrest _cons) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p r2, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\chi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	

esttab marg1 marg2 marg3 marg4 using "Mana_margin_loan.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace		


est clear	
*************************************
* END








