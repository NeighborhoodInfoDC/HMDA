* .sas - 
*
* 
*
* NB:  Program written for SAS Version 9.1
*
* 12/14/07  Peter A. Tatian
****************************************************************************;

*options obs=0;

data sec8mf_current_us;
	length contract_number $11.;
	if contract_number ~= "";
run;

options obs=max;

proc print;

run;

