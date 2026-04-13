// ==============================================================================
// Paper:     Too Little, Too Weak? Paid Parental Leaves in Philippine Collective Agreements
// Author:    Vincent Jerald Ramos
// Date:      April 2026
// Purpose:   Main Figures and Tables in Text
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




////////////////////////// DESCRIPTIVES ////////////////////////////////////////

// Fig 1A. Share of CBAs with PPL
	
	graph bar (mean) mat_leave_law pat_leave_law mat_leave_excess pat_leave_excess, horizontal ///
    ascategory ///
    legend(off) ///
    ytitle("% of all CBAs, 2016-2021 (n=1081)") ///
	ysc(r(0(0.2)0.8)) ylabel(0(0.2)0.8) ///
    title("Paid Parental Leaves") 
		gr_edit .grpaxis.edit_tick 1 10.9204 `"Excess Paternity"', tickset(major)
		gr_edit .grpaxis.edit_tick 2 36.9735 `"Excess Maternity"', tickset(major)
		gr_edit .grpaxis.edit_tick 3 63.0265 `"Statutory Paternity"', tickset(major)
		gr_edit .grpaxis.edit_tick 4 89.0796 `"Statutory Maternity"', tickset(major)
	graph export "$WRITEFIG\desc_ppl.png", replace width(1000)

// Fig 1B. Share of CBAs with other non wage entitlements

	graph bar (mean) deathben deathben_dep fam_plan healthben_law healthben_private_ins healthben_medsub healthben_dentsub educben_dep_dum, horizontal ///
    ascategory ///
    legend(off) ///
    ytitle("% of all CBAs, 2016-2021 (n=1081)") ///
	ysc(r(0(0.2)0.8)) ylabel(0(0.2)0.8) ///
    title("Other Non-Wage Entitlements") 
		gr_edit .grpaxis.edit_tick 1 5.34759 `"Educational Benefits (Dep)"', tickset(major)
		gr_edit .grpaxis.edit_tick 2 18.1054 `"Dental Subsidy"', tickset(major)
		gr_edit .grpaxis.edit_tick 3 30.8633 `"Medical Subsidy"', tickset(major)
		gr_edit .grpaxis.edit_tick 4 43.6211 `"Private Insurance Coverage"', tickset(major)
		gr_edit .grpaxis.edit_tick 5 56.3789 `"Statutory Insurance Coverage"', tickset(major)
		gr_edit .grpaxis.edit_tick 6 69.1367 `"Family Planning Support"', tickset(major)
		gr_edit .grpaxis.edit_tick 7 81.8946 `"Bereavement Aid (Dep)"', tickset(major)
		gr_edit .grpaxis.edit_tick 8 94.6524 `"Bereavement Aid"', tickset(major)
		gr_edit .grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	graph export "$WRITEFIG\desc_othernonwage.png", replace width(1000)




////////////////////////// REGRESSIONS /////////////////////////////////////////


// Fig 2. Gender

		logit mat_leave_law ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store mll_gender		
		logit pat_leave_law ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store pll_gender	
		logit mat_leave_excess ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.manuf i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store mle_gender	
		logit pat_leave_excess ib2.union_rep_gender ib2.firm_rep_gender i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(union_rep_gender firm_rep_gender) vsquish post 
		est store ple_gender	
		
		esttab mll_gender pll_gender mle_gender ple_gender using "$WRITE\leaves_gender.csv", replace se br star(* 0.10 ** 0.05 *** 0.01) b(%5.3f)
		
		coefplot (mll_gender) (pll_gender) (mle_gender) (ple_gender), drop(_cons) xline(0, lcolor(red) lwidth(medium)) ///		
		xtitle("{bf: Marginal Effect on Pr(Inclusion of Provision)}") /// 
		graphregion(margin(medsmall)) ///
		xsize(6.5) ysize(4.5) ///
		xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
		grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
		ylab(, labsize(*1.1)) /// enlarge size of y-axis labels
		coeflabels(1.union_rep_gender="Union Leader" 1.firm_rep_gender="Firm Leader") ///
		xscale(range(-0.4 0.4)) ///
		xlabel(-0.4(0.1)0.4, angle(horizontal)) ///
		///legend(off) ///
		legend(label(2 "Statutory Maternity") label (4 "Statutory Paternity") label (6 "Excess Maternity") label (8 "Excess Paternity")) ///
		legend(pos(6)) ///
		legend(col(4)) ///
		note("Note: Models control for firm type, union type, CBA type, CBA duration, region, sector, and year dummies." "Sample: all CBAs signed from 2016-2021 with information on leaders' gender (n= 621)", size(vsmall) span) /// add a note
		title("Female Leadership")
		graph export "$WRITEFIG\gender.png", replace width(1000)
		
	

		
