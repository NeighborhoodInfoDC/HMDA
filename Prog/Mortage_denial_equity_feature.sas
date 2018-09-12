/**************************************************************************
 Program:  Mortgage_denial_equity_feature.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   Yipeng Su
 Created:  9/11/18
 Version:  SAS 9.4
 Environment:  Windows with SAS/Connect
 
 Description:  calculate home mortage denial rate for JPMC equity tool

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( HMDA )

 **limit to DC and drop withdrawna and cases closed for incompleteness **;
data DC_homemortgage;
	set HMDA.loans_2017 ;

	state=substr(geo2010,1,2);
	if state = "11";

	if action not in ("4","5") and purpose= "1" then do; 
		if action=3 then denial = 1;
	    record=1;
	end;
run;


proc summary data=DC_homemortgage;
	class geo2010;
	var denial record ;
	output	out=denial1 sum= ;
run;


data denial_tract2010;
	set denial1;
	if denial = . then denial = 0;
	if geo2010 in ("11001"," ") then delete;
run;

proc sort data= denial_tract2010;
by geo2010;
run;

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=work.denial_tract2010,
dat_org_geo=geo2010,
dat_count_vars= denial record,
wgt_ds_name=general.Wt_tr10_ward12,
wgt_org_geo=Geo2010,
wgt_new_geo=ward2012, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=denial_by_ward,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars= 

,
calc_vars_labels=

)

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=work.denial_tract2010,
dat_org_geo=geo2010,
dat_count_vars= denial record,
wgt_ds_name=general.Wt_tr10_cl17,
wgt_org_geo=Geo2010,
wgt_new_geo=cluster2017, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=denial_by_cluster,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars= 
,
calc_vars_labels=

)

%Transform_geo_data(
keep_nonmatch=n,
dat_ds_name=work.denial_tract2010,
dat_org_geo=geo2010,
dat_count_vars= denial record,
wgt_ds_name=general.Wt_tr10_city,
wgt_org_geo=Geo2010,
wgt_new_geo=city, 
wgt_id_vars=,
wgt_wgt_var=PopWt,
out_ds_name=denial_by_city,
out_ds_label=%str(Population by age group from tract 2010 to ward),
calc_vars= 
,
calc_vars_labels=

)

data ward12;
set denial_by_ward;
length indicator $80;
keep indicator year ward2012 numerator denom equityvariable;
indicator = "Home Mortage Denial Rate";
year = "2017";
denom= record;
numerator= denial;
equityvariable= numerator/denom;
geo=Ward2012;
format geo $Ward12a.;
run;

data cluster17;
set denial_by_cluster;
length indicator $80;
keep indicator year cluster2017 numerator denom equityvariable;
indicator = "Home Mortage Denial Rate";
year = "2017";
denom= record;
numerator= denial;equityvariable= numerator/denom;
geo=cluster2017;
format cluster2017 $clus17f.;
run;

data city;
set denial_by_city;
length indicator $80;
keep indicator year city numerator denom equityvariable;
indicator = "Home Mortage Denial Rate";
year = "2017";
denom= record;
numerator= denial;equityvariable= numerator/denom;
geo=city;
format geo $city. ;
run;

proc export data=cluster17
	outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Loan_Denial_cl17.csv"
	dbms=csv replace;
run;

proc export data=city
	outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Loan_Denial_city.csv"
	dbms=csv replace;
run;

proc export data=ward12
	outfile="&_dcdata_default_path.\Equity\Prog\JPMC feature\Loan_Denial_ward.csv"
	dbms=csv replace;
run;

