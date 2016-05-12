/**************************************************************************
 Program:  Delete_metadata.sas
 Library:  Hmda
 Project:  DC Data Warehouse
 Author:   P. Tatian
 Created:  01/25/05
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Delete metadata for specified file in HMDA library.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Hmda )

rsubmit;

%Delete_metadata_file(  
         ds_lib=Hmda ,
         ds_name=tr02_was ,
         meta_lib=metadat,
         meta_pre=meta,
         update_notify=
  );

endrsubmit;

signoff;
