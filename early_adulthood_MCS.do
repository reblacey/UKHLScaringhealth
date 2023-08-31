 


//////////////////////////////////////////////////////////////////////////////////////////////////
************************************prepare for matching
//////////////////////////////////////////////////////////////////////////////////////////////////
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta",clear
keep if yougcare!=.
keep pidp *hidp yougcare *age_dv yougcare sex ethnicity parenclass_h incomqu_1obya age_1ob_ya agemin ///
agemax ageonset wavesobs higestedu children_1ob_ya  *_scghq1_dv *_sf12mcs_dv *_sf12pcs_dv *_ycareany  *_age_dv wavefirstcar psu strata ///
class_1obya workcom_ya marriage_1ob_ya age_1ob_ya wavefirstobv urban_1ob_ya children_1ob_ya meanhour_g 

tab yougcare sex,col
/////////////select carers who have participated the survey once before and once after the care onset,

gen samplepiece=1 if agemin<ageonset & agemax>=ageonset & ageonset!=. 
drop if samplepiece!=1&yougcare==1


////////////////no. people in the same hh
tokenize "`c(alpha)'"
gen hhid_1obya=a_hidp if wavefirstobv==1
forval waveno = 2/10 {
  replace hhid_1obya=``waveno''_hidp if wavefirstobv==`waveno'
}

sort hhid_1obya pidp
by hhid_1obya: gen nucarehh=[_N]

//////////baseline sf
tokenize "`c(alpha)'"
gen sfm_1ob_ya=a_sf12mcs_dv if wavefirstobv==1
forval waveno = 2/10 {
  replace sfm_1ob_ya=``waveno''_sf12mcs_dv if wavefirstobv==`waveno'
}
recode sfm_1ob_ya (min/-1=.)

tokenize "`c(alpha)'"
gen sfp_1ob_ya=a_sf12pcs_dv if wavefirstobv==1
forval waveno = 2/10 {
  replace sfp_1ob_ya=``waveno''_sf12pcs_dv if wavefirstobv==`waveno'
}
recode sfp_1ob_ya (min/-1=.)

*combine small n categories
recode workcom_ya 5=4
recode marriage_1ob_ya (3=1) (6=1)

mdesc age_1ob  sex ethnicity incomqu_1obya class_1obya  workcom_ya marriage_1ob_ya ///
parenclass_h urban_1ob_ya children_1ob_ya higestedu sfp_1ob_ya sfm_1ob_ya if yougcare==1



kmatch ps yougcare age_1ob_ya i.ethnicity i.incomqu_1obya i.class_1obya i.workcom_ya i.marriage_1ob_ya i.parenclass_h i.urban_1ob_ya i.children_1ob_ya i.higestedu i.wavesobs  (sfp_1ob_ya sfm_1ob_ya), ematch(sex) nn(2) idgenerate(controlid) idvar(pidp)generate(kpscore)

tab kpscore if _KM_nm>=1
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


gen ageonset_all=ageonset
replace ageonset_all=ageonset_g1 if ageonset_g1!=. & ageonset_all==0
replace ageonset_all=ageonset_g2 if ageonset_g1==.& ageonset_all==0


save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_sf.dta"
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_sf.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", keepus(meanhour_g placecare)
drop if _merge==2
drop _merge
 tab kpscore if ageonset_all!=.
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all

replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

tab kpscore if ageonset_all!=.
gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample
keep if usesample==1

keep pidp *age_dv   *_sf12mcs_dv *_sf12pcs_dv  ageonset_all yougcare age_1ob agemax agemin kpscore  sex meanhour* kpscore sex hhid_1obya meanhour_g placecare


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
reshape long sf12mcs_dv age_dv , i(pidp) j(wave)
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

recode sf12mcs_dv (min/-1=.)
mixed sf12mcs_dv i.kpscore part1 i.kpscore##c.part2 c.part3 || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var

/////////////////////////////////graphs for yes/no care


mixed sf12mcs_dv i.poyrtoset if kpscore==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_y_yn, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_y_yn, replace)
combomarginsplot file1_y_yn file2_y_yn, labels ("carers" "non carers") savefile(combined_sfm_yn, replace)
mplotoffset using combined_sfm_yn, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 16-29") xtitle ("Years centred on care onset year") ytitle (SF12-MCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")ciopts(msize(vsmall))




/////////////////////////////////graphs for yes/no care by sex
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & sex==1&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_yn_m, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==0 & sex==1&poyrtoset!=0&poyrtoset<15&poyrtoset!=1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_yn_m, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & sex==2&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_yn_f, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==0 & sex==2&poyrtoset!=0&poyrtoset<15&poyrtoset!=1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_yn_f, replace)
combomarginsplot file1_yn_m file2_yn_m file1_yn_f file2_yn_f, labels ("male carers" "male non carers" "female carers" "female non carers") savefile(combined_sfm_yn_sex, replace)

mplotoffset using combined_sfm_yn_sex, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 16-29") xtitle ("Years centred on care onset year") ytitle (SF12-MCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")ciopts(msize(vsmall))



/////////////////////////////////graphs for care intensity (small N at two ends, excluded)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & meanhour_g==1&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_low, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & meanhour_g==2&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_lmid, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & meanhour_g==3&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_mid, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & poyrtoset!=0 & (meanhour_g==4|meanhour_g==5)&poyrtoset<15 &poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_hig, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==0 & poyrtoset!=0&poyrtoset<15 &poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_ncare, replace)
combomarginsplot file1_low file1_lmid file1_mid file1_hig file1_ncare, labels ("<5h per week" "5-9h per week" "10-19h per week" "20+h per week" "non carers") savefile(combined_sfm_intensity, replace)

mplotoffset using combined_sfm_intensity, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 16-29") xtitle ("Years centred on care onset year") ytitle (SF12-MCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")ciopts(msize(vsmall))


/////////////////////////////////graphs for care place

mixed sf12mcs_dv i.poyrtoset if kpscore==1 & (placecare==1|placecare==3)&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_in, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & (placecare==2)&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_out, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==0&poyrtoset!=0&poyrtoset<15&poyrtoset!=1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_nocare, replace)

combomarginsplot file1_in file1_out file1_nocare, labels ("inside household care" "outside household care" "non carers") savefile(combined_sfm_place, replace)

mplotoffset using combined_sfm_place, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 16-29") xtitle ("Years centred on care onset year") ytitle (SF12-MCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8")ciopts(msize(vsmall))






//////////////////////modelling 
mixed sf12mcs_dv part1 i.kpscore##c.part2 i.kpscore##c.part3 || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
mixed sf12mcs_dv part1 i.kpscore##c.part2##sex i.kpscore##c.part3##sex || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.kpscore#c.part2#sex i.kpscore#c.part3#sex
testparm i.kpscore#c.part2#sex

gen careintensity=0 if kpscore==0
replace careintensity=1 if kpscore==1&meanhour_g==1
replace careintensity=2 if kpscore==1&meanhour_g==2
replace careintensity=3 if kpscore==1&meanhour_g==3
replace careintensity=4 if kpscore==1&(meanhour_g==4|meanhour_g==5)

mixed sf12mcs_dv part1 i.careintensity##c.part2 i.careintensity##c.part3 if  kpscore==1|| hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.careintensity#c.part2 i.careintensity#c.part3 
testparm i.careintensity#c.part2 

gen careplace=0 if kpscore==0
replace careplace=2 if kpscore==1&(placecare==1|placecare==3)
replace careplace=1 if kpscore==1&placecare==2
* 1 is outside, 2 is inside 
mixed sf12mcs_dv part1 i.careplace##c.part2 i.careplace##c.part3 if  kpscore==1|| hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.careplace#c.part2 i.careplace#c.part3
testparm i.careplace#c.part2 






