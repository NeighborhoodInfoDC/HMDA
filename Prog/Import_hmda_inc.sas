/**************************************************************************
 Program:  Import_hmda_inc.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/14/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Import Hmda_inc_: data sets from SAS transport file.

 Modifications:
**************************************************************************/

***%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

filename tranfile "&_dcdata_path\hmda\data\hmda_inc.xpt";

proc cimport library=Hmda infile=tranfile;
  select Hmda_inc_wd02 Hmda_inc_city / memtype=data;
run;

filename tranfile clear;

%File_info( data=Hmda.Hmda_inc_wd02 )

run;
