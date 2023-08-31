
//////////////////////////////////////////////early adulthood (16-29y)
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact.dta"

tab kpscore if ageonset_all!=.
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all

replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

tab kpscore if ageonset_all!=.
gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample

gen ghqsample=1 if kpscore!=.&usesample==1
rename kpscore ghq_treated

save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\ghqsamplevar.dta"

use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_sf.dta"
tab kpscore if ageonset_all!=.
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all

replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

tab kpscore if ageonset_all!=.
gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample

gen sfsample=1 if kpscore!=.&usesample==1
rename kpscore sf_treated
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\sfsamplevar.dta"

use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\ghqsamplevar.dta",keepus (ghqsample ghq_treated)
drop _merge

merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\sfsamplevar.dta",keepus (sfsample sf_treated)
drop _merge


gen youngallsample=1 if ghqsample==1| sfsample==1
mean age_1ob_ya if youngallsample==1
sum age_1ob_ya if youngallsample==1
tab ethnicity if youngallsample==1
tab parenclass_h if youngallsample==1
tab incomqu_1obya if youngallsample==1
tab workcom_ya if youngallsample==1
tab class_1obya if youngallsample==1
tab higestedu if youngallsample==1
tab marriage_1ob_ya if youngallsample==1
tab children_1ob_ya if youngallsample==1
tab urban_1ob_ya if youngallsample==1


tab sf_treated ghq_treated
gen carebi=0 if sf_treated==0| ghq_treated==0
replace carebi=1 if sf_treated==1| ghq_treated==1

sum age_1ob_ya if youngallsample==1&carebi==0
sum age_1ob_ya if youngallsample==1&carebi==1
tab ethnicity carebi if youngallsample==1,col nofre
tab parenclass_h carebi  if youngallsample==1,col nofre
tab incomqu_1obya carebi  if youngallsample==1,col nofre
tab higestedu carebi if youngallsample==1,col nofre
tab workcom_ya carebi  if youngallsample==1,col nofre
tab class_1obya carebi if youngallsample==1,col nofre
tab marriage_1ob_ya carebi  if youngallsample==1,col nofre
tab children_1ob_ya carebi if youngallsample==1,col nofre
tab urban_1ob_ya carebi  if youngallsample==1,col nofre



sum age_1ob_ya if youngallsample==1&sex==1
sum age_1ob_ya if youngallsample==1&sex==2
tab ethnicity sex if youngallsample==1,col nofre
tab parenclass_h sex  if youngallsample==1,col nofre
tab incomqu_1obya sex  if youngallsample==1,col nofre
tab higestedu sex if youngallsample==1,col nofre
tab workcom_ya sex  if youngallsample==1,col nofre
tab class_1obya sex if youngallsample==1,col nofre
tab marriage_1ob_ya sex  if youngallsample==1,col nofre
tab children_1ob_ya sex if youngallsample==1,col nofre
tab urban_1ob_ya sex  if youngallsample==1,col nofre

merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta",keepus (placecare meannum_g duration_g)
drop if_merge==2
drop _merge
tab meanhour_g sex if youngallsample==1&carebi==1,col nofre
tab placecare sex if youngallsample==1&carebi==1,col nofre
tab meannum_g sex if youngallsample==1&carebi==1,col nofre
tab duration_g sex if youngallsample==1&carebi==1,col nofre


merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", keepusing (care_parent care_grand care_partner care_sibling care_child care_otherrel care_nonrel)
drop _merge
tab care_parent sex if youngallsample==1&carebi==1,col nofre
tab care_grand sex if youngallsample==1&carebi==1,col nofre
tab care_partner sex if youngallsample==1&carebi==1,col nofre
tab care_sibling sex if youngallsample==1&carebi==1,col nofre
tab care_child sex if youngallsample==1&carebi==1,col nofre
tab care_otherrel sex if youngallsample==1&carebi==1,col nofre
tab care_nonrel sex if youngallsample==1&carebi==1,col nofre

