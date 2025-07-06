import delimited "/yourpath/df_long1.csv", clear
* Generate logarithmic income variables
gen ln_income = log(income)
* Encode the string id variable
encode msoa11cd, gen(msoa_id)
* Set the panel structure
xtset msoa_id year
ssc install reghdfe
ssc install ftools

* ==============================
* Table 6. Placebo Test Results in 2011
* ==============================
* 5.3.2 Placebo Test (Random Treatment Group Test)
* Save current data
preserve

* Generate random treatment group (based on 2011 data)
keep if year == 2011
set seed 12345
gen random = runiform()
sort random
gen fake_treat = _n <= _N * 0.5
keep msoa_id fake_treat
tempfile fake_treatment
save `fake_treatment'

* Restore original data and merge
restore
merge m:1 msoa_id using `fake_treatment'
drop if _merge != 3
drop _merge

* Generate fake treatment variable (takes effect in 2021)
gen fake_oa = fake_treat * (year == 2021)

* Placebo test for ln_income
reghdfe ln_income fake_oa pop unem edu mig, absorb(msoa_id year) cluster(msoa_id)
estimates store placebo_income

* Placebo test for imd
reghdfe imd fake_oa pop unem edu mig, absorb(msoa_id year) cluster(msoa_id)
estimates store placebo_imd

* Output placebo test results
esttab placebo_income placebo_imd using "table_6_2_placebo.rtf", ///
    keep(fake_oa) b(4) se(4) ///
    mtitles("Log Income" "Multiple Deprivation Index") ///
    title("Table 6") ///
    varlabels(fake_oa "Fake Treatment Effect") ///
    addnotes("Notes: Standard errors in parentheses. ***, **, * indicate significance at 1%, 5%, 10% levels respectively. All regressions control for population size, unemployment rate, education level, migration rate, and include MSOA and year fixed effects.") ///
    stats(N r2_a, labels("Observations" "Adjusted R²") fmt(0 4)) ///
    star(* 0.10 ** 0.05 *** 0.01) replace rtf


