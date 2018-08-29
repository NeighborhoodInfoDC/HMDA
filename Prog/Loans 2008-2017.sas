/**************************************************************************
 Program:  Loans 2008-2017
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  08/27/18
 Version:  SAS 9.4
 Environment:  Windows 7
 Description: Read raw HMDA data for the Washington region, create loan_yyyy
		      base files. 
 Modifications: 

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( HMDA )

%let revisions = New file ;


%macro hmda_input (state);

%do year = 2008 %to 2017 ;

%let rawpath = &_dcdata_r_path\HMDA\Raw\;
%let filename = hmda_lar 2008_2017_&state..csv;

/* Read raw HMDA from CSV */
filename fimport "&rawpath.&filename." lrecl=2000;
data hmda_&state._&year._raw;

  infile FIMPORT delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;

	informat action_taken best32.;
	informat action_taken_name $30.;
	informat agency_code best32.;
	informat agency_abbr $10.;
	informat agency_name $50.;
	informat applicant_ethnicity best32.;
	informat applicant_ethnicity_name $99.;
	informat applicant_income_000s best32.;
	informat applicant_race_1 best32.;
	informat applicant_race_2 best32.;
	informat applicant_race_3 best32.;
	informat applicant_race_4 best32.;
	informat applicant_race_5 best32.;
	informat applicant_race_name_1 $99.;
	informat applicant_race_name_2 $99.;
	informat applicant_race_name_3 $99.;
	informat applicant_race_name_4 $99.;
	informat applicant_race_name_5 $99.;
	informat applicant_sex best32.;
	informat applicant_sex_name $99.;
	informat application_date_indicator best32.;
	informat as_of_year best32.;
	informat census_tract_number $9.;
	informat co_applicant_ethnicity best32.;
	informat co_applicant_ethnicity_name $99.;
	informat co_applicant_race_1 best32.;
	informat co_applicant_race_2 best32.;
	informat co_applicant_race_3 best32.;
	informat co_applicant_race_4 best32.;
	informat co_applicant_race_5 best32.;
	informat co_applicant_race_name_1 $99.;
	informat co_applicant_race_name_2 $99.;
	informat co_applicant_race_name_3 $99.;
	informat co_applicant_race_name_4 $99.;
	informat co_applicant_race_name_5 $99.;
	informat co_applicant_sex best32.;
	informat co_applicant_sex_name $99.;
	informat county_code best32.;
	informat county_name $50.;
	informat denial_reason_1 best32.;
	informat denial_reason_2 best32.;
	informat denial_reason_3 best32.;
	informat denial_reason_name_1 $99.;
	informat denial_reason_name_2 $99.;
	informat denial_reason_name_3 $99.;
	informat edit_status best32.;
	informat edit_status_name $99.;
	informat hoepa_status best32.;
	informat hoepa_status_name $99.;
	informat lien_status best32.;
	informat lien_status_name $99.;
	informat loan_purpose best32.;
	informat loan_purpose_name $99.;
	informat loan_type best32.;
	informat loan_type_name $99.;
	informat msamd best32.;
	informat msamd_name $99.;
	informat owner_occupancy best32.;
	informat owner_occupancy_name $99.;
	informat preapproval best32.;
	informat preapproval_name $99.;
	informat property_type best32.;
	informat property_type_name $99.;
	informat purchaser_type best32.;
	informat purchaser_type_name $99.;
	informat respondent_id $12.;
	informat sequence_number best32.;
	informat state_code best32.;
	informat state_abbr $2.;
	informat state_name $50.;
	informat hud_median_family_income best32.;
	informat loan_amount_000s best32.;
	informat number_of_1_to_4_family_units best32.;
	informat number_of_owner_occupied_units best32.;
	informat minority_population best32.;
	informat population best32.;
	informat rate_spread best32.;
	informat tract_to_msamd_income best32.;

	input 
	action_taken 
	action_taken_name $
	agency_code 
	agency_abbr $
	agency_name $
	applicant_ethnicity 
	applicant_ethnicity_name $
	applicant_income_000s 
	applicant_race_1 
	applicant_race_2 
	applicant_race_3 
	applicant_race_4 
	applicant_race_5 
	applicant_race_name_1 $
	applicant_race_name_2 $
	applicant_race_name_3 $
	applicant_race_name_4 $
	applicant_race_name_5 $
	applicant_sex 
	applicant_sex_name $
	application_date_indicator 
	as_of_year 
	census_tract_number $
	co_applicant_ethnicity 
	co_applicant_ethnicity_name $
	co_applicant_race_1 
	co_applicant_race_2 
	co_applicant_race_3 
	co_applicant_race_4 
	co_applicant_race_5 
	co_applicant_race_name_1 $
	co_applicant_race_name_2 $
	co_applicant_race_name_3 $
	co_applicant_race_name_4 $
	co_applicant_race_name_5 $
	co_applicant_sex 
	co_applicant_sex_name $
	county_code 
	county_name $
	denial_reason_1 
	denial_reason_2 
	denial_reason_3 
	denial_reason_name_1 $
	denial_reason_name_2 $
	denial_reason_name_3 $
	edit_status 
	edit_status_name $
	hoepa_status 
	hoepa_status_name $
	lien_status 
	lien_status_name $
	loan_purpose 
	loan_purpose_name $
	loan_type 
	loan_type_name $
	msamd 
	msamd_name $
	owner_occupancy 
	owner_occupancy_name $
	preapproval 
	preapproval_name $
	property_type 
	property_type_name $
	purchaser_type 
	purchaser_type_name $
	respondent_id $
	sequence_number 
	state_code 
	state_abbr $
	state_name $
	hud_median_family_income 
	loan_amount_000s 
	number_of_1_to_4_family_units 
	number_of_owner_occupied_units 
	minority_population 
	population 
	rate_spread 
	tract_to_msamd_income 
	;

	if as_of_year=&year. ;