/////////////////////////////////////////////////////////////early mid adulthood (30-49)
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_ym.dta"

tab kpscore if ageonset_all!=.
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all

replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

tab kpscore if ageonset_all!=.
gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample

gen ghqsample=1 if kpscore!=.&usesample==1
rename kpscore ghq_treated

save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\ghqsamplevar_ym.dta"

use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_ym_sfm.dta"
tab kpscore if ageonset_all!=.
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all

replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

tab kpscore if ageonset_all!=.
gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample

gen sfsample=1 if kpscore!=.&usesample==1
rename kpscore sf_treated
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\sfsamplevar_ym.dta"


use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_ym.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\ghqsamplevar_ym.dta",keepus (ghqsample ghq_treated)
drop _merge

merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\sfsamplevar_ym.dta",keepus (sfsample sf_treated)
drop _merge


gen ymidallsample=1 if ghqsample==1| sfsample==1

sum age_1ob_ym if ymidallsample==1
sum age_1ob_ym if ymidallsample==1&sex==1
sum age_1ob_ym if ymidallsample==1&sex==2
tab ethnicity sex if ymidallsample==1,col nofre
tab parenclass_h sex  if ymidallsample==1,col nofre
tab incomqu_1obym sex  if ymidallsample==1,col nofre
tab higestedu sex if ymidallsample==1,col nofre
tab workcom_ym sex  if ymidallsample==1,col nofre
tab class_1ob_ym sex if ymidallsample==1,col nofre
tab marriage_1ob_ym sex  if ymidallsample==1,col nofre
tab children_1ob_ym sex if ymidallsample==1,col nofre
tab urban_1ob_ym sex  if ymidallsample==1,col nofre



tab sf_treated ghq_treated
gen carebi=0 if sf_treated==0| ghq_treated==0
replace carebi=1 if sf_treated==1| ghq_treated==1

sum age_1ob_ym if ymidallsample==1&carebi==0
sum age_1ob_ym if ymidallsample==1&carebi==1
tab ethnicity carebi if ymidallsample==1,col nofre
tab parenclass_h carebi  if ymidallsample==1,col nofre
tab incomqu_1obym carebi  if ymidallsample==1,col nofre
tab higestedu carebi if ymidallsample==1,col nofre
tab workcom_ym carebi  if ymidallsample==1,col nofre
tab class_1ob_ym carebi if ymidallsample==1,col nofre
tab marriage_1ob_ym carebi  if ymidallsample==1,col nofre
tab children_1ob_ym carebi if ymidallsample==1,col nofre
tab urban_1ob_ym carebi  if ymidallsample==1,col nofre


merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", keepusing (meanhour_ymg placecare_ym meannumcar_ymg duration_ymg care_parent_ym care_grand_ym care_partner_ym care_sibling_ym care_child_ym care_otherrel_ym care_nonrel_ym placecare_ym meannumcar_ymg  duration_ymg)
drop if _merge==2
drop _merge

tab meanhour_ymg sex if ymidallsample==1&carebi==1,col nofre
tab placecare_ym sex if ymidallsample==1&carebi==1,col nofre
tab meannumcar_ymg sex if ymidallsample==1&carebi==1,col nofre
tab duration_ymg sex if ymidallsample==1&carebi==1,col nofre

tab care_parent sex if ymidallsample==1&carebi==1,col nofre
tab care_grand sex if ymidallsample==1&carebi==1,col nofre
tab care_partner sex if ymidallsample==1&carebi==1,col nofre
tab care_sibling sex if ymidallsample==1&carebi==1,col nofre
tab care_child sex if ymidallsample==1&carebi==1,col nofre
tab care_otherrel sex if ymidallsample==1&carebi==1,col nofre
tab care_nonrel sex if ymidallsample==1&carebi==1,col nofre

///////////////////////////////////////////////////////////////late mid_adulthood (50-64)
use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_om.dta"

tab kpscore if ageonset_all!=.
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all

replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

