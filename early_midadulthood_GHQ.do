/
*/
///////////////////////////////////////////////////Use the wide-care data (which was prepared for young care analysis, but with everyone in the sample)

// assign global macro to refer to Understanding Society data
global ukhls "C:\Users\baowe\Documents\EUROCARE\6614stata_8D1EEFD485763DAAACEFFA6FAD3DFEB1_V1\UKDA-6614-stata\stata\stata13_se"
// loop through the remaining waves
foreach w in a b c d e f g h i j {

	// find the wave number
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")

	// open the individual level file for that wave
	use pidp `w'_sf1 `w'_health `w'_mastat_dv `w'_jbnssec3_dv `w'_jbft_dv `w'_jbstat `w'_urban_dv `w'_jbhrs using "$ukhls\ukhls_w`waveno'/`w'_indresp", clear
	
	// sort by pidp
	sort pidp
	
	// merge with the file previously saved
	merge 1:1 pidp using "C:\Users\baowe\OneDrive - University College London\EUROCARE\2paper_GHQ\data\wide_care.dta"
	
	// drop the _merge variable - otherwise the next merge will not work
	drop _merge
	
	// sort by pidp
	sort pidp
	
	// save the file to be used in the next merge
	save "C:\Users\baowe\OneDrive - University College London\EUROCARE\2paper_GHQ\data\wide_care.dta", replace
}



// assign global macro to refer to Understanding Society data
global ukhls "C:\Users\baowe\Documents\EUROCARE\6614stata_8D1EEFD485763DAAACEFFA6FAD3DFEB1_V1\UKDA-6614-stata\stata\stata13_se"
// loop through the remaining waves
foreach w in a b c d e f g h i j {

	// find the wave number
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")

	// open the individual level file for that wave
	use pidp `w'_sf1 `w'_health `w'_mastat_dv `w'_jbnssec3_dv `w'_jbft_dv `w'_jbstat `w'_urban_dv `w'_jbhrs using "$ukhls\ukhls_w`waveno'/`w'_indresp", clear
	
	// sort by pidp
	sort pidp
	
	// merge with the file previously saved
	merge 1:1 pidp using "C:\Users\baowe\OneDrive - University College London\EUROCARE\2paper_GHQ\data\wide_care.dta"
	
	// drop the _merge variable - otherwise the next merge will not work
	drop _merge
	
	// sort by pidp
	sort pidp
	
	// save the file to be used in the next merge
	save "C:\Users\baowe\OneDrive - University College London\EUROCARE\2paper_GHQ\data\wide_care.dta", replace
}



// assign global macro to refer to Understanding Society data
global ukhls "C:\Users\baowe\Documents\EUROCARE\6614stata_8D1EEFD485763DAAACEFFA6FAD3DFEB1_V1\UKDA-6614-stata\stata\stata13_se"
// loop through the remaining waves
foreach w in a b c d e f g h i j {

	// find the wave number
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")

	// open the individual level file for that wave
	use pidp `w'_scghq1_dv `w'_sf12mcs_dv `w'_sf12pcs_dv `w'_nch14resp using "$ukhls\ukhls_w`waveno'/`w'_indresp", clear
	
	// sort by pidp
	sort pidp
	
	// merge with the file previously saved
	merge 1:1 pidp using "C:\Users\baowe\OneDrive - University College London\EUROCARE\2paper_GHQ\data\wide_care.dta"
	
	// drop the _merge variable - otherwise the next merge will not work
	drop _merge
	
	// sort by pidp
	sort pidp
	
	// save the file to be used in the next merge
	save "C:\Users\baowe\OneDrive - University College London\EUROCARE\2paper_GHQ\data\wide_care.dta", replace
}


