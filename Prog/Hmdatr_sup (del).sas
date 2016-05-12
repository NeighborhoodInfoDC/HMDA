/**************************************************************************
 Program:  Hmdatr_sup.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/18/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create supplemental tract summary vars. from HMDA
data.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%let year = 2005;

/** Macro Hmdatr_sup - Start Definition **/

%macro Hmdatr_sup( year );

  %let shyear = %substr( &year, 3, 2 );

  %if &year >= 2003 %then %do;

    %let tractvar = geo2000;
    %let trvfmt   = $geo00v.;
    %let trafmt   = $geo00a.;
    
  %end;
  %else %do;

    %let tractvar = geo1990;
    %let trvfmt   = $geo90v.;
    %let trafmt   = $geo90a.;
    
  %end;

  data Hmdatr&shyear._loans (compress=no);

    set Hmda.Loans_&year;
    
    where 
      ucounty =: "11" and           /** DC **/ 
      loantype = "1" and            /** Conventional **/
      type = "1" and                /** 1-4 family (non-manufactured) **/
      purpose in ( "1", "3" ) and   /** Purchase and refinance **/
      action = "1"                  /** Originations **/
    ;
    
    if put( &tractvar, &trvfmt ) = '' then do;
      %warn_put( msg="Invalid tract will be deleted. data=Hmda.Loans_&year " _n_= &tractvar= )
      delete;
    end;

    loans = 1;
    
    array a{*}
      DenSubprimeMrtgPurch_vli DenSubprimeMrtgPurch_li
      DenSubprimeMrtgPurch_mi DenSubprimeMrtgPurch_hinc

      DenSubprimeMrtgRefin_vli DenSubprimeMrtgRefin_li
      DenSubprimeMrtgRefin_mi DenSubprimeMrtgRefin_hinc

      NumSubprimeMrtgPurch_vli NumSubprimeMrtgPurch_li
      NumSubprimeMrtgPurch_mi NumSubprimeMrtgPurch_hinc

      NumSubprimeMrtgRefin_vli NumSubprimeMrtgRefin_li
      NumSubprimeMrtgRefin_mi NumSubprimeMrtgRefin_hinc

      %if &year >= 2004 %then %do;
        NumHighCostMrtgPurch_vli NumHighCostMrtgPurch_li
        NumHighCostMrtgPurch_mi NumHighCostMrtgPurch_hinc

        NumHighCostMrtgRefin_vli NumHighCostMrtgRefin_li
        NumHighCostMrtgRefin_mi NumHighCostMrtgRefin_hinc
      %end;
    ;
    
    do i = 1 to dim( a );
      a{i} = 0;
    end;
    
    if income > 0 then do;
      
      ** Create HUD categories **;
    
      vli = 0;
      li = 0;
      mi = 0;
      hinc = 0;
      
      if income <= 0.5 * hudmdinc then do;
        vli=1; 
      end;
      else if income <= 0.8 * hudmdinc then do;
        li=1;
      end;
      else if income < 1.2 * hudmdinc then do;
        mi=1;
      end;
      else if income >= 1.2 * hudmdinc then do;
        hinc=1;
      end;
      
      ** Create new variables **;
      
      if purpose = "1" then do;
      
        DenSubprimeMrtgPurch_vli = vli;
        DenSubprimeMrtgPurch_li = li;
        DenSubprimeMrtgPurch_mi = mi;
        DenSubprimeMrtgPurch_hinc = hinc;

        if subprime_lender then do;

          NumSubprimeMrtgPurch_vli = vli;
          NumSubprimeMrtgPurch_li = li;
          NumSubprimeMrtgPurch_mi = mi;
          NumSubprimeMrtgPurch_hinc = hinc;
          
        end;
        
        %if &year >= 2004 %then %do;
        
          if high_interest then do;
          
            NumHighCostMrtgPurch_vli = vli;
            NumHighCostMrtgPurch_li = li;
            NumHighCostMrtgPurch_mi = mi;
            NumHighCostMrtgPurch_hinc = hinc;

          end;
          
        %end;
        
      end;
      else if purpose = "3" then do;

        DenSubprimeMrtgRefin_vli = vli;
        DenSubprimeMrtgRefin_li = li;
        DenSubprimeMrtgRefin_mi = mi;
        DenSubprimeMrtgRefin_hinc = hinc;
        
        if subprime_lender then do;  

          NumSubprimeMrtgRefin_vli = vli;
          NumSubprimeMrtgRefin_li = li;
          NumSubprimeMrtgRefin_mi = mi;
          NumSubprimeMrtgRefin_hinc = hinc;

        end;

        %if &year >= 2004 %then %do;
        
          if high_interest then do;
          
            NumHighCostMrtgRefin_vli = vli;
            NumHighCostMrtgRefin_li = li;
            NumHighCostMrtgRefin_mi = mi;
            NumHighCostMrtgRefin_hinc = hinc;

          end;
          
        %end;
        
      end;
    
    end;

    label
      DenSubprimeMrtgPurch_vli = "Conventional home purchase mortgage loans to very low-income borrowers"
      DenSubprimeMrtgPurch_li = "Conventional home purchase mortgage loans to low-income borrowers"
      DenSubprimeMrtgPurch_mi = "Conventional home purchase mortgage loans to middle-income borrowers"
      DenSubprimeMrtgPurch_hinc = "Conventional home purchase mortgage loans to high income borrowers"

      DenSubprimeMrtgRefin_vli = "Conventional refinancing mortgage loans to very low-income borrowers"
      DenSubprimeMrtgRefin_li = "Conventional refinancing mortgage loans to low-income borrowers"
      DenSubprimeMrtgRefin_mi = "Conventional refinancing mortgage loans to middle-income borrowers"
      DenSubprimeMrtgRefin_hinc = "Conventional refinancing mortgage loans to high-income borrowers"

      NumSubprimeMrtgPurch_vli = "Conventional home purchase loans by subprime lenders to very-low inc. borrowers"
      NumSubprimeMrtgPurch_li = "Conventional home purchase loans by subprime lenders to low-income borrowers"
      NumSubprimeMrtgPurch_mi = "Conventional home purchase loans by subprime lenders to middle-income borrowers"
      NumSubprimeMrtgPurch_hinc = "Conventional home purchase loans by subprime lenders to high-income borrowers"

      NumSubprimeMrtgRefin_vli = "Conventional refinancing loans by subprime lenders to very-low inc. borrowers"
      NumSubprimeMrtgRefin_li = "Conventional refinancing loans by subprime lenders to low-income borrowers"
      NumSubprimeMrtgRefin_mi = "Conventional refinancing loans by subprime lenders to middle-income borrowers"
      NumSubprimeMrtgRefin_hinc = "Conventional refinancing loans by subprime lenders to high-income borrowers"

      %if &year >= 2004 %then %do;
        NumHighCostMrtgPurch_vli = "Conventional home purchase loans with high interest rates to very-low inc. borrowers"
        NumHighCostMrtgPurch_li = "Conventional home purchase loans with high interest rates to low-income borrowers"
        NumHighCostMrtgPurch_mi = "Conventional home purchase loans with high interest rates to middle-income borrowers"
        NumHighCostMrtgPurch_hinc = "Conventional home purchase loans with high interest rates to high-income borrowers"

        NumHighCostMrtgRefin_vli = "Conventional refinancing loans with high interest rates to very-low inc. borrowers"
        NumHighCostMrtgRefin_li = "Conventional refinancing loans with high interest rates to low-income borrowers"
        NumHighCostMrtgRefin_mi = "Conventional refinancing loans with high interest rates to middle-income borrowers"
        NumHighCostMrtgRefin_hinc = "Conventional refinancing loans with high interest rates to high-income borrowers"
      %end;
    ;  

    keep year &tractvar DenSubprimeMrtg: NumSubprimeMrtg: 
         %if &year >= 2004 %then %do;
           NumHighCostMrtg: 
         %end;
    ;

  run;

  proc summary data=Hmdatr&shyear._loans nway completetypes;
    class year;
    class &tractvar / preloadfmt;
    var DenSubprimeMrtg: NumSubprimeMrtg: 
        %if &year >= 2004 %then %do;
          NumHighCostMrtg: 
        %end;
        ;
    output out=Hmdatr&shyear._sum (compress=no drop=_type_ _freq_) sum= ;
    format &tractvar &trafmt;
    
  %if %upcase( &tractvar ) ~= GEO2000 %then %do;
  
    %Transform_geo_data(
      dat_ds_name=Hmdatr&shyear._sum,
      dat_org_geo=&tractvar,
      dat_id_vars=year,
      dat_count_vars=DenSubprimeMrtg: NumSubprimeMrtg:,      
      dat_prop_vars=,      
      wgt_ds_name=General.Wt_tr90_tr00 ,
      wgt_org_geo=&tractvar,
      wgt_new_geo=geo2000,
      wgt_id_vars=,
      wgt_wgt_var=popwt,
      out_ds_name=Hmdatr&shyear._sup,
      out_ds_label=,
      calc_vars=,
      calc_vars_labels=,
      keep_nonmatch=N,
      show_warnings=10
    )
    
  %end;
  %else %do;
  
  
    data Hmdatr&shyear._sup;
    
      set Hmdatr&shyear._sum;
      
    run;
    
  %end;
  
  
  data Hmda.Hmdatr&shyear._sup 
    (label="HMDA supplemental summary variables, DC, Census tract (2000)"
     sortedby=year geo2000
    );
    
    set Hmdatr&shyear._sup;
    
    array a{*} DenSubprimeMrtg: NumSubprimeMrtg: 
        %if &year >= 2004 %then %do;
          NumHighCostMrtg: 
        %end;
        ;
    
    do i = 1 to dim( a );
      if a{i} = . then a{i} = 0;
    end;

    label geo2000 = "Full census tract ID (2000): ssccctttttt";
    
    drop i;
    
  run;
  
  %File_info( data=Hmda.Hmdatr&shyear._sup, printobs=15 )

%mend Hmdatr_sup;

/** End Macro Definition **/

/*
%Hmdatr_sup( 1997 )
%Hmdatr_sup( 1998 )
%Hmdatr_sup( 1999 )
%Hmdatr_sup( 2000 )
%Hmdatr_sup( 2001 )
%Hmdatr_sup( 2002 )
%Hmdatr_sup( 2003 )
*/
%Hmdatr_sup( 2004 )
%Hmdatr_sup( 2005 )

