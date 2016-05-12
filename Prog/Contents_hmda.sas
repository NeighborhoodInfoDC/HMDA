/**************************************************************************
 Program:  Contents_hmda.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/02/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Contents of HMDA file.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( HMDA )

*libname hmdax "D:\DCData\Libraries\HMDA\Data\HMDATR97_was.zip";

%File_info( data=HMDA.ts2006, printobs=20 )



run;
