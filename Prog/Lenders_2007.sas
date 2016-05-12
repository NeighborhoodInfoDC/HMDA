/**************************************************************************
 Program:  Lenders_2007.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/14/09
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read HMDA lender data.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%Read_lenders( 
  year=2007,
  lenders_txt=2007HMDAInstitutionRecords.txt,
  subprime_wbk=subprime_2007_distributed (faux 2007).xls
)