// assign global macro to refer to Understanding Society data
global ukhls "C:\Users\baowe\Documents\EUROCARE\6614stata_8D1EEFD485763DAAACEFFA6FAD3DFEB1_V1\UKDA-6614-stata\stata\stata13_se"
// loop through the remaining waves
foreach w in a b c d e f g h i j {

	// find the wave number
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")

	// open the individual level file for that wave
	use pidp `w'_hidp using "$ukhls\ukhls_w`waveno'/`w'_indresp", clear
	
	// sort by pidp
	sort pidp
	
	// merge with the file previously saved
	merge 1:1 pidp using "C:\Users\baowe\OneDrive - University College London\EUROCARE\2paper_GHQ\data\wide_care.dta"
	
	// drop the _merge variable - otherwise the next merge will not work
	drop _merge
	
	// sort by pidp
	sort pidp
	
	// save the file to be used in the next merge
	save "C:\Users\baowe\OneDrive - University College London\EUROCARE\2paper_GHQ\data\wide_care.dta", replace
}


// assign global macro to refer to Understanding Society data
global ukhls "C:\Users\baowen\Documents\EUROCARE\UKHLS 11 waves\UKDA-6614-stata\stata\stata13_se"
// loop through the remaining waves
foreach w in a b c d e f g h i j {


	// open the individual level file for that wave
	use pidp `w'_aidhua* using "$ukhls\ukhls/`w'_indresp", clear
	
	// sort by pidp
	sort pidp
	
	// merge with the file previously saved
	merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"
	
	// drop the _merge variable - otherwise the next merge will not work
	drop _merge
	
	// sort by pidp
	sort pidp
	
	// save the file to be used in the next merge
	save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", replace
}

//////////////////////////////////////////////////////////////////////////////////////////////////
**************************************************************care related variables
////////////////////////////////////////////////////////////////////////////////////////////////

use"C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"
////////////////////gen care variable withing the age range (30-49)
foreach w in a b c d e f g h i j {
gen `w'_ymcareinhh=`w'_careinhh
replace `w'_ymcareinhh=. if `w'_age_dv>=50|`w'_age_dv<30
gen `w'_ymcareouthh=`w'_careouthh
replace `w'_ymcareouthh=. if `w'_age_dv>=50|`w'_age_dv<30
gen `w'_ymcareany=`w'_careany
replace `w'_ymcareany=. if `w'_age_dv>=50|`w'_age_dv<30
}

