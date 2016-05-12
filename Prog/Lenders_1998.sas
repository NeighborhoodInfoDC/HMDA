/**************************************************************************
 Program:  Lenders_1998.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/15/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read HMDA lender data for 1998.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%Read_lenders( 
  year=1998,
  lenders_wbk=Lenders_10_10_06.xls,
  subprime_wbk=subprime_2005_distributed.xls
)
