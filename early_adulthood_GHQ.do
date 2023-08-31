/////////////////////////////////////////////////////////////////////////////////////////////////////////////
 *----------------------------------PREPARE WIDE DATASET
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// change current file location
cd "C:\Users\baowen\Documents\EUROCARE\"
// assign global macro to refer to Understanding Society data
global ukhls "C:\Users\baowen\Documents\EUROCARE\UKHLS 11 waves\UKDA-6614-stata\stata\stata13_se"
// open the individual level file for wave 1 containing the variables to use
use pidp a_aidhh a_aidxhh a_age_dv a_sf1 a_health a_mastat_dv a_jbnssec3_dv a_jbft_dv a_jbstat ///
	a_jbhrs a_aidhua* a_naidxhh a_aidhu* a_aidhrs a_aideft a_sex_dv  a_ethn_dv ///
	a_indinus_xw a_psu a_strata a_qfhigh a_qfhigh_dv a_hiqual_dv a_urban_dv ///
	 a_manssec8_dv a_panssec8_dv a_paju a_maju  ///
	 a_aidhua* a_naidxhh a_aidhu* a_aidhrs a_aideft a_naidxhh ///
	 a_sex_dv  a_ethn_dv a_memorig using "$ukhls\ukhls\a_indresp", clear
//sort by pidp and save
sort pidp
save wide_care, replace

// loop through the remaining waves
foreach w in b c d e f g h i j k{
	// find the wave number
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
	// open the individual level file for that wave
	use pidp `w'_aidhh `w'_aidxhh `w'_age_dv `w'_scsf1 `w'_sf1 `w'_health `w'_mastat_dv `w'_jbnssec3_dv `w'_jbft_dv `w'_jbstat ///
	`w'_jbhrs `w'_aidhua* `w'_naidxhh `w'_aidhu* `w'_aidhrs `w'_aideft `w'_sex_dv  `w'_ethn_dv ///
	 `w'_indinub_xw `w'_psu `w'_strata `w'_qfhigh `w'_qfhigh_dv `w'_hiqual_dv `w'_urban_dv ///
	 `w'_manssec8_dv `w'_panssec8_dv `w'_paju `w'_maju ///
	 `w'_aidhua* `w'_naidxhh `w'_aidhu* `w'_aidhrs `w'_aideft `w'_naidxhh ///
	 `w'_sex_dv  `w'_ethn_dv `w'_memorig using "$ukhls\ukhls/`w'_indresp", clear
	// sort by pidp
	sort pidp
	// merge with the file previously saved
	merge 1:1 pidp using wide_care_demres
	// drop the _merge variable - otherwise the next merge will not work
	drop _merge
	// sort by pidp
	sort pidp
	// save the file to be used in the next merge
	save wide_care, replace
}
*---------------------------------GENERATE CARE VARIABLE (YES/NO) AT EACH WAVE
foreach w in a b c d e f g h i j k{
recode `w'_aidhh (-9/-1=.), gen (`w'_careinhh)
recode `w'_aidxhh(-10/-1=.), gen (`w'_careouthh)
gen `w'_careany=1 if `w'_careinhh==1|`w'_careouthh==1
replace `w'_careany=2 if `w'_careinhh==2&`w'_careouthh==2
replace `w'_careany=2 if `w'_careinhh==2&`w'_careouthh==.
replace `w'_careany=2 if `w'_careinhh==.&`w'_careouthh==2
}

label define carelab 1"yes" 2"no"
foreach w in a b c d e f g h i j k{
label values `w'_careinhh carelab
label values `w'_careouthh carelab
label values `w'_careany carelab
}

**gen care variable withing the age range (16-30), so young carers
foreach w in a b c d e f g h i j k{
gen `w'_ycareinhh=`w'_careinhh
replace `w'_ycareinhh=. if `w'_age_dv>=30|`w'_age_dv<0
gen `w'_ycareouthh=`w'_careouthh
replace `w'_ycareouthh=. if `w'_age_dv>=30|`w'_age_dv<0
gen `w'_ycareany=`w'_careany
replace `w'_ycareany=. if `w'_age_dv>=30|`w'_age_dv<0
}

