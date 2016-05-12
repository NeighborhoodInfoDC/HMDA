/**************************************************************************
 Program:  Upload_formats.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/11/07
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload HMDA formats to Alpha.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Hmda )

** Start submitting commands to remote server **;

rsubmit;

proc upload status=no
  inlib=Hmda 
  outlib=Hmda memtype=(catalog);

run;

proc catalog catalog=Hmda.formats;
  contents;
quit;

run;

endrsubmit;

** End submitting commands to remote server **;

signoff;
