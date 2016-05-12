/**************************************************************************
 Program:  Loans_2001.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/17/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create data set with HMDA loan application record
 (LAR) data for Washington region, 2001.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )
%DCData_lib( HUD )


%Read_loans( year=2001 )