foreach w in a b c d e f g h i j {
label values `w'_ymcareinhh carelab
label values `w'_ymcareouthh carelab
label values `w'_ymcareany carelab
}

egen ym_times_careinhh=anycount (*_ymcareinhh),values (1)
egen ym_times_careouthh=anycount (*_ymcareouthh),values (1)
egen ym_times_careany=anycount (*_ymcareany),values (1)

drop rowmisscare
egen rowmisscare=rowmiss(*_ymcareany)
tab ym_times_careany if rowmisscare!=10

recode ym_times_careany (1/10=1), gen(ymidcare)
replace ymidcare=. if rowmisscare==10
label var ymidcare " whehther provide care 30-49y"

*-----------------------------------wave when first observed enter the young-mid age range (age range of 30-49)
gen wavefirstobv_ym=1 if a_ymcareany!=.
replace wavefirstobv_ym=2 if b_ymcareany!=.&wavefirstobv_ym==.
replace wavefirstobv_ym=3 if c_ymcareany!=.&wavefirstobv_ym==.
replace wavefirstobv_ym=4 if d_ymcareany!=.&wavefirstobv_ym==.
replace wavefirstobv_ym=5 if e_ymcareany!=.&wavefirstobv_ym==.
replace wavefirstobv_ym=6 if f_ymcareany!=.&wavefirstobv_ym==.
replace wavefirstobv_ym=7 if g_ymcareany!=.&wavefirstobv_ym==.
replace wavefirstobv_ym=8 if h_ymcareany!=.&wavefirstobv_ym==.
replace wavefirstobv_ym=9 if i_ymcareany!=.&wavefirstobv_ym==.
replace wavefirstobv_ym=10 if j_ymcareany!=.&wavefirstobv_ym==.


*-----------------------------------wave when first observed caring in  the young-mid age range (age range of 30-49)

gen wavefirstcar_ym=1 if a_ymcareany==1
replace wavefirstcar_ym=2 if b_ymcareany==1&wavefirstcar_ym==.
replace wavefirstcar_ym=3 if c_ymcareany==1&wavefirstcar_ym==.
replace wavefirstcar_ym=4 if d_ymcareany==1&wavefirstcar_ym==.
replace wavefirstcar_ym=5 if e_ymcareany==1&wavefirstcar_ym==.
replace wavefirstcar_ym=6 if f_ymcareany==1&wavefirstcar_ym==.
replace wavefirstcar_ym=7 if g_ymcareany==1&wavefirstcar_ym==.
replace wavefirstcar_ym=8 if h_ymcareany==1&wavefirstcar_ym==.
replace wavefirstcar_ym=9 if i_ymcareany==1&wavefirstcar_ym==.
replace wavefirstcar_ym=10 if j_ymcareany==1&wavefirstcar_ym==.


*-----------------------------------age when first observed care in  the young-mid age range (age range of 30-49)

gen ageonset_ym=a_age_dv if wavefirstcar_ym==1
replace ageonset_ym=b_age_dv if wavefirstcar_ym==2
replace ageonset_ym=c_age_dv if wavefirstcar_ym==3
replace ageonset_ym=d_age_dv if wavefirstcar_ym==4
replace ageonset_ym=e_age_dv if wavefirstcar_ym==5
replace ageonset_ym=f_age_dv if wavefirstcar_ym==6
replace ageonset_ym=g_age_dv if wavefirstcar_ym==7
replace ageonset_ym=h_age_dv if wavefirstcar_ym==8
replace ageonset_ym=i_age_dv if wavefirstcar_ym==9
replace ageonset_ym=j_age_dv if wavefirstcar_ym==10


recode ageonset_ym (30/31=1) (32/33=2) (34/35=3)(36/37=4) (38/39=5) (40/41=6) (42/43=7)(44/45=8)(46/47=9) (48/49=10) , gen (ageonset_ymg)
label define ageonset_ymg 1"30/31" 2"32/33" 3"34/35" 4"36/37" 5"38/39" 6"40/41" 7"42/43" 8"44/45" 9"46/47" 10"48/49"
label values ageonset_ymg ageonset_ymg
tab ageonset_ymg
egen times_careany_ym=anycount (*_ymcareany),values (1)
recode times_careany_ym (4/max=4)
tab times_careany_ym


*-----------------------------------HOURS OF CARING (INSIDE AND OUTSIDE HOUSEHOLD COMBINED)
foreach w in a b c d e f g h i j {
recode `w'_aidhrs (-10/-1=.)
 }
  /////////////////use mid point of hours
  foreach w in a b c d e f g h i j {
  gen `w'_hours_ym=2 if `w'_aidhrs==1&`w'_ymcareany!=.
  replace `w'_hours_ym=7 if `w'_aidhrs==2&`w'_ymcareany!=.
  replace `w'_hours_ym=14.5 if `w'_aidhrs==3&`w'_ymcareany!=.
  replace `w'_hours_ym=27 if `w'_aidhrs==4&`w'_ymcareany!=.
  replace `w'_hours_ym=42 if `w'_aidhrs==5&`w'_ymcareany!=.
  replace `w'_hours_ym=74.5 if `w'_aidhrs==6&`w'_ymcareany!=.
  replace `w'_hours_ym=100 if `w'_aidhrs==7&`w'_ymcareany!=.
  replace `w'_hours_ym=10 if `w'_aidhrs==8&`w'_ymcareany!=.
  replace `w'_hours_ym=34 if `w'_aidhrs==9&`w'_ymcareany!=.
  replace `w'_hours_ym=. if `w'_aidhrs==97&`w'_ymcareany!=.
  }
  egen meanhour_ym=rowmean (*_hours_ym)
  
  gen meanhour_ymg=1 if meanhour_ym<5
  replace meanhour_ymg=2 if meanhour_ym<10&meanhour_ymg==.
  replace meanhour_ymg=3 if meanhour_ym<20&meanhour_ymg==.
  replace meanhour_ymg=4 if meanhour_ym<35&meanhour_ymg==.
  replace meanhour_ymg=5 if meanhour_ym<50&meanhour_ymg==.
  replace meanhour_ymg=6 if meanhour_ym<100&meanhour_ymg==.
  replace meanhour_ymg=7 if meanhour_ym==100&meanhour_ymg==.
  label value meanhour_ymg a_aidhrs

  replace meanhour_ymg=0 if ymidcare==0
   recode meanhour_ymg (5/7=5)
   
   
