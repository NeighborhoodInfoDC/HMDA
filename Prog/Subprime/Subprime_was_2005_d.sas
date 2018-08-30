/**************************************************************************
 Program:  Subprime_was_2005_d.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/19/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  List of counties in region by subprime & high cost
lending.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%let year = 2005;
%let rpt_yr = 2005;

%let rpt_path = &_dcdata_path\Hmda\Prog;
%let rpt_file = Subprime_was_&rpt_yr;
%let rpt_xls  = &rpt_file..xls;

/** Macro Write_bar_dde - Write data for creating bar chart to workbook **/

%macro Write_bar_dde( type=, num=, den=, range= );

data Bar;

  set Hmda.Subprime_was (keep=ucounty &num &den);
  
  Percent = 100 * &num / &den;

run;

proc sort data=Bar;
  by Percent;
  
%let sheet = Region;
%let fopt = notab;
  
filename xlsFile dde "excel|&rpt_path\[&rpt_xls]&sheet!&range" lrecl=2000 &fopt;

data _null_;

  file xlsFile;
  
  set Bar;
  
  put ucounty $cnty99f. '09'x Percent;
  
run;

%mend Write_bar_dde;

/** End Macro Definition **/

%Write_bar_dde( num=NumSubprimePurRef_&year, den=NumConvPurRef_&year, range=r4c13:r28c14 )

%Write_bar_dde( num=NumHighCostPurRef_&year, den=DenHighCostPurRef_&year, range=r31c13:r56c14 )

