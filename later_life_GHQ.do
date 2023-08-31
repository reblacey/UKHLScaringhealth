use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"

//////////////////////////////////////////////////////////////////////////////////////////////////
**************************************************************care related variables
////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////gen care variable withing the age range (65 and above)
foreach w in a b c d e f g h i j {
gen `w'_oldcareinhh=`w'_careinhh
replace `w'_oldcareinhh=. if `w'_age_dv<65
gen `w'_oldcareouthh=`w'_careouthh
replace `w'_oldcareouthh=. if `w'_age_dv<65
gen `w'_oldcareany=`w'_careany
replace `w'_oldcareany=. if `w'_age_dv<65
}

foreach w in a b c d e f g h i j {
label values `w'_oldcareinhh carelab
label values `w'_oldcareouthh carelab
label values `w'_oldcareany carelab
}

egen old_times_careinhh=anycount (*_oldcareinhh),values (1)
egen old_times_careouthh=anycount (*_oldcareouthh),values (1)
egen old_times_careany=anycount (*_oldcareany),values (1)

drop rowmisscare
egen rowmisscare=rowmiss(*_oldcareany)
tab old_times_careany if rowmisscare!=10

recode old_times_careany (1/10=1), gen(oldcare)
replace oldcare=. if rowmisscare==10
label var oldcare " whehther provide care 65+y"

*-----------------------------------wave when first observed enter the older-mid age range (65 and above)
gen wavefirstobv_old=1 if a_oldcareany!=.
replace wavefirstobv_old=2 if b_oldcareany!=.&wavefirstobv_old==.
replace wavefirstobv_old=3 if c_oldcareany!=.&wavefirstobv_old==.
replace wavefirstobv_old=4 if d_oldcareany!=.&wavefirstobv_old==.
replace wavefirstobv_old=5 if e_oldcareany!=.&wavefirstobv_old==.
replace wavefirstobv_old=6 if f_oldcareany!=.&wavefirstobv_old==.
replace wavefirstobv_old=7 if g_oldcareany!=.&wavefirstobv_old==.
replace wavefirstobv_old=8 if h_oldcareany!=.&wavefirstobv_old==.
replace wavefirstobv_old=9 if i_oldcareany!=.&wavefirstobv_old==.
replace wavefirstobv_old=10 if j_oldcareany!=.&wavefirstobv_old==.


*-----------------------------------wave when first observed caring in  the older-mid age range (65 and above)
gen wavefirstcar_old=1 if a_oldcareany==1
replace wavefirstcar_old=2 if b_oldcareany==1&wavefirstcar_old==.
replace wavefirstcar_old=3 if c_oldcareany==1&wavefirstcar_old==.
replace wavefirstcar_old=4 if d_oldcareany==1&wavefirstcar_old==.
replace wavefirstcar_old=5 if e_oldcareany==1&wavefirstcar_old==.
replace wavefirstcar_old=6 if f_oldcareany==1&wavefirstcar_old==.
replace wavefirstcar_old=7 if g_oldcareany==1&wavefirstcar_old==.
replace wavefirstcar_old=8 if h_oldcareany==1&wavefirstcar_old==.
replace wavefirstcar_old=9 if i_oldcareany==1&wavefirstcar_old==.
replace wavefirstcar_old=10 if j_oldcareany==1&wavefirstcar_old==.

*-----------------------------------age when first observed care in  the older-mid age range (65 and above)

gen ageonset_old=a_age_dv if wavefirstcar_old==1
replace ageonset_old=b_age_dv if wavefirstcar_old==2
replace ageonset_old=c_age_dv if wavefirstcar_old==3
replace ageonset_old=d_age_dv if wavefirstcar_old==4
replace ageonset_old=e_age_dv if wavefirstcar_old==5
replace ageonset_old=f_age_dv if wavefirstcar_old==6
replace ageonset_old=g_age_dv if wavefirstcar_old==7
replace ageonset_old=h_age_dv if wavefirstcar_old==8
replace ageonset_old=i_age_dv if wavefirstcar_old==9
replace ageonset_old=j_age_dv if wavefirstcar_old==10

recode ageonset_old (65/66=1) (67/68=2) (69/70=3)(71/72=4) (73/74=5) (75/76=6) (77/78=7)(79/80=8)(81/max=9), gen (ageonset_oldg)
label define ageonset_oldg 1"65/66" 2"67/68" 3"69/70" 4"71/72" 5"73/74" 6"75/76" 7"77/78" 8"79/80" 9"81+"
label values ageonset_oldg ageonset_oldg
tab ageonset_oldg
egen times_careany_old=anycount (*_oldcareany),values (1)
recode times_careany_old (4/max=4)
tab times_careany_old if oldcare==1

*-----------------------------------HOURS OF CARING (INSIDE AND OUTSIDE HOUSEHOLD COMBINED)
foreach w in a b c d e f g h i j {
recode `w'_aidhrs (-10/-1=.)
 }
  /////////////////use mid point of hours
  foreach w in a b c d e f g h i j {
  gen `w'_hours_old=2 if `w'_aidhrs==1&`w'_oldcareany!=.
  replace `w'_hours_old=7 if `w'_aidhrs==2&`w'_oldcareany!=.
  replace `w'_hours_old=14.5 if `w'_aidhrs==3&`w'_oldcareany!=.
  replace `w'_hours_old=27 if `w'_aidhrs==4&`w'_oldcareany!=.
  replace `w'_hours_old=42 if `w'_aidhrs==5&`w'_oldcareany!=.
  replace `w'_hours_old=74.5 if `w'_aidhrs==6&`w'_oldcareany!=.
  replace `w'_hours_old=100 if `w'_aidhrs==7&`w'_oldcareany!=.
  replace `w'_hours_old=10 if `w'_aidhrs==8&`w'_oldcareany!=.
  replace `w'_hours_old=34 if `w'_aidhrs==9&`w'_oldcareany!=.
  replace `w'_hours_old=. if `w'_aidhrs==97&`w'_oldcareany!=.
  }
  egen meanhour_old=rowmean (*_hours_old)
  
  gen meanhour_oldg=1 if meanhour_old<5
  replace meanhour_oldg=2 if meanhour_old<10&meanhour_oldg==.
  replace meanhour_oldg=3 if meanhour_old<20&meanhour_oldg==.
  replace meanhour_oldg=4 if meanhour_old<35&meanhour_oldg==.
  replace meanhour_oldg=5 if meanhour_old<50&meanhour_oldg==.
  replace meanhour_oldg=6 if meanhour_old<100&meanhour_oldg==.
  replace meanhour_oldg=7 if meanhour_old==100&meanhour_oldg==.
  label value meanhour_oldg a_aidhrs

  replace meanhour_oldg=0 if oldcare==0 
   recode meanhour_oldg (5/7=5)
   tab meanhour_oldg if oldcare==1