*--------------------------------------------------------------------------------
*----------------------------------- NUMBER PEOPLE CARING FOR
*-----------------------------------------------------------------------------------

foreach w in a b c d e f g h i j {
forvalues x=1/16 {
gen `w'_person`x'_ym=1 if `w'_aidhua`x'==1
replace `w'_person`x'_ym=0 if `w'_aidhua`x'!=1
}

clonevar `w'_peopleout_ym=`w'_naidxhh
recode `w'_peopleout_ym min/-1=0
gen `w'_numcare_ym=(`w'_peopleout_ym+`w'_person1_ym+`w'_person2_ym+`w'_person3_ym+`w'_person4_ym+`w'_person5_ym+`w'_person6_ym+`w'_person7_ym+`w'_person8_ym+`w'_person9_ym ///
	+`w'_person10_ym+`w'_person11_ym+`w'_person12_ym+`w'_person13_ym+`w'_person14_ym+`w'_person15_ym+`w'_person16_ym)
replace `w'_numcare_ym=0 if `w'_ymcareany==0
replace `w'_numcare_ym=. if `w'_ymcareany==.
}

egen meannum_ym=rowmean(*_numcare_ym)
* round it up
gen meannumcar_ym=ceil(meannum_ym)
recode meannumcar_ym (3/max=3) (0=1), gen (meannumcar_ymg)
*0:n=37
*--------------------------------------------------------------------------------
*----------------------------------- CARE PLACE
*-----------------------------------------------------------------------------------
 egen anyinhh_ym=rowmin(*_ymcareinhh)
  egen anyouthh_ym=rowmin(*_ymcareouthh)
 
 gen placecare_ym=0 if ymidcare==0
 replace placecare_ym=1 if anyinhh_ym==1 & anyouthh_ym!=1
 replace placecare_ym=2 if anyouthh_ym==1 & anyinhh_ym!=1
 replace placecare_ym=3 if anyinhh_ym==1 & anyouthh_ym==1
 
 label define placecare_ym 0"no care" 1" in hh" 2" out hh" 3" both in and out hh"
 label values placecare_ym placecare_ym
 
 
 *------------------------------------------------------------------------------------
 *--------------------------------------DURATION OF CARE
 *--------------------------------------------------------------------------------------
 
 use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"
foreach w in a b c d e f g h i j {
gen `w'_age_care_ym=`w'_age_dv 
replace `w'_age_care_ym=. if `w'_ymcareany!=1
}

egen lastage_ym=rowmax(*_age_care_ym)
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", replace

*reshape it to long format to extend their duration >=50
keep pidp lastage_ym *age_dv *_ymcareany *_careany
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\extendduration_ym.dta"
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

