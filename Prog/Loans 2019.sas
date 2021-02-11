/**************************************************************************
 Program:  Loans 2019
 Library:  HMDA
 Project:  Urban Greater DC
 Author:   Ananya Hariharan
 Created:  02/11/2021
 Version:  SAS 9.4
 Environment:  Windows 7
 Description: Read raw HMDA data for the Washington region, create loan_yyyy
                      base files.
 Modifications:

**************************************************************************/

%include "\\SAS1\DCData\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( HMDA )

%let revisions = New file ;
%let year = 2019;

%let rawpath = &_dcdata_r_path\HMDA\Raw\;
%let filename = 2019_lar.txt;

/* Read raw loan-level HMDA from TXT file */
filename fimport "&rawpath.&filename." lrecl=2000;
data hmda_country_&year._raw;

  infile FIMPORT delimiter = '|' MISSOVER DSD lrecl=32767 firstobs=2 ;

        informat activity_year best32.;
        informat lei  $20.;
        informat derived_msa_md  $5.;
        informat state_code $2.;
        informat county_code $5.;
        informat census_tract $11.;
        informat conforming_loan_limit $2.;
        informat derived_loan_product_type $29.;
        informat derived_dwelling_category $38.;
        informat derived_ethnicity $23.;
        informat derived_race $41.;
        informat derived_sex $17.;
        informat action_taken best32.;
        informat purchaser_type best32.;
        informat preapproval best32.;
        informat loan_type best32.;
        informat loan_purpose best32.;
        informat lien_status best32.;
        informat reverse_mortgage best32.;
        informat open_end_line_of_credit best32.;
        informat business_or_commercial_purpose best32.;
        informat loan_amount $50.;
        informat loan_to_value_ratio $10.;
        informat interest_rate $10.;
        informat rate_spread $10.;
        informat hoepa_status best32.;
        informat total_loan_costs $50.;
        informat total_points_and_fees $50.;
        informat origination_charges $50.;
        informat discount_points $50.;
        informat lender_credits $50.;
        informat loan_term $99.;
        informat prepayment_penalty_term $99.;
        informat intro_rate_period $99.;
        informat negative_amortization best32.;
        informat interest_only_payment best32.;
        informat balloon_payment best32.;
        informat other_nonamortizing_features best32.;
        informat property_value $99.;
        informat construction_method best32.;
        informat occupancy_type best32.;
        informat mfh_secured_property_type best32.;
        informat mfh_land_property_interest best32.;
        informat total_units $7.;
        informat multifamily_affordable_units $6.;
        informat app_income $99.;
        informat debt_to_income_ratio $20.;
        informat applicant_credit_score_type best32.;
        informat co_applicant_credit_score_type best32.;
        informat applicant_ethnicity_1 $2.;
        informat applicant_ethnicity_2 $2.;
        informat applicant_ethnicity_3 $2.;
        informat applicant_ethnicity_4 $2.;
        informat applicant_ethnicity_5 $2.;
        informat co_applicant_ethnicity_1 $2.;
        informat co_applicant_ethnicity_2 $2.;
        informat co_applicant_ethnicity_3 $2.;
        informat co_applicant_ethnicity_4 $2.;
        informat co_applicant_ethnicity_5 $2.;
        informat applicant_ethnicity_observed $1.;
        informat co_applicant_ethnicity_observed $1.;
        informat applicant_race_1 $2.;
        informat applicant_race_2 $2.;
        informat applicant_race_3 $2.;
        informat applicant_race_4 $2.;
        informat applicant_race_5 $2.;
        informat co_applicant_race_1 $2.;
        informat co_applicant_race_2 $2.;
        informat co_applicant_race_3 $2.;
        informat co_applicant_race_4 $2.;
        informat co_applicant_race_5 $2.;
        informat applicant_race_observed best32.;
        informat co_applicant_race_observed best32.;
        informat applicant_sex best32.;
        informat co_applicant_sex best32.;
        informat applicant_sex_observed best32.;
        informat co_applicant_sex_observed best32.;
        informat applicant_age $5.;
        informat co_applicant_age $4.;
        informat applicant_age_above_62  $5.;
        informat co_applicant_age_above_62 $5.;
        informat submission_of_application $4.;
        informat initially_payable_to_institution $4.;
        informat aus_1 best32.;
        informat aus_2 $1.;
        informat aus_3 $1.;
        informat aus_4 $1.;
        informat aus_5 $1.;
        informat denial_reason_1 $4.;
        informat denial_reason_2 $1.;
        informat denial_reason_3 $1.;
        informat denial_reason_4 $1.;
        informat tract_population best32.;
        informat tract_minority_population_pct best32.;
        informat ffiec_msa_md_median_income best32.;
        informat tract_to_msa_income_percentage best32.;
        informat tract_owner_occupied_units best32.;
        informat tract_one_to_four_family_homes best32.;
        informat tract_median_age_housing_units best32.;

        input
        activity_year
        lei  $
        derived_msa_md  $
        state_code $
        county_code $
        census_tract $
        conforming_loan_limit $
        derived_loan_product_type $
        derived_dwelling_category $
        derived_ethnicity $
        derived_race $
        derived_sex $
        action_taken
        purchaser_type
        preapproval
        loan_type
        loan_purpose
        lien_status
        reverse_mortgage
        open_end_line_of_credit
        business_or_commercial_purpose
        loan_amount $
        loan_to_value_ratio $
        interest_rate
        rate_spread $
        hoepa_status
        total_loan_costs $
        total_points_and_fees $
        origination_charges $
        discount_points $
        lender_credits $
        loan_term $
        prepayment_penalty_term $
        intro_rate_period $
        negative_amortization
        interest_only_payment
        balloon_payment
        other_nonamortizing_features
        property_value $
        construction_method
        occupancy_type
        mfh_secured_property_type
        mfh_land_property_interest
        total_units $
        multifamily_affordable_units $
        app_income $
        debt_to_income_ratio $
        applicant_credit_score_type
        co_applicant_credit_score_type
        applicant_ethnicity_1 $
        applicant_ethnicity_2 $
        applicant_ethnicity_3 $
        applicant_ethnicity_4 $
        applicant_ethnicity_5 $
        co_applicant_ethnicity_1 $
        co_applicant_ethnicity_2 $
        co_applicant_ethnicity_3 $
        co_applicant_ethnicity_4 $
        co_applicant_ethnicity_5 $
        applicant_ethnicity_observed $
        co_applicant_ethnicity_observed $
        applicant_race_1 $
        applicant_race_2 $
        applicant_race_3 $
        applicant_race_4 $
        applicant_race_5 $
        co_applicant_race_1 $
        co_applicant_race_2 $
        co_applicant_race_3 $
        co_applicant_race_4 $
        co_applicant_race_5 $
        applicant_race_observed
        co_applicant_race_observed
        applicant_sex
        co_applicant_sex
        applicant_sex_observed
        co_applicant_sex_observed
        applicant_age $
        co_applicant_age $
        applicant_age_above_62   $
        co_applicant_age_above_62 $
        submission_of_application $
        initially_payable_to_institution $
        aus_1
        aus_2 $
        aus_3 $
        aus_4 $
        aus_5 $
        denial_reason_1 $
        denial_reason_2 $
        denial_reason_3 $
        denial_reason_4 $
        tract_population
        tract_minority_population_pct
        ffiec_msa_md_median_income
        tract_to_msa_income_percentage
        tract_owner_occupied_units
        tract_one_to_four_family_homes
        tract_median_age_housing_units
        ;

