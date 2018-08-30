** Get national subprime data for 2005 **;

%include "[dcdata]stdhead.sas";

%DCData_lib( HMDA )

libname dplacepu "DISK$USER05:[dplace]";

%global vars vars_wc file_list;

%let year = 2005;
%let file = DPLEX_HMDA_SUMMARY_05;

%let vars = 
NumSubprimeMrtgPurchBlack
NumSubprimeMrtgRefinBlack
DenSubprimeMrtgPurchBlack
DenSubprimeMrtgRefinBlack
PctSubprimeMrtgPurchBlack
PctSubprimeMrtgRefinBlack
NumSubprimeMrtgPurchHisp
NumSubprimeMrtgRefinHisp
DenSubprimeMrtgPurchHisp
DenSubprimeMrtgRefinHisp
PctSubprimeMrtgPurchHisp
PctSubprimeMrtgRefinHisp
NumSubprimeMrtgPurchWhite
NumSubprimeMrtgRefinWhite
DenSubprimeMrtgPurchWhite
DenSubprimeMrtgRefinWhite
PctSubprimeMrtgPurchWhite
PctSubprimeMrtgRefinWhite
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

