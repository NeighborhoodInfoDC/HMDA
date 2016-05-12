/**************************************************************************
 Program:  Hmda_sum_all.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/03/07
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all other HMDA summary geo files on Alpha from 
 tract-level summary and register metadata.

 When updating data:
 1) Update %let revisions = value to a description of latest file changes. 
    Eg, %let revisions = %str(Added 2006 data.);

 Modifications: 
   04/26/10 CJN Updated for 2007 data processing.
   05/04/10 CJN Updated for 2008 data processing.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
/***%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;***/

** Define libraries **;
%DCData_lib( Hmda )

filename MacTest 'D:\DCData\SAS\Macros\Test';

%MacroSearch( cat=MacTest, action=B )

/***rsubmit;***/

%let revisions = %str(Added 2008 data.);

options mprint symbolgen mlogic;

%Create_all_summary_from_tracts( 
  lib=Hmda,
  data_pre=Hmda_sum, 
  data_label=%str(HMDA summary, DC),
  count_vars=Den: MrtgOrigPurch: Num:, 
  prop_vars=Median: MrtgOrigMedAmt:, 
  calc_vars=, 
  calc_vars_labels=,
  tract_yr=2000,
  register=N,
  creator_process=Hmda_sum_all.sas,
  restrictions=None,
  revisions=&revisions
)

run;

libname save 'D:\DCData\Libraries\HMDA\Data\Save';

proc compare base=Save.hmda_sum_wd02 compare=Hmda.hmda_sum_wd02 maxprint=(40,32000);
  id Ward2002;
run;

/***endrsubmit;***/

/***signoff;***/
