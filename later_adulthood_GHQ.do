use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"


//////////////////////////////////////////////////////////////////////////////////////////////////
**************************************************************care related variables
////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////gen care variable withing the age range (50-64)
foreach w in a b c d e f g h i j {
gen `w'_omcareinhh=`w'_careinhh
replace `w'_omcareinhh=. if `w'_age_dv>=65|`w'_age_dv<50
gen `w'_omcareouthh=`w'_careouthh
replace `w'_omcareouthh=. if `w'_age_dv>=65|`w'_age_dv<50
gen `w'_omcareany=`w'_careany
replace `w'_omcareany=. if `w'_age_dv>=65|`w'_age_dv<50
}

foreach w in a b c d e f g h i j {
label values `w'_omcareinhh carelab
label values `w'_omcareouthh carelab
label values `w'_omcareany carelab
}

egen om_times_careinhh=anycount (*_omcareinhh),values (1)
egen om_times_careouthh=anycount (*_omcareouthh),values (1)
egen om_times_careany=anycount (*_omcareany),values (1)

drop rowmisscare
egen rowmisscare=rowmiss(*_omcareany)
tab om_times_careany if rowmisscare!=10

recode om_times_careany (1/10=1), gen(omidcare)
replace omidcare=. if rowmisscare==10
label var omidcare " whehther provide care 50-64y"

*-----------------------------------wave when first observed enter the older-mid age range (age range of 50-64)
gen wavefirstobv_om=1 if a_omcareany!=.
replace wavefirstobv_om=2 if b_omcareany!=.&wavefirstobv_om==.
replace wavefirstobv_om=3 if c_omcareany!=.&wavefirstobv_om==.
replace wavefirstobv_om=4 if d_omcareany!=.&wavefirstobv_om==.
replace wavefirstobv_om=5 if e_omcareany!=.&wavefirstobv_om==.
replace wavefirstobv_om=6 if f_omcareany!=.&wavefirstobv_om==.
replace wavefirstobv_om=7 if g_omcareany!=.&wavefirstobv_om==.
replace wavefirstobv_om=8 if h_omcareany!=.&wavefirstobv_om==.
replace wavefirstobv_om=9 if i_omcareany!=.&wavefirstobv_om==.
replace wavefirstobv_om=10 if j_omcareany!=.&wavefirstobv_om==.


*-----------------------------------wave when first observed caring in  the older-mid age range (age range of 50-64)
gen wavefirstcar_om=1 if a_omcareany==1
replace wavefirstcar_om=2 if b_omcareany==1&wavefirstcar_om==.
replace wavefirstcar_om=3 if c_omcareany==1&wavefirstcar_om==.
replace wavefirstcar_om=4 if d_omcareany==1&wavefirstcar_om==.
replace wavefirstcar_om=5 if e_omcareany==1&wavefirstcar_om==.
replace wavefirstcar_om=6 if f_omcareany==1&wavefirstcar_om==.
replace wavefirstcar_om=7 if g_omcareany==1&wavefirstcar_om==.
replace wavefirstcar_om=8 if h_omcareany==1&wavefirstcar_om==.
replace wavefirstcar_om=9 if i_omcareany==1&wavefirstcar_om==.
replace wavefirstcar_om=10 if j_omcareany==1&wavefirstcar_om==.

*-----------------------------------age when first observed care in  the older-mid age range (age range of 50-64)

gen ageonset_om=a_age_dv if wavefirstcar_om==1
replace ageonset_om=b_age_dv if wavefirstcar_om==2
replace ageonset_om=c_age_dv if wavefirstcar_om==3
replace ageonset_om=d_age_dv if wavefirstcar_om==4
replace ageonset_om=e_age_dv if wavefirstcar_om==5
replace ageonset_om=f_age_dv if wavefirstcar_om==6
replace ageonset_om=g_age_dv if wavefirstcar_om==7
replace ageonset_om=h_age_dv if wavefirstcar_om==8
replace ageonset_om=i_age_dv if wavefirstcar_om==9
replace ageonset_om=j_age_dv if wavefirstcar_om==10

recode ageonset_om (50/51=1) (52/53=2) (54/55=3)(56/57=4) (58/59=5) (60/61=6) (62/63=7)(64=8), gen (ageonset_omg)
label define ageonset_omg 1"50/51" 2"52/53" 3"54/55" 4"56/57" 5"58/59" 6"60/61" 7"62/63" 8"64"
label values ageonset_omg ageonset_omg
tab ageonset_omg
egen times_careany_om=anycount (*_omcareany),values (1)
recode times_careany_om (4/max=4)
tab times_careany_om if omidcare==1


*-----------------------------------HOURS OF CARING (INSIDE AND OUTSIDE HOUSEHOLD COMBINED)
foreach w in a b c d e f g h i j {
recode `w'_aidhrs (-10/-1=.)
 }
  /////////////////use mid point of hours
  foreach w in a b c d e f g h i j {
  gen `w'_hours_om=2 if `w'_aidhrs==1&`w'_omcareany!=.
  replace `w'_hours_om=7 if `w'_aidhrs==2&`w'_omcareany!=.
  replace `w'_hours_om=14.5 if `w'_aidhrs==3&`w'_omcareany!=.
  replace `w'_hours_om=27 if `w'_aidhrs==4&`w'_omcareany!=.
  replace `w'_hours_om=42 if `w'_aidhrs==5&`w'_omcareany!=.
  replace `w'_hours_om=74.5 if `w'_aidhrs==6&`w'_omcareany!=.
  replace `w'_hours_om=100 if `w'_aidhrs==7&`w'_omcareany!=.
  replace `w'_hours_om=10 if `w'_aidhrs==8&`w'_omcareany!=.
  replace `w'_hours_om=34 if `w'_aidhrs==9&`w'_omcareany!=.
  replace `w'_hours_om=. if `w'_aidhrs==97&`w'_omcareany!=.
  }
  egen meanhour_om=rowmean (*_hours_om)
  
  gen meanhour_omg=1 if meanhour_om<5
  replace meanhour_omg=2 if meanhour_om<10&meanhour_omg==.
  replace meanhour_omg=3 if meanhour_om<20&meanhour_omg==.
  replace meanhour_omg=4 if meanhour_om<35&meanhour_omg==.
  replace meanhour_omg=5 if meanhour_om<50&meanhour_omg==.
  replace meanhour_omg=6 if meanhour_om<100&meanhour_omg==.
  replace meanhour_omg=7 if meanhour_om==100&meanhour_omg==.
  label value meanhour_omg a_aidhrs

  replace meanhour_omg=0 if omidcare==0 
   recode meanhour_omg (5/7=5)
   tab meanhour_omg if omidcare==1
   
 