run;


/* Process a clean HMDA file */
data hmda_&state._&year._clean;
	set hmda_&state._&year._raw;

	/* Set length for variables */
	length action $1.
	 	   agency $1.
		   appdate $1.
		   appdate $1.
		   apprac $1.
		   appsex $1.
		   coapethn $1.
		   coaprac $1.
		   coaprac2 $1.
		   coaprac3 $1.
		   coaprac4 $1.
		   coaprac5 $1.
		   coapsex $1.
		   deny1 $1.
		   deny2 $1.
		   deny3 $1.
		   edit $1.
		   ethn $1.
		   hoepa $1.
		   lien $1.
		   metro $5.
		   occupanc $1.
		   prch_typ $1.
		   preapp $1.
		   purpose $1.
		   race2 $1.
		   race3 $1.
		   race4 $1.
		   race5 $1.
		   type $1.
		   county $3.
		   ucounty $5.
		   year $4.
		   state $2.
		   tract $6.
		   high_interest 3
	;

	/* Create clean versions of variables */
	action = put(action_taken,1.);
	agency = put(agency_code,1.);
	amount = loan_amount_000s * 1000;
	appdate = put(application_date_indicator,1.);
	apprac = put(applicant_race_1,1.);
	appsex = put(applicant_sex,1.);
	coapethn = put(co_applicant_ethnicity,1.);
	coaprac = put(co_applicant_race_1,1.);
	coaprac2 = put(co_applicant_race_2,1.);
	coaprac3 = put(co_applicant_race_3,1.);
	coaprac4 = put(co_applicant_race_4,1.);
	coaprac5 = put(co_applicant_race_5,1.);
	coapsex = put(co_applicant_sex,1.);
	deny1 = put(denial_reason_1,1.);
	deny2 = put(denial_reason_1,1.);
	deny3 = put(denial_reason_1,1.);
	edit = put(edit_status,1.);
	ethn = put(applicant_ethnicity,1.);
	hoepa = put(hoepa_status,1.);
	hudmdinc = hud_median_family_income;
	income = applicant_income_000s * 1000;
	lien = put(lien_status,1.);
	loantype = put(loan_type,1.);
	metro = put(msamd,5.);
	occupanc = put(owner_occupancy,1.);
	prch_typ = put(purchaser_type,1.);
	preapp = put(preapproval,1.);
	purpose = put(loan_purpose,1.);
	race2 = put(applicant_race_2,1.);
	race3 = put(applicant_race_3,1.);
	race4 = put(applicant_race_4,1.);
	race5 = put(applicant_race_5,1.);
	rtspread = rate_spread;
	seq = sequence_number;
	type = put(property_type,1.);
	county = put(county_code,z3.);
	year = put(as_of_year,4.);
	state = put(state_code,2.);
	tract = compress(census_tract_number,".");

	/* Combined ucounty and geo2000/geo2010 */
	ucounty = state || county;

	%if &year. < 2012 %then %do;
	geo2000 = ucounty || tract ;
	label geo2000 = "Full census tract ID (2000): ssccctttttt";
	keep geo2000;
	%end;
	%else %do;
	geo2010 = ucounty || tract ;
	label geo2010 = "Full census tract ID (2010): ssccctttttt";
	keep geo2010;
	%end;

	/* Create unique lender ID */
	resp = compress(respondent_id,"-");
	ulender = year || agency || resp;

	/* High interest */
	if rtspread > 0 then high_interest = 1;
          else high_interest = 0;

	/* Format everything */
	format action $action.
		   agency $agencyf.
		   appdate $appdate.
		   apprac coaprac coaprac2 coaprac3 coaprac4 coaprac5 race2 race3 race4 race5 $hmdrace.
		   appsex coapsex $hmdsex.
		   coapethn ethn $hmdethn.
		   deny1 deny2 deny3 $deny.
		   edit $edit.
		   hoepa $hoepa.
		   lien $lien.
		   loantype loantyp.
		   occupanc $occupan.
		   prch_typ $prchtyp.
		   preapp $preapp.
		   purpose $purpose.
		   type $proptyp.
		   ucounty $cnty99f.
		   high_interest dyesno.
	;

	/* Labels */
	label 
	action = "Type of Action Taken"
	agency = "Agency Code"
	amount = "Loan amount ($)"
	appdate = "Application date prior to HMDA reporting year "
	apprac = "Applicant Race 1"
	appsex = "Applicant Sex"
	coapethn = "Co-Applicant Ethnicity"
	coaprac = "Co-Applicant Race 1"
	coaprac2 = "Co-Applicant Race 2"
	coaprac3 = "Co-Applicant Race 3"
	coaprac4 = "Co-Applicant Race 4"
	coaprac5 = "Co-Applicant Race 5"
	coapsex = "Co-Applicant Sex"
	deny1 = "Denial Reason 1"
	deny2 = "Denial Reason 2"
	deny3 = "Denial Reason 3"
	edit = "Loan record edit status"
	ethn = "Applicant Ethnicity"
	hoepa = "HOEPA status (only for loans originated or purchased"
	hudmdinc = "HUD median family income ($)"
	income = "Applicant income ($)"
	lien = "Lien status (only for applications and originations)"
	loantype = "Type of Loan"
	metro = "Metropolitan area code"
	occupanc = "Owner-occupancy status of loan"
	prch_typ = "Purchaser Type"
	preapp = "Preapproval"
	purpose = "Purpose of Loan"
	race2 = "Applicant Race 2"
	race3 = "Applicant Race 3"
	race4 = "Applicant Race 4"
	race5 = "Applicant Race 5"
	rtspread = "Rate Spread"
	seq = "Loan record sequence number"
	type = "Type of property"
	ucounty = "Full county FIPS: ssccc"
	ulender = "Unique lender ID (year + agency + resp_id)"
	year = "HMDA reporting year"
	high_interest = "High interest rate loan"
	;

	/* Final keep */
	keep action agency amount appdate apprac appsex coapethn coaprac coaprac2 coaprac3 coaprac4 coaprac5
	coapsex deny1 deny2 deny3 edit ethn hoepa hudmdinc income lien loantype metro occupanc prch_typ
	preapp purpose race2 race3 race4 race5 rtspread seq type ucounty ulender year high_interest;

run;

%end;

%mend hmda_input;
%hmda_input (DC);
%hmda_input (MD);
%hmda_input (VA);
%hmda_input (WV);


/* Combine to create metro area files by year */
%macro hmda_finalize ();

%do year = 2008 %to 2017 ;

data loans_was15_&year.;
	set Hmda_dc_&year._clean Hmda_md_&year._clean Hmda_va_&year._clean Hmda_wv_&year._clean;
run;

%Finalize_data_set( 
  /** Finalize data set parameters **/
  data=loans_was15_&year.,
  out=Loans_&year.,
  outlib=hmda,
  label="Mortgage loans (loan application record), Washington region, &year.",
  sortby=ulender seq,
  /** Metadata parameters **/
  restrictions=None,
  revisions=%str(&revisions),
  /** File info parameters **/
  printobs=5
);

%end;

%mend hmda_finalize;
%hmda_finalize;



/* End of program */