////////////////////////////////////////////////////////////////////////////////
///////////// WAGE INCREASE PROVISION //////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Fig 3A. Extensive Margin

		logit mat_leave_law i.wage_inc i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_inc firm_multinational union_federation) vsquish post 
		est store mll_multi_wage
		logit pat_leave_law i.wage_inc i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_inc firm_multinational union_federation) vsquish post 
		est store pll_multi_wage
		logit mat_leave_excess i.wage_inc i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_inc firm_multinational union_federation) vsquish post 
		est store mle_multi_wage
		logit pat_leave_excess i.wage_inc i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(wage_inc firm_multinational union_federation) vsquish post
		est store ple_multi_wage
		
		esttab mll_multi_wage pll_multi_wage mle_multi_wage ple_multi_wage using "$WRITE\leaves_multi_wage.csv", replace se br star(* 0.10 ** 0.05 *** 0.01) b(%5.3f)
		
		coefplot mll_multi_wage pll_multi_wage mle_multi_wage ple_multi_wage, drop(_cons) xline(0, lcolor(red) lwidth(medium)) ///		
		xtitle("{bf: Marginal Effect on Pr(Inclusion of Provision)}") /// 
		graphregion(margin(medsmall)) ///
		xsize(6.5) ysize(4.5) ///
		keep(1.wage_inc) /// Keep option
		xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
		grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
		ylab(, labsize(*1.1)) /// enlarge size of y-axis labels
		///baselevels  ///
		coeflabels(1.wage_inc="with Wage Provision") ///
		///1.pclass="Upper" 2.pclass="Intermediate" 3.pclass="Routine") ///
		///headings(1.union_rep_gender="{bf: Female Union Leader}" ///
		///		1.firm_rep_gender="{bf: Female Firm Leader}", gap(0)) ///
		///msize(small)  mlcolor(navy) msymbol(square_hollow) ///
		///levels(95 90) ciopts(lcolor(navy midblue) recast(rspike rcap)) ///
		///subtitle(, color(black) fcolor(gs15) lcolor(gs12)) ///
		xscale(range(-0.4 0.4)) ///
		xlabel(-0.4(0.1)0.4, angle(horizontal)) ///
		///legend(off) ///
		legend(label(2 "Statutory Maternity") label (4 "Statutory Paternity") label (6 "Excess Maternity") label (8 "Excess Paternity")) ///
		legend(pos(6)) ///
		legend(col(4)) ///
		note("Note: Models control for firm type, union type, CBA type, CBA duration, region, sector, and year dummies." "Sample: all CBAs signed from 2016-2021 (n= 1,081)", size(vsmall) span) /// add a note
		title("Wage Increase Provisions (Extensive Margin)")
		graph export "$WRITEFIG\wage_tradeoff_extensive.png", replace width(1000)


		
