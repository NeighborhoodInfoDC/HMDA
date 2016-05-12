/**************************************************************************
 Program:  Loans_2006.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/02/08
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create data set with HMDA loan application record
 (LAR) data for Washington region, 2006.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%Read_loans( year=2006 )

** Compare with earlier file that had only DC loans **;

proc sort data=Hmda.loans_2006_09_23_08 out=loans_2006_09_23_08;
  by ulender seq;

proc compare base=loans_2006_09_23_08 compare=Hmda.Loans_2006 (where=(ucounty=:'11')) 
    maxprint=(40,32000) listvar;
  id ulender seq;
run;

