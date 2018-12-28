/**************************************************************************
 Program:  hmda_tracts_new.sas
 Library:  HMDA
 Project:  Urban-Greater DC
 Author:   Rob Pitingolo
 Created:  12/6/18
 Version:  SAS 9.4
 Environment:  Windows 7
 
 Description:  Macro to create tract-level HMDA files from raw HMDA.
 
 Modifications:
 
**************************************************************************/

%macro hmda_tracts_new (start_yr,end_yr);

%local year geo geovfmt count_list median_list;

%do year = &start_yr. %to &end_yr.;

%if %upcase( &year ) < 2012 %then %do;
	%let geo = geo2000;
%end;

%else %if %upcase( &year ) >= 2012 %then %do;
	%let geo = geo2010;
%end;

data apps&year.;
	set hmda.loans_&year.;

	/*Keep DC records */
	if ucounty = "11001";

	/* Format and keep valid formats */
	format &geo. geo00a.;

	%let geo = %upcase( &geo. );
    %let geovfmt = %sysfunc( putc( &geo, $geovfmt. ) );

    if put( &geo., &geovfmt ) ^= " ";


	/* Flag each record as an application */
	app=1;

	/* Race flags */
	%racecalc_04;

	/* Gender flags */
	%gender;

	/* Purpose type flags */
	%purp_type;

	/* Property type flags */
	%prop_type;

	/* Income recodes */
	if income < 0 then hhincome = .;
		else hhincome=income;
	if amount < 0 then amount = .;
		else amount=amount;

	/* Loan type flags */
	if loantype = '1' then conv = 1;
		else if loantype in ('2', '3' , '4') then govt=1;

	/* Analysis flags */
	length f_denial highFlag f_lien 3.;

	if appdate ne '1' then do;
		*** flag variable for HOEPA vars ****;
		if hoepa = 1 then f_hoepa=1;
			else f_hoepa=0;
		if lien = '1' then f_lien = 1;
			else if lien = '2' then f_lien = 0;
	end;

	else do;
		f_lien  = . ;
		f_hoepa = . ;
			end;

	/* Denials flags */
	if action = '3' then f_denial =1;
		else f_denial = 0;
	
	/* High interest flag */
	if high_interest = "1" then highflag=1;
		else highflag=0;

	/* Create income categories from ipums %hud_inc macro */
	if hhincome ^= . then do;
	numprec = 4;
	end;

	%if &year. = 2009 %then %do;
	%Hud_inc_2009;
	%end;
	%else %if &year. = 2010 %then %do;
	%Hud_inc_2010;
	%end;
	%else %if &year. = 2011 %then %do;
	%Hud_inc_2011;
	%end;
	%else %if &year. = 2012 %then %do;
	%Hud_inc_2012;
	%end;
	%else %if &year. = 2013 %then %do;
	%Hud_inc_2013;
	%end;
	%else %if &year. = 2014 %then %do;
	%Hud_inc_2014;
	%end;
	%else %if &year. = 2015 %then %do;
	%Hud_inc_2015;
	%end;
	%else %if &year. = 2016 %then %do;
	%Hud_inc_2016;
	%end;
	%else %if &year. = 2017 %then %do;
	%Hud_inc_2017;
	%end;
	%else %if &year. = 2018 %then %do;
	%Hud_inc_2018;
	%end;
	%else %if &year. = 2019 %then %do;
	%Hud_inc_2019;
	%end;
	%else %if &year. = 2020 %then %do;
	%Hud_inc_2020;
	%end;
	%else %do;
    %err_mput( macro= hmda_tracts_new, msg=Update hmda_tracts_new macro to include correct hud_inc_yyyy macro from Ipums library )
    %goto macro_exit;
	%end;


	/* Mortgage loans for 1 to 4 family dwellings home purchase */
	nummrtgorighomepurch1_4m_&year. = purch;

	label nummrtgorighomepurch1_4m_&year. = "Mortgage loans for 1 to 4 family dwellings and manufactured homes purchase, &year.";

	/* Loan originations for 1 to 4 family dwellings home purchase by income */
	if hud_inc in (1,2) then NumMrtgOrig_vli_&year. = nummrtgorighomepurch1_4m_&year.;
		else NumMrtgOrig_vli_&year. = 0;
	if hud_inc in (3) then NumMrtgOrig_li_&year. = nummrtgorighomepurch1_4m_&year.;
		else NumMrtgOrig_li_&year. = 0;
	if hud_inc in (4) then NumMrtgOrig_mi_&year. = nummrtgorighomepurch1_4m_&year.;
		else NumMrtgOrig_mi_&year. = 0;
	if hud_inc in (5) then NumMrtgOrig_hinc_&year. = nummrtgorighomepurch1_4m_&year.;
		else NumMrtgOrig_hinc_&year. = 0;

	label NumMrtgOrig_vli_&year. = "Number of owner-occupied home purchase mortgage loan originations to borrowers that are very low-income for 1 to 4 family dwellings and manufactured homes, &year."
		  NumMrtgOrig_li_&year. = "Number of owner-occupied home purchase mortgage loan originations to borrowers that are low-income for 1 to 4 family dwellings and manufactured homes, &year."
		  NumMrtgOrig_mi_&year. = "Number of owner-occupied home purchase mortgage loan originations to borrowers that are medium-income for 1 to 4 family dwellings and manufactured homes, &year." 
		  NumMrtgOrig_hinc_&year. = "Number of owner-occupied home purchase mortgage loan originations to borrowers that are high-income for 1 to 4 family dwellings and manufactured homes, &year."
	;

	/* Loan originations for 1 to 4 family dwellings home purchase by race */
	if bl = 1 then NumMrtgOrigBlack_&year. = nummrtgorighomepurch1_4m_&year.;
		else NumMrtgOrigBlack_&year. = 0;
	if wh = 1 then NumMrtgOrigWhite_&year. = nummrtgorighomepurch1_4m_&year.;
		else NumMrtgOrigWhite_&year. = 0;
	if hi = 1 then NumMrtgOrigHisp_&year. = nummrtgorighomepurch1_4m_&year.;
		else NumMrtgOrigHisp_&year. = 0;
	if as = 1 then NumMrtgOrigAsianPI_&year. = nummrtgorighomepurch1_4m_&year.;
		else NumMrtgOrigAsianPI_&year. = 0;
	if ind = 1 or mxd = 1 or multiple = 1 or oth = 1 then NumMrtgOrigOtherX_&year. = nummrtgorighomepurch1_4m_&year.;
		else NumMrtgOrigOtherX_&year. = 0;
	if np = 1 then NumMrtgOrigRaceNotProvided_&year. = nummrtgorighomepurch1_4m_&year.;
		else NumMrtgOrigRaceNotProvided_&year. = 0;
	if withrace = 1 then nummrtgorigwithrace_&year. = nummrtgorighomepurch1_4m_&year.;
		else nummrtgorigwithrace_&year. = 0;

	label NumMrtgOrigBlack_&year. = "Owner-occupied home purchase mortgage loans to Black borrowers, &year."
		  NumMrtgOrigWhite_&year. = "Owner-occupied home purchase mortgage loans to White borrowers, &year."
		  NumMrtgOrigHisp_&year. = "Owner-occupied home purchase mortgage loans to Hispanic borrowers, &year."
		  NumMrtgOrigAsianPI_&year. = "Owner-occupied home purchase mortgage loans to Asian borrowers, &year."
		  NumMrtgOrigOtherX_&year. = "Owner-occupied home purchase mortgage loans to other race borrowers, &year."
		  NumMrtgOrigRaceNotProvided_&year. = "Owner-occupied home purchase loans where borrower race is not provided, &year."
		  nummrtgorigwithrace_&year. = "Owner-occupied home purchase loans where borrower race is known, &year."
	;

	/* Median borrower income for owner-occupied home purchase loans */
	if purch = 1 then do;
	medianmrtginc1_4m_&year. = hhincome;
	end;

	label medianmrtginc1_4m_&year. = "Median borrower income for owner-occupied home purchase loans, &year.";

	/* Conventional mortgage loans for home purchase */
	if purpose = 1 and conv = 1 then NumConvMrtgOrigHomePurch_&year. = 1;
		else NumConvMrtgOrigHomePurch_&year. = 0;

	label NumConvMrtgOrigHomePurch_&year. = "Conventional mortgage loans for home purchase, &year.";
	 
	/* Conventional mortgage loans for refinance */
	if purpose = 3 and conv = 1 then NumConvMrtgOrigRefin_&year. = 1;
		else NumConvMrtgOrigRefin_&year. = 0;

	label NumConvMrtgOrigRefin_&year. = "Conventional mortgage loans for refinance, &year.";

	/* Denials of conventional home purchase loans */
	if deny1 > 0 and conv = 1 then NumMrtgPurchDenial_&year. = 1;
		else NumMrtgPurchDenial_&year. = 0;

	label NumMrtgPurchDenial_&year. = "Denials of conventional home purchase loans, &year.";

	/* Denials of conventional home purchase loans by income */
	if deny1 > 0 and conv = 1 then do;
		if hud_inc in (1,2) then nummrtgpurchdenial_vli_&year. = 1;
			else nummrtgpurchdenial_vli_&year. = 0;
		if hud_inc in (3) then nummrtgpurchdenial_li_&year. = 1;
			else nummrtgpurchdenial_li_&year. = 0;
		if hud_inc in (4) then nummrtgpurchdenial_mi_&year. = 1;
			else nummrtgpurchdenial_mi_&year. = 0;
		if hud_inc in (5) then nummrtgpurchdenial_hinc_&year. = 1;
			else nummrtgpurchdenial_hinc_&year. = 0;
	end;

	label nummrtgpurchdenial_vli_&year. = "Number of very low-income applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes, &year."
		  nummrtgpurchdenial_li_&year. = "Number of low-income applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes, &year."
		  nummrtgpurchdenial_mi_&year. = "Number of medium-income applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes, &year."
		  nummrtgpurchdenial_hinc_&year. = "Number of high-income applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes, &year."
	;

	/* Denials of conventional home purchase loans by race */
	if deny1 > 0 and  conv = 1 then do;
		if bl = 1 then nummrtgpurchdenial_bl_&year. = 1;
			else nummrtgpurchdenial_bl_&year. = 0;
		if wh = 1 then nummrtgpurchdenial_wh_&year. = 1;
			else nummrtgpurchdenial_wh_&year. = 0;
		if hi = 1 then nummrtgpurchdenial_hi_&year. = 1;
			else nummrtgpurchdenial_hi_&year. = 0;
		if as = 1 then nummrtgpurchdenial_as_&year. = 1;
			else nummrtgpurchdenial_as_&year. = 0;
		if np =1 or na = 1 then nummrtgpurchdenial_np_&year. = 1;
			else nummrtgpurchdenial_np_&year. = 0;
		if withrace = 1 then nummrtgpurchdenial_withrace_&year. = 1;
			else nummrtgpurchdenial_withrace_&year. = 0;
	end;

	label nummrtgpurchdenial_bl_&year. = "Number of Black applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes, &year."
		  nummrtgpurchdenial_wh_&year. = "Number of White applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes, &year."
		  nummrtgpurchdenial_hi_&year. = "Number of Hispanic applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes, &year."
		  nummrtgpurchdenial_as_&year. = "Number of Asian applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes, &year."
		  nummrtgpurchdenial_np_&year. = "Number of  applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes where race is not known, &year."
		  nummrtgpurchdenial_withrace_&year. = "Number of  applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes where race is known, &year."
	;

	  
