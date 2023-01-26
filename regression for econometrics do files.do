** Import Data **
. import excel "C:\Users\kylec\Downloads\Econometrics\heart_disease_2020_regression_analysis.xlsx"
> , sheet("heart_2020_cleaned") firstrow
(16 vars, 319,795 obs)

** Converting to Binary Form **
gen heartdisease=HeartDisease=="Yes"
gen kidneydisease=KidneyDisease=="Yes"
gen asthma=Asthma=="Yes"
gen physicalactivity=PhysicalActivity=="Yes"
gen diabetic=Diabetic=="Yes"
gen stroke=Stroke=="Yes"
gen alcoholdrinking=AlcoholDrinking=="Yes"
gen smoking=Smoking=="Yes"
gen race=Race=="White"
gen male=Sex=="Male"
gen generalhealth=GenHealth=="Poor"|GenHealth=="Fair"
gen physicalhealth=PhysicalHealth>=15
gen mentalhealth=MentalHealth>=15
gen age=AgeCategory=="Young"|AgeCategory== "18-24"|AgeCategory=="25-29"|AgeCategory=="30-34"|AgeCategory=="35-39"|AgeCategory=="40-44"|AgeCategory=="45-49"

** Summary Table **
sum heartdisease male race kidneydisease alcoholdrinking asthma physicalactivity physicalhealth stroke smoking generalhealth mentalhealth diabetic age BMI SleepTime

** Regression Table for Heart Disease **

ssc install estout, replace

** First regression model ** 
reg heartdisease BMI SleepTime, r eststo

** Second regression Model **
reg heartdisease BMI smoking alcoholdrinking stroke diabetic asthma kidneydisease, r eststo

** Third (Final) Regression Model **
reg heartdisease male race kidneydisease alcoholdrinking asthma physicalactivity physicalhealth stroke smoking generalhealth mentalhealth diabetic age BMI SleepTime, r eststo

esttab using heart_disease_2020_regression_analysis_table, replace r2(4) label se ///
star(* .1 ** .05 *** .01) ///
title(Regression Table for HeartDisease) ///
nonumbers mtitles ((1) (2) (3))
