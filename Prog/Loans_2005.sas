/**************************************************************************
 Program:  Loans_2005.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/19/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create data set with HMDA loan application record
 (LAR) data for Washington region, 2005.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )


%Read_loans( year=2005 )