// Fig 3B. Intensive Margin


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

			
			
			logit mat_leave_excess i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp	
			margins, dydx(wage_quintile) atmeans vsquish post
			///margins, dydx(wage_quintile) at(log_wage_inc_first=(-5(2.5)5))atmeans vsquish post
			marginsplot, title("Excess Maternity Leave") xlabel(1 "Q2" 2 "Q3" 3 "Q4" 4 "Q5") yline(0) name("eml_wage_intensive", replace) 
				gr_edit .yaxis1.reset_rule -0.2 0.2 0.1 , tickset(major) ruletype(range) 
				gr_edit .yaxis1.title.text = {}
				gr_edit .yaxis1.title.text.Arrpush CME (vs. Lowest Q)
				gr_edit .xaxis1.title.text = {}
				gr_edit .xaxis1.title.text.Arrpush Wage Quintile
				gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
			graph save "$WRITEFIG\mle_wageinc_margins.gph", replace 
			graph export "$WRITEFIG\mle_wageinc_margins", replace as(png) 
			
			
			logit pat_leave_excess i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp	
			margins, dydx(wage_quintile) atmeans vsquish post
			///margins, dydx(wage_quintile) at(log_wage_inc_first=(-5(2.5)5))atmeans vsquish post
			marginsplot, title("Excess Paternity Leave") xlabel(1 "Q2" 2 "Q3" 3 "Q4" 4 "Q5") yline(0) name("epl_wage_intensive", replace)
				gr_edit .yaxis1.reset_rule -0.2 0.2 0.1 , tickset(major) ruletype(range) 
				gr_edit .yaxis1.title.text = {}
				gr_edit .yaxis1.title.text.Arrpush CME (vs. Lowest Q)
				gr_edit .xaxis1.title.text = {}
				gr_edit .xaxis1.title.text.Arrpush Wage Quintile
				gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
			graph save "$WRITEFIG\ple_wageinc_margins.gph", replace 
			graph export "$WRITEFIG\ple_wageinc_margins", replace as(png) 
			
			
			logit mat_leave_law i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp	
			margins, dydx(wage_quintile) atmeans vsquish post
			///margins, dydx(wage_quintile) at(log_wage_inc_first=(-5(2.5)5))atmeans vsquish post
			marginsplot, title("Statutory Maternity Leave") xlabel(1 "Q2" 2 "Q3" 3 "Q4" 4 "Q5") yline(0) name("sml_wage_intensive", replace) 
				gr_edit .yaxis1.reset_rule -0.2 0.2 0.1 , tickset(major) ruletype(range) 
				gr_edit .yaxis1.title.text = {}
				gr_edit .yaxis1.title.text.Arrpush CME (vs. Lowest Q)
				gr_edit .xaxis1.title.text = {}
				gr_edit .xaxis1.title.text.Arrpush Wage Quintile
				gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
			graph save "$WRITEFIG\mls_wageinc_margins.gph", replace 
			graph export "$WRITEFIG\mls_wageinc_margins", replace as(png) 
			
			
			logit pat_leave_law i.wage_quintile i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.cba_year_reg i.otherinfo_new_reneg i.cba_duration_grp	
			margins, dydx(wage_quintile) atmeans vsquish post
			///margins, dydx(wage_quintile) at(log_wage_inc_first=(-5(2.5)5))atmeans vsquish post
			marginsplot, title("Statutory Paternity Leave") xlabel(1 "Q2" 2 "Q3" 3 "Q4" 4 "Q5") yline(0) name("spl_wage_intensive", replace)
				gr_edit .yaxis1.reset_rule -0.2 0.2 0.1 , tickset(major) ruletype(range) 
				gr_edit .yaxis1.title.text = {}
				gr_edit .yaxis1.title.text.Arrpush CME (vs. Lowest Q)
				gr_edit .xaxis1.title.text = {}
				gr_edit .xaxis1.title.text.Arrpush Wage Quintile
				gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
			graph save "$WRITEFIG\pls_wageinc_margins.gph", replace 
			graph export "$WRITEFIG\pls_wageinc_margins", replace as(png) 
			
			
			
		graph combine sml_wage_intensive spl_wage_intensive eml_wage_intensive epl_wage_intensive, ycommon note("Note: Models control for firm type, union type, CBA type, CBA duration, region, sector, and year dummies." "Sample: all CBAs signed from 2016-2021 with a wage increase provision (n= 827)", size(vsmall) span) /// add a note
		title("Wage Increase Provisions (Intensive Margin)")
		graph export "$WRITEFIG\wage_tradeoff_excess_intensive.png", replace width(1000)
		
		
	
		
////////////////////// MATERNITY LEAVE REFORM ////////////////////////////////



