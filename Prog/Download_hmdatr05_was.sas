/**************************************************************************
 Program:  Download_hmdatr05_was.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/24/07
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Download and convert HMDATR05_WAS file from Alpha
 DataPlace summary file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Hmda )

** Start submitting commands to remote server **;

rsubmit;

libname dplacepu "DISK$USER05:[dplace.hmda]";

data HMDATR05_WAS (compress=no);

  set dplacepu.DPLEX_HMDA_SUMMARY_05;
  
  where MSAPMA99 = '8840';
  
  ** Recode medians: 0 to missing **;
  
  array a{*} Median: MrtgOrigMed: ;
  
  do i = 1 to dim( a );
    if a{i} = 0 then a{i} = .;
  end;
  
  drop i;
  
run;

proc download status=no
  data=HMDATR05_WAS 
  out=Hmda.HMDATR05_WAS;

run;

endrsubmit;

** End submitting commands to remote server **;


%file_info( data=Hmda.HMDATR05_WAS, printobs=0, freqvars=statecd MSAPMA99 )


proc compare base=hmda.hmdatr05_was_02_12_07 compare=hmda.hmdatr05_was maxprint=(40,32000);
  id stfid;

run;

signoff;