foreach w in a b c d e f g h i j k{
label values `w'_ycareinhh carelab
label values `w'_ycareouthh carelab
label values `w'_ycareany carelab
}

*------------------------- CARE PLACE 
label define careplace 1"inside" 2"outside" 3"both inside and outside"
foreach w in a b c d e f g h i j k{
gen `w'_careplace=1 if `w'_ycareinhh==1
replace `w'_careplace=2 if `w'_ycareouthh==1
replace `w'_careplace=3 if `w'_ycareouthh==1&`w'_ycareinhh==1
label value `w'_careplace careplace
}

*-----------------------------CARE VARIABLE (YES/N0) ACROSS WAVES
egen times_careinhh=anycount (*_ycareinhh),values (1)
egen times_careouthh=anycount (*_ycareouthh),values (1)
egen times_careany=anycount (*_ycareany),values (1)

egen rowmisscare=rowmiss(*_ycareany)
recode times_careany (1/10=1), gen(youngcare)
replace youngcare=. if rowmisscare==10
label var youngcare "provide care before age 30 in any observed wave"
label define youngcare 0"no care at any wave" 1" care at at least one wave"
label value youngcare  youngcare 
 
 
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta",replace
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"


*-----------------------------FIRST OBSERVED FLAG VARIABLES
**wave when first observed caring
gen wavefirstcar=1 if a_ycareany==1
replace wavefirstcar=2 if b_ycareany==1&wavefirstcar==.
replace wavefirstcar=3 if c_ycareany==1&wavefirstcar==.
replace wavefirstcar=4 if d_ycareany==1&wavefirstcar==.
replace wavefirstcar=5 if e_ycareany==1&wavefirstcar==.
replace wavefirstcar=6 if f_ycareany==1&wavefirstcar==.
replace wavefirstcar=7 if g_ycareany==1&wavefirstcar==.
replace wavefirstcar=8 if h_ycareany==1&wavefirstcar==.
replace wavefirstcar=9 if i_ycareany==1&wavefirstcar==.
replace wavefirstcar=10 if j_ycareany==1&wavefirstcar==.

**wave when first observed (yes or no caring)
gen wavefirstobv=1 if a_ycareany!=.
replace wavefirstobv=2 if b_ycareany!=.&wavefirstobv==.
replace wavefirstobv=3 if c_ycareany!=.&wavefirstobv==.
replace wavefirstobv=4 if d_ycareany!=.&wavefirstobv==.
replace wavefirstobv=5 if e_ycareany!=.&wavefirstobv==.
replace wavefirstobv=6 if f_ycareany!=.&wavefirstobv==.
replace wavefirstobv=7 if g_ycareany!=.&wavefirstobv==.
replace wavefirstobv=8 if h_ycareany!=.&wavefirstobv==.
replace wavefirstobv=9 if i_ycareany!=.&wavefirstobv==.
replace wavefirstobv=10 if j_ycareany!=.&wavefirstobv==.

**age when first observed
gen agefirstobv=a_age_dv if wavefirstobv==1
replace agefirstobv=b_age_dv if wavefirstobv==2
replace agefirstobv=c_age_dv if wavefirstobv==3
replace agefirstobv=d_age_dv if wavefirstobv==4
replace agefirstobv=e_age_dv if wavefirstobv==5
replace agefirstobv=f_age_dv if wavefirstobv==6
replace agefirstobv=g_age_dv if wavefirstobv==7
replace agefirstobv=h_age_dv if wavefirstobv==8
replace agefirstobv=i_age_dv if wavefirstobv==9
replace agefirstobv=j_age_dv if wavefirstobv==10

**age when first observed care
gen ageonset=a_age_dv if wavefirstcar==1
replace ageonset=b_age_dv if wavefirstcar==2
replace ageonset=c_age_dv if wavefirstcar==3
replace ageonset=d_age_dv if wavefirstcar==4
replace ageonset=e_age_dv if wavefirstcar==5
replace ageonset=f_age_dv if wavefirstcar==6
replace ageonset=g_age_dv if wavefirstcar==7
replace ageonset=h_age_dv if wavefirstcar==8
replace ageonset=i_age_dv if wavefirstcar==9
replace ageonset=j_age_dv if wavefirstcar==10
replace ageonset=0 if youngcare==0

*-------------------------------DURATION OF CARE
*For those who were caring at age 29 (n=612), we don't want the artifical cut-off point at 29
*So we extend their duration of care unitil the end of this caring episode

foreach w in a b c d e f g h i j {
gen `w'_age_care=`w'_age_dv 
replace `w'_age_care=. if `w'_ycareany!=1
}
egen lastage=rowmax(*_age_care)
tab lastage if youngcare==1
save "wide_care.dta"

*reshape it to long format to extend their duration
keep pidp lastage *age_dv *_ycareany *_careany
save "extendduration.dta"
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

reshape long age_dv ycareany careany, i(pidp) j(wave)
gen agefinal=30 if careany==1&age_dv==30&lastage==29
sort pidp agefinal
by pidp:replace agefinal=agefinal[1]
gen agefinal2=31 if careany==1&age_dv==31&lastage==29
sort pidp agefinal2
by pidp:replace agefinal2=agefinal2[1]
gen agefinal3=32 if careany==1&age_dv==32&lastage==29
sort pidp agefinal3
by pidp:replace agefinal3=agefinal3[1]
gen agefinal4=33 if careany==1&age_dv==33&lastage==29
sort pidp agefinal4
by pidp:replace agefinal4=agefinal4[1]
gen agefinal5=34 if careany==1&age_dv==34&lastage==29
sort pidp agefinal5
by pidp:replace agefinal5=agefinal5[1]
gen agefinal6=35 if careany==1&age_dv==35&lastage==29
sort pidp agefinal6
by pidp:replace agefinal6=agefinal6[1]
gen agefinal7=36 if careany==1&age_dv==36&lastage==29
sort pidp agefinal7
by pidp:replace agefinal7=agefinal7[1]
gen agefinal8=37 if careany==1&age_dv==37&lastage==29
sort pidp agefinal8
by pidp:replace agefinal8=agefinal8[1]
gen agefinal9=38 if careany==1&age_dv==38&lastage==29
sort pidp agefinal9
by pidp:replace agefinal9=agefinal9[1]

gen ageextend=agefinal
recode ageextend 30=31 if agefinal2==31
recode ageextend 31=32 if agefinal3==32
recode ageextend 32=33 if agefinal4==33
recode ageextend 33=34 if agefinal5==34
recode ageextend 34=35 if agefinal6==35
recode ageextend 35=36 if agefinal7==36
recode ageextend 36=37 if agefinal8==37
recode ageextend 37=38 if agefinal9==38
keep if wave==1
save"extendage_long.dta"

use "wide_care.dta"
merge 1:1 pidp using "extendage_long.dta", keepusing (ageextend)
drop _merge
gen extendyear=ageextend-29

gen duration=times_careany
replace duration=duration+extendyear if extendyear!=.