*--------------------------------------------------------------------------------
*----------------------------------- NUMBER PEOPLE CARING FOR
*-----------------------------------------------------------------------------------

foreach w in a b c d e f g h i j {
forvalues x=1/16 {
gen `w'_person`x'_old=1 if `w'_aidhua`x'==1
replace `w'_person`x'_old=0 if `w'_aidhua`x'!=1
}

clonevar `w'_peopleout_old=`w'_naidxhh
recode `w'_peopleout_old min/-1=0
gen `w'_numcare_old=(`w'_peopleout_old+`w'_person1_old+`w'_person2_old+`w'_person3_old+`w'_person4_old+`w'_person5_old+`w'_person6_old+`w'_person7_old+`w'_person8_old+`w'_person9_old ///
	+`w'_person10_old+`w'_person11_old+`w'_person12_old+`w'_person13_old+`w'_person14_old+`w'_person15_old+`w'_person16_old)
replace `w'_numcare_old=0 if `w'_oldcareany==0
replace `w'_numcare_old=. if `w'_oldcareany==.
}

egen meannum_old=rowmean(*_numcare_old)
* round it up
gen meannumcar_old=ceil(meannum_old)
recode meannumcar_old (3/max=3) (0=1), gen (meannumcar_oldg)

tab meannumcar_oldg if oldcare==1