*--------------------------------------------------------------------------------
*----------------------------------- NUMBER PEOPLE CARING FOR
*-----------------------------------------------------------------------------------

foreach w in a b c d e f g h i j {
forvalues x=1/16 {
gen `w'_person`x'_om=1 if `w'_aidhua`x'==1
replace `w'_person`x'_om=0 if `w'_aidhua`x'!=1
}

clonevar `w'_peopleout_om=`w'_naidxhh
recode `w'_peopleout_om min/-1=0
gen `w'_numcare_om=(`w'_peopleout_om+`w'_person1_om+`w'_person2_om+`w'_person3_om+`w'_person4_om+`w'_person5_om+`w'_person6_om+`w'_person7_om+`w'_person8_om+`w'_person9_om ///
	+`w'_person10_om+`w'_person11_om+`w'_person12_om+`w'_person13_om+`w'_person14_om+`w'_person15_om+`w'_person16_om)
replace `w'_numcare_om=0 if `w'_omcareany==0
replace `w'_numcare_om=. if `w'_omcareany==.
}

egen meannum_om=rowmean(*_numcare_om)
* round it up
gen meannumcar_om=ceil(meannum_om)
recode meannumcar_om (3/max=3) (0=1), gen (meannumcar_omg)
*n=18 0
tab meannumcar_omg if omidcare==1

*--------------------------------------------------------------------------------
*----------------------------------- CARE PLACE
*-----------------------------------------------------------------------------------
 egen anyinhh_om=rowmin(*_omcareinhh)
  egen anyouthh_om=rowmin(*_omcareouthh)
 
 gen placecare_om=0 if omidcare==0
 replace placecare_om=1 if anyinhh_om==1 & anyouthh_om!=1
 replace placecare_om=2 if anyouthh_om==1 & anyinhh_om!=1
 replace placecare_om=3 if anyinhh_om==1 & anyouthh_om==1
 
 label define placecare_om 0"no care" 1" in hh" 2" out hh" 3" both in and out hh"
 label values placecare_om placecare_om
 tab placecare_om if omidcare==1
 
 
 
 *------------------------------------------------------------------------------------
 *--------------------------------------DURATION OF CARE
 *--------------------------------------------------------------------------------------
 
 use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"
