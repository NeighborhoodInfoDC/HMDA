/**************************************************************************
 Program:  Subprime_region_2005.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/16/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Subprime lending summary tables by region.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

*options obs=10;

%let year = 2005;

%let shyear = %substr( &year, 3, 2 );

libname hmdatr&shyear. "D:\DCData\Libraries\HMDA\Data\HMDATR&shyear._was.zip";

data Subprime_region_&year;

  set Hmdatr&shyear..HMDATR&shyear._was 
    (keep=ucounty year numconvmrtgorig numconvmrtgorighomepurch numconvmrtgorigrefin
          numsubprimeconvorig NumSubprimeConvOrigHomePurch numsubprimeconvorigrefin
     rename=(NumSubprimeConvOrigHomePurch=NumSubprimeConvOrigHomePur));
  where ucounty in 
    ( "11001", "24031", "24033", "51013", "51059", "51510", "51600", "51610" );

  format ucounty $cnty99f.;

run;

proc tabulate data=Subprime_region_&year format=comma10.0 noseps missing;
  var 
    numconvmrtgorig numsubprimeconvorig 
    numconvmrtgorighomepurch numsubprimeconvorighomepur
    numconvmrtgorigrefin numsubprimeconvorigrefin;
  class ucounty;
  table 
    all ucounty=' ',
    sum='Number loans' * ( numconvmrtgorig='Total' numsubprimeconvorig='Subprime lenders' )
    pctsum<numconvmrtgorig>='Pct. loans by subprime lenders' * numsubprimeconvorig=' ' * f=comma12.1
    / box='All loans';
  table 
    all ucounty=' ',
    sum='Number loans' * ( numconvmrtgorighomepurch='Total' numsubprimeconvorighomepur='Subprime lenders' )
    pctsum<numconvmrtgorighomepurch>='Pct. loans by subprime lenders' * numsubprimeconvorighomepur=' ' * f=comma12.1
    / box='Home purchase loans';
  table 
    all ucounty=' ',
    sum='Number loans' * ( numconvmrtgorigrefin='Total' numsubprimeconvorigrefin='Subprime lenders' )
    pctsum<numconvmrtgorigrefin>='Pct. loans by subprime lenders' * numsubprimeconvorigrefin=' ' * f=comma12.1
    / box='Refinance loans';
  keylabel all = 'Washington, D.C., Region';
  format ucounty $cnty99f.;
  title3 "Conventional Home Mortgage Loans by City/County, Washington, D.C., Region, &year";

run;
