* Import data and basic setup
import delimited "/yourpath/df_long1.csv", clear
gen ln_income = log(income)
encode msoa11cd, gen(msoa_id)
xtset msoa_id year

* ====================================================================
* Table 7. Regional Heterogeneity Analysis Results
* ====================================================================
* Create more meaningful groups
gen policy_timing = .

* Check the OA policy implementation model of each MSOA
bysort msoa_id: egen oa_2011 = max(oa * (year == 2011))
bysort msoa_id: egen oa_2021 = max(oa * (year == 2021))

* Group based on the policy implementation time model
replace policy_timing = 1 if oa_2011 == 0 & oa_2021 == 1  
replace policy_timing = 2 if oa_2011 == 1 & oa_2021 == 1  
replace policy_timing = 3 if oa_2011 == 0 & oa_2021 == 0  

label define timing 1 "New Implementation (2011-2021)" 2 "Early & Continuous" 3 "Never Implemented"
label values policy_timing timing

tab policy_timing year

* Group 1: New implementation group (with within variation)
preserve
keep if policy_timing == 1
xtreg ln_income oa pop unem edu mig, fe robust
estimates store income_new_impl
xtreg imd oa pop unem edu mig, fe robust
estimates store imd_new_impl
restore

* Group 2: Early continuous group (long-term OA coverage area)
preserve
keep if policy_timing == 2
gen year2021 = (year == 2021)
reg ln_income year2021 pop unem edu mig, robust cluster(msoa_id)
estimates store income_early_trend

reg imd year2021 pop unem edu mig, robust cluster(msoa_id)
estimates store imd_early_trend
restore

* Group 3: The never-implementation group
preserve
keep if policy_timing == 3
gen year2021 = (year == 2021)
reg ln_income year2021 pop unem edu mig, robust cluster(msoa_id)
estimates store income_never_trend
reg imd year2021 pop unem edu mig, robust cluster(msoa_id) 
estimates store imd_never_trend
restore

esttab income_new_impl income_early_trend income_never_trend imd_new_impl imd_early_trend imd_never_trend using "heterogeneity.rtf", title(Heterogeneity Analysis Based on OA Policy Timing) se star(* 0.1 ** 0.05 *** 0.01) label replace b(3) se(3) mtitles("lnincome: New" "lnincome: Early"  "lnincome: Never" "imd: New" "imd: Early" "imd: Never") keep(oa year2021)

* ====================================================================
* Table 8. Interaction Effects Between pop and mig on imd Results
* ====================================================================
reg imd c.pop##c.mig unem edu year, cluster(msoa_id)
eststo mymodel0
esttab mymodel0 using "population_migration_interaction.rtf", replace se star(* 0.1 ** 0.05 *** 0.01) label title("Heterogeneity Analysis: Interaction between Population and Migration on IMD") b(3) se(3)

* ====================================================================
* Table 9. Regression Results of imd with oa, pop and mig
* ====================================================================
eststo clear
reg imd c.oa##c.pop##c.mig unem edu year, cluster(msoa_id)
eststo mymodel

esttab mymodel using "imd_oa_pop_mig_interaction.rtf", title("Regression of IMD with OA, Population and Migration Interaction") se star(* 0.1 ** 0.05 *** 0.01) replace label

* ====================================================================
* Figure 8. The Marginal Effects Diagram
* ====================================================================
sum pop, detail
sum mig, detail
margins, at(pop=(7451 8308 9472) mig=(10.5 17.05 25.8)) dydx(oa)
marginsplot

* ====================================================================
* Table 10. Heterogeneity Regression Results by Educational Level
* ====================================================================
sum edu, detail

gen edu_group = .
replace edu_group = 1 if edu <= 31.1
replace edu_group = 2 if edu > 31.1 & edu <= 52
replace edu_group = 3 if edu > 52


reg ln_income oa unem edu mig year if edu_group == 1, cluster(msoa_id)
estimates store income_low_edu
reg imd oa unem edu mig year if edu_group == 1, cluster(msoa_id)
estimates store imd_low_edu
reg ln_income oa unem edu mig year if edu_group == 2, cluster(msoa_id)
estimates store income_mid_edu
reg imd oa unem edu mig year if edu_group == 2, cluster(msoa_id)
estimates store imd_mid_edu
reg ln_income oa unem edu mig year if edu_group == 3, cluster(msoa_id)
estimates store income_high_edu
reg imd oa unem edu mig year if edu_group == 3, cluster(msoa_id)
estimates store imd_high_edu

* Export results
esttab income_low_edu income_mid_edu income_high_edu imd_low_edu imd_mid_edu imd_high_edu using "edu_heterogeneity_analysis.rtf", title("Heterogeneity Analysis Based on Education Level") se star(* 0.1 ** 0.05 *** 0.01) replace label


