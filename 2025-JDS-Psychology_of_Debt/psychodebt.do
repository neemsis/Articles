*-------------------------
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*-----
*psychodebt
*-----
*-------------------------

********** Clear
clear all
macro drop _all

********** Path to do
global dofile = "C:\Users\Arnaud\Documents\GitHub\research_code\psychodebt"

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Research\2025-JDS_Debt_skills\Analysis"
cd"$directory"

********** Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid

********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020