/**************************************************************************
 Program:  Download_summary.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/04/05
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Download HMDA summary files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( HMDA )

rsubmit;

proc download status=no
  inlib=HMDA 
  outlib=HMDA memtype=(data);
  select 
    HMDA_dc_city00
    HMDA_dc_tr00
    ;

run;

signoff;