*--------------------------------------------------------------------------------
*----------------------------------- CARE PLACE
*-----------------------------------------------------------------------------------
 egen anyinhh_old=rowmin(*_oldcareinhh)
 egen anyouthh_old=rowmin(*_oldcareouthh)
 
 gen placecare_old=0 if oldcare==0
 replace placecare_old=1 if anyinhh_old==1 & anyouthh_old!=1
 replace placecare_old=2 if anyouthh_old==1 & anyinhh_old!=1
 replace placecare_old=3 if anyinhh_old==1 & anyouthh_old==1
 
 label define placecare_old 0"no care" 1" in hh" 2" out hh" 3" both in and out hh"
 label values placecare_old placecare_old
 tab placecare_old if oldcare==1
 
 
 ******************************************hhincome use baseline with the age range (i.e first wave when interviewed between 50 and 64)
tokenize "`c(alpha)'"
gen hhincome_1obold=a_netinc if wavefirstobv_old==1
forval waveno = 2/10 {
  replace hhincome_1obold=``waveno''_netinc if wavefirstobv_old==`waveno'
}
xtile incomqu_1obold=hhincome_1obold, n(5)

//////////////////////////////////////////////employment status
tokenize "`c(alpha)'"
gen jbstatus_1ob_old=a_jbstat if wavefirstobv_old==1
forval waveno = 2/10 {
  replace jbstatus_1ob_old=``waveno''_jbstat if wavefirstobv_old==`waveno'
}

label value jbstatus_1ob_old j_jbstat

recode jbstatus_1ob_old  (11=9) (10=97)
recode jbstatus_1ob_old  (5=2)
recode jbstatus_1ob_old  (1=2) (9=7)
recode jbstatus_1ob_old (min/-1=.)

*******************************************
////////////////////////////////////////////////////////nssec
tokenize "`c(alpha)'"
gen class_1ob_old=a_jbnssec3_dv if wavefirstobv_old==1
forval waveno = 2/10 {
  replace class_1ob_old=``waveno''_jbnssec3_dv if wavefirstobv_old==`waveno'
}

label value class_1ob_old a_jbnssec3_dv
replace class_1ob_old=0 if jbstatus_1ob_old==3
replace class_1ob_old=0 if jbstatus_1ob_old==4
replace class_1ob_old=0 if jbstatus_1ob_old>=6&jbstatus_1ob_old<.
recode class_1ob_old (min/-1=.)

//////////////////////////////////////////////////////// FT/PT

tokenize "`c(alpha)'"
gen workhour_1ob_old=a_jbft_dv if wavefirstobv_old==1
forval waveno = 2/10 {
  replace workhour_1ob_old=``waveno''_jbft_dv if wavefirstobv_old==`waveno'
}
label value workhour_1ob_old a_jbft_dv

replace workhour_1ob_old=0 if (jbstatus_1ob_old==3|jbstatus_1ob_old==4)
replace workhour_1ob_old=0 if jbstatus_1ob_old>=6&jbstatus_1ob_old<.
/*
foreach w in a b c d e f g h i j {
recode `w'_jbhrs (0/30=1) (30.01/40=2) (40/max=3), gen (`w'_workfp)
}
*/

tokenize "`c(alpha)'"
gen workfp_1ob_old=a_workfp if wavefirstobv_old==1
forval waveno = 2/10 {
  replace workfp_1ob_old=``waveno''_workfp if wavefirstobv_old==`waveno'
}

replace workfp_1ob_old=0 if jbstatus_1ob_old==3
replace workfp_1ob_old=0 if jbstatus_1ob_old>=6&jbstatus_1ob_old<.
recode workfp_1ob_old (min/-1=.)
replace workfp_1ob_old=workhour_1ob_old if workfp_1ob_old==.

label define workfp_1ob_old 0"not working" 1"PT" 2"FT" 3"FT,long wh"
label values workfp_1ob_old workfp_1ob_old
recode workfp_1ob_old (min/-1=.)


/////////////////////////////////////////////combine FT/PT with employment status
replace workfp_1ob_old=0 if class_1ob_old==0
*2 changes
gen workcom_old=workfp_1ob_old
replace workcom_old=4 if jbstatus_1ob_old==3
replace workcom_old=5 if jbstatus_1ob_old==4
replace workcom_old=6 if jbstatus_1ob_old==6
replace workcom_old=7 if jbstatus_1ob_old==7
replace workcom_old=8 if jbstatus_1ob_old==8
replace workcom_old=9 if jbstatus_1ob_old==97
label define workcom_old 1"PT" 2"FT" 3"FT,long wh" 4"Unemployed" 5 "Retired"  6"Family care"  7"Full-time student"  8"LT sick" 9 "something else"
label values workcom_old workcom_old
/////////////////////////////////////////////combine FT/PT with employment status
replace workfp_1ob_old=0 if class_1ob_old==0
*2 changes
gen workcom_old=workfp_1ob_old
replace workcom_old=4 if jbstatus_1ob_old==3
replace workcom_old=5 if jbstatus_1ob_old==4
replace workcom_old=6 if jbstatus_1ob_old==6
replace workcom_old=7 if jbstatus_1ob_old==7
replace workcom_old=8 if jbstatus_1ob_old==8
replace workcom_old=9 if jbstatus_1ob_old==97
label define workcom_old 1"PT" 2"FT" 3"FT,long wh" 4"Unemployed" 5 "Retired"  6"Family care"  7"Full-time student"  8"LT sick" 9 "something else"
label values workcom_old workcom_old
///////////////////////////////////////////////////marriage

tokenize "`c(alpha)'"
gen marriage_1ob_old=a_mastat_dv if wavefirstobv_old==1
forval waveno = 2/10 {
  replace marriage_1ob_old=``waveno''_mastat_dv if wavefirstobv_old==`waveno'
}
recode marriage_1ob_old (min/-1=.)
recode marriage_1ob_old 0=1 3=2 4/5=3 7/8=3 10=4
label define marriage_1ob_old ///
1"single" 2"married" 3"seperated" 4"live as couple" 6"widowed"

label value marriage_1ob_old marriage_1ob_old
************************************age at baseline
tokenize "`c(alpha)'"
gen age_1ob_old=a_age_dv if wavefirstobv_old==1
forval waveno = 2/10 {
  replace age_1ob_old=``waveno''_age_dv if wavefirstobv_old==`waveno'
}

************************************number of children in hh by age

tokenize "`c(alpha)'"
gen children_old=a_nch14resp  if wavefirstobv_old==1
forval waveno = 2/10 {
  replace children_old=``waveno''_nch14resp  if wavefirstobv_old==`waveno'
}

gen children_1ob_old=children_old
recode children_1ob_old (3/max=3)
recode children_1ob_old (min/-1=.)

***************************************urban/rural
tokenize "`c(alpha)'"
gen urban_1ob_old=a_urban_dv if wavefirstobv_old==1
forval waveno = 2/10 {
  replace urban_1ob_old=``waveno''_urban_dv if wavefirstobv_old==`waveno'
}

recode urban_1ob_old (min/-1=.)
*************************waves have been participated
egen wavesobs_old=anycount (*age_dv), values(65/120)
*-----------------------------------age when first enter the survey
tab agemin if oldcare!=.

recode oldcare (0=.) (1=.) if agemin<55
*5 changes





//////////////////////////////////////////////////////////////////////////////////////////////////
*******************************************************prepare the data for 1:2 matching
//////////////////////////////////////////////////////////////////////////////////////////////////

use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta"



****number of children
drop children_1ob_old
tokenize "`c(alpha)'"
gen children_old=a_nchild_dv  if wavefirstobv_old==1
forval waveno = 2/10 {
  replace children_old=``waveno''_nchild_dv if wavefirstobv_old==`waveno'
}

gen children_1ob_old=children_old
recode children_1ob_old (3/max=3)
recode children_1ob_old (min/-1=.)



save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", replace
keep if oldcare!=.
keep pidp oldcare *age_dv yougcare omidcare oldcare sex ethnicity parenclass_h incomqu_1obold age_1ob_old agemin ///
agemax ageonset_old wavesobs_old higestedu children_1ob_old  *_scghq1_dv *_sf12mcs_dv *_sf12pcs_dv *_oldcareany  *_age_dv wavefirstcar_old psu strata ///
class_1ob_old  workcom_old marriage_1ob_old age_1ob_old wavefirstobv_old urban_1ob_old children_1ob_old *_hidp
/////////////select sample who have participated the survey once before and once after the care onset
gen samplepiece=1 if agemin<ageonset_old & agemax>=ageonset_old & ageonset_old!=. 
drop if samplepiece!=1&oldcare==1
drop if omidcare ==1
*2344 deleted


egen missghq= rowmiss(*scghq1_dv)
tokenize "`c(alpha)'"
gen ghq_1ob_old=a_scghq1_dv if wavefirstobv_old==1
forval waveno = 2/10 {
  replace ghq_1ob_old=``waveno''_scghq1_dv if wavefirstobv_old==`waveno'
}
recode ghq_1ob_old (min/-1=.)



////////////////no. people in the same hh
tokenize "`c(alpha)'"
gen hhid_1obya=a_hidp if wavefirstobv_old==1
forval waveno = 2/10 {
  replace hhid_1obya=``waveno''_hidp if wavefirstobv_old==`waveno'
}

sort hhid_1obya pidp
by hhid_1obya: gen nucarehh=[_N]

*combine small n categories
recode workcom_old 3=2 4=6 7=6 9=6
recode parenclass_h (100=.)

mdesc age_1ob_old  sex ethnicity incomqu_1obold class_1ob_old  workcom_old marriage_1ob_old ///
parenclass_h urban_1ob_old children_1ob_old workcom_old  higestedu ghq_1ob_old if oldcare==1



kmatch ps oldcare age_1ob_old i.ethnicity i.incomqu_1obold i.class_1ob_old i.workcom_old i.marriage_1ob_old i.parenclass_h i.urban_1ob_old i.children_1ob_old i.higestedu i.wavesobs  (ghq_1ob_old), ematch(sex) nn(2) idgenerate(controlid) idvar(pidp)generate(kpscore)


tab kpscore if _KM_nm>=1
recode ageonset_old .=0



*matched control 1
gen double id1=controlid1
replace id1=pidp if kpscore==0
gen ageonset2=ageonset_old if kpscore==1
sort id1 ageonset2
by id1: replace ageonset2=ageonset2[1]
gen ageonset_g1= ageonset2 if kpscore==0
*matched control 2
gen double id2=controlid2
replace id2=pidp if kpscore==0
gen ageonset3=ageonset_old if kpscore==1
sort id2 ageonset3
by id2: replace ageonset3=ageonset3[1]
gen ageonset_g2=ageonset3 if kpscore==0
*matched control 3
gen double id3=controlid3
replace id3=pidp if kpscore==0
gen ageonset4=ageonset_old if kpscore==1
sort id3 ageonset4
by id3: replace ageonset4=ageonset4[1]
gen ageonset_g3=ageonset4 if kpscore==0

*matched control 4
gen double id4=controlid4
replace id4=pidp if kpscore==0
gen ageonset5=ageonset_old if kpscore==1
sort id4 ageonset5
by id4: replace ageonset5=ageonset5[1]
gen ageonset_g4=ageonset5 if kpscore==0


gen ageonset_all=ageonset_old
replace ageonset_all=ageonset_g1 if ageonset_g1!=. & ageonset_all==0
replace ageonset_all=ageonset_g2 if ageonset_g1==.& ageonset_all==0

save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_old.dta"
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_old.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", keepus(meanhour_oldg placecare_old)
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

keep pidp *age_dv  *scghq1_dv  ageonset_all oldcare age_1ob_old agemax agemin kpscore sex hhid_1obya meanhour_oldg placecare_old

 
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
mixed scghq1_dv part1 i.kpscore##c.part2 i.kpscore##c.part3 || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var




/////////////////////////////////graphs for yes/no care
mixed scghq1_dv i.poyrtoset if kpscore==1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_yn, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_old_yn, replace)
combomarginsplot file1_old_yn file2_old_yn, labels ("carers" "non carers") savefile(combined_ghq_yn, replace)

mplotoffset using combined_ghq_yn, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")



/////////////////////////////////graphs for yes/no care by sex
mixed scghq1_dv i.poyrtoset if kpscore==1 & sex==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_yn_m, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & sex==1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_old_yn_m, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & sex==2|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_yn_f, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & sex==2 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_old_yn_f, replace)
combomarginsplot file1_old_yn_m file2_old_yn_m file1_old_yn_f file2_old_yn_f, labels ("male carers" "male non carers" "female carers" "female non carers") savefile(combined_ghq_yn_sex, replace)

mplotoffset using combined_ghq_yn_sex, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray))) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")



/////////////////////////////////graphs for care intensity 
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_oldg==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_low, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_oldg==2|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_lmid, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & meanhour_oldg==3|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_mid, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & (meanhour_oldg==4|meanhour_oldg==5) || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_hig, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0 & poyrtoset!=0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_ncare, replace)
combomarginsplot file1_old_low file1_old_lmid file1_old_mid file1_old_hig file1_old_ncare, labels ("<5h per week" "5-9h per week" "10-19h per week" "20+h per week" "non carers") savefile(combined_ghq_intensity, replace)

mplotoffset using combined_ghq_intensity, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")


/////////////////////////////////graphs for care place

mixed scghq1_dv i.poyrtoset if kpscore==1 & (placecare_old==1|placecare_old==3)|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_in, replace)
mixed scghq1_dv i.poyrtoset if kpscore==1 & (placecare_old==2)|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_out, replace)
mixed scghq1_dv i.poyrtoset if kpscore==0|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_nocare, replace)

combomarginsplot file1_old_in file1_old_out file1_old_nocare, labels ("inside household care" "outside household care" "non carers") savefile(combined_ghq_place, replace)

mplotoffset using combined_ghq_place, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (GHQ) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig 1_panelA\"
grc1leg GHQ_16_29_yn.gph GHQ_30_49_yn.gph GHQ_50_64_yn.gph GHQ_65plus_yn.gph,ycommon

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig 1_panelB\"
grc1leg GHQ_16_29_sex.gph GHQ_30_49_sex.gph GHQ_50_64_sex.gph GHQ_65plus_sex.gph,ycommon

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig 1_panelC\"
grc1leg GHQ_16_29_intensity.gph GHQ_30_49_intensity.gph GHQ_50_64_intensity.gph GHQ_65plus_intensity.gph,ycommon

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig 1_panelD\"
grc1leg GHQ_16_29_place.gph GHQ_30_49_place.gph GHQ_50_64_place.gph GHQ_65plus_place.gph,ycommon



//////////////////////modelling 
mixed scghq1_dv part1 i.kpscore##c.part2 i.kpscore##c.part3 || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
mixed scghq1_dv part1 i.kpscore##c.part2##sex i.kpscore##c.part3##sex || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.kpscore#c.part2#sex i.kpscore#c.part3#sex
testparm i.kpscore#c.part2#sex

gen careintensity=0 if kpscore==0
replace careintensity=1 if kpscore==1&meanhour_oldg==1
replace careintensity=2 if kpscore==1&meanhour_oldg==2
replace careintensity=3 if kpscore==1&meanhour_oldg==3
replace careintensity=4 if kpscore==1&(meanhour_oldg==4|meanhour_oldg==5)


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