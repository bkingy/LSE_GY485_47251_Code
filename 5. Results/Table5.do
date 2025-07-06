import delimited "/yourpath/df_long1.csv", clear
* Generate logarithmic income variables
gen ln_income = log(income)
* Encode the string id variable
encode msoa11cd, gen(msoa_id)
* Set the panel structure
xtset msoa_id year

* ==============================
* Table 5. T-test Results by Year (2011 vs 2021)
* ==============================
* Cross-sectional comparison in 2011 (expected: No significant difference)
preserve
keep if year == 2011
* 2011 - Regression of ln_income as the dependent variable
reg ln_income oa pop unem edu mig, robust
estimates store reg_2011_income
* 2011 - Regression of imd as the dependent variable 
reg imd oa pop unem edu mig, robust
estimates store reg_2011_imd
* 2011 - Simple T-test
ttest ln_income, by(oa)
return list
scalar t_income_2011 = r(t)
scalar p_income_2011 = r(p)
ttest imd, by(oa)
return list
scalar t_imd_2011 = r(t)
scalar p_imd_2011 = r(p)
restore

* Cross-sectional Comparison in 2021 (Expected: Significant differences, 
* Direction consistent with the Main Model)
preserve
keep if year == 2021
* 2021 - Regression of ln_income as the dependent variable
reg ln_income oa pop unem edu mig, robust
estimates store reg_2021_income
* 2021 - Regression of imd as the dependent variable 
reg imd oa pop unem edu mig, robust
estimates store reg_2021_imd
* 2021 - Simple T-test
ttest ln_income, by(oa)
return list
scalar t_income_2021 = r(t)
scalar p_income_2021 = r(p)
ttest imd, by(oa)
return list
scalar t_imd_2021 = r(t)
scalar p_imd_2021 = r(p)
restore

* Result summary table
clear
set obs 4
gen str20 test_type = ""
gen str10 year = ""
gen str15 outcome = ""
gen coefficient = .
gen se = .
gen tstat = .
gen pvalue = .
gen str10 significance = ""
replace test_type = "Regression" in 1
replace year = "2011" in 1
replace outcome = "ln_income" in 1
replace test_type = "Regression" in 2
replace year = "2011" in 2
replace outcome = "imd" in 2
replace test_type = "Regression" in 3
replace year = "2021" in 3
replace outcome = "ln_income" in 3
replace test_type = "Regression" in 4
replace year = "2021" in 4
replace outcome = "imd" in 4
* Fill in the t-test results
replace tstat = scalar(t_income_2011) in 1
replace pvalue = scalar(p_income_2011) in 1
replace tstat = scalar(t_imd_2011) in 2
replace pvalue = scalar(p_imd_2011) in 2
replace tstat = scalar(t_income_2021) in 3
replace pvalue = scalar(p_income_2021) in 3
replace tstat = scalar(t_imd_2021) in 4
replace pvalue = scalar(p_imd_2021) in 4
* Generate significant markers
replace significance = "***" if pvalue < 0.05
replace significance = "" if pvalue >= 0.05
* Show results
list
outsheet test_type year outcome tstat pvalue significance using "Table 5.csv", comma replace

