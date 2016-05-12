/**************************************************************************
 Program:  Lenders_2006.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/02/08
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read HMDA lender data.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%Read_lenders( 
  year=2006,
  lenders_ds=Hmda.ts2006,
  subprime_wbk=subprime_2006_distributed (faux 2006).xls
)
