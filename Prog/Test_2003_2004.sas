/**************************************************************************
 Program:  Test_2003_2004.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/12/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Test 2003 & 2004 race results.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

options mrecall;

** Define libraries **;
%DCData_lib( HMDA )
%DCData_lib( General )

rsubmit;

data Test_2003_2004;

  set 
    Hmda.Hmda_sum_2003_was 
      (keep=geo2000 year
        nummrtgorighomepurch
        NumMrtgOrigAmerInd
        NumMrtgOrigAsianPI
        NumMrtgOrigBlack
        NumMrtgOrigHisp
        NumMrtgOrigWhite
        NumMrtgOrigOther
        NumMrtgOrigRaceNotProvided
        NumMrtgOrigRaceNotApplic
        NumMrtgOrigMxd
        NumMrtgOrigWithRace
      where=(geo2000=:'11'))
    Hmda.Hmda_sum_2004_was 
      (keep=geo2000 year
        NumMrtgOrigHomePurch1_4m
        NumMrtgOrigAmerInd
        NumMrtgOrigAsianPI
        NumMrtgOrigBlack
        NumMrtgOrigHisp
        NumMrtgOrigWhite
        NumMrtgOrigRaceNotProvided
        NumMrtgOrigRaceNotApplic
        NumMrtgOrigMxd
        NumMrtgOrigWithRace
        NumMrtgOrigMulti
        NumMrtgOrigMin
      rename=(NumMrtgOrigHomePurch1_4m=nummrtgorighomepurch));

  label
    NumMrtgOrigAmerInd='American indian'
    NumMrtgOrigAsianPI='Asian/PI'
    NumMrtgOrigBlack='Black'
    NumMrtgOrigHisp='Hispanic'
    NumMrtgOrigWhite='White'
    NumMrtgOrigOther='Other race'
    NumMrtgOrigRaceNotProvided='Race not provided'
    NumMrtgOrigMxd='Mixed race'
    NumMrtgOrigWithRace='Total loans w/race'
    NumMrtgOrigMulti='Multiple races'
    NumMrtgOrigMin='Minority';

run;

proc download status=no
  data=Test_2003_2004 
  out=HMDA.Test_2003_2004;

run;

endrsubmit;

*ods rtf file='d:\temp\test_2003_2004.rtf' style=rtf_arial_9pt;

proc tabulate data=HMDA.Test_2003_2004 format=comma8.1 noseps;
  var nummrtgorighomepurch NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI NumMrtgOrigBlack NumMrtgOrigHisp
      NumMrtgOrigWhite NumMrtgOrigOther NumMrtgOrigRaceNotProvided
      NumMrtgOrigRaceNotApplic NumMrtgOrigMxd NumMrtgOrigWithRace
      NumMrtgOrigMulti NumMrtgOrigMin;
  class year;
  table
    NumMrtgOrigWithRace='Percent loans reporting race' * pctsum<nummrtgorighomepurch>=' ' 
    NumMrtgOrigWithRace * sum=' ' * f=comma8.0
    ( NumMrtgOrigWithRace='Percent loans by race'
      NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI
      NumMrtgOrigBlack
      NumMrtgOrigHisp
      NumMrtgOrigWhite
      NumMrtgOrigOther
      NumMrtgOrigMxd 
      NumMrtgOrigMulti ) * pctsum<NumMrtgOrigWithRace>=' '
  , 
  year / rts=60;
  title2 'Washington, D.C. Total';

run;

*ods rtf close;

proc tabulate data=HMDA.Test_2003_2004 format=comma8.1 noseps;
  where geo2000 in ( '11001001401', '11001001402', '11001001500', '11001001600', '11001001701', 
                     '11001001702', '11001001801', '11001001803', '11001001804', '11001001901', 
                     '11001001902', '11001002001', '11001002002', '11001002101', '11001002102', 
                     '11001002201', '11001002202', '11001002301', '11001002400', '11001002501', 
                     '11001002502', '11001002600' );
  var nummrtgorighomepurch NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI NumMrtgOrigBlack NumMrtgOrigHisp
      NumMrtgOrigWhite NumMrtgOrigOther NumMrtgOrigRaceNotProvided
      NumMrtgOrigRaceNotApplic NumMrtgOrigMxd NumMrtgOrigWithRace
      NumMrtgOrigMulti NumMrtgOrigMin;
  class geo2000 year;
  table
   all='Ward 4 (approximate)' geo2000='Census tract = ',
   NumMrtgOrigWithRace='Percent loans reporting race' * pctsum<nummrtgorighomepurch>=' ' 
    NumMrtgOrigWithRace * sum=' ' * f=comma8.0
    ( NumMrtgOrigWithRace='Percent loans by race'
      NumMrtgOrigAmerInd
      NumMrtgOrigAsianPI
      NumMrtgOrigBlack
      NumMrtgOrigHisp
      NumMrtgOrigWhite
      NumMrtgOrigOther
      NumMrtgOrigMxd 
      NumMrtgOrigMulti ) * pctsum<NumMrtgOrigWithRace>=' '
  , 
  year / rts=60 condense;

  title2;

run;

signoff;