reshape long age_dv ymcareany careany, i(pidp) j(wave)
gen agefinal=50 if careany==1&age_dv==50&lastage_ym==49
sort pidp agefinal
by pidp:replace agefinal=agefinal[1]
gen agefinal2=51 if careany==1&age_dv==51&lastage_ym==49
sort pidp agefinal2
by pidp:replace agefinal2=agefinal2[1]
gen agefinal3=52 if careany==1&age_dv==52&lastage_ym==49
sort pidp agefinal3
by pidp:replace agefinal3=agefinal3[1]
gen agefinal4=53 if careany==1&age_dv==53&lastage_ym==49
sort pidp agefinal4
by pidp:replace agefinal4=agefinal4[1]
gen agefinal5=54 if careany==1&age_dv==54&lastage_ym==49
sort pidp agefinal5
by pidp:replace agefinal5=agefinal5[1]
gen agefinal6=55 if careany==1&age_dv==55&lastage_ym==49
sort pidp agefinal6
by pidp:replace agefinal6=agefinal6[1]
gen agefinal7=56 if careany==1&age_dv==56&lastage_ym==49
sort pidp agefinal7
by pidp:replace agefinal7=agefinal7[1]
gen agefinal8=57 if careany==1&age_dv==57&lastage_ym==49
sort pidp agefinal8
by pidp:replace agefinal8=agefinal8[1]
gen agefinal9=58 if careany==1&age_dv==58&lastage_ym==49
sort pidp agefinal9
by pidp:replace agefinal9=agefinal9[1]

gen ageextend=agefinal
recode ageextend 50=51 if agefinal2==51
recode ageextend 51=52 if agefinal3==52
recode ageextend 52=53 if agefinal4==53
recode ageextend 53=54 if agefinal5==54
recode ageextend 54=55 if agefinal6==55
recode ageextend 55=56 if agefinal7==56
recode ageextend 56=57 if agefinal8==57
recode ageextend 57=58 if agefinal9==58

keep if wave==1
rename ageextend ageextend_ym
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\extendduration_long_ym.dta",replace
erase  "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\extendduration_ym.dta"


use"C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\extendduration_long_ym.dta", keepusing (ageextend_ym)
drop _merge

gen extendyear_ym=ageextend_ym-49

gen duration_ym=ym_times_careany
replace duration_ym=duration_ym+extendyear_ym if extendyear_ym!=.
gen duration_ymg=duration_ym
recode duration_ymg 4/max=4
replace duration_ymg=. if ymidcare==.

//////////////////////////////////////////////////////////////////////////////////////////////////
**************************************************************time varying covariance
////////////////////////////////////////////////////////////////////////////////////////////////



******************************************hhincome use baseline within the age range (i.e first wave when interviewed between 30 and 49)
tokenize "`c(alpha)'"
gen hhincome_1obym=a_netinc if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace hhincome_1obym=``waveno''_netinc if wavefirstobv_ym==`waveno'
}
xtile incomqu_1obym=hhincome_1obym, n(5)

//////////////////////////////////////////////employment status
tokenize "`c(alpha)'"
gen jbstatus_1ob_ym=a_jbstat if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace jbstatus_1ob_ym=``waveno''_jbstat if wavefirstobv_ym==`waveno'
}

label value jbstatus_1ob_ym j_jbstat

recode jbstatus_1ob_ym  (11=9) (10=97)
recode jbstatus_1ob_ym  (5=2)
recode jbstatus_1ob_ym  (1=2) (9=7)
recode jbstatus_1ob_ym (min/-1=.)

*******************************************
////////////////////////////////////////////////////////nssec
tokenize "`c(alpha)'"
gen class_1ob_ym=a_jbnssec3_dv if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace class_1ob_ym=``waveno''_jbnssec3_dv if wavefirstobv_ym==`waveno'
}

label value class_1ob_ym a_jbnssec3_dv
replace class_1ob_ym=0 if jbstatus_1ob_ym==3
replace class_1ob_ym=0 if jbstatus_1ob_ym==4
replace class_1ob_ym=0 if jbstatus_1ob_ym>=6&jbstatus_1ob_ym<.
recode class_1ob_ym (min/-1=.)

//////////////////////////////////////////////////////// FT/PT

tokenize "`c(alpha)'"
gen workhour_1ob_ym=a_jbft_dv if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace workhour_1ob_ym=``waveno''_jbft_dv if wavefirstobv_ym==`waveno'
}
label value workhour_1ob_ym a_jbft_dv

replace workhour_1ob_ym=0 if (jbstatus_1ob_ym==3|jbstatus_1ob_ym==4)
replace workhour_1ob_ym=0 if jbstatus_1ob_ym>=6&jbstatus_1ob_ym<.
/*
foreach w in a b c d e f g h i j {
recode `w'_jbhrs (0/30=1) (30.01/40=2) (40/max=3), gen (`w'_workfp)
}
*/

