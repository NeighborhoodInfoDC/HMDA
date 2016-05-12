/**************************************************************************
 Program:  Download_hmda_sum.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/03/07
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Download HMDA summary files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Hmda )

rsubmit;

proc download status=no
  inlib=Hmda 
  outlib=Hmda memtype=(data);
  select
    hmda_sum_anc02
    hmda_sum_anc12
    hmda_sum_city
    hmda_sum_cltr00
    hmda_sum_eor
    hmda_sum_psa04
    hmda_sum_psa12
    hmda_sum_tr00
    hmda_sum_tr10
    hmda_sum_wd02
    hmda_sum_wd12
    hmda_sum_zip
  ;

run;

endrsubmit;

signoff;