gen care_3g=duration
recode care_3g (2/max=2)
label define care_3g 0"no care" 1"care 1 w" 2"care 2+w"
label values care_3g care_3g  


 
*-----------------------------------HOURS OF CARING (INSIDE AND OUTSIDE HOUSEHOLD COMBINED)
foreach w in a b c d e f g h i j {
recode `w'_aidhrs (-10/-1=.)
 }
  /////////////////use mid point of hours
  foreach w in a b c d e f g h i j {
  gen `w'_hours=2 if `w'_aidhrs==1&`w'_ycareany!=.
  replace `w'_hours=7 if `w'_aidhrs==2&`w'_ycareany!=.
  replace `w'_hours=14.5 if `w'_aidhrs==3&`w'_ycareany!=.
  replace `w'_hours=27 if `w'_aidhrs==4&`w'_ycareany!=.
  replace `w'_hours=42 if `w'_aidhrs==5&`w'_ycareany!=.
  replace `w'_hours=74.5 if `w'_aidhrs==6&`w'_ycareany!=.
  replace `w'_hours=100 if `w'_aidhrs==7&`w'_ycareany!=.
  replace `w'_hours=10 if `w'_aidhrs==8&`w'_ycareany!=.
  replace `w'_hours=34 if `w'_aidhrs==9&`w'_ycareany!=.
  replace `w'_hours=. if `w'_aidhrs==97&`w'_ycareany!=.
  }
  egen meanhour=rowmean (*_hours)
  
  gen meanhour_g=1 if meanhour<5
  replace meanhour_g=2 if meanhour<10&meanhour_g==.
  replace meanhour_g=3 if meanhour<20&meanhour_g==.
  replace meanhour_g=4 if meanhour<35&meanhour_g==.
  replace meanhour_g=5 if meanhour<50&meanhour_g==.
  replace meanhour_g=6 if meanhour<100&meanhour_g==.
  replace meanhour_g=7 if meanhour==100&meanhour_g==.
  label value meanhour_g a_aidhrs

  replace meanhour_g=0 if youngcare==0
  recode meanhour_g (5/7=5)

*------------------------------------AGE ONSET OF CARE
recode ageonset (16/17=1)(18/19=2)(20/21=3)(22/23=4)(24/25=5)(26/27=6) (28/29=7),gen(ageonset_g)
label define ageonset_g ///
1"16/17" 2"18/19" 3"20/21" 4"22/23" 5"24/25" 6"26/27" 7"28/29"
label value ageonset_g ageonset_g
save "wide_care.dta",replace

*------------------------------------------------------
*------------------------------------RECIPENT OF CARE
*-------------------------------------------------------
//START WITH WAVE 1

use ukhls\a_indresp.dta
keep pidp a_aidhua* a_hidp a_pno
forvalues x=1/16 {
recode a_aidhua`x' -9/-1=.
	}
reshape long a_aidhua , i(pidp) j(pnocaree)
save Wacarer, replace 

use ukhls\a_egoalt.dta
*apno is alter person number
gen pnocaree=a_apno
merge 1:1 pidp pnocaree using Wacarer, keepusing(a_aidhua)
keep if _merge==3
*_relationship is ego's relationship to alter (so switch childen and parent, grandchildren and grandparents)
gen parentWa=1 if a_aidhua==1 & (a_relationship==4|a_relationship==5|a_relationship==6|a_relationship==7| ///
	a_relationship==8)	
gen childWa=1 if a_aidhua==1 & (a_relationship==9|a_relationship==10|a_relationship==11| ///
	a_relationship==12|a_relationship==13)
gen partnerWa=1 if a_aidhua==1 & (a_relationship==1|a_relationship==2|a_relationship==3)
gen grandWa=1 if a_aidhua==1 & a_relationship==20
gen brosisWa=1 if a_aidhua==1 & (a_relationship>=14 & a_relationship<=19)
gen othrelativeWa=1 if a_aidhua==1 & (a_relationship>=21& a_relationship<=25)
gen nonrelativeWa=1 if a_aidhua==1 & (a_relationship>25& a_relationship<=30)
keep pidp parent child partner grand brosis oth a_aidhua pnocaree a_aidhua a_relationship nonrelativeWa
net from https://www.sealedenvelope.com/
*need to install xfill
xfill childWa, i(pidp)
xfill parentWa, i(pidp)
xfill partnerWa, i(pidp)
xfill othrelativeWa, i(pidp)
xfill nonrelativeWa, i(pidp)
xfill brosisWa, i(pidp)
xfill grandWa,i(pidp)

replace parentWa=0 if parentWa==.
replace childWa=0 if childWa==.
replace partnerWa=0 if partnerWa==.
replace brosisWa=0 if brosisWa==.
replace grandWa=0 if grandWa==.
replace othrelativeWa=0 if othrelativeWa==.
replace nonrelativeWa=0 if nonrelativeWa==.
bysort pidp: keep if _n==1
save recipent.dta
//GO THROUGH OTHER WAVES TO GEN RECIPENT VARIABLES

