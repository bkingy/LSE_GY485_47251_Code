import delimited "/yourpath/df_long1.csv", clear
* Generate logarithmic income variables
gen ln_income = log(income)
* Encode the string id variable
encode msoa11cd, gen(msoa_id)
* Set the panel structure
xtset msoa_id year

* ==============================
* Table 3. Descriptive Statistics
* ==============================
estpost summarize ln_income imd oa pop unem edu mig 
esttab using descriptives.rtf, cells("count mean sd min max") replace title("5.1 Descriptive Statistics") label noobs nonumber

* ==============================
* Table 4. Regression Results of Equation (2) and Equation (3)
* ==============================
* Note: Using oa directly as it can vary across time periods
* No need to generate interaction term since oa captures the treatment effect
* Install required packages for result storage and table creation
ssc install estout, replace
ssc install outreg2, replace

* Model 1: Log Income Regression (Equation 2)
* Model 1.0: OLS without fixed effects
reg ln_income oa, vce(cluster msoa_id)
estimates store model1_0
* Model 1.1: Basic DID with only OA treatment
xtreg ln_income oa i.year, fe vce(cluster msoa_id)
estimates store model1_1
* Model 1.2: Add population control
xtreg ln_income oa pop i.year, fe vce(cluster msoa_id)
estimates store model1_2
* Model 1.3: Add unemployment control
xtreg ln_income oa pop unem i.year, fe vce(cluster msoa_id)
estimates store model1_3
* Model 1.4: Add education control
xtreg ln_income oa pop unem edu i.year, fe vce(cluster msoa_id)
estimates store model1_4
* Model 1.5: Add migration control (full model)
xtreg ln_income oa pop unem edu mig i.year, fe vce(cluster msoa_id)
estimates store model1_5

* Model 2: IMD Regression (Equation 3)
* Model 2.0: OLS without fixed effects
reg imd oa, vce(cluster msoa_id)
estimates store model2_0
* Model 2.1: Basic DID with only OA treatment
xtreg imd oa i.year, fe vce(cluster msoa_id)
estimates store model2_1
* Model 2.2: Add population control
xtreg imd oa pop i.year, fe vce(cluster msoa_id)
estimates store model2_2
* Model 2.3: Add unemployment control
xtreg imd oa pop unem i.year, fe vce(cluster msoa_id)
estimates store model2_3
* Model 2.4: Add education control
xtreg imd oa pop unem edu i.year, fe vce(cluster msoa_id)
estimates store model2_4
* Model 2.5: Add migration control (full model)
xtreg imd oa pop unem edu mig i.year, fe vce(cluster msoa_id)
estimates store model2_5

* Create Comprehensive Results Table
esttab model1_0 model1_1 model1_2 model1_3 model1_4 model1_5 model2_0 model2_1 model2_2 model2_3 model2_4 model2_5 using "did_results_table.rtf", replace rtf b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) title("DID Fixed Effects Regression Results") mtitles("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)" "(11)" "(12)") mgroups("Log Income" "IMD", pattern(1 0 0 0 0 0 1 0 0 0 0 0) span) label nonumbers addnotes("Notes: Standard errors clustered at MSOA level in parentheses. * p<0.10, ** p<0.05, *** p<0.01." "MSOA Fixed Effects: No in (1) & (7); Yes in others." "Time Fixed Effects: No in (1) & (7); Yes in others.") stats(N r2_a F, labels("Observations" "Adj. R-squared" "F-statistic") fmt(0 3 2)) keep(oa pop unem edu mig _cons) order(oa pop unem edu mig _cons) varlabels(oa "OA Treatment" pop "Population" unem "Unemployment Rate" edu "Education Level" mig "Migration Rate" _cons "Constant")
