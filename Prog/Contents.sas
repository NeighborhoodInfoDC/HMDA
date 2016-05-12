/**************************************************************************
 Program:  Contents.sas
 Library:  Hmda
 Project:  DC Data Warehouse
 Author:   P. Tatian
 Created:  02/17/05
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Contents of HMDA files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Hmda )

rsubmit;

%file_info( data=Hmda.Hmda_dc_tr00, freqvars=year geoscaleid )

endrsubmit;

run;

signoff;