// assign global macro to refer to Understanding Society data
global ukhls "C:\Users\baowen\Documents\EUROCARE\UKHLS 11 waves\UKDA-6614-stata\stata\stata13_se"
// loop through the remaining waves
foreach w in b c d e f g h i j {
	// open the individual level file for that wave
	use "$ukhls\ukhls/`w'_indresp", clear	
	keep pidp `w'_aidhua* `w'_hidp `w'_pno
	
forvalues x=1/16 {
recode `w'_aidhua`x' -9/-1=.
	}	
	
reshape long `w'_aidhua , i(pidp) j(pnocaree)
save W`w'carer, replace 
}
foreach w in b c d e f g h i j {
use "$ukhls\ukhls/`w'_egoalt"
gen pnocaree=`w'_apno
merge 1:1 pidp pnocaree using W`w'carer, keepusing(`w'_aidhua)
keep if _merge==3
gen parentW`w'=1 if `w'_aidhua==1 & (`w'_relationship==4|`w'_relationship==5|`w'_relationship==6|`w'_relationship==7| ///
	`w'_relationship==8)
gen childW`w'=1 if `w'_aidhua==1 & (`w'_relationship==9|`w'_relationship==10|`w'_relationship==11| ///
	`w'_relationship==12|`w'_relationship==13)
gen partnerW`w'=1 if `w'_aidhua==1 & (`w'_relationship==1|`w'_relationship==2|`w'_relationship==3)
gen grandW`w'=1 if `w'_aidhua==1 & `w'_relationship==20
gen brosisW`w'=1 if `w'_aidhua==1 & (`w'_relationship>=14 & `w'_relationship<=19)
gen othrelativeW`w'=1 if `w'_aidhua==1 & (`w'_relationship>=21& `w'_relationship<=25)
gen nonrelativeW`w'=1 if `w'_aidhua==1 & (`w'_relationship>25& `w'_relationship<=30)

keep pidp parent child partner grand brosis `w'_aidhua pnocaree `w'_relationship othrelativeW`w' nonrelativeW`w'
xfill childW`w', i(pidp)
xfill parentW`w', i(pidp)
xfill partnerW`w', i(pidp)
xfill brosisW`w', i(pidp)
xfill grandW`w',i(pidp)
xfill othrelativeW`w', i(pidp)
xfill nonrelativeW`w', i(pidp)

replace parentW`w'=0 if parentW`w'==.
replace childW`w'=0 if childW`w'==.
replace partnerW`w'=0 if partnerW`w'==.
replace brosisW`w'=0 if brosisW`w'==.
replace grandW`w'=0 if grandW`w'==.
replace othrelativeW`w'=0 if othrelativeW`w'==.
replace nonrelativeW`w'=0 if nonrelativeW`w'==.

bysort pidp: keep if _n==1
save recipent`w'.dta
}


// merge all waves into one
foreach w in b c d e f g h i j {

	// open the individual level file for that wave
	use pidp parent child partner grand brosis othrelative nonrelative using "$ukhls/recipent`w'", clear
	
	// sort by pidp
	sort pidp 
	
	// merge with the file previously saved
	merge 1:1 pidp using recipent
	
	// drop the _merge variable - otherwise the next merge will not work
	drop _merge
	
	// sort by pidp
	sort pidp
	
	// save the file to be used in the next merge
	save recipent, replace
}
use recipent.dta
merge 1:1 pidp using "C:\Users\baowen\Documents\EUROCARE\wide_care.dta", keepusing (*_ycareany)
drop if _merge==2
drop _merge
foreach w in a b c d e f g h i j {
	replace parentW`w'=. if `w'_ycareany==.
	replace childW`w'=. if `w'_ycareany==.
	replace partnerW`w'=. if `w'_ycareany==.
	replace grandW`w'=. if `w'_ycareany==.
	replace brosisW`w'=. if `w'_ycareany==.
	replace othrelativeW`w'=. if `w'_ycareany==.
	replace nonrelativeW`w'=. if `w'_ycareany==.
}	

egen anyparentc= anycount (parent*), values (1)
egen anychildc= anycount (child*), values (1)
egen anypartnerc= anycount (partner*), values (1)
egen anygrandc= anycount (grand*), values (1)
egen anybrosisc= anycount (brosis*), values (1)
egen anyotrelat=anycount (othrelative*), values (1)
egen anynonrelat=anycount (nonrelative*), values (1)
save recipent_young, replace

use "C:\Users\baowen\Documents\EUROCARE\wide_care.dta"
merge 1:1 pidp using recipent_young, keepusing (any*)
drop _merge
recode anyparentc anychildc anypartnerc anygrandc anybrosisc anyotrelat anynonrelat (1/max=1)
*Above are the recipent inside household
save "C:\Users\baowen\Documents\EUROCARE\wide_care.dta",replace
// RECIPIENT OUTSIDE HOUSEHOLD

// merge all waves into one
global ukhls "C:\Users\baowen\Documents\EUROCARE\UKHLS 11 waves\UKDA-6614-stata\stata\stata13_se"
foreach w in a b c d e f g h i j {
use pidp `w'_aidhu1 `w'_aidhu2 using "$ukhls\ukhls/`w'_indresp", clear
sort pidp 
	
	// merge with the file previously saved
	merge 1:1 pidp using "C:\Users\baowen\Documents\EUROCARE\wide_care.dta"
	
	// drop the _merge variable - otherwise the next merge will not work
	drop _merge
	
	// sort by pidp
	sort pidp
	
	// save the file to be used in the next merge
	save "C:\Users\baowen\Documents\EUROCARE\wide_care.dta", replace
}

egen anyparentout_p1=anycount(*_aidhu1),value (1)
egen anyparentout_p2=anycount(*_aidhu2),value (1)
recode anyparentout_p1 anyparentout_p2 (1/max=1)

egen anygrandout_p1=anycount(*_aidhu1),value (2)
egen anygrandout_p2=anycount(*_aidhu2),value (2)
recode anygrandout_p1 anygrandout_p2 (1/max=1)

egen anyothrelout_p1=anycount(*_aidhu1),value ( 3 4 )
egen anyothrelout_p2=anycount(*_aidhu2),value ( 3 4 )
recode anyothrelout_p1 anyothrelout_p2 (1/max=1)

egen anynonrel_p1=anycount(*_aidhu1),value (5 6 97)
egen anynonrel_p2=anycount(*_aidhu2),value (5 6 97)
recode anynonrel_p1 anynonrel_p2 (1/max=1)

//These are the final var used for recipent
gen care_parent=anyparentc
replace care_parent=1 if anyparentout_p1==1|anyparentout_p2==1
replace care_parent=0 if care_parent==.& (anyparentout_p1==0&anyparentout_p2==0)

gen care_grand=anygrandc
replace care_grand=1 if anygrandout_p1==1|anygrandout_p2==1
replace care_grand=0 if care_grand==.& (anygrandout_p1==0&anygrandout_p2==0)

gen care_partner=anypartnerc
replace care_partner=0 if care_partner==.& youngcare==1

gen care_sibling=anybrosisc
replace care_sibling=0 if care_sibling==.& youngcare==1

gen care_child=anychildc
replace care_child=0 if care_child==.&youngcare==1

gen care_otherrel=anyotrelat
replace care_otherrel=1 if anyothrelout_p1==1|anyothrelout_p2==1
replace care_otherrel=0 if care_otherrel==.& (anyothrelout_p1==0&anyothrelout_p2==0)

gen care_nonrel=anynonrelat
replace care_nonrel=1 if anynonrel_p1==1|anynonrel_p2==1
replace care_nonrel=0 if care_nonrel==.& (anynonrel_p1==0&anynonrel_p1==0)

recode care_parent care_grand care_partner care_sibling care_child care_otherrel care_nonrel (min/max=0) if youngcare==0

*--------------------------------------------------------------------------------
*----------------------------------- NUMBER PEOPLE CARING FOR
*-----------------------------------------------------------------------------------

foreach w in a b c d e f g h i j {
forvalues x=1/16 {
gen `w'_person`x'=1 if `w'_aidhua`x'==1
replace `w'_person`x'=0 if `w'_aidhua`x'!=1
}

clonevar `w'_peopleout=`w'_naidxhh
recode `w'_peopleout min/-1=0
gen `w'_numcare=(`w'_peopleout+`w'_person1+`w'_person2+`w'_person3+`w'_person4+`w'_person5+`w'_person6+`w'_person7+`w'_person8+`w'_person9 ///
	+`w'_person10+`w'_person11+`w'_person12+`w'_person13+`w'_person14+`w'_person15+`w'_person16)
replace `w'_numcare=0 if youngcare==0
replace `w'_numcare=. if youngcare==.
}

egen meannum=rowmean(*_numcare)
* round it up
gen meannumcar=ceil(meannum)


gen meannum_g=meannumcar
recode meannum_g 3/max=3
label define meannum_g 0 "Not caring" 3" Caring 3 or more people"
label values meannum_g meannum_g
recode meannum_g 0=1 if youngcare==1


/////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////generate baseline covariates
////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////hhincome use baseline within the age range (i.e first wave when interviewed between 16 and 29)
tokenize "`c(alpha)'"
gen hhincome_1obya=a_netinc if wavefirstobv==1
forval waveno = 2/10 {
  replace hhincome_1obya=``waveno''_netinc if wavefirstobv==`waveno'
}
xtile incomqu_1obya=hhincome_1obya, n(5)

//////////////////////////////////////////////employment status
tokenize "`c(alpha)'"
gen jbstatus_1obya=a_jbstat if wavefirstobv==1
forval waveno = 2/10 {
  replace jbstatus_1obya=``waveno''_jbstat if wavefirstobv==`waveno'
}

label value jbstatus_1obya j_jbstat

recode jbstatus_1obya  (11=9) (10=97)
recode jbstatus_1obya  (5=2)
recode jbstatus_1obya  (1=2) (9=7)
recode jbstatus_1obya (min/-1=.)

////////////////////////////////////////////////////////nssec
tokenize "`c(alpha)'"
gen class_1obya=a_jbnssec3_dv if wavefirstobv==1
forval waveno = 2/10 {
  replace class_1obya=``waveno''_jbnssec3_dv if wavefirstobv==`waveno'
}

label value class_1obya a_jbnssec3_dv
replace class_1obya=0 if jbstatus_1obya==3
replace class_1obya=0 if jbstatus_1obya==4
replace class_1obya=0 if jbstatus_1obya>=6&jbstatus_1obya<.
recode class_1obya (min/-1=.)

///////////////////////////////////////////////////////////FT/PT

tokenize "`c(alpha)'"
gen workhour_1obya=a_jbft_dv if wavefirstobv==1
forval waveno = 2/10 {
  replace workhour_1obya=``waveno''_jbft_dv if wavefirstobv==`waveno'
}
label value workhour_1obya a_jbft_dv

replace workhour_1obya=0 if (jbstatus_1obya==3|jbstatus_1obya==4)
replace workhour_1obya=0 if jbstatus_1obya>=6&jbstatus_1obya<.

foreach w in a b c d e f g h i j {
recode `w'_jbhrs (0/30=1) (30.01/40=2) (40.01/max=3), gen (`w'_workfp)
}


tokenize "`c(alpha)'"
gen workfp_1obya=a_workfp if wavefirstobv==1
forval waveno = 2/10 {
  replace workfp_1obya=``waveno''_workfp if wavefirstobv==`waveno'
}

replace workfp_1obya=0 if jbstatus_1obya==3
replace workfp_1obya=0 if jbstatus_1obya>=6&jbstatus_1obya<.
recode workfp_1obya (min/-1=.)
replace workfp_1obya=workhour_1obya if workfp_1obya==.

label define workfp_1obya 0"not working" 1"PT" 2"FT" 3"FT,long wh"
label values workfp_1obya workfp_1obya
recode workfp_1obya (min/-1=.)


/////////////////////////////////////////////combine FT/PT with employment status
gen workcom_ya=workfp_1obya
replace workcom_ya=4 if jbstatus_1obya==3
replace workcom_ya=5 if jbstatus_1obya==4
replace workcom_ya=6 if jbstatus_1obya==6
replace workcom_ya=7 if jbstatus_1obya==7
replace workcom_ya=8 if jbstatus_1obya==8
replace workcom_ya=9 if jbstatus_1obya==97
label define workcom_ya 1"PT" 2"FT" 3"FT,long wh" 4"Unemployed" 5 "Retired"  6"Family care"  7"Full-time student"  8"LT sick" 9 "something else"
label values workcom_ya workcom_ya
///////////////////////////////////////////////////marriage
tokenize "`c(alpha)'"
gen marriage_1ob_ya=a_mastat_dv if wavefirstobv==1
forval waveno = 2/10 {
  replace marriage_1ob_ya=``waveno''_mastat_dv if wavefirstobv==`waveno'
}
recode marriage_1ob_ya (min/-1=.)
recode marriage_1ob_ya 0=1 3=2 4/5=3 7/8=3 10=4
label define marriage_1ob_ya ///
1"single" 2"married" 3"seperated" 4"live as couple" 6"widowed"

label value marriage_1ob_ya marriage_1ob_ya
************************************age at baseline
tokenize "`c(alpha)'"
gen age_1ob_ya=a_age_dv if wavefirstobv==1
forval waveno = 2/10 {
  replace age_1ob_ya=``waveno''_age_dv if wavefirstobv==`waveno'
}

recode age_1ob_ya 15=16
************************************number of children in hh under 16


cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\"
use wide_care.dta
global ukhls "C:\Users\baowen\Documents\EUROCARE\UKHLS 11 waves\UKDA-6614-stata\stata\stata13_se"
foreach w in a b c d e f g h i j k{
use pidp `w'_nchild_dv  using "$ukhls\ukhls/`w'_indresp", clear
sort pidp 
	
	// merge with the file previously saved
	merge 1:1 pidp using wide_care
	
	// drop the _merge variable - otherwise the next merge will not work
	drop _merge
	
	// sort by pidp
	sort pidp
	
	// save the file to be used in the next merge
	save wide_care, replace
}
tokenize "`c(alpha)'"
gen children_ya=a_nchild_dv  if wavefirstobv==1
forval waveno = 2/10 {
  replace children_ya=``waveno''_nchild_dv  if wavefirstobv==`waveno'
}

gen children_1ob_ya=children_ya
recode children_1ob_ya (3/max=3)
recode children_1ob_ya (min/-1=.)

***************************************urban/rural
tokenize "`c(alpha)'"
gen urban_1ob_ya=a_urban_dv if wavefirstobv==1
forval waveno = 2/10 {
  replace urban_1ob_ya=``waveno''_urban_dv if wavefirstobv==`waveno'
}

recode urban_1ob_ya (min/-1=.)

*************************waves have been participated
tab wavesobs

////////////////////////////////////////////////////////////////////////////////
*------------------------------------------TIME INVARIATE VARIABLE
/////////////////////////////////////////////////////////////////////////////////
**ETHNICITY
egen ethin=rowmax (*_ethn_dv)
label values ethin j_ethn_dv
recode ethin 56=15
gen ethnicity=1 if ethin<=4&ethin>=1
replace ethnicity=2 if ethin==5|ethin==6|ethin==14|ethin==15|ethin==16
replace ethnicity=3 if ethin==9
replace ethnicity=4 if ethin==10
replace ethnicity=5 if ethin==11
replace ethnicity=6 if ethin==7|ethin==12|ethin==13|ethin==17|ethin==97|ethin==8
*combine Pakistan/Bangladesh
recode ethnicity(5=4) (6=5)
label define ethnicity 1"white" 2"black" 3"indian" 4"pakistani/bangladeshi" 5"other asian/other"
label value ethnicity ethnicity
**SEX
egen sex=rowmax (*_sex_dv)
recode sex 0=1
label define sex 1"men" 2"women"
label value sex sex
**MOTHER AND FATHER'S OCCUPATIONAL CLASS (when age 14)

foreach w in a b c d e f g h i j {
recode `w'_manssec8_dv (-10/-1=.)(1/3=1)(4/5=2)(6/8=3), gen(`w'_moclass)
recode `w'_panssec8_dv (-10/-1=.)(1/3=1)(4/5=2)(6/8=3),gen(`w'_faclass)
 }
egen motherclass=rowmin(*_moclass)
egen fatherclass=rowmin(*_faclass) 

egen monotwork=anycount (*_maju),value (2)
egen nomother=anycount (*_maju),value (3,4)
replace motherclass=10 if (monotwork==1|monotwork==2)& motherclass==.
replace motherclass=11 if (nomother==1|nomother==2)
 
egen fanotwork=anycount (*_paju),value (2)
egen nofather=anycount (*_paju),value (3,4)
replace fatherclass=10 if (fanotwork==1|fanotwork==2)& fatherclass==.
replace fatherclass=11 if (nofather==1|nofather==2)
 
label define parentclass 1"Management/Professional" 2"Intermediate" 3"Routine/Manual" 10 "Not working" 11"Not in household"
label value motherclass parentclass
label value fatherclass parentclass
save "wide_care.dta", replace
**use household grid information to reduce the missing data of parental class
global ukhls "C:\Users\baowen\Documents\EUROCARE\UKHLS 11 waves\UKDA-6614-stata\stata\stata13_se"
// loop through the remaining waves
foreach w in a b c d e f g h i j {
// find the wave number
	local waveno=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
// open the individual level file for that wave
	use "$ukhls\ukhls/`w'_egoalt", clear	
merge m:1 pidp using "$ukhls\ukhls/`w'_indresp",keepusing (`w'_jbnssec3_dv `w'_single_dv)
drop if _merge==2
drop _merge

*gen occupation for parents
gen `w'_fatherocc=`w'_jbnssec3_dv if `w'_relationship_dv>=9 & `w'_relationship_dv<=12 &`w'_sex==1
gen `w'_motherocc=`w'_jbnssec3_dv if `w'_relationship_dv>=9 & `w'_relationship_dv<=12 &`w'_sex==2

*identify single parent household
gen `w'_singlemother=1 if `w'_relationship_dv>=9 & `w'_relationship_dv<=12 &`w'_sex==2&`w'_single_dv==1
gen `w'_singlefather=1 if `w'_relationship_dv>=9 & `w'_relationship_dv<=12 &`w'_sex==1&`w'_single_dv==1
recode `w'_fatherocc .=11 if `w'_singlemother==1
recode `w'_motherocc .=11 if `w'_singlefather==1
* apply parents' occupation to everyone in the household
sort `w'_hidp `w'_fatherocc 
by `w'_hidp:replace `w'_fatherocc=`w'_fatherocc[1]

sort `w'_hidp `w'_motherocc 
by `w'_hidp:replace `w'_motherocc=`w'_motherocc[1]
*only keep children i.e. our sample, so thus have moved parents occupation to our sample's rows
replace `w'_fatherocc=. if `w'_relationship_dv<4
replace `w'_fatherocc=. if `w'_relationship_dv>6
replace `w'_motherocc=. if `w'_relationship_dv<4
replace `w'_motherocc=. if `w'_relationship_dv>6

keep if `w'_relationship_dv==4|`w'_relationship_dv==5|`w'_relationship_dv==6
bysort pidp: keep if _n==1
save hhid_parentocc_W`w'.dta
}

* merge all waves into one
foreach w in a b c d e f g h i j {
use pidp `w'_fatherocc `w'_motherocc using "hhid_parentocc_W`w'", clear
sort pidp 
	
	// merge into one file
	merge 1:1 pidp using "hhid_parentocc_Wa"
	// drop the _merge variable - otherwise the next merge will not work
	drop _merge
	// sort by pidp
	sort pidp
	// save the file to be used in the next merge
	save "hhid_parentocc_Wa", replace
}

*continue with parental class 
use "wide_care.dta"
merge 1:1 pidp using "hhid_parentocc_Wa"
drop if _merge==2
drop _merge

foreach w in a b c d e f g h i j {
recode `w'_motherocc -9/-8=10
recode `w'_fatherocc -9/-8=10
}
* many of those a_age_dv=. are those who are <16 and thus not participated in adult's survey
foreach w in a b c d e f g h i j {
replace motherclass=`w'_motherocc if motherclass==.&youngcare!=.&a_age_dv==.
replace fatherclass=`w'_fatherocc if fatherclass==.&youngcare!=.&a_age_dv==.
}

**********************************parental highest occupation class (when R at age 14)whoever is the highest in the hh
egen parenclass_h=rowmin(motherclass fatherclass)
label define parenclass ///
10"not working" 11" not in hh" 1"Prof/manage" 2"Intermediate" 3"Routine/manual"
label values parenclass_h parenclass
label var parenclass_h "parental highest class"
recode parenedu_h 99=100 if parenclass_h!=11
////////////////////////////////////////////////////////////////////////////////////////////
*************************GHQ outcome
////////////////////////////////////////////////////////////////////////////////////////////
recode *_scghq1_dv (min/-1=.)
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", replace



/////////////////////////////////////baseline hidp
tokenize "`c(alpha)'"
gen hhid_1obya=a_hidp if wavefirstobv==1
forval waveno = 2/10 {
  replace hhid_1obya=``waveno''_hidp if wavefirstobv==`waveno'
}

sort hhid_1obya pidp
by hhid_1obya: gen nucarehh=[_N]

save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", replace
//////////////////////////////////////////////////////////////////////////////////////////////////
************************************prepare for matching 1:2 matching
//////////////////////////////////////////////////////////////////////////////////////////////////
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta",clear
keep if youngcare!=.
keep pidp *hidp youngcare *age_dv sex ethnicity parenclass_h incomqu_1obya age_1ob_ya agemin ///
agemax ageonset wavesobs higestedu children_1ob_ya  *_scghq1_dv *_sf12mcs_dv *_sf12pcs_dv *_ycareany  *_age_dv wavefirstcar psu strata ///
class_1obya workcom_ya marriage_1ob_ya age_1ob_ya wavefirstobv urban_1ob_ya children_1ob_ya meanhour_g 

tab youngcare sex,col
/////////////select carers who have participated the survey once before and once after the care onset,

gen samplepiece=1 if agemin<ageonset & agemax>=ageonset & ageonset!=. 
drop if samplepiece!=1&youngcare==1

////////////////no. people in the same hh
tokenize "`c(alpha)'"
gen hhid_1obya=a_hidp if wavefirstobv==1
forval waveno = 2/10 {
  replace hhid_1obya=``waveno''_hidp if wavefirstobv==`waveno'
}

sort hhid_1obya pidp
by hhid_1obya: gen nucarehh=[_N]


tokenize "`c(alpha)'"
gen ghq_1ob_ya=a_scghq1_dv if wavefirstobv==1
forval waveno = 2/10 {
  replace ghq_1ob_ya=``waveno''_scghq1_dv if wavefirstobv==`waveno'
}
recode ghq_1ob_ya (min/-1=.)

*combine small n categories
recode workcom_ya 5=4
recode marriage_1ob_ya (3=1) (6=1)

mdesc age_1ob  sex ethnicity incomqu_1obya class_1obya  workcom_ya marriage_1ob_ya ///
parenclass_h urban_1ob_ya children_1ob_ya higestedu ghq_1ob_ya if youngcare==1

kmatch ps youngcare age_1ob_ya i.ethnicity i.incomqu_1obya i.class_1obya i.workcom_ya i.marriage_1ob_ya i.parenclass_h i.urban_1ob_ya i.children_1ob_ya i.higestedu i.wavesobs  (ghq_1ob_ya), ematch(sex) nn(2) idgenerate(controlid) idvar(pidp)generate(kpscore)

tab kpscore if _KM_nm>=1

/////////////some people has been matched for several times
*matched control 1
gen double id1=controlid1
replace id1=pidp if kpscore==0
gen ageonset2=ageonset if kpscore==1
sort id1 ageonset2
by id1: replace ageonset2=ageonset2[1]
gen ageonset_g1= ageonset2 if kpscore==0
*matched control 2
gen double id2=controlid2
replace id2=pidp if kpscore==0
gen ageonset3=ageonset if kpscore==1
sort id2 ageonset3
by id2: replace ageonset3=ageonset3[1]
gen ageonset_g2=ageonset3 if kpscore==0
*matched control 3
gen double id3=controlid3
replace id3=pidp if kpscore==0
gen ageonset4=ageonset if kpscore==1
sort id3 ageonset4
by id3: replace ageonset4=ageonset4[1]
gen ageonset_g3=ageonset4 if kpscore==0

*matched control 4
gen double id4=controlid4
replace id4=pidp if kpscore==0
gen ageonset5=ageonset if kpscore==1
sort id4 ageonset5
by id4: replace ageonset5=ageonset5[1]
gen ageonset_g4=ageonset5 if kpscore==0

* give non-carers the same age of onset care as their matched carers
gen ageonset_all=ageonset
replace ageonset_all=ageonset_g1 if ageonset_g1!=. & ageonset_all==0
replace ageonset_all=ageonset_g2 if ageonset_g1==.& ageonset_all==0


save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact.dta"
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", keepus(meanhour_g placecare)
drop if _merge==2
drop _merge
tab kpscore if ageonset_all!=.

 *select those non-carers who has paricipated the survey at least once before and once after the onset
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

tab kpscore if ageonset_all!=.
gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample
keep if usesample==1

keep pidp *age_dv  *scghq1_dv  ageonset_all youngcare age_1ob agemax agemin kpscore  sex meanhour* kpscore sex hhid_1obya meanhour_g placecare


*Step 2: reshape to long format for the use of piecewise
 
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
* time scale variable
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
mixed scghq1_dv i.poyrtoset if kpscore==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_y_yn, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_y_yn, replace)
combomarginsplot file1_y_yn file2_y_yn, labels ("carers" "non carers")savefile(combined_ghq_yn, replace)
mplotoffset using combined_ghq_yn, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 16-29") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")




/////////////////////////////////graphs for yes/no care by sex
mixed scghq1_dv i.poyrtoset if kpscore==1 & sex==1&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_yn_m, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & sex==1&poyrtoset!=0&poyrtoset<15&poyrtoset!=1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_yn_m, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & sex==2&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_yn_f, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & sex==2&poyrtoset!=0&poyrtoset<15&poyrtoset!=1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_yn_f, replace)
combomarginsplot file1_yn_m file2_yn_m file1_yn_f file2_yn_f, labels ("male carers" "male non carers" "female carers" "female non carers") savefile(combined_ghq_yn_sex, replace)

mplotoffset using combined_ghq_yn_sex, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray))) title("Age 16-29") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")



/////////////////////////////////graphs for care intensity (small N at two ends, excluded)
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_g==1&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_low, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_g==2&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_lmid, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_g==3&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_mid, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & poyrtoset!=0 & (meanhour_g==4|meanhour_g==5)&poyrtoset<15 &poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_hig, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & poyrtoset!=0&poyrtoset<15 &poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ncare, replace)
combomarginsplot file1_low file1_lmid file1_mid file1_hig file1_ncare, labels ("<5h per week" "5-9h per week" "10-19h per week" "20+h per week" "non carers") savefile(combined_ghq_intensity, replace)

mplotoffset using combined_ghq_intensity, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 16-29") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")


/////////////////////////////////graphs for care place
mixed scghq1_dv i.poyrtoset if kpscore==1 & (placecare==1|placecare==3)&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_in, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & (placecare==2)&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_out, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_nocare, replace)

combomarginsplot file1_in file1_out file1_nocare, labels ("inside household care" "outside household care" "non carers") savefile(combined_ghq_place, replace)

mplotoffset using combined_ghq_place, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 16-29") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")


//////////////////////modelling to test the significance
mixed scghq1_dv part1 i.kpscore##c.part2 i.kpscore##c.part3 || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
mixed scghq1_dv part1 i.kpscore##c.part2##sex i.kpscore##c.part3##sex || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.kpscore#c.part2#sex i.kpscore#c.part3#sex


gen careintensity=0 if kpscore==0
replace careintensity=1 if kpscore==1&meanhour_g==1
replace careintensity=2 if kpscore==1&meanhour_g==2
replace careintensity=3 if kpscore==1&meanhour_g==3
replace careintensity=4 if kpscore==1&(meanhour_g==4|meanhour_g==5)

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