// Fig 4A. Naive Estimator


		logit mat_leave_law i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(post_mlreform_cutoff1) vsquish post 
		est store mll_reform_cutoff1
		logit pat_leave_law i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(post_mlreform_cutoff1) vsquish post 
		est store pll_reform_cutoff1
		logit mat_leave_excess i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.manuf i.otherinfo_new_reneg i.cba_duration_grp
		margins, dydx(post_mlreform_cutoff1) vsquish post 
		est store mle_reform_cutoff1
		logit pat_leave_excess i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp 
		margins, dydx(post_mlreform_cutoff1) vsquish post
		est store ple_reform_cutoff1
	
		// extract table
		esttab mll_reform_cutoff1 pll_reform_cutoff1 mle_reform_cutoff1 ple_reform_cutoff1 using "$WRITE\leaves_reform_naive.csv", replace se br star(* 0.10 ** 0.05 *** 0.01) b(%5.3f)

		coefplot mll_reform_cutoff1 pll_reform_cutoff1 mle_reform_cutoff1 ple_reform_cutoff1, ///
		drop(_cons) xline(0, lcolor(red) lwidth(medium)) ///		
		xtitle("{bf: Marginal Effect on Pr(Inclusion of Provision)}") /// 
		graphregion(margin(medsmall)) ///
		xsize(6.5) ysize(4.5) ///
		xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
		grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
		ylab(, labsize(*1.1)) /// enlarge size of y-axis labels
		coeflabels(1.post_mlreform_cutoff1="Post-Reform") ///
		xscale(range(-0.2 0.2)) ///
		xlabel(-0.2(0.1)0.2, angle(horizontal)) ///
		legend(label(2 "Statutory Maternity") label (4 "Statutory Paternity") label (6 "Excess Maternity") label (8 "Excess Paternity")) ///
		legend(pos(6)) ///
		legend(col(4)) ///
		note("Note: Models control for firm type, union type, CBA type, CBA duration, region and sector dummies. Sample: all CBAs (n=1081).", size(vsmall) span) /// add a note
		title("ML reform, naive pre-post comparison")
		graph export "$WRITEFIG\prepost_naive.png", replace as(png) 


// Fig 4B. Multi-Plant UPE

		logit mat_leave_law i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if flag_multi_upe==1, vce(cluster firm_upe_num)
		margins, dydx(post_mlreform_cutoff1) vsquish post 
		est store mll_reform_cutoff1_upe

		logit pat_leave_law i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if flag_multi_upe==1, vce(cluster firm_upe_num)
		margins, dydx(post_mlreform_cutoff1) vsquish post 
		est store pll_reform_cutoff1_upe
		
		logit mat_leave_excess i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.manuf i.otherinfo_new_reneg i.cba_duration_grp if flag_multi_upe==1, vce(cluster firm_upe_num)
		margins, dydx(post_mlreform_cutoff1) vsquish post 
		est store mle_reform_cutoff1_upe
		
		logit pat_leave_excess i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp if flag_multi_upe==1, vce(cluster firm_upe_num)
		margins, dydx(post_mlreform_cutoff1) vsquish post 
		est store ple_reform_cutoff1_upe
		
		// extract tables
		esttab mll_reform_cutoff1_upe pll_reform_cutoff1_upe mle_reform_cutoff1_upe ple_reform_cutoff1_upe using "$WRITE\leaves_reform_upe.csv", replace se br star(* 0.10 ** 0.05 *** 0.01) b(%5.3f)

		coefplot mll_reform_cutoff1_upe pll_reform_cutoff1_upe mle_reform_cutoff1_upe ple_reform_cutoff1_upe, ///
		drop(_cons) xline(0, lcolor(red) lwidth(medium)) ///		
		xtitle("{bf: Marginal Effect on Pr(Inclusion of Provision)}") /// 
		graphregion(margin(medsmall)) ///
		xsize(6.5) ysize(4.5) ///
		xlab(, glpattern(solid) glcolor(gs14)) /// adds solid, light gray vertical lines at x-axis values
		grid(glpattern(solid) glcolor(gs14)) /// adds solid, light gray horizontal lines at y-axis values
		ylab(, labsize(*1.1)) /// enlarge size of y-axis labels
		coeflabels(1.post_mlreform_cutoff1="Post-Reform") ///
		xscale(range(-0.2 0.2)) ///
		xlabel(-0.2(0.1)0.2, angle(horizontal)) ///
		legend(label(2 "Statutory Maternity") label (4 "Statutory Paternity") label (6 "Excess Maternity") label (8 "Excess Paternity")) ///
		legend(pos(6)) ///
		legend(col(4)) ///
		note("Note: Models control for firm type, union type, CBA type, CBA duration, region and sector dummies." "SEs clustered at UPE level and sample consists of those with multiple CBAs within a single UPE (n=425)", size(vsmall) span) /// add a note
		title("ML reform, UPE-level pre-post comparison")
		graph export "$WRITEFIG\prepost_upe.png", replace as(png) 
		
		
		

