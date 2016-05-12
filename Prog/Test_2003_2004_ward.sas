/**************************************************************************
 Program:  Test_2003_2004_ward.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/13/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Test table for HMDA race data by ward, 2003 & 2004.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )
%DCData_lib( General )

/** Macro Do_one_year - Start Definition **/

%macro Do_one_year( year );

data Test_&year;
  set Hmda.Test_2003_2004;
  where year = &year;
run;

%Transform_geo_data(
    dat_ds_name=Test_&year,
    dat_org_geo=geo2000,
    dat_count_vars=
      nummrtgorighomepurch NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI NumMrtgOrigBlack NumMrtgOrigHisp
      NumMrtgOrigWhite NumMrtgOrigOther NumMrtgOrigRaceNotProvided
      NumMrtgOrigRaceNotApplic NumMrtgOrigMxd NumMrtgOrigWithRace
      NumMrtgOrigMulti NumMrtgOrigMin
    ,
    dat_prop_vars=,
    wgt_ds_name=General.wt_tr00_ward02,
    wgt_org_geo=geo2000,
    wgt_new_geo=ward2002,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=Test_&year._wd02,
    out_ds_label=,
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )

run;

%mend Do_one_year;

/** End Macro Definition **/

%Do_one_year( 2003 )
%Do_one_year( 2004 )

data Test_2003_2004_ward;

  set Test_2003_wd02 (in=in2003) Test_2004_wd02 (in=in2004);
  
  if in2003 then year = 2003;
  else if in2004 then year = 2004;
  
run;

ods rtf file="D:\DCData\Libraries\HMDA\Prog\Test_2003_2004_ward.rtf" style=Rtf_arial_9pt;

options orientation=landscape;

proc tabulate data=Test_2003_2004_ward format=comma8.1 noseps;
  var nummrtgorighomepurch NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI NumMrtgOrigBlack NumMrtgOrigHisp
      NumMrtgOrigWhite NumMrtgOrigOther NumMrtgOrigRaceNotProvided
      NumMrtgOrigRaceNotApplic NumMrtgOrigMxd NumMrtgOrigWithRace
      NumMrtgOrigMulti NumMrtgOrigMin;
  class year ward2002;
  table
    year='Year = ',
    nummrtgorighomepurch='Total home purchase loans' * sum=' ' * f=comma8.0
    NumMrtgOrigWithRace='\line Total loans reporting race'  * sum=' ' * f=comma8.0
    NumMrtgOrigWithRace='Percent loans reporting race' * pctsum<nummrtgorighomepurch>=' ' 
    ( NumMrtgOrigWithRace='\line\i Percent loans by race'
      NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI
      NumMrtgOrigBlack
      NumMrtgOrigHisp
      NumMrtgOrigWhite
      NumMrtgOrigOther
      NumMrtgOrigMxd 
      NumMrtgOrigMulti ) * pctsum<NumMrtgOrigWithRace>=' '
  , 
  ward2002=' ' / rts=40 box=_page_ row=float;
  title2 ' ';
  title3 'Home Purchase Mortgage Lending, Washington, D.C., 2003 - 2004';

run;

proc tabulate data=Test_2003_2004_ward format=comma8.1 noseps;
  where ward2002 in ( '1', '2', '3', '4' );
  var nummrtgorighomepurch NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI NumMrtgOrigBlack NumMrtgOrigHisp
      NumMrtgOrigWhite NumMrtgOrigOther NumMrtgOrigRaceNotProvided
      NumMrtgOrigRaceNotApplic NumMrtgOrigMxd NumMrtgOrigWithRace
      NumMrtgOrigMulti NumMrtgOrigMin;
  class year ward2002;
  table
    nummrtgorighomepurch='Total home purchase loans' * sum=' ' * f=comma8.0
    NumMrtgOrigWithRace='\line Total loans reporting race'  * sum=' ' * f=comma8.0
    NumMrtgOrigWithRace='Percent loans reporting race' * pctsum<nummrtgorighomepurch>=' ' 
    ( NumMrtgOrigWithRace='\line\i Percent loans by race'
      NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI
      NumMrtgOrigBlack
      NumMrtgOrigHisp
      NumMrtgOrigWhite
      NumMrtgOrigOther
      NumMrtgOrigMxd 
      NumMrtgOrigMulti ) * pctsum<NumMrtgOrigWithRace>=' '
  , 
  ward2002=' ' * year=' ' / rts=40 box=_page_ row=float;

  title2 ' ';
  title3 'Home Purchase Mortgage Lending, Washington, D.C., 2003 - 2004';

run;

proc tabulate data=Test_2003_2004_ward format=comma8.1 noseps;
  where ward2002 in ( '5', '6', '7', '8' );
  var nummrtgorighomepurch NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI NumMrtgOrigBlack NumMrtgOrigHisp
      NumMrtgOrigWhite NumMrtgOrigOther NumMrtgOrigRaceNotProvided
      NumMrtgOrigRaceNotApplic NumMrtgOrigMxd NumMrtgOrigWithRace
      NumMrtgOrigMulti NumMrtgOrigMin;
  class year ward2002;
  table
    nummrtgorighomepurch='Total home purchase loans' * sum=' ' * f=comma8.0
    NumMrtgOrigWithRace='\line Total loans reporting race'  * sum=' ' * f=comma8.0
    NumMrtgOrigWithRace='Percent loans reporting race' * pctsum<nummrtgorighomepurch>=' ' 
    ( NumMrtgOrigWithRace='\line\i Percent loans by race'
      NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI
      NumMrtgOrigBlack
      NumMrtgOrigHisp
      NumMrtgOrigWhite
      NumMrtgOrigOther
      NumMrtgOrigMxd 
      NumMrtgOrigMulti ) * pctsum<NumMrtgOrigWithRace>=' '
  , 
  ward2002=' ' * year=' ' / rts=40 box=_page_ row=float;

  title2 ' ';
  title3 'Home Purchase Mortgage Lending, Washington, D.C., 2003 - 2004';

run;

ods rtf close;

