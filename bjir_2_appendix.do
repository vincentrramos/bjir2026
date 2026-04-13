// ==============================================================================
// Paper:     Too Little, Too Weak? Paid Parental Leaves in Philippine Collective Agreements
// Author:    Vincent Jerald Ramos
// Date:      April 2026
// Purpose:   Appendix Figures and Tables 
// ==============================================================================



clear all
clear matrix
capture drop _all
capture log close
macro drop _all
capture program drop _all
set more off
set mat 2000
eststo clear
set more off 
set emptycells drop

global WRITE "Tables"
global WRITEFIG "Figures_BJIR_newoutcome"


use "ph_cbas_bjir.dta", clear




******************************** TABLES ***************************************

// Table A. 1. Descriptive Statistics of Full Sample
	
	table (var), ///
		statistic(fvfrequency firm_multinational union_federation union_rep_gender firm_rep_gender wage_inc otherinfo_new_reneg cba_duration_grp post_mlreform_cutoff1 PSIC cba_region) ///
		statistic(fvpercent firm_multinational union_federation union_rep_gender firm_rep_gender wage_inc otherinfo_new_reneg cba_duration_grp post_mlreform_cutoff1 PSIC cba_region) ///
		nformat(%5.2f fvpercent) sformat("%s%%" fvpercent)
		
	collect recode result fvpercent = column1 fvfrequency = column2
	collect layout (var) (result[column1 column2])
	collect style header result, level(hide)
	collect style row stack, nobinder spacer
	collect style cell var[firm_multinational union_federation union_rep_gender firm_rep_gender wage_inc otherinfo_new_reneg cba_duration_grp post_mlreform_cutoff1 PSIC cba_region]#result[column2], nformat(%5.2f) sformat("%s%%")
	collect preview
	collect export "$WRITEFIG\desc_sumstats.xlsx", replace

// Table A. 2. Paid Parental Leaves - Prevalence by Key Indicators
	table PSIC, ///
		statistic(mean mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess) ///
		nformat(%6.3f)
	collect export "$WRITEFIG\ppl_psic.xlsx", replace
		
	table cba_region, ///
		statistic(mean mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess) ///
		nformat(%6.3f)
	collect export "$WRITEFIG\ppl_region.xlsx", replace
		
	table firm_multinational, ///
		statistic(mean mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess) ///
		nformat(%6.3f)
	collect export "$WRITEFIG\ppl_multinational.xlsx", replace    

	table union_federation, ///
		statistic(mean mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess) ///
		nformat(%6.3f)
	collect export "$WRITEFIG\ppl_unionfed.xlsx", replace    
	
		
	table post_mlreform_cutoff1, ///
		statistic(mean mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess) ///
		nformat(%6.3f)
	collect export "$WRITEFIG\ppl_reform.xlsx", replace
	
	table union_rep_gender, ///
		statistic(mean mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess) ///
		nformat(%6.3f)
	collect export "$WRITEFIG\ppl_unionrepgender.xlsx", replace
	
	table firm_rep_gender, ///
		statistic(mean mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess) ///
		nformat(%6.3f)
	collect export "$WRITEFIG\ppl_firmrepgender.xlsx", replace
	
	table wage_inc, ///
		statistic(mean mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess) ///
		nformat(%6.3f)
	collect export "$WRITEFIG\ppl_wage_inc.xlsx", replace
	
	
	table otherinfo_new_reneg, ///
		statistic(mean mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess) ///
		nformat(%6.3f)
	collect export "$WRITEFIG\ppl_cbatype.xlsx", replace
	
	table cba_duration_grp, ///
		statistic(mean mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess) ///
		nformat(%6.3f)
	collect export "$WRITEFIG\ppl_cbadur.xlsx", replace

	
