

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

keep pidp *age_dv  *sf12pcs_dv  ageonset_all oldcare age_1ob_old agemax agemin kpscore sex hhid_1obya meanhour_oldg placecare_old

 
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
reshape long sf12pcs_dv age_dv , i(pidp) j(wave)
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
recode sf12pcs_dv (min/-1=.)




/////////////////////////////////graphs for yes/no care
mixed sf12pcs_dv i.poyrtoset if kpscore==1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_yn, replace)
mixed sf12pcs_dv i.poyrtoset if kpscore==0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_old_yn, replace)
combomarginsplot file1_old_yn file2_old_yn, labels ("carers" "non carers") savefile(combined_sfp_yn, replace)

mplotoffset using combined_sfp_yn, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (SF12-PCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8") ciopts(msize(vsmall))



/////////////////////////////////graphs for yes/no care by sex
mixed sf12pcs_dv i.poyrtoset if kpscore==1 & sex==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_yn_m, replace)
mixed sf12pcs_dv i.poyrtoset if kpscore==0 & sex==1 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_old_yn_m, replace)
mixed sf12pcs_dv i.poyrtoset if kpscore==1 & sex==2|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_yn_f, replace)
mixed sf12pcs_dv i.poyrtoset if kpscore==0 & sex==2 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file2_old_yn_f, replace)
combomarginsplot file1_old_yn_m file2_old_yn_m file1_old_yn_f file2_old_yn_f, labels ("male carers" "male non carers" "female carers" "female non carers") savefile(combined_sfp_yn_sex, replace)

mplotoffset using combined_sfp_yn_sex, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (SF12-PCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8") ciopts(msize(vsmall))



/////////////////////////////////graphs for care intensity 
mixed sf12pcs_dv i.poyrtoset if kpscore==1 & meanhour_oldg==1|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_low, replace)
mixed sf12pcs_dv i.poyrtoset if kpscore==1 & meanhour_oldg==2|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_lmid, replace)
mixed sf12pcs_dv i.poyrtoset if kpscore==1 & meanhour_oldg==3|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_mid, replace)
mixed sf12pcs_dv i.poyrtoset if kpscore==1 & (meanhour_oldg==4|meanhour_oldg==5) || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_hig, replace)
mixed sf12pcs_dv i.poyrtoset if kpscore==0 & poyrtoset!=0 || hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_ncare, replace)
combomarginsplot file1_old_low file1_old_lmid file1_old_mid file1_old_hig file1_old_ncare, labels ("<5h per week" "5-9h per week" "10-19h per week" "20+h per week" "non carers") savefile(combined_sfp_intensity, replace)

mplotoffset using combined_sfp_intensity, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (SF12-PCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8") ciopts(msize(vsmall))


/////////////////////////////////graphs for care place

mixed sf12pcs_dv i.poyrtoset if kpscore==1 & (placecare_old==1|placecare_old==3)|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_in, replace)
mixed sf12pcs_dv i.poyrtoset if kpscore==1 & (placecare_old==2)|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_out, replace)
mixed sf12pcs_dv i.poyrtoset if kpscore==0|| hhid_1obya:,covariance(unstructured)mle var
margins i.poyrtoset,saving(file1_old_nocare, replace)

combomarginsplot file1_old_in file1_old_out file1_old_nocare, labels ("inside household care" "outside household care" "non carers") savefile(combined_sfp_place, replace)

mplotoffset using combined_sfp_place, xline(7,lpattern(shortdash)lcolor(gray)) xline(8,lpattern(shortdash)lcolor(gray)) title("Age 65+") xtitle ("Years centred on care onset year") ytitle (SF12-PCS) xlabel(0 "-8" 1 "-7" 2 "-6" 3 "-5" 4 "-4" 5 "-3" 6 "-2" 7 "-1" 8 "0" 9 "1" 10 "2" 11 "3" 12 "4" 13 "5" 14 "6" 15 "7" 16 "8") ciopts(msize(vsmall))

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig3_panelA\"
grc1leg sfp_16_29_yn.gph sfp_30_49_yn.gph sfp_50_64_yn.gph sfp_65plus_yn.gph,ycommon

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig3_panelB\"
grc1leg sfp_16_29_sex.gph sfp_30_49_sex.gph sfp_50_64_sex.gph sfp_65plus_sex.gph,ycommon

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig3_panelC\"
grc1leg sfp_16_29_intensity.gph sfp_30_49_intensity.gph sfp_50_64_intensity.gph sfp_65plus_intensity.gph,ycommon

cd "C:\Users\baowen\OneDrive - University College London\EUROCARE\Life course health\lancet_revision\Fig3_panelD\"
grc1leg sfp_16_29_place.gph sfp_30_49_place.gph sfp_50_64_place.gph sfp_65plus_place.gph,ycommon






//////////////////////modelling 
mixed sf12pcs_dv part1 i.kpscore##c.part2 i.kpscore##c.part3 || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
mixed sf12pcs_dv part1 i.kpscore##c.part2##sex i.kpscore##c.part3##sex || hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.kpscore#c.part2#sex i.kpscore#c.part3#sex
testparm i.kpscore#c.part2#sex

gen careintensity=0 if kpscore==0
replace careintensity=1 if kpscore==1&meanhour_oldg==1
replace careintensity=2 if kpscore==1&meanhour_oldg==2
replace careintensity=3 if kpscore==1&meanhour_oldg==3
replace careintensity=4 if kpscore==1&(meanhour_oldg==4|meanhour_oldg==5)

mixed sf12pcs_dv part1 i.careintensity##c.part2 i.careintensity##c.part3 if  kpscore==1|| hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.careintensity#c.part2 i.careintensity#c.part3 
testparm i.careintensity#c.part2 

gen careplace=0 if kpscore==0
replace careplace=2 if kpscore==1&(placecare_old==1|placecare_old==3)
replace careplace=1 if kpscore==1&placecare_old==2
* 1 is outside, 2 is inside 
mixed sf12pcs_dv part1 i.careplace##c.part2 i.careplace##c.part3 if  kpscore==1|| hhid_1obya:||pidp:poyrtoset,covariance(unstructured)mle var
testparm i.careplace#c.part2 i.careplace#c.part3
testparm i.careplace#c.part2 