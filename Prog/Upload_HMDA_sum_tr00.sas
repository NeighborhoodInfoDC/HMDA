/**************************************************************************
 Program:  Upload_HMDA_sum_tr00.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/03/07
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Upload HMDA tract-level summary file to Alpha and
 register metadata.
 
 When updating data:
 1) Update %let revisions = value to a description of latest file changes. 
    Eg, %let revisions = %str(Added 2006 data.);

 Modifications: 04/26/10 CJN	Updated for 2007 data processing.
				05/04/10 CJN	Updated for 2008 data processing.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Hmda )

rsubmit;

%let revisions = %str(Added 2008 data.);

proc upload status=no
  inlib=Hmda 
  outlib=Hmda memtype=(data);
  select Hmda_sum_tr00;

run;

x "purge [dcdata.hmda.data]Hmda_sum_tr00.*";

%Dc_update_meta_file(
  ds_lib=Hmda,
  ds_name=Hmda_sum_tr00,
  creator_process=Hmda_sum_tr00.sas,
  restrictions=None,
  revisions=%str(&revisions)
)

run;

endrsubmit;

signoff;
