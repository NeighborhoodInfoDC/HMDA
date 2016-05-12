/**************************************************************************
 Program:  Read_loans.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/11/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to read DataPlace LAR data set and
 convert to warehouse format.

 Modifications:
  04/16/07 PAT Added label for MSAPMA99.
  12/13/07 PAT Added data= parameter (NOT WORKING FOR 2003 DATA YET).
  12/17/07 PAT Added support for years 1997 - 2003.
  09/23/08 PAT Added support for 2006 file format.
               Check for invalid counties (not in metro).
**************************************************************************/

/** Macro Read_loans - Start Definition **/

%macro Read_loans( year=, obs=100000000 );

  %let shyear = %substr( &year, 3, 2 );
  
  %if &year >= 2003 %then %let tractvar = geo2000;
  %else %let tractvar = geo1990;
  
  %if &year >= 2006 %then %do;
  
    %let data = Hmda.HMDA&shyear._WAS (drop=state county tract pop minpopct ownocc tctinc units1_4 obs=&obs
                                       rename=(before2004=appdate proptype=type appethn=ethn
                                               apprac2=race2 apprac3=race3 apprac4=race4 apprac5=race5));
    
  %end;
  %else %if &year >= 2004 %then %do;
  
    %let data = Hmda.HMDA&shyear._WAS (drop=state county tract pop minpopct ownocc tctinc units1_4 obs=&obs);
    
  %end;
  %else %do;
  
    %let data = Hmda.all&year._was (drop=state county tract rename=(type=loantype) obs=&obs WHERE=(&tractvar=:'11'));
  
  %end;
  
  proc contents data=&data;
  
  ** Create format from subprime list **;

  %Data_to_format(
    FmtLib=work,
    FmtName=$subprim,
    Desc=,
    Data=Hmda.Lenders_&year,
    Value=ulender,
    Label=subprime_lender,
    OtherLabel="0",
    DefaultLen=.,
    MaxLen=.,
    MinLen=.,
    Print=N,
    Contents=N
    )

  %if &year <= 2003 %then %do;

  /*
  %Dup_check(
  data=HUD.INCLIM&shyear,
  by=fips_state_code fips_county_code,
  id=fy_&year._median_family_income County_Name hud_msa_code,
  out=_dup_check,
  listdups=Y
  )
  */

  
    ** Create format from HUD median incomes **;
    
    %Data_to_format(
      FmtLib=work,
      FmtName=$hudminc,
      Desc=,
      Data=HUD.INCLIM&shyear (where=(fips_state_code in ('11', '24', '51', '54' ))),
      Value=fips_state_code || fips_county_code,
      Label=put( fy_&year._median_family_income, 20. ),
      OtherLabel=".",
      DefaultLen=.,
      MaxLen=.,
      MinLen=.,
      Print=N,
      Contents=N
      )
 
  %end;

  ** Read and convert DataPlace LAR data file **;

  data Hmda.Loans_&year (label="Mortgage loans (loan application record), Washington region, &year");

    set &data;
    
    /*
    IF PUT( GEO2000, $GEO00V. ) = '' THEN DO;
      %ERR_PUT( MSG='INVALID TRACT NO. ' _N_= GEO2000= )
    END;
    */
    
    ** Unique lender ID **;
    
    length ulender $ 15;
    
    ulender = put( 1 * year, 4. ) || agency || resp_id;
    
    %** For 2006 and later(?), create standard tract, county, metro area vars. **;
    
    %if &year >= 2006 %then %do;
    
      length xgeo2000 $ 11 ucounty $ 5 msapma99 $ 4 metro03 $ 5;
      
      ** Correct tract var formatting **;
      
      xgeo2000 = compress( geo2000, '.' );
      
      ** Unique county ID **;
      
      ucounty = xgeo2000;
      
      ** Metro area IDs **;
      
      msapma99 = put( ucounty, $ctym99f. );
      metro03 = put( ucounty, $ctym03f. );
      
      label
        xgeo2000 = "Full census tract ID (2000): ssccctttttt"
        ucounty = "Full county FIPS: ssccc"
        msapma99 = "FIPS MSA/PMSA code (6/30/99 def.)"
        metro03 = "Metropolitan statistical area code (6/6/2003 def.)";
        
      rename xgeo2000=Geo2000;
        
      drop geo2000;
      
    %end;
    
    ** Check for invalid counties **;
    
    if msapma99 ~= "8840" and metro03 ~= "47900" then do;
      %warn_put( macro=Read_loans, msg="Invalid county: " _n_= ucounty= msapma99= metro03= " Obs will be deleted." )
      delete;
    end;

    ** Suprime lenders **;
    
    length subprime_lender 3;
    
    if loantype = "1" then do;
      subprime_lender = 1 * put( ulender, $subprim. );
    end;
    else do;
      subprime_lender = .n;
    end;
    
    ** Convert loan amt. & income to dollars **;
    
    amount = 1000 * amount;
    income = 1000 * income;
    
    %** For 2003 and earlier, need to add HUD median income **;
    
    %if &year <= 2003 %then %do;
    
      hudmdinc = input( put( ucounty, $hudminc. ), 20. );
      
    %end;
    
    %** For 2003 and earlier, need to create property type var. **;
    
    %if &year <= 2003 %then %do;
    
      length type $ 1;
    
      select ( purpose );
        when ( '1', '2', '3' ) type = '1';
        when ( '4' ) type = '3';
        when ( ' ' ) type = ' ';
      end;
      
    %end;
    
    %** High cost loans are only for 2004 or later **;
    
    %if &year >= 2004 %then %do;
  
      ** High interest rate loans **;

      length high_interest 3;
      
      if loantype = "1" and action = "1" then do;
      
        %if &year = 2004 %then %do;

          if appdate ne '1' then do;
            if rtspread > 0 then high_interest = 1;
            else high_interest = 0;
          end;
          else do;
            high_interest = .u;
          end;

        %end;
        %else %if &year >= 2005 %then %do;

          if rtspread > 0 then high_interest = 1;
          else high_interest = 0;

        %end;
        %else %do;

          high_interest = .u;

        %end;
        
      end;
      else do;
      
        high_interest = .n;
        
      end;
      
      label high_interest = "High interest rate loan";
      
      format high_interest dyesno.;
    
    %end;
    
    ** Recodes **;
    
    array a{*} edit deny: ;
    
    if edit = "" then edit = "0";
    
    if action = "3" then do;
      if deny1 = "" then deny1 = "0";
      if deny2 = "" then deny2 = "0";
      if deny3 = "" then deny3 = "0";
    end;
    
    %if &year >= 2004 %then %do;
    
      if coaprac = "8" then do;
        coaprac2 = "8";
        coaprac3 = "8";
        coaprac4 = "8";
        coaprac5 = "8";
      end;  
      
    %end;
    
    label
      type = "Type of property"
      ulender = "Unique lender ID [year + agency + resp_id]"
      subprime_lender = "Loan issued by HUD-classified subprime lender"
      amount = "Loan amount ($)"
      income = "Applicant income ($)"
      seq = "Loan record sequence number"
      year = "HMDA reporting year"
      occupanc = "Owner-occupancy status of loan"
      edit = "Loan record edit status"
      hudmdinc = "HUD median family income ($)"
      msapma99 = "MSA/PMSA (1999)"
      metro03 = "Metropolitan area (2003)"
    ;
    
    format 
      agency $agencyf. loantype $loantyp. purpose $purpose. 
      type $proptyp. 
      occupanc $occupan. action $action.
      apprac race: coaprac: $hmdrace. appsex coapsex $hmdsex. 
      prch_typ $prchtyp. 
      deny: $deny. edit $edit. 
      subprime_lender dyesno.
      ucounty $cnty99f.
    ;
    
    %let freqvars = year agency ucounty msapma99 metro03 
      loantype purpose type occupanc action 
      apprac coaprac: appsex coapsex prch_typ
      deny: edit hudmdinc subprime_lender ;
    
    %if &year >= 2004 %then %do;
    
      label 
        hoepa = "HOEPA status (only for loans originated or purchased)"
        lien = "Lien status (only for applications and originations)"
        appdate = "Application date prior to HMDA reporting year"
      ;
      
      format hoepa $hoepa. lien $lien. preapp $preapp. ethn coapethn $hmdethn.
             appdate $appdate.;
      
      %let freqvars = &freqvars race: preapp ethn coapethn hoepa lien appdate high_interest;
      
    %end;
  
    drop resp_id;
    
  run;

  proc sort data=Hmda.Loans_&year;
    by ulender seq;

  %File_info( 
    data=Hmda.Loans_&year,
    printobs=5,
    freqvars=&freqvars
  )
  
  proc tabulate data=Hmda.Loans_&year format=comma10.0 noseps missing;
    where action = "1";    /** Originations only **/
    class type purpose ucounty;
    var subprime_lender;
    table 
    ucounty,
    /** Rows **/
    all='All loans' type=' ' * purpose=' ',
    /** Columns **/
    n='Total'
    subprime_lender='Conven-tional' * n=' ' 
    subprime_lender='Subprime lenders' * sum=' '
    / indent=3 rts=50;
    title2;
    title3 "Loan Originations, &year";

  run;

%mend Read_loans;

/** End Macro Definition **/