tab kpscore if ageonset_all!=.
gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample

gen ghqsample=1 if kpscore!=.&usesample==1
rename kpscore ghq_treated

save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\ghqsamplevar_om.dta"

use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_om_sfm.dta"
tab kpscore if ageonset_all!=.
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all

replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

tab kpscore if ageonset_all!=.
gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample

gen sfsample=1 if kpscore!=.&usesample==1
rename kpscore sf_treated
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\sfsamplevar_om.dta"


use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_om.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\ghqsamplevar_om.dta",keepus (ghqsample ghq_treated)
drop _merge

merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\sfsamplevar_om.dta",keepus (sfsample sf_treated)
drop _merge


gen omidallsample=1 if ghqsample==1| sfsample==1

sum age_1ob_om if omidallsample==1
sum age_1ob_om if omidallsample==1&sex==1
sum age_1ob_om if omidallsample==1&sex==2
tab ethnicity sex if omidallsample==1,col nofre
tab parenclass_h sex  if omidallsample==1,col nofre
tab incomqu_1obom sex  if omidallsample==1,col nofre
tab higestedu sex if omidallsample==1,col nofre
tab workcom_om sex  if omidallsample==1,col nofre
tab class_1ob_om sex if omidallsample==1,col nofre
recode  marriage_1ob_om 9=.
tab marriage_1ob_om sex  if omidallsample==1,col nofre
tab children_1ob_om sex if omidallsample==1,col nofre
tab urban_1ob_om sex  if omidallsample==1,col nofre



tab sf_treated ghq_treated
gen carebi=0 if sf_treated==0| ghq_treated==0
replace carebi=1 if sf_treated==1| ghq_treated==1

sum age_1ob_om if omidallsample==1&carebi==0
sum age_1ob_om if omidallsample==1&carebi==1
tab ethnicity carebi if omidallsample==1,col nofre
tab parenclass_h carebi  if omidallsample==1,col nofre
tab incomqu_1obom carebi  if omidallsample==1,col nofre
tab higestedu carebi if omidallsample==1,col nofre
tab workcom_om carebi  if omidallsample==1,col nofre
tab class_1ob_om carebi if omidallsample==1,col nofre
tab marriage_1ob_om carebi  if omidallsample==1,col nofre
tab children_1ob_om carebi if omidallsample==1,col nofre
tab urban_1ob_om carebi  if omidallsample==1,col nofre






merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", keepusing (meanhour_omg placecare_om meannumcar_omg duration_omg care_parent_om care_grand_om care_partner_om care_sibling_om care_child_om care_otherrel_om care_nonrel_om placecare_om meannumcar_omg  duration_omg)
drop if _merge==2
drop _merge

tab meanhour_omg sex if omidallsample==1&carebi==1,col nofre
tab placecare_om sex if omidallsample==1&carebi==1,col nofre
tab meannumcar_omg sex if omidallsample==1&carebi==1,col nofre
tab duration_omg sex if omidallsample==1&carebi==1,col nofre

tab care_parent sex if omidallsample==1&carebi==1,col nofre
tab care_grand sex if omidallsample==1&carebi==1,col nofre
tab care_partner sex if omidallsample==1&carebi==1,col nofre
tab care_sibling sex if omidallsample==1&carebi==1,col nofre
tab care_child sex if omidallsample==1&carebi==1,col nofre
tab care_otherrel sex if omidallsample==1&carebi==1,col nofre
tab care_nonrel sex if omidallsample==1&carebi==1,col nofre


tab meanhour_omg  if omidallsample==1&carebi==1
tab placecare_om if omidallsample==1&carebi==1
tab meannumcar_omg  if omidallsample==1&carebi==1
tab duration_omg if omidallsample==1&carebi==1



//////////////////////////////////////////////////////////////////////later life 65+
se "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_old.dta"

tab kpscore if ageonset_all!=.
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all

replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

tab kpscore if ageonset_all!=.
gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample

