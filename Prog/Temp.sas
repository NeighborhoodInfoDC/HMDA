/**************************************************************************
 Program:  Temp.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/24/07
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

options nolabel;

proc means data=Hmda.Hmdatr05_was n sum;
  where stfid =: "11";
  title2 'Hmda.Hmdatr05_was';
run;

   
proc means data=Hmda.Subprime05tr_was n sum;
  where geo2000 =: "11";
  title2 'Hmda.Subprime05tr_was';
run;

   
