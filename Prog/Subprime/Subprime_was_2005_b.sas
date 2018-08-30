/**************************************************************************
 Program:  Subprime_was_2005_b.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/18/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create lists of top 10 subprime lenders for counties
in Washington region.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%let year = 2005;
%let rpt_yr = 2005;

%let rpt_path = &_dcdata_path\Hmda\Prog;
%let rpt_file = Subprime_was_&rpt_yr;
%let rpt_xls  = &rpt_file..xls;

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


** Get total loan amount for table **;

data Loans_tbl (compress=no);

  set Hmda.Loans_&year (keep=ulender ucounty loantype action subprime_lender purpose amount);

  where loantype = "1" and action = "1" and 
        subprime_lender and purpose in ( "1", "3" );
  
run;

proc summary data=Loans_tbl;
  var amount;
  class ucounty ulender;
  output out=Subprime_lender_totals (where=(_type_ in ( 2, 3 ) )) 
    sum= ;

run;

proc sort data=Subprime_lender_totals;
  by ucounty _type_ descending amount;

proc print data=Subprime_lender_totals;

run;

%let sheet = SubprimeLenders;
%let range = r2c1:r100c50;
%let max_lenders = 10;
%let fopt = notab;

filename xlsFile dde "excel|&rpt_path\[&rpt_xls]&sheet!&range" lrecl=2000 &fopt;

data _null_;

  file xlsFile;
  
  retain count 0;

  set Subprime_lender_totals;
  by ucounty;
  
  if first.ucounty then do;
    count = 0;
    put ucounty '09'x @;
  end;
  
  if count <= &max_lenders then do;
  
    put 
      ulender $lender. '09'x 
      _freq_ '09'x
      amount thous. '09'x 
      @;
    
    count + 1;
    
  end;
  
  if last.ucounty then put ;
    
run;