run;

%macro hmda_input (state);

/* Process a clean HMDA file for each state */
proc sql noprint;
        CREATE TABLE hmda_&state._&year._raw AS
                SELECT *
                FROM hmda_country_&year._raw
                WHERE state_code = "&state." ;
quit;


/* Process a clean HMDA file */
data hmda_&state._&year._clean;
        set hmda_&state._&year._raw;

        /* Set length for variables */
        length action $1.
                   apprac $1.
                   appsex $1.
                   coapethn $1.
                   coaprac $1.
                   coaprac2 $1.
                   coaprac3 $1.
                   coaprac4 $1.
                   coaprac5 $1.
                   coapsex $1.
                   deny1 $2.
                   deny2 $2.
                   deny3 $2.
                   deny4 $2.
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
        amount = loan_amount +0;
        apprac = put(applicant_race_1,1.);
        appsex = put(applicant_sex,1.);
        coapethn = put(co_applicant_ethnicity_1,1.);
        coaprac = put(co_applicant_race_1,1.);
        coaprac2 = put(co_applicant_race_2,1.);
        coaprac3 = put(co_applicant_race_3,1.);
        coaprac4 = put(co_applicant_race_4,1.);
        coaprac5 = put(co_applicant_race_5,1.);
        coapsex = put(co_applicant_sex,1.);
        deny1 = left(put(denial_reason_1,2.));
        deny2 = left(put(denial_reason_2,2.));
        deny3 = left(put(denial_reason_3,2.));
        deny4 = left(put(denial_reason_4,2.));
        ethn = put(applicant_ethnicity_1,1.);
        hoepa = put(hoepa_status,1.);
        hudmdinc = ffiec_msa_md_median_income;
        income = app_income *1000;
        lien = put(lien_status,1.);
        loantype = put(loan_type,1.);
        metro = put(derived_msa_md,5.);
        occupanc = put(occupancy_type,1.);
        prch_typ = left(put(purchaser_type,2.));
        preapp = put(preapproval,1.);
        purpose = left(put(loan_purpose,2.));
        race2 = put(applicant_race_2,1.);
        race3 = put(applicant_race_3,1.);
        race4 = put(applicant_race_4,1.);
        race5 = put(applicant_race_5,1.);
        rtspread = rate_spread + 0;
        seq = lei;
        county = substr(county_code,2,3);
        year = put(activity_year,4.);
        state = put(state_code,2.);
        tract = census_tract;


        /* Property type changed in raw data to derived dwelling */
        if derived_dwelling_category = "Single Family (1-4 Units):Site-Built" then property_type = "1";
                else if derived_dwelling_category = "Single Family (1-4 Units):Manufactured" then property_type = "2";
                else if derived_dwelling_category = "Multifamily:Site-Built" then property_type = "3";
                else if derived_dwelling_category = "Multifamily:Manufactured" then property_type = "3";

        type = put(property_type,1.);


        /* Flag for missing tracts */
        if tract = " " then missingtract = 1;
                else missingtract = 0;


        /* Combined ucounty and geo2000/geo2010 */
        if county_code ^= "NA" then ucounty = county_code;

        if census_tract ^= "NA" then geo2010 = census_tract;
        label geo2010 = "Full census tract ID (2010): ssccctttttt";


        /* High interest */
                if rtspread > 0 then high_interest = 1;
                  else high_interest = 0;


        /* Create unique lender ID */
        ulender = year || lei;


        /* Format everything */
        format action $action.
                   apprac coaprac coaprac2 coaprac3 coaprac4 coaprac5 race2 race3 race4 race5 $hmdrace.
                   appsex coapsex $hmdsex.
                   coapethn ethn $hmdethn.
                   deny1 deny2 deny3 $deny.
                   hoepa $hoepa.
                   lien $lien.
                   loantype loantyp.
                   occupanc $occupan.
                   prch_typ $prchtyp.
                   preapp $preapp.
                   purpose $purpose.
                   type $proptyp.
                   ucounty $cnty15f.
                   high_interest dyesno.
        ;

        /* Labels */
        label
        action = "Type of Action Taken"
        amount = "Loan amount ($)"
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
        ulender = "Unique lender ID (year + LEI)"
        year = "HMDA reporting year"
        high_interest = "High interest rate loan"
        missingtract = "Flag for missing tract ID on raw data"
        ;




        /* Make sure missing is coded correctly */
        %let clist = action apprac appsex coapethn coaprac coaprac2 coaprac3 coaprac4
                                 coaprac5 coapsex deny1 deny2 deny3 ethn hoepa lien metro occupanc prch_typ preapp
                                 purpose race2 race3 race4 race5 type county ucounty year state tract ;

        %macro fixmissing();
        %let varlist = &clist. ;
                %let i = 1;
                        %do %until (%scan(&varlist,&i,' ')=);
                                %let var=%scan(&varlist,&i,' ');
                if &var. = "." then &var. = " " ;
                else if &var. = "    ." then &var. = " " ;
        %let i=%eval(&i + 1);
                        %end;
                %let i = 1;
                        %do %until (%scan(&varlist,&i,' ')=);
                                %let var=%scan(&varlist,&i,' ');
        %let i=%eval(&i + 1);
                        %end;
        %mend fixmissing;
        %fixmissing;


        /* Final keep */
        if put( ucounty, $ctym15f. ) ^= " ";

        keep action amount apprac appsex coapethn coaprac coaprac2 coaprac3 coaprac4 coaprac5
        coapsex deny1 deny2 deny3 edit ethn hoepa hudmdinc income lien loantype occupanc prch_typ
        preapp purpose race2 race3 race4 race5 rtspread seq type ucounty ulender year high_interest geo2010;



run;

%mend hmda_input;
%hmda_input (DC);
%hmda_input (MD);
%hmda_input (VA);
%hmda_input (WV);


data loans_allgeo_&year.;
        set Hmda_dc_&year._clean Hmda_md_&year._clean Hmda_va_&year._clean Hmda_wv_&year._clean;
run;

proc contents data = loans_allgeo_&year. out = cont_&year.;
run;

data cont_ch_&year.;
        set cont_&year.;
        if type = 2;
run;

proc sql noprint;
        select name
        into :vars separated by " "
        from cont_ch_&year.;
quit;

data loans_was15_&year.;
        set loans_allgeo_&year.;

        %macro fixzero();
                %let varlist = &vars.;
                        %let i = 1;
                                %do %until (%scan(&varlist,&i,' ')=);
                                        %let var=%scan(&varlist,&i,' ');
                        if &var. = "." then &var. = " " ;
                %let i=%eval(&i + 1);
                                %end;
                        %let i = 1;
                                %do %until (%scan(&varlist,&i,' ')=);
                                        %let var=%scan(&varlist,&i,' ');
                %let i=%eval(&i + 1);
                                %end;
        %mend fixzero;
        %fixzero;

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


/* End of program */
