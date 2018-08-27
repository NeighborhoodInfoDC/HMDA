/**************************************************************************
 Program:  Loans 2008-2017
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  08/27/18
 Version:  SAS 9.4
 Environment:  Windows 7
 Modifications: 

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( HMDA )

%let rawpath = &_dcdata_r_path\HMDA\Raw\;
%let filename = hmda_lar_2017b.csv;
%let year = 2017;

filename fimport "&rawpath.&filename." lrecl=2000;

data hmda_&year._raw;

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


/*
  
  format SALEDATE yymmdd10.;
	format	 DEEDDATE yymmdd10.;
	format	 EXTRACTDAT yymmdd10.;

drop c_SALEDATE c_DEEDDATE c_EXTRACTDAT in_usecode;*/

run;


proc import 
	datafile = "L:\Libraries\HMDA\Raw\hmda_lar_2017.csv"
	out = lar1
	dbms = csv replace;
	getnames = YES;
run;



proc import 
	datafile = "L:\Libraries\HMDA\Raw\hmda_lar_2017b.csv"
	out = lar2
	dbms = csv replace;
	getnames = YES;
run;


proc contents data = lar1 out = lar1cont; run;
proc contents data = lar2 out = lar2cont; run;

proc sort data = lar1cont; by varnum; run;
proc sort data = lar2cont; by varnum; run;

data lar_test;
	merge lar1cont (in=a) lar2cont (in=b) ;
	by name;
	if a and b then inboth = 1;
	if a and not b then ina = 1;
	if b and not a then inb = 1;
run;
