/**************************************************************************
 Program:  Compare.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/19/08
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Compare files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

proc compare base=Hmda.hmda_sum_tr00 compare=Hmda.hmda_sum_tr00_new maxprint=(40,32000) listvar;
  id geo2000;

run;

