/**************************************************************************
 Program:  Lenders_2005.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/10/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read HMDA lender data.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%Read_lenders( 
  year=2005,
  lenders_wbk=Lenders_10_10_06.xls,
  subprime_wbk=subprime_2006_distributed.xls
)
