/**************************************************************************
 Program:  Hmda_sum_all.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/03/07
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all other HMDA summary geo files on Alpha from 
 tract-level summary and register metadata.

 When updating data:
 1) Update %let revisions = value to a description of latest file changes. 
    Eg, %let revisions = %str(Added 2006 data.);

 Modifications: 
   04/26/10 CJN Updated for 2007 data processing.
   05/04/10 CJN Updated for 2008 data processing.
   09/09/12 PAT Updated for new 2010/2012 geos.
                New weights for Median and MrtgOrigMedAmt vars.
   03/15/18 NS  Changed from K drive to L drive
**************************************************************************/

%include "L:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "L:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Hmda )

rsubmit;

/** Update with information on latest file revision **/
%let revisions = %str(Updated for new 2010/2012 geos. New weights for Median and MrtgOrigMedAmt vars.);

%Create_all_summary_from_tracts( 
  
  register=Y,   /** Change to N for testing, Y for final batch mode run **/

  lib=Hmda,
  data_pre=Hmda_sum, 
  data_label=%str(HMDA summary, DC),
  count_vars=Den: MrtgOrigPurch: Num:, 
  prop_vars=Median: MrtgOrigMedAmt:, 
  calc_vars=, 
  calc_vars_labels=,
  tract_yr=2000,
  creator_process=Hmda_sum_all.sas,
  restrictions=None,
  revisions=&revisions
)

run;

endrsubmit;

signoff;