// Figure 5: Discontinuity Plot Centered at the ML Reform Effectivity Date

		rdplot mat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(2) graph_options(title(Pr(Statutory ML)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52)  name(mll_weeks_cutoff1_52, replace))
		rdplot pat_leave_law rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(2) graph_options(title(Pr(Statutory PL)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52) name(pll_weeks_cutoff1_52, replace))
		rdplot mat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(2) graph_options(title(Pr(Excess ML)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52) name(mle_weeks_cutoff1_52, replace))
		rdplot pat_leave_excess rdd_weeks_cutoff1 if abs(rdd_weeks_cutoff1) <= 52, c(0) p(2) graph_options(title(Pr(Excess PL)) legend(pos(6)) xtitle("Weeks") xlabel(-52(26)52) name(ple_weeks_cutoff1_52, replace))
		
		grc1leg2 mll_weeks_cutoff1_52 pll_weeks_cutoff1_52 mle_weeks_cutoff1_52 ple_weeks_cutoff1_52, title("52 Week Bandwidth Around ML Reform Effectivity")
		graph export "$WRITEFIG\rdd_weeks_cutoff1_52.png", replace as(png) 

		
// Figure 6: Discontinuity Plot Centered at the ML Reform Effectivity Date

		// 52-week cutoff with second-order polynomial for running variable, similar to above
		eststo mll_rdd_52: reg mat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 52, cluster(firm_upe)
		eststo pll_rdd_52: reg pat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 52, cluster(firm_upe)
		eststo mle_rdd_52: reg mat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.manuf i.otherinfo_new_reneg i.cba_duration_grp if abs(rdd_weeks_cutoff1) <= 52, cluster(firm_upe)
		eststo ple_rdd_52: reg pat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 52, cluster(firm_upe)
		
		coefplot (mll_rdd_52, label(Statutory Maternity)) (pll_rdd_52, label(Statutory Paternity)) (mle_rdd_52, label(Excess Maternity)) (ple_rdd_52, label(Excess Paternity)), keep(*post_mlreform_cutoff1) xline(0) name(rdd_estimates_cutoff1_52, replace) ///
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
			subtitle("52 week bandwidth") ///
			yscale(off) 
		graph export "$WRITEFIG\rdd_estimates_cutoff1_52.png", replace as(png) 


			// 26-week cutoff with second-order polynomial for running variable, similar to above
		eststo mll_rdd_26: reg mat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 26, cluster(firm_upe)
		eststo pll_rdd_26: reg pat_leave_law post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 26, cluster(firm_upe)
		eststo mle_rdd_26: reg mat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 26, cluster(firm_upe)
		eststo ple_rdd_26: reg pat_leave_excess post_mlreform_cutoff1 c.rdd_weeks_cutoff1 c.rdd_weeks_cutoff1_sq c.rdd_weeks_cutoff1#i.post_mlreform_cutoff1 c.rdd_weeks_cutoff1_sq#i.post_mlreform_cutoff1 i.firm_multinational i.union_federation i.cba_region_grp i.PSIC_grp i.otherinfo_new_reneg i.cba_duration_grp  if abs(rdd_weeks_cutoff1) <= 26, cluster(firm_upe)
		
		coefplot (mll_rdd_26, label(Statutory Maternity)) (pll_rdd_26, label(Statutory Paternity)) (mle_rdd_26, label(Excess Maternity)) (ple_rdd_26, label(Excess Paternity)) , keep(*post_mlreform_cutoff1) xline(0) name(rdd_estimates_cutoff1_26, replace) ///
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
			subtitle("26 week bandwidth") ///
			yscale(off) 
		graph export "$WRITEFIG\rdd_estimates_cutoff1_26.png", replace as(png) 

	
		grc1leg2 rdd_estimates_cutoff1_52 rdd_estimates_cutoff1_26, title("RDiT Estimates post-2019 ML reform") ///
		note("Note: Models include a quadratic term for weeks and control for multinational firm, union federation membership, CBA type, CBA duration, region, and industry." "SEs clustered at the UPE level. Sample: CBAs around a 52-week (n=367) and 26-week (n=197) bandwidth.", size(vsmall) span)
		graph export "$WRITEFIG\rdd_estimates_cutoff1_all.png", replace as(png) 
