/**************************************************************************
 Program:  Compare_2005.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/12/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Compare old and new 2005 data.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( HMDA )


proc compare base=Hmda.hmdatr05_was (where=(stfid=:'11')) 
    compare=Hmda.dc_dplex_hmda_summary_05 
    listvar maxprint=(40,32000);
  id stfid notsorted;

run;
