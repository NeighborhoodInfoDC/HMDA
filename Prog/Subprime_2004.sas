/**************************************************************************
 Program:  Subprime_2004.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/11/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Subprime summary tables (used in testimony 03-14-07).

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%let year = 2004;

proc tabulate data=Hmda.Hmda_sum_wd02 format=comma10.0 noseps missing;
  var 
    numconvmrtgorig_&year numsubprimeconvorig_&year 
    numconvmrtgorighomepurch_&year numsubprimeconvorighomepur_&year
    numconvmrtgorigrefin_&year numsubprimeconvorigrefin_&year;
  class ward2002;
  table 
    all='Washington, D.C.' ward2002=' ',
    sum='Number loans' * ( numconvmrtgorig_&year='Total' numsubprimeconvorig_&year='Subprime lenders' )
    pctsum<numconvmrtgorig_&year>='Pct. loans by subprime lenders' * numsubprimeconvorig_&year=' ' * f=comma12.1
    / box='All loans';
  table 
    all='Washington, D.C.' ward2002=' ',
    sum='Number loans' * ( numconvmrtgorighomepurch_&year='Total' numsubprimeconvorighomepur_&year='Subprime lenders' )
    pctsum<numconvmrtgorighomepurch_&year>='Pct. loans by subprime lenders' * numsubprimeconvorighomepur_&year=' ' * f=comma12.1
    / box='Home purchase loans';
  table 
    all='Washington, D.C.' ward2002=' ',
    sum='Number loans' * ( numconvmrtgorigrefin_&year='Total' numsubprimeconvorigrefin_&year='Subprime lenders' )
    pctsum<numconvmrtgorigrefin_&year>='Pct. loans by subprime lenders' * numsubprimeconvorigrefin_&year=' ' * f=comma12.1
    / box='Refinance loans';
  title3 "Conventional Home Mortgage Loans by Ward, Washington, DC, &year";

run;

data FlipRace;

  set Hmda.Hmda_sum_city ;
  
  race = "0";
  output;
  
  race = "1";
  numconvmrtgorighomepurch_&year = densubprimemrtgpurchwhite_&year;
  numsubprimeconvorighomepur_&year = numsubprimemrtgpurchwhite_&year;
  numconvmrtgorigrefin_&year = densubprimemrtgrefinwhite_&year;
  numsubprimeconvorigrefin_&year = numsubprimemrtgrefinwhite_&year;
  output;
  
  race = "2";
  numconvmrtgorighomepurch_&year = densubprimemrtgpurchblack_&year;
  numsubprimeconvorighomepur_&year = numsubprimemrtgpurchblack_&year;
  numconvmrtgorigrefin_&year = densubprimemrtgrefinblack_&year;
  numsubprimeconvorigrefin_&year = numsubprimemrtgrefinblack_&year;
  output;
  
  race = "3";
  numconvmrtgorighomepurch_&year = densubprimemrtgpurchhisp_&year;
  numsubprimeconvorighomepur_&year = numsubprimemrtgpurchhisp_&year;
  numconvmrtgorigrefin_&year = densubprimemrtgrefinhisp_&year;
  numsubprimeconvorigrefin_&year = numsubprimemrtgrefinhisp_&year;
  output;
  
  race = "4";
  numconvmrtgorighomepurch_&year = densubprimemrtgpurchasianpi_&year;
  numsubprimeconvorighomepur_&year = numsubprimemrtgpurchasianpi_&year;
  numconvmrtgorigrefin_&year = densubprimemrtgrefinasianpi_&year;
  numsubprimeconvorigrefin_&year = numsubprimemrtgrefinasianpi_&year;
  output;

  keep race numconvmrtgorighomepurch_&year numsubprimeconvorighomepur_&year 
    numconvmrtgorigrefin_&year numsubprimeconvorigrefin_&year ;

run;

proc format;
  value $race
    "0" = "Washington, D.C."
    "1" = "Whites"
    "2" = "African-Americans"
    "3" = "Latinos"
    "4" = "Asians";    

proc tabulate data=FlipRace format=comma10.0 noseps missing;
  var 
    numconvmrtgorighomepurch_&year numsubprimeconvorighomepur_&year
    numconvmrtgorigrefin_&year numsubprimeconvorigrefin_&year
    ;
  class race;
  table 
    /*all='Washington, D.C.'*/ race=' ',
    sum='Number loans' * ( numconvmrtgorighomepurch_&year='Total' numsubprimeconvorighomepur_&year='Subprime lenders' )
    pctsum<numconvmrtgorighomepurch_&year>='Pct. loans by subprime lenders' * numsubprimeconvorighomepur_&year=' ' * f=comma12.1
    / box='Home purchase loans';
  table 
    /*all='Washington, D.C.'*/ race=' ',
    sum='Number loans' * ( numconvmrtgorigrefin_&year='Total' numsubprimeconvorigrefin_&year='Subprime lenders' )
    pctsum<numconvmrtgorigrefin_&year>='Pct. loans by subprime lenders' * numsubprimeconvorigrefin_&year=' ' * f=comma12.1
    / box='Refinance loans';
  format race $race.;
  title3 "Conventional Home Mortgage Loans by Race/Ethnicity, Washington, DC, &year";

    
