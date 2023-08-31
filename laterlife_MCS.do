
//////////////////////////////////////////////////////////////////////////////////////////////////
*******************************************************prepare the data for 1:2 matching
//////////////////////////////////////////////////////////////////////////////////////////////////




use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", clear
keep if oldcare!=.
keep pidp oldcare *age_dv yougcare omidcare oldcare sex ethnicity parenclass_h incomqu_1obold age_1ob_old agemin ///
agemax ageonset_old wavesobs_old higestedu children_1ob_old  *_scghq1_dv *_sf12mcs_dv *_sf12pcs_dv *_oldcareany  *_age_dv wavefirstcar_old psu strata ///
class_1ob_old  workcom_old marriage_1ob_old age_1ob_old wavefirstobv_old urban_1ob_old children_1ob_old *_hidp
/////////////select sample who have participated the survey once before and once after the care onset
gen samplepiece=1 if agemin<ageonset_old & agemax>=ageonset_old & ageonset_old!=. 
drop if samplepiece!=1&oldcare==1
drop if omidcare ==1
*2344 deleted


tokenize "`c(alpha)'"
gen sfm_1ob_old=a_sf12mcs_dv if wavefirstobv_old==1
forval waveno = 2/10 {
  replace sfm_1ob_old=``waveno''_sf12mcs_dv if wavefirstobv_old==`waveno'
}
recode sfm_1ob_old (min/-1=.)


tokenize "`c(alpha)'"
gen sfp_1ob_old=a_sf12pcs_dv if wavefirstobv_old==1
forval waveno = 2/10 {
  replace sfp_1ob_old=``waveno''_sf12pcs_dv if wavefirstobv_old==`waveno'
}
recode sfp_1ob_old (min/-1=.)

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
parenclass_h urban_1ob_old children_1ob_old workcom_old  higestedu sfm_1ob_old if oldcare==1



kmatch ps oldcare age_1ob_old i.ethnicity i.incomqu_1obold i.class_1ob_old i.workcom_old i.marriage_1ob_old i.parenclass_h i.urban_1ob_old i.children_1ob_old i.higestedu i.wavesobs  (sfm_1ob_old sfp_1ob_old), ematch(sex) nn(2) idgenerate(controlid) idvar(pidp)generate(kpscore)


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

save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_old_sfm.dta"
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_old_sfm.dta"
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

keep pidp *age_dv  *sf12mcs_dv  ageonset_all oldcare age_1ob_old agemax agemin kpscore sex hhid_1obya meanhour_oldg placecare_old

 
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
recode sf12mcs_dv (min/-1=.)





/////////////////////////////////graphs for yes/no care
mixed sf12mcs_dv i.poyrtoset if kpscore==1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_yn, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_old_yn, replace)
combomarginsplot file1_old_yn file2_old_yn, labels ("carers" "non carers") savefile(combined_sfm_yn, replace)

mplotoffset using combined_sfm_yn, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (SF12-MCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8") ciopts(msize(vsmall))



/////////////////////////////////graphs for yes/no care by sex
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & sex==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_yn_m, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==0 & sex==1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_old_yn_m, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & sex==2|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_yn_f, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==0 & sex==2 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_old_yn_f, replace)
combomarginsplot file1_old_yn_m file2_old_yn_m file1_old_yn_f file2_old_yn_f, labels ("male carers" "male non carers" "female carers" "female non carers") savefile(combined_sfm_yn_sex, replace)

mplotoffset using combined_sfm_yn_sex, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (SF12-MCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8") ciopts(msize(vsmall))



/////////////////////////////////graphs for care intensity 
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & meanhour_oldg==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_low, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & meanhour_oldg==2|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_lmid, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & meanhour_oldg==3|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_mid, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & (meanhour_oldg==4|meanhour_oldg==5) || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_hig, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==0 & poyrtoset!=0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_ncare, replace)
combomarginsplot file1_old_low file1_old_lmid file1_old_mid file1_old_hig file1_old_ncare, labels ("<5h per week" "5-9h per week" "10-19h per week" "20+h per week" "non carers") savefile(combined_sfm_intensity, replace)

mplotoffset using combined_sfm_intensity, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (SF12-MCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8") ciopts(msize(vsmall))


/////////////////////////////////graphs for care place

mixed sf12mcs_dv i.poyrtoset if kpscore==1 & (placecare_old==1|placecare_old==3)|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_in, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==1 & (placecare_old==2)|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_out, replace)
mixed sf12mcs_dv i.poyrtoset if kpscore==0|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_nocare, replace)

combomarginsplot file1_old_in file1_old_out file1_old_nocare, labels ("inside household care" "outside household care" "non carers") savefile(combined_sfm_place, replace)

mplotoffset using combined_sfm_place, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (SF12-MCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8") ciopts(msize(vsmall))

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig2_panelA\"
grc1leg SFM_16_29_yn.gph SFM_30_49_yn.gph SFM_50_64_yn.gph SFM_65plus_yn.gph,ycommon

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig2_panelB\"
grc1leg SFM_16_29_sex.gph SFM_30_49_sex.gph SFM_50_64_sex.gph SFM_65plus_sex.gph,ycommon

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig2_panelC\"
grc1leg SFM_16_29_intensity.gph SFM_30_49_intensity.gph SFM_50_64_intensity.gph SFM_65plus_intensity.gph,ycommon

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig2_panelD\"
grc1leg SFM_16_29_place.gph SFM_30_49_place.gph SFM_50_64_place.gph SFM_65plus_place.gph,ycommon



//////////////////////modelling 
mixed sf12mcs_dv part1 i.kpscore##c.part2 i.kpscore##c.part3 || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
mixed sf12mcs_dv part1 i.kpscore##c.part2##sex i.kpscore##c.part3##sex || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.kpscore#c.part2#sex i.kpscore#c.part3#sex
testparm i.kpscore#c.part2#sex

gen careintensity=0 if kpscore==0
replace careintensity=1 if kpscore==1&meanhour_oldg==1
replace careintensity=2 if kpscore==1&meanhour_oldg==2
replace careintensity=3 if kpscore==1&meanhour_oldg==3
replace careintensity=4 if kpscore==1&(meanhour_oldg==4|meanhour_oldg==5)

mixed sf12mcs_dv part1 i.careintensity##c.part2 i.careintensity##c.part3 if  kpscore==1|| hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.careintensity#c.part2 i.careintensity#c.part3 
testparm i.careintensity#c.part2 

gen careplace=0 if kpscore==0
replace careplace=2 if kpscore==1&(placecare_old==1|placecare_old==3)
replace careplace=1 if kpscore==1&placecare_old==2
* 1 is outside, 2 is inside 
mixed sf12mcs_dv part1 i.careplace##c.part2 i.careplace##c.part3 if  kpscore==1|| hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.careplace#c.part2 i.careplace#c.part3
testparm i.careplace#c.part2 
