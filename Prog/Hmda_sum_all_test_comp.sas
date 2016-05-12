/**************************************************************************
 Program:  Hmda_sum_all_test_comp.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/21/12
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Compare new and old HMDA summary files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

libname Save 'D:\DCData\Libraries\HMDA\Data\Save';


/** Macro Compare - Start Definition **/

%macro Compare( ds, id );

  proc compare base=Save.&ds compare=Hmda.&ds /*novalues*/ maxprint=(50,32000)
      method=percent criterion=1.0;
    id &id;
  run;

%mend Compare;

/** End Macro Definition **/

%Compare( Hmda_sum_anc02, Anc2002 )
%Compare( Hmda_sum_city, City )
%Compare( Hmda_sum_cltr00, Cluster_tr2000 )
%Compare( Hmda_sum_eor, Eor )
%Compare( Hmda_sum_psa04, Psa2004 )
%Compare( Hmda_sum_tr00, Geo2000 )
%Compare( Hmda_sum_wd02, Ward2002 )
%Compare( Hmda_sum_zip, Zip )