foreach w in a b c d e f g h i j {
gen `w'_age_care_om=`w'_age_dv 
replace `w'_age_care_om=. if `w'_omcareany!=1
}

egen lastage_om=rowmax(*_age_care_om)
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", replace

*reshape it to long format to extend their duration >=50
keep pidp lastage_om *age_dv *_omcareany *_careany
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\extendduration_om.dta"
rename a_* *1
rename b_* *2
rename c_* *3
rename d_* *4
rename e_* *5
rename f_* *6
rename g_* *7
rename h_* *8
rename i_* *9
rename j_* *10

reshape long age_dv omcareany careany, i(pidp) j(wave)
gen agefinal=65 if careany==1&age_dv==65&lastage_om==64
sort pidp agefinal
by pidp:replace agefinal=agefinal[1]
gen agefinal2=66 if careany==1&age_dv==66&lastage_om==64
sort pidp agefinal2
by pidp:replace agefinal2=agefinal2[1]
gen agefinal3=67 if careany==1&age_dv==67&lastage_om==64
sort pidp agefinal3
by pidp:replace agefinal3=agefinal3[1]
gen agefinal4=68 if careany==1&age_dv==68&lastage_om==64
sort pidp agefinal4
by pidp:replace agefinal4=agefinal4[1]
gen agefinal5=69 if careany==1&age_dv==69&lastage_om==64
sort pidp agefinal5
by pidp:replace agefinal5=agefinal5[1]
gen agefinal6=70 if careany==1&age_dv==70&lastage_om==64
sort pidp agefinal6
by pidp:replace agefinal6=agefinal6[1]
gen agefinal7=71 if careany==1&age_dv==71&lastage_om==64
sort pidp agefinal7
by pidp:replace agefinal7=agefinal7[1]
gen agefinal8=72 if careany==1&age_dv==72&lastage_om==64
sort pidp agefinal8
by pidp:replace agefinal8=agefinal8[1]
gen agefinal9=73 if careany==1&age_dv==73&lastage_om==64
sort pidp agefinal9
by pidp:replace agefinal9=agefinal9[1]

gen ageextend=agefinal
recode ageextend 65=66 if agefinal2==66
recode ageextend 66=67 if agefinal3==67
recode ageextend 67=68 if agefinal4==68
recode ageextend 68=69 if agefinal5==69
recode ageextend 69=70 if agefinal6==70
recode ageextend 70=71 if agefinal7==71
recode ageextend 71=72 if agefinal8==72
recode ageextend 72=73 if agefinal9==73

keep if wave==1
rename ageextend ageextend_om
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\extendduration_long_om.dta",replace
erase  "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\extendduration_om.dta"


use"C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\extendduration_long_om.dta", keepusing (ageextend_om)
drop _merge

gen extendyear_om=ageextend_om-64

