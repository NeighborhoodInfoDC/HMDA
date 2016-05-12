/**************************************************************************
 Program:  Hmda_sum_2004_was.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/07/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Copy HMDA 2004 tract summary file from Dataplace Alpha
 directory to DCData HMDA library.
 
 Modifications:
  08/24/06  New name for source file: Dplex_hmda_summary_04a
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( HMDA )

rsubmit;

libname dplace "DISK$USER05:[DPLACE]";

%let year = 2004;

*options obs=100;

data Hmda_sum_&year._was;

  length geo2000_11 $ 11;
  
  set dplace.Dplex_hmda_summary_04a;
  
  where metro05 = '47900' and geoscaleid = '1';
  
  *where stfid in: ( '11' ); 
  
  nyear = input( year, 4. );
  
  geo2000_11 = left( compress( stfid, '.' ) );
  
  if geo2000_11 =: '11' and put( geo2000_11, $GEO00V. ) = '' then do;
    %warn_put( msg='Invalid tract no. ' stfid= geo2000_11= )
  end;
    
  format _all_ ;
  informat _all_ ;
  
  rename nyear=year geo2000_11=geo2000;
  
  drop year stfid;

run;

proc sort data=Hmda_sum_&year._was 
  out=Hmda.Hmda_sum_&year._was (label="NNIP HMDA tract-level summary files, &year, Washington, D.C. region");
  by geo2000;

run;

%file_info( data=Hmda.Hmda_sum_&year._was, printchar=Y, freqvars=stusab )

run;

endrsubmit;

** End submitting commands to remote server **;

signoff;
