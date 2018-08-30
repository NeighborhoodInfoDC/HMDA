** Get national subprime data for 2006 **;

%include "[dcdata]stdhead.sas";

%DCData_lib( HMDA )

libname dplacepu "DISK$USER05:[dplace]";

%global vars vars_wc file_list;

%let year = 2006;
%let file = DPLEX_HMDA_SUMMARY_06;

%let vars = 
NumHighCostConvOrigFirst
NumHighCostConvOrigFirstPurch
NumHighCostConvOrigFirstImprov
NumHighCostConvOrigFirstRefin
DenHighCostConvOrigFirst
DenHighCostConvOrigFirstPurch
DenHighCostConvOrigFirstImprov
DenHighCostConvOrigFirstRefin
PctHighCostConvOrigFirst
PctHighCostConvOrigFirstPurch
PctHighCostConvOrigFirstImprov
PctHighCostConvOrigFirstRefin
;

/*
proc contents data=dplacepu.&file;

proc freq data=dplacepu.&file;
  tables geoscaleid;
run;
*/

data _null_;
  file print;
  set dplacepu.&file;
  where geoscaleid = '6';
  put (&vars) (= /);
run;

