import delimited "/yourpath/df_long1.csv"
* Generate logarithmic income variables
gen ln_income = log(income)
* Encode the string id variable
encode msoa11cd, gen(msoa_id)
* Set the panel structure
xtset msoa_id year

* ==============================
* Table 2. F test and Hausman test
* ==============================
* ln_income
* pooled OLS
reg ln_income oa pop unem edu mig
estimates store pooled_ln
* Fixed effect (F-test: Fixed effect vs. pooled OLS)
xtreg ln_income oa pop unem edu mig, fe
estimates store fe_ln
* Random effect
xtreg ln_income oa pop unem edu mig, re
estimates store re_ln
* Hausman test: Fixed effect vs. Random effect
hausman fe_ln re_ln, sigmamore

* imd
* pooled OLS
reg imd oa pop unem edu mig
estimates store pooled_imd
* Fixed effect
xtreg imd oa pop unem edu mig, fe
estimates store fe_imd
* Random effect
xtreg imd oa pop unem edu mig, re
estimates store re_imd
* Hausman test
hausman fe_imd re_imd, sigmamore