// Table A. 4. Stepwise Regression Estimates - Female Leadership and PPL Inclusion

		logit mat_leave_law ib2.union_rep_gender ib2.firm_rep_gender
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store mll_gender_base
		logit mat_leave_law ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store mll_gender_meso		
		logit mat_leave_law ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store mll_gender_full		
		
		logit pat_leave_law ib2.union_rep_gender ib2.firm_rep_gender
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store pll_gender_base
		logit pat_leave_law ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store pll_gender_meso		
		logit pat_leave_law ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store pll_gender_full	
		
		logit mat_leave_excess ib2.union_rep_gender ib2.firm_rep_gender
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store mle_gender_base
		logit mat_leave_excess ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store mle_gender_meso		
		logit mat_leave_excess ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.manuf i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store mle_gender_full		
		
		logit pat_leave_excess ib2.union_rep_gender ib2.firm_rep_gender
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store ple_gender_base
		logit pat_leave_excess ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store ple_gender_meso		
		logit pat_leave_excess ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store ple_gender_full		
		
		esttab mll_gender_base mll_gender_meso mll_gender_full pll_gender_base pll_gender_meso pll_gender_full mle_gender_base mle_gender_meso mle_gender_full ple_gender_base ple_gender_meso ple_gender_full using "$WRITE\leaves_gender_stepwise.csv", replace se br star(* 0.10 ** 0.05 *** 0.01) b(%5.3f)
		

// Table A. 5. Wage Increase Quintile (Intensive Margin) and PPL Inclusion
		
		logit mat_leave_law i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_quintile) atmeans vsquish post
		est store mll_wage_inc
		logit pat_leave_law i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_quintile) atmeans vsquish post
		est store pll_wage_inc
		logit mat_leave_excess i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_quintile) atmeans vsquish post
		est store mle_wage_inc
		logit pat_leave_excess i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_quintile) atmeans vsquish post
		est store ple_wage_inc
		
		esttab mll_wage_inc pll_wage_inc mle_wage_inc ple_wage_inc using "$WRITE\leaves_wage_inc.csv", replace se br star(* 0.10 ** 0.05 *** 0.01) b(%5.3f)
		

// Table A. 7. Firth-corrected Stepwise Regression Estimates - Female Leadership and PPL Inclusion


		firthlogit mat_leave_law ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.		cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store mll_gender_full_firth
		
		firthlogit pat_leave_law ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store pll_gender_full_firth	

		firthlogit mat_leave_excess ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.manuf i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store mle_gender_full_firth		
		
		firthlogit pat_leave_excess ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store ple_gender_full_firth		
		
		
		esttab mll_gender_full_firth  pll_gender_full_firth  mle_gender_full_firth ple_gender_full_firth using "$WRITE\leaves_gender_firth.csv", replace se br star(* 0.10 ** 0.05 *** 0.01) b(%5.3f)
		
	
// Table A. 8. Firth-Corrected Logistic Regression Models on Wage Increase Provisions

		firthlogit mat_leave_law i.wage_inc i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_inc firm_multinational union_federation) vsquish post 
		est store mll_multi_wage_firth
		firthlogit pat_leave_law i.wage_inc i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_inc firm_multinational union_federation) vsquish post 
		est store pll_multi_wage_firth
		firthlogit mat_leave_excess i.wage_inc i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_inc firm_multinational union_federation) vsquish post 
		est store mle_multi_wage_firth
		firthlogit pat_leave_excess i.wage_inc i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_inc firm_multinational union_federation) vsquish post
		est store ple_multi_wage_firth
		
		esttab mll_multi_wage_firth pll_multi_wage_firth mle_multi_wage_firth ple_multi_wage_firth using "$WRITE\leaves_multi_wage_firth.csv", replace se br star(* 0.10 ** 0.05 *** 0.01) b(%5.3f)



		firthlogit mat_leave_law i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_quintile) atmeans vsquish post
		est store mll_wage_inc_firth
		firthlogit pat_leave_law i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_quintile) atmeans vsquish post
		est store pll_wage_inc_firth
		firthlogit mat_leave_excess i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_quintile) atmeans vsquish post
		est store mle_wage_inc_firth
		firthlogit pat_leave_excess i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_quintile) atmeans vsquish post
		est store ple_wage_inc_firth
		
		esttab mll_wage_inc_firth pll_wage_inc_firth mle_wage_inc_firth ple_wage_inc_firth using "$WRITE\leaves_wage_inc_firth.csv", replace se br star(* 0.10 ** 0.05 *** 0.01) b(%5.3f)


