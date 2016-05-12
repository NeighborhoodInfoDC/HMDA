/**************************************************************************
 Program:  Download_hmdatr06_was.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/15/08
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Download and convert HMDATR06_WAS file from Alpha
 DataPlace files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Hmda )

** Start submitting commands to remote server **;

rsubmit;

libname dplacepu "DISK$USER05:[dplace.hmda]";

data HMDATR06_WAS (compress=no);

  set dplacepu.DPLEX_HMDA_SUMMARY_06;
  
  where MSAPMA99 = '8840';
  
  ** Recode medians: 0 to missing **;
  
  array a{*} Median: MrtgOrigMed: ;
  
  do i = 1 to dim( a );
    if a{i} = 0 then a{i} = .;
  end;
  
  drop i;
  
run;

proc download status=no
  data=HMDATR06_WAS 
  out=Hmda.HMDATR06_WAS;

run;

endrsubmit;

** End submitting commands to remote server **;


%file_info( data=Hmda.HMDATR06_WAS, printobs=0, freqvars=statecd MSAPMA99 )

run;

signoff;
