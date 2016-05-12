/**************************************************************************
 Program:  Hmda_sum_2004_was.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/12/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Upload HMDA 2004 tract summary file (preliminary
 version).

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( HMDA )
%DCData_lib( General )

%let year = 2004;

%syslput year=&year;

*options obs=100;

data Hmda_sum_&year._was;

  set hmda.all_summary04;
  
  where geo2000 in: ( '11' ); 
  
  nyear = input( year, 4. );
  
  length geo2000_11 $ 11;
  
  geo2000_11 = left( compress( geo2000, '.' ) );
  
  if put( geo2000_11, $GEO00V. ) = '' then
    put 'Invalid tract no. ' geo2000= geo2000_11=;
  
  rename nyear=year geo2000_11=geo2000;
  
  drop year geo2000;

run;

proc sort data=Hmda_sum_&year._was;
  by geo2000;

run;

** Start submitting commands to remote server **;

rsubmit;

proc upload status=no
  data=Hmda_sum_&year._was 
  out=Hmda.Hmda_sum_&year._was;

run;

%file_info( data=Hmda.Hmda_sum_&year._was )

run;

endrsubmit;

** End submitting commands to remote server **;

signoff;
