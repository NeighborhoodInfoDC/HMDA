%include "[dcdata]stdhead.sas";

%DCData_lib( HMDA )

libname dplace 'DISK$USER09:[DPLACE.HMDA]';  /*assigns location of DPLACE alpha*/ 

proc contents data=dplace.NAT_HMDA2008;

proc contents data=dplace.NAT_HMDA2007;

run;