gen duration_om=om_times_careany
replace duration_om=duration_om+extendyear_om if extendyear_om!=.
gen duration_omg=duration_om
recode duration_omg 4/max=4
replace duration_omg=. if omidcare==.
******************************************hhincome use baseline with the age range (i.e first wave when interviewed between 50 and 64)
tokenize "`c(alpha)'"
gen hhincome_1obom=a_netinc if wavefirstobv_om==1
forval waveno = 2/10 {
  replace hhincome_1obom=``waveno''_netinc if wavefirstobv_om==`waveno'
}
xtile incomqu_1obom=hhincome_1obom, n(5)

//////////////////////////////////////////////employment status
tokenize "`c(alpha)'"
gen jbstatus_1ob_om=a_jbstat if wavefirstobv_om==1
forval waveno = 2/10 {
  replace jbstatus_1ob_om=``waveno''_jbstat if wavefirstobv_om==`waveno'
}

label value jbstatus_1ob_om j_jbstat

recode jbstatus_1ob_om  (11=9) (10=97)
recode jbstatus_1ob_om  (5=2)
recode jbstatus_1ob_om  (1=2) (9=7)
recode jbstatus_1ob_om (min/-1=.)

*******************************************
////////////////////////////////////////////////////////nssec
tokenize "`c(alpha)'"
gen class_1ob_om=a_jbnssec3_dv if wavefirstobv_om==1
forval waveno = 2/10 {
  replace class_1ob_om=``waveno''_jbnssec3_dv if wavefirstobv_om==`waveno'
}

label value class_1ob_om a_jbnssec3_dv
replace class_1ob_om=0 if jbstatus_1ob_om==3
replace class_1ob_om=0 if jbstatus_1ob_om==4
replace class_1ob_om=0 if jbstatus_1ob_om>=6&jbstatus_1ob_om<.
recode class_1ob_om (min/-1=.)

//////////////////////////////////////////////////////// FT/PT

tokenize "`c(alpha)'"
gen workhour_1ob_om=a_jbft_dv if wavefirstobv_om==1
forval waveno = 2/10 {
  replace workhour_1ob_om=``waveno''_jbft_dv if wavefirstobv_om==`waveno'
}
label value workhour_1ob_om a_jbft_dv

replace workhour_1ob_om=0 if (jbstatus_1ob_om==3|jbstatus_1ob_om==4)
replace workhour_1ob_om=0 if jbstatus_1ob_om>=6&jbstatus_1ob_om<.

foreach w in a b c d e f g h i j {
recode `w'_jbhrs (0/30=1) (30.01/40=2) (40/max=3), gen (`w'_workfp)
}


tokenize "`c(alpha)'"
gen workfp_1ob_om=a_workfp if wavefirstobv_om==1
forval waveno = 2/10 {
  replace workfp_1ob_om=``waveno''_workfp if wavefirstobv_om==`waveno'
}

replace workfp_1ob_om=0 if jbstatus_1ob_om==3
replace workfp_1ob_om=0 if jbstatus_1ob_om>=6&jbstatus_1ob_om<.
recode workfp_1ob_om (min/-1=.)
replace workfp_1ob_om=workhour_1ob_om if workfp_1ob_om==.

label define workfp_1ob_om 0"not working" 1"PT" 2"FT" 3"FT,long wh"
label values workfp_1ob_om workfp_1ob_om
recode workfp_1ob_om (min/-1=.)


/////////////////////////////////////////////combine FT/PT with employment status
replace workfp_1ob_om=0 if class_1ob_om==0
*2 changes
gen workcom_om=workfp_1ob_om
replace workcom_om=4 if jbstatus_1ob_om==3
replace workcom_om=5 if jbstatus_1ob_om==4
replace workcom_om=6 if jbstatus_1ob_om==6
replace workcom_om=7 if jbstatus_1ob_om==7
replace workcom_om=8 if jbstatus_1ob_om==8
replace workcom_om=9 if jbstatus_1ob_om==97
label define workcom_om 1"PT" 2"FT" 3"FT,long wh" 4"Unemployed" 5 "Retired"  6"Family care"  7"Full-time student"  8"LT sick" 9 "something else"
label values workcom_om workcom_om
///////////////////////////////////////////////////marriage
tokenize "`c(alpha)'"
gen marriage_1ob_om=a_mastat_dv if wavefirstobv_om==1
forval waveno = 2/10 {
  replace marriage_1ob_om=``waveno''_mastat_dv if wavefirstobv_om==`waveno'
}
recode marriage_1ob_om (min/-1=.)
recode marriage_1ob_om 0=1 3=2 4/5=3 7/8=3 10=4
label define marriage_1ob_om ///
1"single" 2"married" 3"seperated" 4"live as couple" 6"widowed"

label value marriage_1ob_om marriage_1ob_om

************************************age at baseline
tokenize "`c(alpha)'"
gen age_1ob_om=a_age_dv if wavefirstobv_om==1
forval waveno = 2/10 {
  replace age_1ob_om=``waveno''_age_dv if wavefirstobv_om==`waveno'
}

************************************number of children in hh by age

*nch02_dv nch34_dv nch511_dv 

tokenize "`c(alpha)'"
gen children_om=a_nch14resp  if wavefirstobv_om==1
forval waveno = 2/10 {
  replace children_om=``waveno''_nchild_dv if wavefirstobv_om==`waveno'
}

gen children_1ob_om=children_om
recode children_1ob_om (3/max=3)
recode children_1ob_om (min/-1=.)

***************************************urban/rural
tokenize "`c(alpha)'"
gen urban_1ob_om=a_urban_dv if wavefirstobv_om==1
forval waveno = 2/10 {
  replace urban_1ob_om=``waveno''_urban_dv if wavefirstobv_om==`waveno'
}

recode urban_1ob_om (min/-1=.)
*************************waves have been participated
egen wavesobs_om=anycount (*age_dv), values(50/64)
*-----------------------------------age when first enter the survey
foreach w in a b c d e f g h i j {
recode `w'_age_dv -9=.
}
egen agemin=rowmin(*age_dv)

save "C:\Users\baowen\OneDrive - University College London\EUROCARE\2paper_GHQ\data\wide_care.dta", replace


//////////////////////////////////////////////////////////////////////////////////////////////////
*******************************************************prepare the data for 1:2 matching
//////////////////////////////////////////////////////////////////////////////////////////////////

use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"



****number of children
drop children_1ob_om children_om
tokenize "`c(alpha)'"
gen children_om=a_nchild_dv  if wavefirstobv_om==1
forval waveno = 2/10 {
  replace children_om=``waveno''_nchild_dv if wavefirstobv_om==`waveno'
}

gen children_1ob_om=children_om
recode children_1ob_om (3/max=3)
recode children_1ob_om (min/-1=.)

save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", replace
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"
keep if omidcare!=.

keep pidp yougcare *age_dv yougcare ymidcare omidcare sex ethnicity parenclass_h incomqu_1obom age_1ob_om agemin ///
agemax ageonset_om wavesobs_om higestedu children_1ob_om  *_scghq1_dv *_sf12mcs_dv *_sf12pcs_dv *_omcareany  *_age_dv wavefirstcar_om psu strata ///
class_1ob_om  workcom_om marriage_1ob_om age_1ob_om wavefirstobv_om urban_1ob_om children_1ob_om *_hidp

/////////////select sample who have participated the survey once before and once after the care onset
gen samplepiece=1 if agemin<ageonset_om & agemax>=ageonset_om & ageonset_om!=. 
drop if samplepiece!=1&omidcare==1
drop if ymidcare ==1
*(2,548 observations deleted)


///////////////////base outcome
egen missghq= rowmiss(*scghq1_dv)
tokenize "`c(alpha)'"
gen ghq_1ob_om=a_scghq1_dv if wavefirstobv_om==1
forval waveno = 2/10 {
  replace ghq_1ob_om=``waveno''_scghq1_dv if wavefirstobv_om==`waveno'
}
recode ghq_1ob_om (min/-1=.)



////////////////no. people in the same hh
tokenize "`c(alpha)'"
gen hhid_1obya=a_hidp if wavefirstobv_om==1
forval waveno = 2/10 {
  replace hhid_1obya=``waveno''_hidp if wavefirstobv_om==`waveno'
}

sort hhid_1obya pidp
by hhid_1obya: gen nucarehh=[_N]


*combine small n categories
*recode workcom_om 5=4

recode parenclass_h (100=.)


mdesc age_1ob_om  sex ethnicity incomqu_1obom class_1ob_om  workcom_om marriage_1ob_om ///
parenclass_h urban_1ob_om children_1ob_om workcom_om  higestedu ghq_1ob_om if omidcare==1



kmatch ps omidcare age_1ob_om i.ethnicity i.incomqu_1obom i.class_1ob_om i.workcom_om i.marriage_1ob_om i.parenclass_h i.urban_1ob_om i.children_1ob_om i.higestedu i.wavesobs  (ghq_1ob_om), ematch(sex) nn(2) idgenerate(controlid) idvar(pidp)generate(kpscore)


tab kpscore if _KM_nm>=1
recode ageonset_om .=0



*matched control 1
gen double id1=controlid1
replace id1=pidp if kpscore==0
gen ageonset2=ageonset_om if kpscore==1
sort id1 ageonset2
by id1: replace ageonset2=ageonset2[1]
gen ageonset_g1= ageonset2 if kpscore==0
*matched control 2
gen double id2=controlid2
replace id2=pidp if kpscore==0
gen ageonset3=ageonset_om if kpscore==1
sort id2 ageonset3
by id2: replace ageonset3=ageonset3[1]
gen ageonset_g2=ageonset3 if kpscore==0
*matched control 3
gen double id3=controlid3
replace id3=pidp if kpscore==0
gen ageonset4=ageonset_om if kpscore==1
sort id3 ageonset4
by id3: replace ageonset4=ageonset4[1]
gen ageonset_g3=ageonset4 if kpscore==0

*matched control 4
gen double id4=controlid4
replace id4=pidp if kpscore==0
gen ageonset5=ageonset_om if kpscore==1
sort id4 ageonset5
by id4: replace ageonset5=ageonset5[1]
gen ageonset_g4=ageonset5 if kpscore==0


gen ageonset_all=ageonset_om
replace ageonset_all=ageonset_g1 if ageonset_g1!=. & ageonset_all==0
replace ageonset_all=ageonset_g2 if ageonset_g1==.& ageonset_all==0

save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_om.dta"
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_om.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", keepus(meanhour_omg placecare_om)
drop if _merge==2
drop _merge
tab kpscore if ageonset_all!=.
 
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample
keep if usesample==1

keep pidp *age_dv  *scghq1_dv  ageonset_all omidcare age_1ob_om agemax agemin kpscore sex hhid_1obya meanhour_omg placecare_om

 
 rename a_* *1
 rename b_* *2
 rename c_* *3
 rename d_* *4
 rename e_* *5
 rename f_* *6
 rename g_* *7
 rename h_* *8
 rename i_* *9
 rename j_* *10
reshape long scghq1_dv age_dv , i(pidp) j(wave)
*time scale variable
gen yrtoset=age_dv-ageonset_all 
*make time scale positive, as margins command can be only used for positive values
gen poyrtoset=yrtoset+8
label var poyrtoset"years before and after onest caring,all add 8"
* recode two ends as missing to exclude the small N at two ends
recode poyrtoset -1=. -2=. 
recode poyrtoset 17=.
recode poyrtoset 23=.
* generate 3 pieces
mkspline part1 7 part2 8 part3 = poyrtoset,marginal
showcoding yrtoset poyrtoset part1 part2 part3





/////////////////////////////////graphs for yes/no care
mixed scghq1_dv i.poyrtoset if kpscore==1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_yn, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_om_yn, replace)
combomarginsplot file1_om_yn file2_om_yn, labels ("carers" "non carers") savefile(combined_ghq_yn, replace)

mplotoffset using combined_ghq_yn, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 50-64") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")



/////////////////////////////////graphs for yes/no care by sex
mixed scghq1_dv i.poyrtoset if kpscore==1 & sex==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_yn_m, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & sex==1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_om_yn_m, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & sex==2|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_yn_f, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & sex==2 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_om_yn_f, replace)
combomarginsplot file1_om_yn_m file2_om_yn_m file1_om_yn_f file2_om_yn_f, labels ("male carers" "male non carers" "female carers" "female non carers") savefile(combined_ghq_yn_sex, replace)

mplotoffset using combined_ghq_yn_sex, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 50-64") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")



/////////////////////////////////graphs for care intensity 
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_omg==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_low, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_omg==2|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_lmid, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_omg==3|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_mid, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & (meanhour_omg==4|meanhour_omg==5) || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_hig, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & poyrtoset!=0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_ncare, replace)
combomarginsplot file1_om_low file1_om_lmid file1_om_mid file1_om_hig file1_om_ncare, labels ("<5h per week" "5-9h per week" "10-19h per week" "20+h per week" "non carers") savefile(combined_ghq_intensity, replace)

mplotoffset using combined_ghq_intensity, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 50-64") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")


/////////////////////////////////graphs for care place

mixed scghq1_dv i.poyrtoset if kpscore==1 & (placecare_om==1|placecare_om==3)|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_in, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & (placecare_om==2)|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_out, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_om_nocare, replace)

combomarginsplot file1_om_in file1_om_out file1_om_nocare, labels ("inside household care" "outside household care" "non carers") savefile(combined_ghq_place, replace)

mplotoffset using combined_ghq_place, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 50-64") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")



//////////////////////modelling 
mixed scghq1_dv part1 i.kpscore##c.part2 i.kpscore##c.part3 || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
mixed scghq1_dv part1 i.kpscore##c.part2##sex i.kpscore##c.part3##sex || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.kpscore#c.part2#sex i.kpscore#c.part3#sex
testparm i.kpscore#c.part2#sex 

gen careintensity=0 if kpscore==0
replace careintensity=1 if kpscore==1&meanhour_omg==1
replace careintensity=2 if kpscore==1&meanhour_omg==2
replace careintensity=3 if kpscore==1&meanhour_omg==3
replace careintensity=4 if kpscore==1&(meanhour_omg==4|meanhour_omg==5)

mixed scghq1_dv part1 i.careintensity##c.part2 i.careintensity##c.part3 if  kpscore==1|| hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.careintensity#c.part2 i.careintensity#c.part3 
testparm i.careintensity#c.part2 

gen careplace=0 if kpscore==0
replace careplace=2 if kpscore==1&(placecare==1|placecare==3)
replace careplace=1 if kpscore==1&placecare==2
* 1 is outside, 2 is inside 
mixed scghq1_dv part1 i.careplace##c.part2 i.careplace##c.part3 if  kpscore==1|| hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.careplace#c.part2 i.careplace#c.part3
testparm i.careplace#c.part2 
