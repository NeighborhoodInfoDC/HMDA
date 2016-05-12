/**************************************************************************
 Program:  Subprime05tr_was.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/19/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Temporary subprime tract data for 2005.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%let year = 2005;
%let shyear = 05;

data Subprime;

  set Hmda.Loans_&year (keep=ulender ucounty geo2000 loantype action subprime_lender purpose amount lien rtspread);

  where subprime_lender and loantype = "1" and action = "1";
  
  select ( purpose );
    when ( "1" )
      NumSubprimeConvOrigHomePurch = 1;
    when ( "3" )
      numsubprimeconvorigrefin = 1;
    otherwise
      delete;
  end;
    
run;

proc summary data=Subprime nway;
  class geo2000;
  var numsubprimeconvorigrefin NumSubprimeConvOrigHomePurch ;
  output out=Hmda.Subprime&shyear.tr_was sum=;

run;

%File_info( data=Hmda.Subprime&shyear.tr_was )