run;

%let count_list = 	nummrtgorighomepurch1_4m_&year. 

					NumMrtgOrig_vli_&year. 
					NumMrtgOrig_li_&year. 
				    NumMrtgOrig_mi_&year. 
				    NumMrtgOrig_hinc_&year. 

					NumMrtgOrigBlack_&year. 
				    NumMrtgOrigWhite_&year. 
				    NumMrtgOrigHisp_&year. 
				    NumMrtgOrigAsianPI_&year. 
				    NumMrtgOrigOtherX_&year. 
				    nummrtgorigwithrace_&year. 
				    NumMrtgOrigRaceNotProvided_&year. 

					NumConvMrtgOrigHomePurch_&year.
					NumConvMrtgOrigRefin_&year.

					NumMrtgPurchDenial_&year.
					nummrtgpurchdenial_vli_&year.
					nummrtgpurchdenial_li_&year.
					nummrtgpurchdenial_mi_&year.
					nummrtgpurchdenial_hinc_&year.

					nummrtgpurchdenial_bl_&year.
					nummrtgpurchdenial_wh_&year.
					nummrtgpurchdenial_hi_&year.
					nummrtgpurchdenial_as_&year.
					nummrtgpurchdenial_np_&year.
;

%let median_list = 	medianmrtginc1_4m_&year.
;


proc summary data = apps&year.;
	class &geo.;
	var &count_list.;
	output out = apps&year.tr sum=;
run;

proc summary data = apps&year.;
	class &geo.;
	var &median_list.;
	output out = med&year.tr median=;
run;

proc sort data = apps&year.tr; by &geo.; run;
proc sort data = med&year.tr; by &geo.; run;

data hmda&year.tr;
	merge apps&year.tr (drop = _type_ _freq_)
	med&year.tr (drop = _type_ _freq_) ;
	by &geo.; 
	if &geo. ^= " ";
run;

%end;

%mend hmda_tracts_new;
