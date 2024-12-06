*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*July 22, 2022
*-----
*Locus analysis
*-----
cd""
*-------------------------










****************************************
* Analysis
****************************************
cls
use"$wave3~_RED", clear


********** LOC
fre locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4 locuscontrol5 locuscontrol6
omegacoef locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4 locuscontrol5 locuscontrol6



********** Descriptive statistics
fre edulevel
fre mainocc_occupation_indiv
fre villageid 
sum female dalit age locus debt_reco_indiv debt_nego_indiv annualincome_HH



********** Variables used
global indivcontrol age dummyhead i.mainocc_occupation_indiv i.edulevel i.maritalstatus
global hhcontrol assets_noland hhsize covsell annualincome_HH i.villageid
global cont $indivcontrol $hhcontrol



***** Reco
cls
probit debt_reco_indiv c.locus i.female i.dalit $cont, cluster(household)
margins, dydx(locus) atmeans 

probit debt_reco_indiv c.locus##i.female##i.dalit $cont, cluster(household)
margins, dydx(locus) at(dalit=(0 1) female=(0 1)) atmeans 



***** Nego
cls
probit debt_nego_indiv c.locus i.female i.dalit $cont, cluster(household)
margins, dydx(locus) atmeans 

probit debt_nego_indiv c.locus##i.female##i.dalit $cont, cluster(household)
margins, dydx(locus) at(dalit=(0 1) female=(0 1)) atmeans 

****************************************
* END