******************************** FIGURES ***************************************


// Figure A. 1. Discontinuity Plots with Alternative Bandwidth Specifications

		
		// check for discontinuity - all sample 
		rdplot mat_leave_law rdd_weeks_cutoff1, c(0) p(2) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") name(mll_weeks_cutoff1, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1, c(0) p(2) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") name(pll_weeks_cutoff1, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1, c(0) p(2) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") name(mle_weeks_cutoff1, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1, c(0) p(2) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") name(ple_weeks_cutoff1, replace))
		
		grc1leg2 mll_weeks_cutoff1 pll_weeks_cutoff1 mle_weeks_cutoff1 ple_weeks_cutoff1, title("Unconstrained Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_all.png", replace as(png) 
		
				// check for discontinuity - 104 week cutoff
		rdplot mat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 104, c(0) p(2) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") xlabel(-104(26)104)  name(mll_weeks_cutoff1_104, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 104, c(0) p(2) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") xlabel(-104(26)104) name(pll_weeks_cutoff1_104, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 104, c(0) p(2) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") xlabel(-104(26)104) name(mle_weeks_cutoff1_104, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 104, c(0) p(2) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") xlabel(-104(26)104) name(ple_weeks_cutoff1_104, replace))
		
		grc1leg2 mll_weeks_cutoff1_104 pll_weeks_cutoff1_104 mle_weeks_cutoff1_104 ple_weeks_cutoff1_104, title("104 Week Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_104.png", replace as(png) 
		
		// check for discontinuity - 52 week cutoff
		rdplot mat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(2) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52)  name(mll_weeks_cutoff1_52, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(2) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52) name(pll_weeks_cutoff1_52, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(2) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52) name(mle_weeks_cutoff1_52, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(2) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52) name(ple_weeks_cutoff1_52, replace))
		
		grc1leg2 mll_weeks_cutoff1_52 pll_weeks_cutoff1_52 mle_weeks_cutoff1_52 ple_weeks_cutoff1_52, title("52 Week Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_52.png", replace as(png) 
		
		// check for discontinuity - 26 week cutoff
		rdplot mat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 26, c(0) p(2) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") xlabel(-30(15)30) name(mll_weeks_cutoff1_26, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 26, c(0) p(2) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") xlabel(-30(15)30)  name(pll_weeks_cutoff1_26, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 26, c(0) p(2) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") xlabel(-30(15)30)  name(mle_weeks_cutoff1_26, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 26, c(0) p(2) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") xlabel(-30(15)30)  name(ple_weeks_cutoff1_26, replace))
		
		grc1leg2 mll_weeks_cutoff1_26 pll_weeks_cutoff1_26 mle_weeks_cutoff1_26 ple_weeks_cutoff1_26, title("26 Week Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_26.png", replace as(png) 
		
		// check for discontinuity - 12 week cutoff
		rdplot mat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 12, c(0) p(2) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") xlabel(-12(6)12) name(mll_weeks_cutoff1_12, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 12, c(0) p(2) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") xlabel(-12(6)12)  name(pll_weeks_cutoff1_12, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 12, c(0) p(2) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") xlabel(-12(6)12)  name(mle_weeks_cutoff1_12, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 12, c(0) p(2) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") xlabel(-12(6)12)  name(ple_weeks_cutoff1_12, replace))
		
		grc1leg2 mll_weeks_cutoff1_12 pll_weeks_cutoff1_12 mle_weeks_cutoff1_12 ple_weeks_cutoff1_12, title("12 Week Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_12.png", replace as(png) 


/// Figure A. 2. Discontinuity Plots with Alternative Bandwidth Specifications

		// unconstrained cutoff with second-order polynomial for running variable, similar to above
		eststo mll_rdd_all: reg mat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp, cluster(firm_upe)
		eststo pll_rdd_all: reg pat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp, cluster(firm_upe)
		eststo mle_rdd_all: reg mat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp, cluster(firm_upe)
		eststo ple_rdd_all: reg pat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp, cluster(firm_upe)
		
		coefplot (mll_rdd_all, label(Statutory Maternity)) (pll_rdd_all, label(Statutory Paternity)) (mle_rdd_all, label(Excess Maternity)) (ple_rdd_all, label(Excess Paternity)), keep(*post_mlreform_cutoff1) xline(0) name(rdd_estimates_cutoff1_all, replace) ///
			graphregion(col(white)) scale(0.9) ///
			legend(pos(6)) ///
			legend(col(4)) ///
			xtitle("{bf:Discrete jump in Pr() of PPL inclusion at cut-off}") ///
			graphregion(margin(medsmall)) ///
			xsize(6.5) ysize(4.5) ///
			xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
			grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
			xscale(range(-0.8 0.8)) ///
			xlabel(-0.8(0.4)0.8, angle(horizontal)) ///
			subtitle("Unconstrained bandwidth") ///
			yscale(off) 
			/// note("Note: Models include a quadratic term for weeks and control for multinational firm, union federation membership, region," "and industry. SEs clustered at the UPE level. Sample: collective agreements around an unconstrained bandwidth (n=1078).", size(small) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_unc.png", replace as(png) 
			
			
		// 104-week cutoff with second-order polynomial for running variable, similar to above
		eststo mll_rdd_104: reg mat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 104, cluster(firm_upe)
		eststo pll_rdd_104: reg pat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 104, cluster(firm_upe)
		eststo mle_rdd_104: reg mat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 104, cluster(firm_upe)
		eststo ple_rdd_104: reg pat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 104, cluster(firm_upe)
		
		coefplot (mll_rdd_104, label(Statutory Maternity)) (pll_rdd_104, label(Statutory Paternity)) (mle_rdd_104, label(Excess Maternity)) (ple_rdd_104, label(Excess Paternity)), keep(*post_mlreform_cutoff1) xline(0) name(rdd_estimates_cutoff1_104, replace) ///
			graphregion(col(white)) scale(0.9) ///
			legend(pos(6)) ///
			legend(col(4)) ///
			xtitle("{bf:Discrete jump in Pr() of PPL inclusion at cut-off}") ///
			graphregion(margin(medsmall)) ///
			xsize(6.5) ysize(4.5) ///
			xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
			grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
			xscale(range(-0.8 0.8)) ///
			xlabel(-0.8(0.4)0.8, angle(horizontal)) ///
			subtitle("104 week bandwidth") ///
			yscale(off) 
			/// note("Note: Models include a quadratic term for weeks and control for multinational firm, union federation membership, region," "and industry. SEs clustered at the UPE level. Sample: collective agreements around a 104-week bandwidth (n=722).", size(small) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_104", replace as(png) 
		
			grc1leg2 rdd_estimates_cutoff1_all rdd_estimates_cutoff1_104, title("RDiT Estimates post-2019 ML reform, longer bandwidths") ///
		note("Note: Models include a quadratic term for weeks and control for multinational firm, union federation membership, CBA type, CBA duration, region, and industry." "SEs clustered at the UPE level. Sample: CBAs around an unconstrained (n=1078) and 104-week (n=722) bandwidth.", size(vsmall) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_longer.png", replace as(png) 
	
//Figure A. 5. Placebo Donut RDiT Estimates with a 12-week Anticipation Window

	// 52-week cutoff with second-order polynomial for running variable, omit 12 weeks before (44 obs, n=323)
		eststo mll_rdd_52_donut: reg mat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 52 & (rdd_weeks_cutoff1>0 | rdd_weeks_cutoff1<-12), cluster(firm_upe)
		eststo pll_rdd_52_donut: reg pat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 52 & (rdd_weeks_cutoff1>0 | rdd_weeks_cutoff1<-12), cluster(firm_upe)
		eststo mle_rdd_52_donut: reg mat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 52 & (rdd_weeks_cutoff1>0 | rdd_weeks_cutoff1<-12), cluster(firm_upe)
		eststo ple_rdd_52_donut: reg pat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 52 & (rdd_weeks_cutoff1>0 | rdd_weeks_cutoff1<-12), cluster(firm_upe)
		
		coefplot (mll_rdd_52_donut, label(Statutory Maternity)) (pll_rdd_52_donut, label(Statutory Paternity)) (mle_rdd_52_donut, label(Excess Maternity)) (ple_rdd_52_donut, label(Excess Paternity)), keep(*post_mlreform_cutoff1) xline(0) name(rdd_estimates_cutoff1_52_donut, replace) ///
			graphregion(col(white)) scale(0.9) ///
			legend(pos(6)) ///
			legend(col(4)) ///
			xtitle("{bf:Discrete jump in Pr() of PPL inclusion at cut-off}") ///
			graphregion(margin(medsmall)) ///
			xsize(6.5) ysize(4.5) ///
			xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
			grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
			xscale(range(-1.2 1.2)) ///
			xlabel(-1.2(0.4)1.2, angle(horizontal)) ///
			subtitle("52 week bandwidth with 12 week anticipation") ///
			yscale(off) 
		graph export "$WRITEFIG\rdd_estimates_cutoff1_52_donut.png", replace as(png) 


		eststo mll_rdd_104_donut: reg mat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 104 & (rdd_weeks_cutoff1>0 | rdd_weeks_cutoff1<-12), cluster(firm_upe)
		eststo pll_rdd_104_donut: reg pat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 104 & (rdd_weeks_cutoff1>0 | rdd_weeks_cutoff1<-12), cluster(firm_upe)
		eststo mle_rdd_104_donut: reg mat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 104 & (rdd_weeks_cutoff1>0 | rdd_weeks_cutoff1<-12), cluster(firm_upe)
		eststo ple_rdd_104_donut: reg pat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 104 & (rdd_weeks_cutoff1>0 | rdd_weeks_cutoff1<-12), cluster(firm_upe)
		
		coefplot (mll_rdd_104_donut, label(Statutory Maternity)) (pll_rdd_104_donut, label(Statutory Paternity)) (mle_rdd_104_donut, label(Excess Maternity)) (ple_rdd_104_donut, label(Excess Paternity)), keep(*post_mlreform_cutoff1) xline(0) name(rdd_estimates_cutoff1_104_donut, replace) ///
			graphregion(col(white)) scale(0.9) ///
			legend(pos(6)) ///
			legend(col(4)) ///
			xtitle("{bf:Discrete jump in Pr() of PPL inclusion at cut-off}") ///
			graphregion(margin(medsmall)) ///
			xsize(6.5) ysize(4.5) ///
			xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
			grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
			xscale(range(-1.2 1.2)) ///
			xlabel(-1.2(0.4)1.2, angle(horizontal)) ///
			subtitle("104 week bandwidth with 12 week anticipation") ///
			yscale(off) 
		graph export "$WRITEFIG\rdd_estimates_cutoff1_104_donut.png", replace as(png) 

	
		grc1leg2 rdd_estimates_cutoff1_52_donut rdd_estimates_cutoff1_104_donut, title("RDiT Estimates post-2019 ML reform with 12-week anticipation") ///
		note("Note: Models include a quadratic term for weeks and control for multinational firm, union federation membership, CBA type, CBA duration, region, and industry." "SEs clustered at the UPE level. Sample: CBAs around a 52-week (n=323) and 104-week (n=678) bandwidth. 26-week insufficient sample with a donut", size(vsmall) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_all_donut.png", replace as(png) 

// Figure A. 3. Discontinuity Plots Using a Linear Polynomial Specification Across Alternative Bandwidth Specifications

		// check for discontinuity - all sample 
		rdplot mat_leave_law rdd_weeks_cutoff1, c(0) p(1) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") name(mll_weeks_cutoff1_p1, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1, c(0) p(1) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") name(pll_weeks_cutoff1_p1, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1, c(0) p(1) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") name(mle_weeks_cutoff1_p1, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1, c(0) p(1) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") name(ple_weeks_cutoff1_p1, replace))
		
		grc1leg2 mll_weeks_cutoff1_p1 pll_weeks_cutoff1_p1 mle_weeks_cutoff1_p1 ple_weeks_cutoff1_p1, title("Unconstrained Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_all_p1.png", replace as(png) 
		
				// check for discontinuity - 104 week cutoff
		rdplot mat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 104, c(0) p(1) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") xlabel(-104(26)104)  name(mll_weeks_cutoff1_104_p1, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 104, c(0) p(1) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") xlabel(-104(26)104) name(pll_weeks_cutoff1_104_p1, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 104, c(0) p(1) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") xlabel(-104(26)104) name(mle_weeks_cutoff1_104_p1, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 104, c(0) p(1) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") xlabel(-104(26)104) name(ple_weeks_cutoff1_104_p1, replace))
		
		grc1leg2 mll_weeks_cutoff1_104_p1 pll_weeks_cutoff1_104_p1 mle_weeks_cutoff1_104_p1 ple_weeks_cutoff1_104_p1, title("104 Week Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_104_p1.png", replace as(png) 
		
		// check for discontinuity - 52 week cutoff
		rdplot mat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(1) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52)  name(mll_weeks_cutoff1_52_p1, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(1) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52) name(pll_weeks_cutoff1_52_p1, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(1) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52) name(mle_weeks_cutoff1_52_p1, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(1) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52) name(ple_weeks_cutoff1_52_p1, replace))
		
		grc1leg2 mll_weeks_cutoff1_52_p1 pll_weeks_cutoff1_52_p1 mle_weeks_cutoff1_52_p1 ple_weeks_cutoff1_52_p1, title("52 Week Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_52_p1.png", replace as(png) 
		
		// check for discontinuity - 26 week cutoff
		rdplot mat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 26, c(0) p(1) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") xlabel(-30(15)30) name(mll_weeks_cutoff1_26_p1, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 26, c(0) p(1) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") xlabel(-30(15)30)  name(pll_weeks_cutoff1_26_p1, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 26, c(0) p(1) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") xlabel(-30(15)30)  name(mle_weeks_cutoff1_26_p1, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 26, c(0) p(1) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") xlabel(-30(15)30)  name(ple_weeks_cutoff1_26_p1, replace))
		
		grc1leg2 mll_weeks_cutoff1_26_p1 pll_weeks_cutoff1_26_p1 mle_weeks_cutoff1_26_p1 ple_weeks_cutoff1_26_p1, title("26 Week Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_26_p1.png", replace as(png) 
		
		// check for discontinuity - 12 week cutoff
		rdplot mat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 12, c(0) p(1) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") xlabel(-12(6)12) name(mll_weeks_cutoff1_12_p1, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 12, c(0) p(1) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") xlabel(-12(6)12)  name(pll_weeks_cutoff1_12_p1, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 12, c(0) p(1) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") xlabel(-12(6)12)  name(mle_weeks_cutoff1_12_p1, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 12, c(0) p(1) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") xlabel(-12(6)12)  name(ple_weeks_cutoff1_12_p1, replace))
		
		grc1leg2 mll_weeks_cutoff1_12_p1 pll_weeks_cutoff1_12_p1 mle_weeks_cutoff1_12_p1 ple_weeks_cutoff1_12_p1, title("12 Week Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_12_p1.png", replace as(png)

		
// Figure A. 4. RDiT Point Estimates Using a Linear Polynomial Specification

		// 52-week cutoff with second-order polynomial for running variable, similar to above
		eststo mll_rdd_52_p1: reg mat_leave_law c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 52, cluster(firm_upe)
		eststo pll_rdd_52_p1: reg pat_leave_law c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 52, cluster(firm_upe)
		eststo mle_rdd_52_p1: reg mat_leave_excess c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 52, cluster(firm_upe)
		eststo ple_rdd_52_p1: reg pat_leave_excess c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 52, cluster(firm_upe)
		
		coefplot (mll_rdd_52_p1, label(Statutory Maternity)) (pll_rdd_52_p1, label(Statutory Paternity)) (mle_rdd_52_p1, label(Excess Maternity)) (ple_rdd_52_p1, label(Excess Paternity)), keep(*post_mlreform_cutoff1) xline(0) name(rdd_estimates_cutoff1_52_p1, replace) ///
			graphregion(col(white)) scale(0.9) ///
			legend(pos(6)) ///
			legend(col(4)) ///
			xtitle("{bf:Discrete jump in Pr() of PPL inclusion at cut-off}") ///
			graphregion(margin(medsmall)) ///
			xsize(6.5) ysize(4.5) ///
			xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
			grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
			xscale(range(-0.8 0.8)) ///
			xlabel(-0.8(0.4)0.8, angle(horizontal)) ///
			subtitle("52 week bandwidth, linear term for weeks") ///
			yscale(off) 
			/// note("Note: Models include a linear term for weeks and control for multinational firm, union federation membership, region," "and industry. SEs clustered at the UPE level. Sample: collective agreements around a 52-week bandwidth (n=367).", size(small) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_52_p1.png", replace as(png) 


			// 26-week cutoff with second-order polynomial for running variable, similar to above
		eststo mll_rdd_26_p1: reg mat_leave_law c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 26, cluster(firm_upe)
		eststo pll_rdd_26_p1: reg pat_leave_law c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 26, cluster(firm_upe)
		eststo mle_rdd_26_p1: reg mat_leave_excess c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 26, cluster(firm_upe)
		eststo ple_rdd_26_p1: reg pat_leave_excess c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 26, cluster(firm_upe)
		
		coefplot (mll_rdd_26_p1, label(Statutory Maternity)) (pll_rdd_26_p1, label(Statutory Paternity)) (mle_rdd_26_p1, label(Excess Maternity)) (ple_rdd_26_p1, label(Excess Paternity)) , keep(*post_mlreform_cutoff1) xline(0) name(rdd_estimates_cutoff1_26_p1, replace) ///
			graphregion(col(white)) scale(0.9) ///
			legend(pos(6)) ///
			legend(col(4)) ///
			xtitle("{bf:Discrete jump in Pr() of PPL inclusion at cut-off}") ///
			graphregion(margin(medsmall)) ///
			xsize(6.5) ysize(4.5) ///
			xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
			grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
			xscale(range(-0.8 0.8)) ///
			xlabel(-0.8(0.4)0.8, angle(horizontal)) ///
			subtitle("26 week bandwidth, linear term for weeks") ///
			yscale(off) 
			///note("Note: Models include a linear term for weeks and control for multinational firm, union federation membership, region," "and industry. SEs clustered at the UPE level. Sample: collective agreements around a 26-week bandwidth (n=197).", size(small) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_26_p1.png", replace as(png) 

	
		grc1leg2 rdd_estimates_cutoff1_52_p1 rdd_estimates_cutoff1_26_p1, title("RDiT Estimates post-2019 ML reform, linear") ///
		note("Note: Models include a linear term for weeks and control for multinational firm, union federation membership, CBA type, CBA duration, region, and industry." "SEs clustered at the UPE level. Sample: CBAs around a 52-week (n=397) and 26-week (n=197) bandwidth.", size(vsmall) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_5226_p1.png", replace as(png) 
		

		// 104-week cutoff with second-order polynomial for running variable, similar to above
		eststo mll_rdd_104_p1: reg mat_leave_law c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 104, cluster(firm_upe)
		eststo pll_rdd_104_p1: reg pat_leave_law c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 104, cluster(firm_upe)
		eststo mle_rdd_104_p1: reg mat_leave_excess c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 104, cluster(firm_upe)
		eststo ple_rdd_104_p1: reg pat_leave_excess c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 104, cluster(firm_upe)
		
		coefplot (mll_rdd_104_p1, label(Statutory Maternity)) (pll_rdd_104_p1, label(Statutory Paternity)) (mle_rdd_104_p1, label(Excess Maternity)) (ple_rdd_104_p1, label(Excess Paternity)), keep(*post_mlreform_cutoff1) xline(0) name(rdd_estimates_cutoff1_104_p1, replace) ///
			graphregion(col(white)) scale(0.9) ///
			legend(pos(6)) ///
			legend(col(4)) ///
			xtitle("{bf:Discrete jump in Pr() of PPL inclusion at cut-off}") ///
			graphregion(margin(medsmall)) ///
			xsize(6.5) ysize(4.5) ///
			xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
			grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
			xscale(range(-0.8 0.8)) ///
			xlabel(-0.8(0.4)0.8, angle(horizontal)) ///
			subtitle("104 week bandwidth, linear term for weeks") ///
			yscale(off) 
			/// note("Note: Models include a linear term for weeks and control for multinational firm, union federation membership, region," "and industry. SEs clustered at the UPE level. Sample: collective agreements around a 104-week bandwidth (n=367).", size(small) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_104_p1.png", replace as(png) 


			// all-week cutoff with second-order polynomial for running variable, similar to above
		eststo mll_rdd_all_p1: reg mat_leave_law c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp, cluster(firm_upe)
		eststo pll_rdd_all_p1: reg pat_leave_law c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp, cluster(firm_upe)
		eststo mle_rdd_all_p1: reg mat_leave_excess c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp, cluster(firm_upe)
		eststo ple_rdd_all_p1: reg pat_leave_excess c.rdd_weeks_cutoff1##i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp, cluster(firm_upe)
		
		coefplot (mll_rdd_all_p1, label(Statutory Maternity)) (pll_rdd_all_p1, label(Statutory Paternity)) (mle_rdd_all_p1, label(Excess Maternity)) (ple_rdd_all_p1, label(Excess Paternity)) , keep(*post_mlreform_cutoff1) xline(0) name(rdd_estimates_cutoff1_all_p1, replace) ///
			graphregion(col(white)) scale(0.9) ///
			legend(pos(6)) ///
			legend(col(4)) ///
			xtitle("{bf:Discrete jump in Pr() of PPL inclusion at cut-off}") ///
			graphregion(margin(medsmall)) ///
			xsize(6.5) ysize(4.5) ///
			xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
			grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
			xscale(range(-0.8 0.8)) ///
			xlabel(-0.8(0.4)0.8, angle(horizontal)) ///
			subtitle("Unconstrained bandwidth, linear term for weeks") ///
			yscale(off) 
			///note("Note: Models include a linear term for weeks and control for multinational firm, union federation membership, region," "and industry. SEs clustered at the UPE level. Sample: collective agreements around an unconstrained bandwidth (n=197).", size(small) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_all_p1.png", replace as(png) 

	
		grc1leg2 rdd_estimates_cutoff1_all_p1 rdd_estimates_cutoff1_104_p1, title("RDiT Estimates post-2019 ML reform, linear") ///
		note("Note: Models include a linear term for weeks and control for multinational firm, union federation membership, CBA type, CBA duration, region, and industry." "SEs clustered at the UPE level. Sample: CBAs around an unconstrained (n=1078) and 104-week (n=722) bandwidth.", size(vsmall) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_unc104_p1.png", replace as(png) 
		