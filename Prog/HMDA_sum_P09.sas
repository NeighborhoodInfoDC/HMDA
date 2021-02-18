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

 When updating: Make sure there is an updated version of %hud_inc_yyyy
			    in the iPums macro library. 
 
 Modifications: 2/18/21: updated to add 2019 loans files (ALH)
 
**************************************************************************/

%include "\\SAS1\DCDData\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( HMDA )
%DCData_lib( ipums )

%let start_yr = 2009;
%let end_yr = 2019;

%let revisions = Update with 2019 HMDA data ;

%let tr2000data = hmda2009tr hmda2010tr hmda2011tr;
%let tr2010data = hmda2012tr hmda2013tr hmda2014tr hmda2015tr hmda2016tr hmda2017tr hmda2018tr hmda2019tr;



/*Create tract-level summary file for each year of data */
%hmda_tracts_new (&start_yr.,&end_yr.);


/* Merge 2000-tract year files */
data hmda_long00_tr00_m;
	merge &tr2000data.;
	by geo2000;
run;

proc contents data = hmda_long00_tr00_m out = vars2000;
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


/* Loop through and record missing variables as zero */
data hmda_long00_tr00;
	set hmda_long00_tr00_m;

	%macro makezero();
		%let varlist = &count_vars.;
			%let i = 1;
				%do %until (%scan(&varlist,&i,' ')=);
					%let var=%scan(&varlist,&i,' ');
			if &var. = . then &var. = 0;
		%let i=%eval(&i + 1);
				%end;
			%let i = 1;
				%do %until (%scan(&varlist,&i,' ')=);
					%let var=%scan(&varlist,&i,' ');
		%let i=%eval(&i + 1);
				%end;
	%mend makezero;
	%makezero;

run;

proc sql noprint;
select name
into :median_vars separated by " "
from vars2000p (where=(prefix="MED"));
quit;

/* Create summary files from 2000-tract files */
%Create_all_summary_from_tracts( 
  lib=work,
  data_pre=hmda_long00,
  data_label=,
  count_vars=&count_vars., 
  prop_vars=&median_vars., 
  calc_vars=, 
  calc_vars_labels=,
  tract_yr=2000,
  register=,
  finalize=n,
  creator_process=,
  restrictions=,
  revisions="&revisions.",
  mprint=n
);


/* Merge 2010-tract year files */
data hmda_long10_tr10_m;
	merge &tr2010data.;
	by geo2010;
run;

proc contents data = hmda_long10_tr10_m out = vars2010;
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

/* Loop through and record missing variables as zero */
data hmda_long10_tr10;
	set hmda_long10_tr10_m;

	%macro makezero();
		%let varlist = &count_vars.;
			%let i = 1;
				%do %until (%scan(&varlist,&i,' ')=);
					%let var=%scan(&varlist,&i,' ');
			if &var. = . then &var. = 0;
		%let i=%eval(&i + 1);
				%end;
			%let i = 1;
				%do %until (%scan(&varlist,&i,' ')=);
					%let var=%scan(&varlist,&i,' ');
		%let i=%eval(&i + 1);
				%end;
	%mend makezero;
	%makezero;

run;

proc sql noprint;
select name
into :median_vars separated by " "
from vars2010p (where=(prefix="MED"));
quit;

/* Create summary files from 2010-tract files */
%Create_all_summary_from_tracts( 
  lib=work,
  data_pre=hmda_long10,
  data_label=,
  count_vars=&count_vars., 
  prop_vars=&median_vars., 
  calc_vars=, 
  calc_vars_labels=,
  tract_yr=2010,
  register=,
  finalize=n,
  creator_process=,
  restrictions=,
  revisions="&revisions.",
  mprint=n
);


/* Merge summary files together into one big summary file */
%macro hmda_merge(geo);

%let geosuf = %sysfunc( putc( %upcase(&geo), $geosuf. ) );

data hmda_sum_p09&geosuf;
	merge hmda_long00&geosuf. hmda_long10&geosuf.;
	by &geo.;

	%if &geo. = geo2010 %then %do;
	if geo2010 ^= "51013980200";
	%end;

run;

/* Save final summary file */
%Finalize_data_set( 
data=hmda_sum_p09&geosuf,
out=hmda_sum_p09&geosuf,
outlib=hmda,
label="HMDA summary, DC, &start_yr. - &end_yr.",
sortby=&geo.,
restrictions=None,
printobs=0,
revisions=&revisions.
);

%mend hmda_merge;
%hmda_merge (geo2000);
%hmda_merge (geo2010);
%hmda_merge (anc2002);
%hmda_merge (anc2012);
%hmda_merge (bridgepk);
%hmda_merge (city);
%hmda_merge (cluster2017);
%hmda_merge (cluster_tr2000);
%hmda_merge (eor);
%hmda_merge (stantoncommons);
%hmda_merge (voterpre2012);
%hmda_merge (ward2002);
%hmda_merge (ward2012);
%hmda_merge (psa2012);
%hmda_merge (zip);





/* End of Program */