gen ghqsample=1 if kpscore!=.&usesample==1
rename kpscore ghq_treated

save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\ghqsamplevar_old.dta"

use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_old_sfm.dta"
tab kpscore if ageonset_all!=.
gen preafter=1 if agemin <ageonset_all & agemax>=ageonset_all

replace ageonset_all=ageonset_g3 if preafter!=1
gen preafter2=1 if agemin <ageonset_all & agemax>=ageonset_all
replace ageonset_all=ageonset_g4 if preafter2!=1

tab kpscore if ageonset_all!=.
gen usesample=1 if agemin <ageonset_all & agemax>=ageonset_all
tab kpscore usesample

gen sfsample=1 if kpscore!=.&usesample==1
rename kpscore sf_treated
save "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\sfsamplevar_old.dta"


use "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\1to2matchedexact_old.dta"
merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\ghqsamplevar_old.dta",keepus (ghqsample ghq_treated)
drop _merge

merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\sfsamplevar_old.dta",keepus (sfsample sf_treated)
drop _merge


gen omidallsample=1 if ghqsample==1| sfsample==1

sum age_1ob_old if omidallsample==1
sum age_1ob_old if omidallsample==1&sex==1
sum age_1ob_old if omidallsample==1&sex==2
tab ethnicity sex if omidallsample==1,col nofre
tab parenclass_h sex  if omidallsample==1,col nofre
tab incomqu_1obold sex  if omidallsample==1,col nofre
tab higestedu sex if omidallsample==1,col nofre
tab workcom_old sex  if omidallsample==1,col nofre
tab class_1ob_old sex if omidallsample==1,col nofre
recode  marriage_1ob_old 9=.
tab marriage_1ob_old sex  if omidallsample==1,col nofre
tab children_1ob_old sex if omidallsample==1,col nofre
tab urban_1ob_old sex  if omidallsample==1,col nofre



tab sf_treated ghq_treated
gen carebi=0 if sf_treated==0| ghq_treated==0
replace carebi=1 if sf_treated==1| ghq_treated==1

sum age_1ob_old if omidallsample==1&carebi==0
sum age_1ob_old if omidallsample==1&carebi==1
tab ethnicity carebi if omidallsample==1,col nofre
tab parenclass_h carebi  if omidallsample==1,col nofre
tab incomqu_1obold carebi  if omidallsample==1,col nofre
tab higestedu carebi if omidallsample==1,col nofre
tab workcom_old carebi  if omidallsample==1,col nofre
tab class_1ob_old carebi if omidallsample==1,col nofre
tab marriage_1ob_old carebi  if omidallsample==1,col nofre
tab children_1ob_old carebi if omidallsample==1,col nofre
tab urban_1ob_old carebi  if omidallsample==1,col nofre



merge 1:1 pidp using "C:\Users\baowen\OneDrive - University College London\EUROCARE\data\wide_care.dta", keepusing (meanhour_oldg placecare_old meannumcar_oldg duration_oldg care_parent_old care_grand_old care_partner_old care_sibling_old care_child_old care_otherrel_old care_nonrel_old placecare_old meannumcar_oldg  duration_oldg)
drop if _merge==2
drop _merge


tab meanhour_oldg sex if omidallsample==1&carebi==1,col nofre
tab placecare_old sex if omidallsample==1&carebi==1,col nofre
tab meannumcar_oldg sex if omidallsample==1&carebi==1,col nofre
tab duration_oldg sex if omidallsample==1&carebi==1,col nofre

tab care_parent sex if omidallsample==1&carebi==1,col nofre
tab care_grand sex if omidallsample==1&carebi==1,col nofre
tab care_partner sex if omidallsample==1&carebi==1,col nofre
tab care_sibling sex if omidallsample==1&carebi==1,col nofre
tab care_child sex if omidallsample==1&carebi==1,col nofre
tab care_otherrel sex if omidallsample==1&carebi==1,col nofre
tab care_nonrel sex if omidallsample==1&carebi==1,col nofre

