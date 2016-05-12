/**************************************************************************
 Program:  Loans_tbl_2004.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/11/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  HMDA loan table.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%let year = 2004;

** Create format from subprime list **;

%Data_to_format(
  FmtLib=work,
  FmtName=$lender,
  Desc=,
  Data=Hmda.Lenders_&year,
  Value=ulender,
  Label=rsp_name,
  OtherLabel="",
  DefaultLen=.,
  MaxLen=.,
  MinLen=.,
  Print=N,
  Contents=N
  )

proc format;
  picture thous (round) 
    low-high='0,000,000' (multiplier=0.001);
  picture mill (round) 
    low-high='0,000,000' (multiplier=0.000001);

*options obs=100;

** Get total loan amount for table **;

proc sql noprint;
  select sum( amount ) into :total_amount 
  from Hmda.Loans_&year (where=(geo2000 =: "11" and loantype = "1" and action = "1"));

%put total_amount=&total_amount;

data Loans_tbl (compress=no);

  set Hmda.Loans_&year 
        (keep=ulender ucounty loantype action subprime_lender high_interest purpose amount 
              lien rtspread appdate);

  where /*geo2000 =: "11"*/ ucounty = "11001" and loantype = "1" and action = "1";
  
  pct_total = 100 * amount / &total_amount;
  
/** Macro SKIP - Start Definition **/

%macro SKIP;
  
  length high_interest $ 3;
  
  if rtspread > 0 and appdate ne '1' then high_interest = 1;

  select ( lien );
    when ( "1" ) do;
      if rtspread > 3 then high_interest = 1;
      else high_interest = 0;
    end;
    when ( "2" ) do;
      if rtspread > 5 then high_interest = 1;
      else high_interest = 0;
    end;
    otherwise 
      /** Do nothing **/ ;
  end;

  label high_interest = "High interest rate loan";
  
  format high_interest dyesno.;
  
%mend SKIP;

/** End Macro Definition **/

  
run;

** Total prime & subprime lending **;

proc tabulate data=Loans_tbl format=comma10. noseps missing;
  ***where geo2000 =: "11" and loantype = "1" and action = "1";
  class subprime_lender purpose;
  var amount;
  tables
    all purpose,
    ( n='Number of loans' rowpctn='Percent of loans'*f=comma10.1 ) * ( all subprime_lender );

  tables
    all purpose,
    amount='Amount (mil. $)' * ( sum='Total'*f=mill. rowpctsum='Percent'*f=comma10.1 ) * ( all subprime_lender );

  title3 'Home Mortgage Loans, Washington, DC, 2004';

run;

** Subprime lending by lender **;

ods rtf file="&_dcdata_path\hmda\prog\Loans_tbl.rtf" style=Minimal;

proc tabulate data=Loans_tbl format=comma10. noseps missing;
  ***where geo2000 =: "11" and loantype = "1" and action = "1" and subprime_lender;
  where subprime_lender and purpose in ( "1", "3" );
  class ulender /order=freq;
  class purpose;
  var amount pct_total;
  tables
    all='All Subprime Lenders' ulender=' ',
    n='Number loans' 
    amount='Amount (thous. $)' * 
      ( sum='Total'*f=thous. colpctsum='% of subprime'*f=comma10.1 )
    /*pct_total=' ' * sum='% of all loans'*f=comma10.1*/
  / rtspace=60 box='Home Purchase and Refinance Loans';
  format ulender $lender.;
  title3 'Subprime Home Mortgage Lending, Washington, DC, 2004';

run;

ods rtf close;

** High interest rate loans **;

proc tabulate data=Loans_tbl format=comma10. noseps missing;
  ***where geo2000 =: "11" and loantype = "1" and action = "1";
  class high_interest purpose lien;
  var amount;
  tables
    all lien,
    all purpose,
    ( n='Number of loans' rowpctn='Percent of loans'*f=comma10.1 ) * ( all high_interest );

  tables
    all purpose,
    amount='Amount (mil. $)' * ( sum='Total'*f=mill. rowpctsum='Percent'*f=comma10.1 ) * ( all high_interest );

  title3 'Home Mortgage Loans, Washington, DC, 2004';

run;

