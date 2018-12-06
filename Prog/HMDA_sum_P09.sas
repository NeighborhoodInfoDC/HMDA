/**************************************************************************
 Program:  HMDA_sum_P09.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  9/11/18
 Version:  SAS 9.4
 Environment:  Windows 7
 
 Description:  Create HMDA summary indicator file for Census tracts
 (2000) from selected variables in HMDA files.

 When updating: make sure there is an updated version of %hud_inc_yyyy
			    in the iPums macro library. 
 
 Modifications:
 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( HMDA )
%DCData_lib( ipums )

%let start_yr = 2009;
%let end_yr = 2016;

%let revisions = New file ;

%let tr2000data = hmda2009tr hmda2010tr hmda2011tr;
%let tr2010data = hmda2012tr hmda2013tr hmda2014tr hmda2015tr hmda2016tr;



/*Create tract-level summary file for each year of data */
%hmda_tracts_new (&start_yr.,&end_yr.);


/* Merge 2000-tract year files */
data hmda_long00_tr00;
	merge &tr2000data.;
	by geo2000;
run;

proc contents data = hmda_long00_tr00 out = vars2000;
run;

data vars2000p;
	set vars2000;
	prefix = upcase(substr(name,1,3));
run;

proc sort data = vars2000p; by name; run;

proc sql noprint;
select name
into :count_vars separated by " "
from vars2000p (where=(prefix="NUM"));
quit;

/* Create summary files from 2000-tract files */
%Create_all_summary_from_tracts( 
  lib=work,
  data_pre=hmda_long00,
  data_label=,
  count_vars=&count_vars., 
  prop_vars=, 
  calc_vars=, 
  calc_vars_labels=,
  tract_yr=2000,
  register=,
  finalize=y,
  creator_process=,
  restrictions=,
  revisions="&revisions.",
  mprint=n
);


/* Merge 2010-tract year files */
data hmda_long10_tr10;
	merge &tr2010data.;
	by geo2010;
run;

proc contents data = hmda_long10_tr10 out = vars2010;
run;

data vars2010p;
	set vars2010;
	prefix = upcase(substr(name,1,3));
run;

proc sort data = vars2010p; by name; run;

proc sql noprint;
select name
into :count_vars separated by " "
from vars2010p (where=(prefix="NUM"));
quit;

/* Create summary files from 2010-tract files */
%Create_all_summary_from_tracts( 
  lib=work,
  data_pre=hmda_long10,
  data_label=,
  count_vars=&count_vars., 
  prop_vars=, 
  calc_vars=, 
  calc_vars_labels=,
  tract_yr=2010,
  register=,
  finalize=y,
  creator_process=,
  restrictions=,
  revisions="&revisions.",
  mprint=n
);


/* Merge summary files together into one big summary file */
%macro hmda_merge(geo,geosuf);

data hmda_p09_sum_&geosuf.;
	merge hmda_long00_&geosuf. hmda_long10_&geosuf.;
	by &geo.;
run;

/* Save final summary file */
%Finalize_data_set( 
data=hmda_p09_sum_&geosuf.,
out=hmda_p09_sum_&geosuf.,
outlib=hmda,
label="HMDA summary, DC, &start_yr. - &end_yr.",
sortby=&geo.,
restrictions=None,
printobs=0,
revisions=&revisions.
);

%mend hmda_merge;
%hmda_merge (geo2000,tr00);
%hmda_merge (geo2010,tr10);
%hmda_merge (anc2002,anc02);
%hmda_merge (anc2012,anc12);
%hmda_merge (bridgepk,bpk);
%hmda_merge (city,city);
%hmda_merge (cluster2017,cl17);
%hmda_merge (cluster_tr2000,cltr00);
%hmda_merge (eor,eor);
%hmda_merge (stantoncommons,stanc);
%hmda_merge (voterpre2012,vp12);
%hmda_merge (ward2002,wd02);
%hmda_merge (ward2012,wd12);
%hmda_merge (zip,zip);





/* End of Program */