tokenize "`c(alpha)'"
gen workfp_1ob_ym=a_workfp if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace workfp_1ob_ym=``waveno''_workfp if wavefirstobv_ym==`waveno'
}

replace workfp_1ob_ym=0 if jbstatus_1ob_ym==3
replace workfp_1ob_ym=0 if jbstatus_1ob_ym>=6&jbstatus_1ob_ym<.
recode workfp_1ob_ym (min/-1=.)
replace workfp_1ob_ym=workhour_1ob_ym if workfp_1ob_ym==.

label define workfp_1ob_ym 0"not working" 1"PT" 2"FT" 3"FT,long wh"
label values workfp_1ob_ym workfp_1ob_ym
recode workfp_1ob_ym (min/-1=.)

/////////////////////////////////////////////combine FT/PT with employment status
replace workfp_1ob_ym=0 if class_1ob_ym==0
*2 changes
gen workcom_ym=workfp_1ob_ym
replace workcom_ym=4 if jbstatus_1ob_ym==3
replace workcom_ym=5 if jbstatus_1ob_ym==4
replace workcom_ym=6 if jbstatus_1ob_ym==6
replace workcom_ym=7 if jbstatus_1ob_ym==7
replace workcom_ym=8 if jbstatus_1ob_ym==8
replace workcom_ym=9 if jbstatus_1ob_ym==97
label define workcom_ym 0"not working" 1"PT" 2"FT" 3"FT,long wh" 4"Unemployed" 5 "Retired"  6"Family care"  7"Full-time student"  8"LT sick" 9 "something else"
label values workcom_ym workcom_ym

///////////////////////////////////////////////////marriage
tokenize "`c(alpha)'"
gen marriage_1ob_ym=a_mastat_dv if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace marriage_1ob_ym=``waveno''_mastat_dv if wavefirstobv_ym==`waveno'
}
recode marriage_1ob_ym (min/-1=.)
recode marriage_1ob_ym 0=1 3=2 4/5=3 7/8=3 10=4
label define marriage_1ob_ym ///
1"single" 2"married" 3"seperated" 4"live as couple" 6"widowed"

label value marriage_1ob_ym marriage_1ob_ym

************************************age at baseline
tokenize "`c(alpha)'"
gen age_1ob_ym=a_age_dv if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace age_1ob_ym=``waveno''_age_dv if wavefirstobv_ym==`waveno'
}
************************************number of children in hh by age

*nch02_dv nch34_dv nch511_dv 

tokenize "`c(alpha)'"
gen children_ym=a_nchild_dv  if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace children_ym=``waveno''_nchild_dv  if wavefirstobv_ym==`waveno'
}

gen children_1ob_ym=children_ym
recode children_1ob_ym (3/max=3)
recode children_1ob_ym (min/-1=.)

***************************************urban/rural
tokenize "`c(alpha)'"
gen urban_1ob_ym=a_urban_dv if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace urban_1ob_ym=``waveno''_urban_dv if wavefirstobv_ym==`waveno'
}

recode urban_1ob_ym (min/-1=.)

*************************waves have been participated
egen wavesobs_ym=anycount (*age_dv), values(30/49)

////////////////////////////////////////////////////////////////////////////////
**********************************************time-invariate variables
////////////////////////////////////////////////////////////////////////////////

/*
**********************************parental highest edu (when R at age 14) whoever is the highest in the hh
egen parenedu_h=rowmin(motherquali fatherquali)
label define parenedu ///
5 "degree or higher" 4"lower than degree" 3" some quali" 2"no quali" 99"not in hh"
label values parenedu_h parenedu
label var parenedu_h "parental highest edu"
*/

tab  parenedu_h 

save "C:\Users\baowe\OneDrive - University College London\EUROCARE\2paper_GHQ\data\wide_care.dta", replace



//////////////////////////////////////////////////////////////////////////////////////////////////
*******************************************************prepare the data for 1:2 matching
//////////////////////////////////////////////////////////////////////////////////////////////////

use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"
/////////////////////////////////////baseline hidp


keep if ymidcare!=.
keep pidp yougcare *age_dv ymidcare sex ethnicity parenclass_h incomqu_1obym age_1ob_ym agemin ///
agemax ageonset_ym wavesobs_ym higestedu children_1ob_ym  *_scghq1_dv *_sf12mcs_dv *_sf12pcs_dv *_ymcareany  *_age_dv wavefirstcar_ym psu strata ///
class_1ob_ym  workcom_ym marriage_1ob_ym age_1ob_ym wavefirstobv_ym urban_1ob_ym children_1ob_ym   *_hidp


/////////////select sample who have participated the survey once before and once after the care onset, and never care in young adulhood (<30)
gen samplepiece=1 if agemin<ageonset_ym & agemax>=ageonset_ym & ageonset_ym!=. 
drop if samplepiece!=1&ymidcare==1
drop if yougcare==1


////////////////no. people in the same hh
tokenize "`c(alpha)'"
gen hhid_1obya=a_hidp if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace hhid_1obya=``waveno''_hidp if wavefirstobv_ym==`waveno'
}

sort hhid_1obya pidp
by hhid_1obya: gen nucarehh=[_N]


//////////////baseline outcome

tokenize "`c(alpha)'"
gen ghq_1ob_ym=a_scghq1_dv if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace ghq_1ob_ym=``waveno''_scghq1_dv if wavefirstobv_ym==`waveno'
}
recode ghq_1ob_ym (min/-1=.)

tokenize "`c(alpha)'"
gen sfm_1ob_ym=a_sf12mcs_dv if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace sfm_1ob_ym=``waveno''_sf12mcs_dv if wavefirstobv_ym==`waveno'
}
recode sfm_1ob_ym (min/-1=.)

tokenize "`c(alpha)'"
gen sfp_1ob_ym=a_sf12pcs_dv if wavefirstobv_ym==1
forval waveno = 2/10 {
  replace sfp_1ob_ym=``waveno''_sf12pcs_dv if wavefirstobv_ym==`waveno'
}
recode sfp_1ob_ym (min/-1=.)



*combine small n categories
recode workcom_ym 5=4

recode parenclass_h (100=.)


mdesc age_1ob_ym  sex ethnicity incomqu_1obym class_1ob_ym  workcom_ym marriage_1ob_ym ///
parenclass_h urban_1ob_ym children_1ob_ym higestedu ghq_1ob_ym if ymidcare==1


kmatch ps ymidcare age_1ob_ym i.ethnicity i.incomqu_1obym i.class_1ob_ym i.workcom_ym i.marriage_1ob_ym i.parenclass_h i.urban_1ob_ym i.children_1ob_ym i.higestedu i.wavesobs  (ghq_1ob_ym), ematch(sex) nn(2) idgenerate(controlid) idvar(pidp)generate(kpscore)

tab kpscore if _KM_nm>=1
recode ageonset_ym .=0

*matched control 1
gen double id1=controlid1
replace id1=pidp if kpscore==0
gen ageonset2=ageonset_ym if kpscore==1
sort id1 ageonset2
by id1: replace ageonset2=ageonset2[1]
gen ageonset_g1= ageonset2 if kpscore==0
*matched control 2
gen double id2=controlid2
replace id2=pidp if kpscore==0
gen ageonset3=ageonset_ym if kpscore==1
sort id2 ageonset3
by id2: replace ageonset3=ageonset3[1]
gen ageonset_g2=ageonset3 if kpscore==0
*matched control 3
gen double id3=controlid3
replace id3=pidp if kpscore==0
gen ageonset4=ageonset_ym if kpscore==1
sort id3 ageonset4
by id3: replace ageonset4=ageonset4[1]
gen ageonset_g3=ageonset4 if kpscore==0

*matched control 4
gen double id4=controlid4
replace id4=pidp if kpscore==0
gen ageonset5=ageonset_ym if kpscore==1
sort id4 ageonset5
by id4: replace ageonset5=ageonset5[1]
gen ageonset_g4=ageonset5 if kpscore==0


gen ageonset_all=ageonset_ym
replace ageonset_all=ageonset_g1 if ageonset_g1!=. & ageonset_all==0
replace ageonset_all=ageonset_g2 if ageonset_g1==.& ageonset_all==0




save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_ym.dta"
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_ym.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", keepus(meanhour_ymg placecare_ym)
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

keep pidp *age_dv  *scghq1_dv  ageonset_all ymidcare age_1ob_ym agemax agemin kpscore sex hhid_1obya meanhour_ymg placecare_ym

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
* generate 3 pieces
mkspline part1 7 part2 8 part3 = poyrtoset,marginal
showcoding yrtoset poyrtoset part1 part2 part3

/////////////////////////////////graphs for yes/no care
mixed scghq1_dv i.poyrtoset if kpscore==1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_yn, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_ym_yn, replace)
combomarginsplot file1_ym_yn file2_ym_yn, labels ("carers" "non carers") savefile(combined_ghq_yn, replace)

mplotoffset using combined_ghq_yn, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 30-49") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")



/////////////////////////////////graphs for yes/no care by sex
mixed scghq1_dv i.poyrtoset if kpscore==1 & sex==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_yn_m, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & sex==1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_ym_yn_m, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & sex==2|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_yn_f, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & sex==2 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_ym_yn_f, replace)
combomarginsplot file1_ym_yn_m file2_ym_yn_m file1_ym_yn_f file2_ym_yn_f, labels ("male carers" "male non carers" "female carers" "female non carers") savefile(combined_ghq_yn_sex, replace)

mplotoffset using combined_ghq_yn_sex, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 30-49") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")



/////////////////////////////////graphs for care intensity (small N at left end, excluded)
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_ymg==1&poyrtoset!=0|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_low, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_ymg==2&poyrtoset!=0|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_lmid, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_ymg==3&poyrtoset!=0|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_mid, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & poyrtoset!=0 & (meanhour_ymg==4|meanhour_ymg==5) || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_hig, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & poyrtoset!=0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_ncare, replace)
combomarginsplot file1_ym_low file1_ym_lmid file1_ym_mid file1_ym_hig file1_ym_ncare, labels ("<5h per week" "5-9h per week" "10-19h per week" "20+h per week" "non carers") savefile(combined_ghq_intensity, replace)

mplotoffset using combined_ghq_intensity, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 30-49") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")


/////////////////////////////////graphs for care place

mixed scghq1_dv i.poyrtoset if kpscore==1 & (placecare_ym==1|placecare_ym==3)|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_in, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & (placecare_ym==2)|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_out, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ym_nocare, replace)

combomarginsplot file1_ym_in file1_ym_out file1_ym_nocare, labels ("inside household care" "outside household care" "non carers") savefile(combined_ghq_place, replace)

mplotoffset using combined_ghq_place, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 30-49") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")



//////////////////////modelling 
mixed scghq1_dv part1 i.kpscore##c.part2 i.kpscore##c.part3 || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
mixed scghq1_dv part1 i.kpscore##c.part2##sex i.kpscore##c.part3##sex || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.kpscore#c.part2#sex i.kpscore#c.part3#sex


gen careintensity=0 if kpscore==0
replace careintensity=1 if kpscore==1&meanhour_ymg==1
replace careintensity=2 if kpscore==1&meanhour_ymg==2
replace careintensity=3 if kpscore==1&meanhour_ymg==3
replace careintensity=4 if kpscore==1&(meanhour_ymg==4|meanhour_ymg==5)

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


