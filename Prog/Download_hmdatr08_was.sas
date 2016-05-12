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

 Modifications: C.Narducci - 2007 update 04/26/10
				C.Narducci - 2008 update 05/04/10
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Hmda )

** Start submitting commands to remote server **;

rsubmit;

libname dplacepu "DISK$USER09:[DPLACE.HMDA]";

data HMDATR08_WAS (compress=no);

  set dplacepu.nat_hmda2008;
  
  where MSAPMA99 = '8840';
  
  ** Recode medians: 0 to missing **;
  
  array a{*} Median: MrtgOrigMed: ;
  
  do i = 1 to dim( a );
    if a{i} = 0 then a{i} = .;
  end;
  
  drop i;
  
run;

proc download status=no
  data=HMDATR08_WAS 
  out=Hmda.HMDATR08_WAS;

run;

endrsubmit;

** End submitting commands to remote server **;


%file_info( data=Hmda.HMDATR08_WAS, printobs=0, freqvars=statecd MSAPMA99 )


signoff;
