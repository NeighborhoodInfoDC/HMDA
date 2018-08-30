** Temporary program to grab loans by income level vars. **;

%include "[dcdata]stdhead.sas";

%DCData_lib( HMDA )
%DCData_lib( General )

libname dplacepu "DISK$USER05:[dplace]";

%global vars vars_wc file_list;

%let year = 2005;
%let file = DPLEX_HMDA_SUMMARY_05;

%let vars = 
NumMrtgOrig_vli
NumMrtgOrig_li
NumMrtgOrig_mi
NumMrtgOrig_hinc
NumMrtgOrig_Inc
;

%let vars_wc = 
NumMrtgOrig_vli:
NumMrtgOrig_li:
NumMrtgOrig_mi:
NumMrtgOrig_hinc:
NumMrtgOrig_Inc:
;

%macro OneYear( year=, file= );

data Vars&year (compress=no);

  retain year &year;

  set dplacepu.&file (
    keep=stfid statecd &vars
    where=(statecd='11'));

  if missing( put( stfid, $geo00v. ) ) then delete;

  rename stfid=geo2000;

run;

%let file_list = &file_list Vars&year;

%mend OneYear;

%OneYear( year=1997, file=DPLEX_HMDA_SUMMARY_97a )
%OneYear( year=1998, file=DPLEX_HMDA_SUMMARY_98a )
%OneYear( year=1999, file=DPLEX_HMDA_SUMMARY_99a )
%OneYear( year=2000, file=DPLEX_HMDA_SUMMARY_00a )
%OneYear( year=2001, file=DPLEX_HMDA_SUMMARY_01a )
%OneYear( year=2002, file=DPLEX_HMDA_SUMMARY_02a )
%OneYear( year=2003, file=DPLEX_HMDA_SUMMARY_03a )
%OneYear( year=2004, file=DPLEX_HMDA_SUMMARY_04 )
%OneYear( year=2005, file=DPLEX_HMDA_SUMMARY_05 )

data VarsAll (compress=no);

  set &file_list;
  by geo2000;

run;

%Super_transpose(  
  data=VarsAll,
  out=VarsAll_tr,
  var=&vars,
  id=year,
  by=geo2000,
  mprint=N
)

%file_info( data=VarsAll_tr )

%Transform_geo_data(
    dat_ds_name=VarsAll_tr,
    dat_org_geo=geo2000,
    dat_count_vars=&vars_wc,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_tr00_city,
    wgt_org_geo=geo2000,
    wgt_new_geo=city,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=Hmda_inc_city,
    out_ds_label=%str(HMDA loans by HUD income category, city total),
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )

%File_info( data=Hmda_inc_city )


%Transform_geo_data(
    dat_ds_name=VarsAll_tr,
    dat_org_geo=geo2000,
    dat_count_vars=&vars_wc,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_tr00_ward02,
    wgt_org_geo=geo2000,
    wgt_new_geo=ward2002,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=Hmda_inc_wd02,
    out_ds_label=%str(HMDA loans by HUD income category, wards),
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )

%File_info( data=Hmda_inc_wd02 )

** Export files **;

filename tranfile "[dcdata.hmda.data]Hmda_inc.xpt";

proc cport library=Work file=tranfile;
  select Hmda_inc_wd02 Hmda_inc_city / memtype=data;
run;

filename tranfile clear;


